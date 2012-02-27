<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class DatabaseImport {

	private static $_current = array();
	private static $_stored = array();
	private static $_database = array();
	private static $_siteErrors;
	private static $_processingErrors = array();
	private static $_charset;
	private static $_cache;
	private static $_lineNumber = 0;
	private static $_csvDatas = array(); 
	private static $_lang; 
	private static $_strings;

	public static function importCsv($filepath, $separator=';', $charset='utf8', $lf="\n", $skipline=0, $lang='fr', $ownerId=0) {

		// TO BE LINKED WITH TRANSLATION MODULE
		self::$_lang = $lang;
		self::$_charset = $charset;
		$numProcessed = 0;

		self::$_strings['Yes']['fr'] = 'oui';
		self::$_strings['Yes']['de'] = 'ja';
		self::$_strings['No']['fr'] = 'non';
		self::$_strings['No']['de'] = 'nein';

		$knowledge['fr'] = array('non renseigné', 'littérature, prospecté', 'littérature prospecté', 'sondé', 'fouillé');
		$knowledge['en'] = array('unknown', 'literature', 'literature', 'surveyed', 'excavated');
		$knowledge['de'] = array('unbestimmt', 'literatur, lesefund', 'literatur', 'sondiert', 'ausgegraben');
		$occupation['fr'] = array('non renseigné', 'unique', 'continue', 'multiple');
		$occupation['en'] = array('unknown', 'uniq', 'continuous', 'multiple');
		$occupation['de'] = array('unbestimmt', 'einzelphase', 'durchgehend', 'mehrphasig');
		$epsgCodes['wgs84'] = 4326;

		self::$_cache['period'] = array();
		self::$_cache['realestate'] = array();
		self::$_cache['furniture'] = array();
		self::$_cache['production'] = array();
		self::$_cache['siteperiod'] = array();
		self::$_cache['specialperiod'] = array();

		if (!is_file($filepath) || !is_readable($filepath)) {
			// Check if filename is in current directory (for tests)
			$moduleDir = dirname(__FILE__);
			if (is_file("$moduleDir/$filepath") && is_readable("$moduleDir/$filepath")) {
				$filepath = "$moduleDir/$filepath";
			} else {
				throw new \Exception("File does not exist or is not readable");
			}
		}

		$lines = array_chunk(str_getcsv(str_replace("\n", ';',file_get_contents($filepath)), $separator), 33);

		\core\Core::$db->exec('BEGIN');

		// Retrieve special periods

		foreach(\core\Core::$db->fetchAll('SELECT "node_path", "pe_name_'.$lang.'" FROM "ark_period" WHERE "pe_name_'.$lang.'" IN (?, ?, ?, ?, ?, ?, ?)', array('BRF3/HAC1', 'HAC2/HAD1', 'HAD3/LTA1', 'LTC2/LTD1', 'Grandes  invasions', 'Grandes invasions', 'Völkerwanderungszeit')) as $row) {
			self::$_cache['specialperiod'][$lang][$row['pe_name_'.$lang]][] = $row['node_path']; 
		}

		foreach($lines as $datas) {

			self::$_lineNumber++;
			self::$_current = array('owner' => $ownerId);
			self::$_csvDatas = implode(';', $datas);

			if (self::$_lineNumber != 0 && self::$_lineNumber <= $skipline) {
				continue;
			}
			$datas = array_map(array('self', '_cleanString'), $datas);

			// Skip blank lines
			if (!isset($datas[1])) continue;

			# 1 : Database
			self::_processDatabaseName($datas[1]);

			# 0 : Site ID
			if (!self::_processSiteId($datas[0])) {
				self::_addError('No site unique ID provided');
				continue;
			}

			 // Site not already processed
			if (!isset(self::$_stored[self::$_current['code']])) {

				// If this site code already registered as error we do not process it
				if (isset(self::$_siteErrors[self::$_current['code']])) {
						self::_addError("Site with same id already registered as error, skipping.");
						continue;
				}

				# 2 : Site name
				# 3 : City name
				# 4 : City code
				foreach (array(2,3,4,5) as $k) {
					if(!self::_checkDifference($k, $datas[$k])) {
						switch($k) {
						case 2:
							$dataType = "Site name";
							break;
						case 3:
							$dataType = "City name";
							break;
						case 4:
							$dataType = "City code";
							break;
						}
						self::_addError("$dataType ($datas[$k]) is different from the one previously defined with same site id. ($dataType)");
					}
				}
				# 5 : Projection SRID
				# 6 : x0
				# 7 : y0
				# 8 : x1
				# 9 : y1
				# 10 : z
				# 11 : centroid 
				$stop = false;

				$coords = array();
				self::$_current['centroid'] = false;

				// Site defined as centroid
				if (strtolower($datas[11]) == self::$_strings['Yes'][self::$_lang]) {
					self::$_current['centroid'] = true;
				}

				if (empty($datas[6]) || empty($datas[7])) {
					// City info not set: error
					if (empty($datas[3])) {
						self::_addError("Site has no coordinates and no city name provided.");
					} else if (empty($datas[4])) {
						self::_addError("Site has no coordinates and no city code provided.");
					} else {
						// Get city coords
						try {
							$cityInfos =	\mod\arkeogis\Tools::getCityInfos($datas[3], $datas[4]);
							$coords = array('x' => $cityInfos['x'], 'y' => $cityInfos['y'], 0);
							self::$_current['city_id'] = $cityInfos['id'];	
						} catch (\Exception $e) {
							self::_addError("Unable to find coordinates from city.");
						}
					}
				} else {
					if (empty($datas[8]) && empty($datas[9])) {
						$coords = array('x' => $datas[6], 'y' => $datas[7]);
					} else {
						// Get centroid coords
						try {
							$coords =	\mod\arkeogis\Tools::getSquareCentroid($datas[6], $datas[7], $datas[8], $datas[9]);
						} catch (\Exception $e) {
							self::_addError("Unable to find centroid coordinates.");
						}
					}
				}

				// Compute coords
				if (isset($coords['x']) && isset($coords['y'])) {
					if (empty($datas[5]))
						self::_addError("EPSG not provided");
					$epsg = (int)$datas[5];
					if ($epsg < 2) {
						$os = strtolower($datas[5]);
						if (!isset($epsgCodes[$os])) {
							self::_addError("Unable to get EPSG from code $datas[5]");
						} else {
							$epsg = $epsgCodes[$os];
						}
					}
					if (!empty($epsg) && $epsg != 4326) {
						// Check if geom exists
						if (!\core\Core::$db->fetchOne('SELECT count(srtext) FROM "spatial_ref_sys" WHERE "srid" = 4326')) {
							self::_addError("EPSG code provided not found ($datas[5]) it must be numeric, see http://www.epsg-registry.org/");
						} else {
							try {
								$coords = \mod\arkeogis\Tools::transformPoint($coords, $epsg, 4326);
							} catch (\Exception $e) {
								self::_addError("Unable to transform coordinates in WGS84. Error: ".$e->getMessage());
								$coords = null;
							}
						}
					}
					// Geom
					# 5 EPSG
						self::$_current['geom'] = (is_array($coords) && !empty($coords['x']) && !empty($coords['y'])) ? "ST_GeomFromText('POINT($coords[x] $coords[y] ".((!is_null($datas[10]) && $datas[10] != '') ? $datas[10] : -999).")', $epsg)" : NULL;
				}
				
			} // End of first time site processing


			# 12 : Knowledge
			if (in_array(strtolower($datas[12]), $knowledge[self::$_lang])) {
				$os = array_keys($knowledge[self::$_lang], strtolower($datas[12]));
				self::$_current['knowledge'] = $knowledge['en'][$os[0]];
			} else if (!empty($datas[12])) {
				self::_addError("Knowledge type ($datas[12]) is not referenced.");
			} else {
				self::$_current['knowledge'] = NULL;
			}

			# 13 : Occupation
			if (in_array(strtolower($datas[13]), $occupation[self::$_lang])) {
				$os = array_keys($occupation[self::$_lang], strtolower($datas[13]));
				self::$_current['occupation'] = $occupation['en'][$os[0]];
				// Check if period is "range"
				self::$_current['period_isrange'] = (self::$_current['occupation'] == 'continuous' && !isset(self::$_stored[self::$_current['code']])) ? true : false;
			} else if (!empty($datas[13])) {
				self::_addError("Occupation type ($datas[13]) is not referenced.");
			} else {
				if (!isset(self::$_stored[self::$_current['code']])) {
					self::_addError("Occupation type not defined");
				}
			}

			# 14 : Period start
			# 15 : Period end
			// We have starting and ending period
			if (!empty($datas[14]) && !empty($datas[15])) {
					self::$_current['period'] = self::_processPeriod($datas[14], $datas[15]);
			// We do not have starting and ending period
			} else {
				// It's the first time we process this site: error
				if (!isset(self::$_stored[self::$_current['code']])) {
					// No starting period
					if (empty($datas[14])) {
						self::_addError("Starting period not defined");
					}
					// No ending period
					if (empty($datas[15])) {
						self::_addError("Ending period not defined");
					}
					// We have already processed this site
				} else {
					self::$_current['period'] = self::$_stored[self::$_current['code']]['period'];
					
				}	// Done with new site, next it's common to new/already processed site
			}

			# 16 : Realestate level 1
			# 17 : Realestate level 2
			# 18 : Realestate level 3
			# 19 : Realestate level 4
			#
			if (empty($datas[16]) && (!empty($datas[17]) || !empty($datas[18]) || !empty($datas[19]))) {
				self::_addError("Realestate level 1 not set but some other realestate fields are defined");	
			} else {
				if (!empty($datas[16])) {
					self::_processLtree($datas[16], $datas[17], $datas[18], $datas[19], 'realestate');
				}
			}

			# 20 : Depth
			if (!empty($datas[20])) {
				if (!preg_match("/^[0-9]*\.?[0-9]+$/", $datas[20]) || $datas[20] < 10) {
					self::_addError("Depth invalid ($datas[20])");	
				} else {
					self::$_current['depth'] = $datas[20];
				}
			}

			# 21 : Realestate exceptional
			self::_processExceptional('realestate', $datas[21]);

			# 22 : Furniture level 1
			# 23 : Furniture level 2
			# 24 : Furniture level 3
			# 25 : Furniture level 4
			if (empty($datas[22]) && (!empty($datas[23]) || !empty($datas[24]) || !empty($datas[25]))) {
				self::_addError("Furniture level 1 not set but some other furniture fields are defined");	
			} else {
				if (!empty($datas[22]))
					self::_processLtree($datas[22], $datas[23], $datas[24], $datas[25], 'furniture');
			}

			# 26 : Furniture exceptional
			self::_processExceptional('furniture', $datas[26]);

			# 27 : Production level 1
			# 28 : Production level 2
			# 29 : Production level 3
			if (empty($datas[27]) && (!empty($datas[28]) || !empty($datas[29]))) {
				self::_addError("Production level 1 not set but some other production fields are defined");	
			} else {
				if (!empty($datas[27]))
					self::_processLtree($datas[27], $datas[28], $datas[29], NULL, 'production');
			}

			# 30 : Production exceptional
			self::_processExceptional('production', $datas[30]);

			# 31 : Biblio
			self::$_current['biblio'] = (!empty($datas[31])) ? $datas[31] : NULL;

			#32 : Comments
			self::$_current['comments'] = (!empty($datas[32])) ? $datas[32] : NULL;
			
			// OK we check if we have at leat one carac
			if (!isset(self::$_current['realestate']) && !isset(self::$_current['furniture']) && !isset(self::$_current['production'])) {
				self::_addError('No characteristic defined for this site');
			}

			// If no error
			if (!isset(self::$_siteErrors[self::$_current['code']])) {
				// If it's first time we process this site 
				if (!isset(self::$_stored[self::$_current['code']]) || empty(self::$_stored[self::$_current['code']])) {
					// Store site informations
					try {
						\mod\arkeogis\ArkeoGIS::addSite(self::$_current['code'], self::$_current['name'], self::$_database['id'], ((isset(self::$_current['city_id'])) ? self::$_current['city_id'] : NULL), self::$_current['geom'], self::$_current['centroid'], self::$_current['occupation'], self::$_current['owner']);
						self::$_stored[self::$_current['code']] = self::$_current;
						$numProcessed += 1;
					} catch (\Exception $e) {
						self::_addProcessingError($e->getMessage());
						continue;
					}
				}

				// Store site period informations

				$periods = array();
				$multipleStart = false;
				$multipleEnd = false;
				if (in_array(self::$_current['period']['start'], self::$_cache['specialperiod'][$lang])) {
					$multipleStart = true;
					//$periods['start'] = self::$_cache['specialperiod'][$lang][self::$_current['period']['start']];
				}
				if (in_array(self::$_current['period']['end'], self::$_cache['specialperiod'][$lang])) {
					$multipleEnd = true;
					//$periods['end'] = self::$_cache['specialperiod'][$lang][self::$_current['period']['end']];
				}

				// Multiple starting period and uniq ending period
				if ($multipleStart && !$multipleEnd) {
					foreach	(self::$_cache['specialperiod'][$lang][self::$_current['period']['start']] as $p) {
						$periods[] = array(\mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($p), self::$_current['period']['end']);
					}
				// Uniq starting period and multiple ending period
				} else if (!$multipleStart && $multipleEnd) {
					foreach	(self::$_cache['specialperiod'][$lang][self::$_current['period']['end']] as $p) {
						$periods[] = array(self::$_current['period']['start'], \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($p));
					}
				// Multiple starting period and multiple ending period
				} else if ($multipleStart && $multipleEnd) {
					foreach	(self::$_cache['specialperiod'][$lang][self::$_current['period']['start']] as $ps) {
						foreach	(self::$_cache['specialperiod'][$lang][self::$_current['period']['end']] as $pe) {
							$periods[] = array(\mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($ps), \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($pe));
						}
					}
				} else {
				// Uniq starting period and uniq ending period
					$periods[] = array(self::$_current['period']['start'], self::$_current['period']['end']);
				}

				foreach($periods as $period) {

					$md5Period = self::$_current['code'].$period[0].$period[1];
					$existing = \mod\arkeogis\ArkeoGIS::getSitePeriod(self::$_current['code'], $period[0], $period[1]);
					if (!empty($existing)) {
						self::$_cache['siteperiod'][$md5Period] = $existing;
					} else {
						try {
							self::$_cache['siteperiod'][$md5Period] = \mod\arkeogis\ArkeoGIS::addSitePeriod(self::$_current['code'], $period[0], $period[1], self::$_current['period_isrange'], ((isset(self::$_current['depth'])) ?  self::$_current['depth'] : NULL),self::$_current['knowledge'], self::$_current['comments'], self::$_current['biblio']);
						} catch (\Exception $e) {
							self::_addProcessingError($e->getMessage());
							continue;
						}
					}
					foreach(array('realestate', 'furniture', 'production') as $carac) {
						if (isset(self::$_current[$carac]) && !is_null(self::$_current[$carac])) {
							try {
								\mod\arkeogis\ArkeoGIS::addSitePeriodCharacteristic(self::$_cache['siteperiod'][$md5Period], $carac, self::$_current[$carac], ((isset(self::$_current[$carac.'_ex']) && self::$_current[$carac.'_ex']) ? 1 : 0));
							} catch (\Exception $e) {
								self::_addProcessingError($e->getMessage());
							}
						}
					}

				}


			} // End of site treatment, next one.

		}
		/*
		echo "<br /> ==== INSERTING SITE ERRORS ===== ";
		foreach(self::$_processingErrors as $k=>$entry) {
			foreach($entry AS $error) {
				echo "$k :: ".implode("<br />", $error['msg'])."<br />";
			}
		}
		*/
		\core\Core::$db->exec('COMMIT');
		return array("total" => (self::$_lineNumber-$skipline-1), "processed" => $numProcessed, "errors" => self::$_siteErrors);
	}

	private static function _processSiteId($siteCode) {
		if (empty($siteCode)) {
			return false;
		} else {
			if (!isset(self::$_stored[$siteCode]) && isset(self::$_database['id']) && !empty(self::$_database['id'])) {
				\mod\arkeogis\ArkeoGIS::deleteSite($siteCode, self::$_database['id']);
			}
			self::$_current['code'] = $siteCode;
		}
		return true;
	}

	private static function _processDatabaseName($dbName) {
		// Db name provided
		if (!empty($dbName)) {
			// we check if it matches previously stored db dbName
			if (isset(self::$_database['name']) && !empty(self::$_database['name'])) {
				if ($dbName != self::$_database['name']) {
					self::_addError("Database name ($dbName) is different from the database name previously defined (".self::$_database['name'].")");
					return false;
				} else {
					return;
				}
			}
			self::$_database['name'] = $dbName;
			$dbId = \mod\arkeogis\ArkeoGIS::getDatabaseId($dbName);
			if (!empty($dbId)) {
				self::$_database['id'] = $dbId;
				self::$_database['name'] = $dbName;
			} else {
				try {
					self::$_database['id'] = \mod\arkeogis\ArkeoGIS::addDatabase($dbName);
					self::$_database['name'] = $dbName;
				} catch (\Exception $e) {
					self::_addError("Unable to register database name $dbName: ".$e->getMessage());
				}
			}
		// No db name provided
		} else {
			if (empty(self::$_database['name'])) {
				self::$_current('No database name provided and no database already registered');
			}
		}
		self::$_current['database'] = self::$_database;
		return true;
	}

	private static function _checkDifference($num, $value) {
		// If ref already stored, we 'll get already defined values, so return true
		if (isset(self::$_stored[self::$_current['code']]))
			if (empty($value)) return true;
		// For new entry
		switch($num) {
			case 2:
				$dataType = "name";
				break;
			case 3:
				$dataType = "city_name";
				break;
			case 4:
				$dataType = "city_code";
				break;
			case 5:
				$dataType = "epsg";
				break;
		}
		// Store current value
			if (!isset(self::$_current[$dataType]))
				self::$_current[$dataType] = $value;
		// Compare
		if (isset(self::$_stored[self::$_current['code']][$dataType])) {
			if (self::$_stored[self::$_current['code']][$dataType] != $value)
				return false;
		}
		return true;
	}

	private static function _processPeriod($start, $end) {
		if (!isset(self::$_cache['period'][$start])) {
			$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($start, 'period', NULL, NULL, self::$_lang);
			if (sizeof($resPath) > 1) {
				self::_addError("Multiple results found for period ($start)");
				return;
			} else if (empty($resPath)) {
				self::_addError("No matching starting period found ($start)");
				return;
			}
			self::$_cache['period'][$start] = \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($resPath[0]['node_path']);
		}
		if (!isset(self::$_cache['period'][$end])) {
			$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($end, 'period', NULL, NULL, self::$_lang);
			if (sizeof($resPath) > 1) {
				self::_addError("Multiple results found for period ($end)");
				return;
			} else if (empty($resPath)) {
				self::_addError("No matching ending period found ($end)");
				return;
			}
			self::$_cache['period'][$end] = \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($resPath[0]['node_path']);
		}
		return array('start' => self::$_cache['period'][$start], 'end' => self::$_cache['period'][$end]);
	}

	private static function _processLtree($lvl1, $lvl2, $lvl3, $lvl4, $type) {
		$hash = md5($lvl1.$lvl2.$lvl3.$lvl4);

		if (isset(self::$_cache[$type][$hash])) {
			self::$_current[$type] = self::$_cache[$type][$hash];
		}

		$str = '';
		$ids = array();
		for($i=1;$i<=4;$i++) {
			$l = ${'lvl'.$i};
			if (!empty($l)) {
				$str .= $l;
				$h = md5($str);
				if (!isset(self::$_cache[$type][$h]) && !empty($l)) {
					$parentId = $i-1;
					$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($l, $type, $i, (($parentId > 0) ? ((isset($ids[$parentId])) ? $ids[$parentId] : NULL) : NULL), self::$_lang);
					if (sizeof($resPath) > 1) {
						self::_addError("Multiple results found for $type ($str)");
					} else if (sizeof($resPath) == 0) {
						self::_addError("No result found for $type ($str)");
					} else {
						$ids[$i] = self::$_cache[$type][$h] = $resPath[0]['node_path'];
					}	
				} else {
					$ids[$i] = self::$_cache[$type][$h];
				}
			}
		}
		if (isset(self::$_cache[$type][$h])) {
			self::$_current[$type] = \mod\arkeogis\ArkeoGIS::getCharacteristicIdFromPath($type, self::$_cache[$type][$h]);
		}	
	}

	private static function _processExceptional($type, $value) {
		if (!empty($value)) {
			if (strtolower($value) != self::$_strings['Yes'][self::$_lang] && strtolower($value) != self::$_strings['No'][self::$_lang]) {
				self::_addError(ucfirst($type)." exceptional flag invalid ($value)");	
			}
			if (strtolower($value) == self::$_strings['Yes'][self::$_lang]) {
				self::$_current[$type.'_ex'] = $value;
			}
		}
	}

	private static function _addError($msg) {
		$num = (!isset(self::$_siteErrors[self::$_current['code']]) || (!isset(self::$_siteErrors[self::$_current['code']][self::$_lineNumber]))) ? 0 : $num = sizeof(self::$_siteErrors[self::$_current['code']][self::$_lineNumber])+1;
		self::$_siteErrors[self::$_current['code']][self::$_lineNumber]['csvDatas'] = self::$_csvDatas;
		self::$_siteErrors[self::$_current['code']][self::$_lineNumber]['msg'][] = $msg;
	}

	private static function _addProcessingError($msg) {
		$num = (!isset(self::$_processingErrors[self::$_current['code']]) || (!isset(self::$_processingErrors[self::$_current['code']][self::$_lineNumber]))) ? 0 : $num = sizeof(self::$_processingErrors[self::$_current['code']][self::$_lineNumber])+1;
		self::$_processingErrors[self::$_current['code']][self::$_lineNumber]['csvDatas'] = self::$_csvDatas;
		self::$_processingErrors[self::$_current['code']][self::$_lineNumber]['msg'][] = $msg;
	}

	private static function _cleanString($str) {
		if (self::$_charset != 'utf8') $str = iconv(self::$_charset, 'utf8', $str);
		return trim(str_replace(array('"',';','NULL','null'), array('',"\n",NULL,NULL),$str));
	}

}

