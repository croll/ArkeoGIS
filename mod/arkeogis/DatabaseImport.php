<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class DatabaseImport {

	private static $_current = array();
	private static $_stored = array();
	private static $_database = array();
	private static $_siteErrors;
	private static $_processingErrors = array();
	private static $_cache;
	private static $_lineNumber = 0;
	private static $_csvDatas = array(); 
	private static $_lang; 
	private static $_strings;
	private static $_nbSites = 0;
	private static $_temporalBounds = array('start' => '1', 'end' => '1');

	public static function importCsv($filepath, $separator=';', $enclosure='"', $skipline=0, $lang='fr', $fields='') {

		self::$_lang = $lang;

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

		self::$_cache['period_start'] = array();
		self::$_cache['period_end'] = array();
		self::$_cache['realestate'] = array();
		self::$_cache['furniture'] = array();
		self::$_cache['landscape'] = array();
		self::$_cache['production'] = array();
		self::$_cache['siteperiod'] = array();
		self::$_cache['specialperiod'] = array();

		$stop = false;
		$uid = NULL;
		// Get user ID
		if ($_SESSION['login'] == 'admin') 
			$uid = 0;
		else
			$uid = \mod\user\Main::getUserId($_SESSION['login']);

		if (!is_int($uid)) {
			die("User ID cannot be found");
		}

		if (!is_file($filepath) || !is_readable($filepath)) {
			// Check if filename is in current directory (for tests)
			$moduleDir = dirname(__FILE__);
			if (is_file("$moduleDir/$filepath") && is_readable("$moduleDir/$filepath")) {
				$filepath = "$moduleDir/$filepath";
			} else {
				throw new \Exception("File does not exist or is not readable: \"$filepath\"");
			}
		}

		if ($separator == '\t') $separator="\t";
		$os = '';
		if (($handle = fopen($filepath, "r")) !== FALSE) {
			while (($content = fgetcsv($handle, 1000, $separator, $enclosure)) !== FALSE) {
				$lines[] = $content;
				$os .= implode($content, '');
			}
		}

		\core\Core::$db->exec('BEGIN');

		// Retrieve special periods

		foreach(\core\Core::$db->fetchAll('SELECT "node_path", "pe_name_'.$lang.'" FROM "ark_period" WHERE "pe_name_'.$lang.'" IN (?, ?, ?, ?, ?, ?, ?)', array('BRF3/HAC1', 'HAC2/HAD1', 'HAD3/LTA1', 'LTC2/LTD1', 'Grandes  invasions', 'Grandes invasions', 'Völkerwanderungszeit')) as $row) {
			self::$_cache['specialperiod'][$lang][$row['pe_name_'.$lang]][] = $row['node_path']; 
		}

		foreach($lines as $datas) {

			self::$_lineNumber++;
			self::$_current = array();
			self::$_csvDatas = implode(';', $datas);

			if (self::$_lineNumber != 0 && self::$_lineNumber <= $skipline) {
				continue;
			}
			$datas = array_map(array('self', '_cleanString'), $datas);

			// Skip blank lines
			if (!isset($datas[1])) continue;

			# 1 : Database
			self::_processDatabaseName($datas[1], $fields, $uid);

			# 0 : Site ID
			if (!self::_processSiteId($datas[0])) {
				self::_addError('No site unique ID provided');
				continue;
			}

			# 10 z
			$datas[10] = trim($datas[10]);
			if (!empty($datas[10]) && !preg_match('/^[0-9]+$/', $datas[10])) {
				self::_addError('Altitude invalid: String provided, Int expected: '.$datas[10]);
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

				$datas[6] = str_replace(',', '.', $datas[6]);
				$datas[7] = str_replace(',', '.', $datas[7]);
				$datas[8] = str_replace(',', '.', $datas[8]);
				$datas[9] = str_replace(',', '.', $datas[9]);

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
						if (!\core\Core::$db->fetchOne('SELECT count(srtext) FROM "spatial_ref_sys" WHERE "srid" = ?', array($epsg))) {
							self::_addError("EPSG code provided not found ($datas[5]) it must be numeric, see http://www.epsg-registry.org/");
						} else {
							try {
								$coords = \mod\arkeogis\Tools::transformPoint($coords, $epsg, 4326);
								if (empty($coords)) {
									self::_addError("Unable to transform coordinates in WGS84.");
								}
							} catch (\Exception $e) {
								self::_addError("Unable to transform coordinates in WGS84. Error: ".$e->getMessage());
								$coords = null;
							}
						}
					}
					// Geom
					# 5 EPSG
					self::$_current['geom'] = (is_array($coords) && !empty($coords['x']) && !empty($coords['y'])) ? "ST_GeomFromText('POINT($coords[x] $coords[y] ".((!is_null($datas[10]) && $datas[10] != '') ? $datas[10] : -999).")', 4326)" : NULL;
				} else {
					self::$_current['geom'] = 'NULL';
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
				self::$_current['period_isrange'] = 1;
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
					self::$_current['period_isrange'] = 0;
					
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

			/*
			# 20 : Depth
			if (!empty($datas[20])) {
				if (!preg_match("/^[0-9]*\.?[0-9]+$/", $datas[20]) || $datas[20] < 10) {
					self::_addError("Depth invalid ($datas[20])");	
				} else {
					self::$_current['depth'] = $datas[20];
				}
			}
			*/

			# 20 : Realestate exceptional
			self::_processExceptional('realestate', $datas[20]);

			# 21 : Furniture level 1
			# 22 : Furniture level 2
			# 23 : Furniture level 3
			# 24 : Furniture level 4
			if (empty($datas[21]) && (!empty($datas[22]) || !empty($datas[23]) || !empty($datas[24]))) {
				self::_addError("Furniture level 1 not set but some other furniture fields are defined");	
			} else {
				if (!empty($datas[21]))
					self::_processLtree($datas[21], $datas[22], $datas[23], $datas[24], 'furniture');
			}

			# 25 : Furniture exceptional
			self::_processExceptional('furniture', $datas[25]);

			# 26 : Production level 1
			# 27 : Production level 2
			# 28 : Production level 3
			if (empty($datas[26]) && (!empty($datas[27]) || !empty($datas[28]))) {
				self::_addError("Production level 1 not set but some other production fields are defined");	
			} else {
				if (!empty($datas[26]))
					self::_processLtree($datas[26], $datas[27], $datas[28], NULL, 'production');
			}

			# 29 : Production exceptional
			self::_processExceptional('production', $datas[29]);

			# 30 : Landscape 1
			# 31 : Landscape 2
			# 32 : Landscape 3
			# 33 : Landscape 4
			if (empty($datas[30]) && (!empty($datas[31]) || !empty($datas[32]) || !empty($datas[33]))) {
				self::_addError("Landscape level 1 not set but some other landscape fields are defined");	
			} else {
				if (!empty($datas[30]))
					self::_processLtree($datas[30], $datas[31], $datas[32], $datas[33], 'landscape');
			}

			# 34 : Landcape exceptional
			self::_processExceptional('landscape', $datas[29]);

			# 35 : Biblio
			self::$_current['biblio'] = (!empty($datas[35])) ? $datas[35] : NULL;

			#36 : Comments
			self::$_current['comments'] = (!empty($datas[36])) ? $datas[36] : NULL;
			
			// OK we check if we have at leat one carac
			if (!isset(self::$_current['realestate']) && !isset(self::$_current['furniture']) && !isset(self::$_current['production']) && !isset(self::$_current['landscape'])) {
				self::_addError('No characteristic defined for this site');
			}

			// If no error
			if (!isset(self::$_siteErrors[self::$_current['code']])) {
				// If it's first time we process this site 
				if (!isset(self::$_stored[self::$_current['code']]) || empty(self::$_stored[self::$_current['code']])) {
					// Store site informations
					try {
						self::$_current['siteId'] = \mod\arkeogis\ArkeoGIS::addSite(self::$_current['code'], self::$_current['name'], self::$_database['id'], ((isset(self::$_current['city_id'])) ? self::$_current['city_id'] : NULL), self::$_current['geom'], self::$_current['centroid'], self::$_current['occupation'], trim($datas[3], '" '), trim($datas[4], '" '), $uid);
						self::$_nbSites += 1;
						self::$_stored[self::$_current['code']] = self::$_current;
					} catch (\Exception $e) {
						self::_addProcessingError($e->getMessage());
						continue;
					}
				}

				// Store site period informations
				$md5Period = self::$_current['code'].self::$_current['period']['start'].'-'.self::$_current['period']['end'];
				if (!isset(self::$_current['siteId'])) {
					if (isset(self::$_stored[self::$_current['code']]))
						$siteId = self::$_stored[self::$_current['code']]['siteId'];
					else 
						throw new \Exception('Unable to get site id for this period');
				} else {
					$siteId = self::$_current['siteId'];
				}
				if (!empty($siteId)) {
					$existing = \mod\arkeogis\ArkeoGIS::getSitePeriod($siteId, self::$_current['period']['start'], self::$_current['period']['end']);
				}
				if (!empty($existing)) {
					self::$_cache['siteperiod'][$md5Period] = $existing;
				} else {
					try {
						self::$_cache['siteperiod'][$md5Period] = \mod\arkeogis\ArkeoGIS::addSitePeriod($siteId, self::$_current['period']['start'], self::$_current['period']['end'], (isset(self::$_current['period_isrange']) ? self::$_current['period_isrange'] : NULL), NULL, self::$_current['knowledge'], self::$_current['comments'], self::$_current['biblio']);
					} catch (\Exception $e) {
						self::_addProcessingError($e->getMessage());
						continue;
					}
				}
				foreach(array('realestate', 'furniture', 'production', 'landscape') as $carac) {
					if (isset(self::$_current[$carac]) && !is_null(self::$_current[$carac])) {
						try {
							\mod\arkeogis\ArkeoGIS::addSitePeriodCharacteristic(self::$_cache['siteperiod'][$md5Period], $carac, self::$_current[$carac], ((isset(self::$_current[$carac.'_ex']) && self::$_current[$carac.'_ex']) ? 1 : 0));
						} catch (\Exception $e) {
							self::_addProcessingError($e->getMessage());
						}
					}
				}
				$existing = null;
				$siteId = null;


			} // End of site treatment, next one.

		}
		\core\Core::$db->exec('COMMIT');
		$nbLines = self::$_lineNumber-$skipline-1;
		self::_postProcess($filepath, $nbLines, $uid);
		return array("total" => $nbLines, "processed" => self::$_nbSites, "errors" => self::$_siteErrors, "processingErrors" => self::$_processingErrors);
	}
//
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

	private static function _processDatabaseName($dbName, $fields, $ownerId) {
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
			$dbId = \mod\arkeogis\ArkeoGIS::getDatabaseId($dbName);
			// Check if owner owns the database
			if (!\mod\user\Main::userhasRight('Manage all databases') && !\mod\user\Main::userhasRight('Manage personal database')) {
				self::_addError('You are not allowed to import a database');
				return false;
			} else if ($dbId && !\mod\user\Main::userhasRight('Manage all databases') && (\mod\user\Main::userhasRight('Manage personal database') && !\mod\arkeogis\ArkeoGIS::isDatabaseOwner($dbId, $ownerId))) {
				self::_addError('Database '.self::$_database['name'].' already exists and not belongs to you');
				return false;
			}
			self::$_database['name'] = $dbName;
			if (!empty($dbId)) {
				self::$_database['id'] = $dbId;
				self::$_database['name'] = $dbName;
				if (sizeof($fields) > 0) {
					\mod\arkeogis\ArkeoGIS::updateDatabase($dbId, $fields);
				}
			} else {
				try {
					self::$_database['id'] = \mod\arkeogis\ArkeoGIS::addDatabase($dbName, $fields, $ownerId);
					self::$_database['name'] = $dbName;
				} catch (\Exception $e) {
					self::_addError("Unable to register database name $dbName: ".$e->getMessage());
				}
			}
		// No db name provided
		} else {
			if (empty(self::$_database['name'])) {
				self::_addError('No database name provided and no database already registered');
			}
		}
		self::$_current['database'] = self::$_database;
		return;
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
		if (!isset(self::$_cache['period_start'][$start])) {
			// Special period start
			if (in_array($start, array_keys(self::$_cache['specialperiod'][self::$_lang]))) {
				self::$_cache['period_start'][$start] = \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath(self::$_cache['specialperiod'][self::$_lang][$start][0]);
				$path = self::$_cache['specialperiod'][self::$_lang][$start][0];
			} else {
			// Normal period start
				$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($start, 'period', NULL, NULL, self::$_lang);
				if (sizeof($resPath) > 1) {
					self::_addError("Multiple results found for period ($start)");
					return;
				} else if (empty($resPath)) {
					self::_addError("No matching starting period found ($start)");
					return;
				}
				self::$_cache['period_start'][$start] = \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($resPath[0]['node_path']);
				$path = $resPath[0]['node_path'];
			}
			self::_setTemporalBounds($path, 'start');
		}
		if (!isset(self::$_cache['period_end'][$end])) {
			// Special period end
			if (in_array($end, array_keys(self::$_cache['specialperiod'][self::$_lang]))) {
				self::$_cache['period_end'][$end] = \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath(self::$_cache['specialperiod'][self::$_lang][$end][1]);
				$path = self::$_cache['specialperiod'][self::$_lang][$start][0];
			} else {
				// Normal period end
				$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($end, 'period', NULL, NULL, self::$_lang);
				if (sizeof($resPath) > 1) {
					self::_addError("Multiple results found for period ($end)");
					return;
				} else if (empty($resPath)) {
					self::_addError("No matching ending period found ($end)");
					return;
				}
				self::$_cache['period_end'][$end] = \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath($resPath[0]['node_path']);
				$path = $resPath[0]['node_path'];
			}
			self::_setTemporalBounds($path, 'end');
		}
		return array('start' => self::$_cache['period_start'][$start], 'end' => self::$_cache['period_end'][$end]);
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
			if (strtolower($value) != self::$_strings['Yes'][self::$_lang] && strtolower($value) != self::$_strings['No'][self::$_lang] && $value != 0 && $value != 1) {
				self::_addError(ucfirst($type)." exceptional flag invalid ($value)");	
			}
			if (strtolower($value) == self::$_strings['Yes'][self::$_lang] || $value == 1) {
				self::$_current[$type.'_ex'] = $value;
			}
		}
	}

	private static function _addError($msg) {
		if (!isset(self::$_current['code'])) self::$_current['code'] = 'NO_CODE';
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
		$detected = mb_detect_encoding($str, array('utf-8', 'latin1', 'windows-1251'), true);
		if ($detected != 'UTF-8') {
			$str = iconv($detected, 'UTF-8', $str);
		}
		return trim(str_replace(array('"',';','NULL','null'), array('',"\n",NULL,NULL),$str));
	}

	private static function _detectEncodingBastard($str) {
		foreach(array('utf8', 'Windows-1252', 'lantin1', 'mac') as $c) {
			if (md5($str) == md5(iconv($c, 'utf8', $str))) 
				return $c;
			return false;
		}
	}

	private static function _setTemporalBounds($period, $type) {
		/* if ($type == 'end')
			echo "$type -- Actual: ".self::$_temporalBounds[$type]." To check: $period => "; */
		if (self::$_temporalBounds[$type] == 1) {
			self::$_temporalBounds[$type] = $period;
			return;
		}
		$actual = preg_split('/\./', self::$_temporalBounds[$type]);
		$tocheck = preg_split('/\./', $period);
		$slice = null;
		// If period == 'Intederminé' => exit
		if ($tocheck[0] == 1) {
			// echo "\n";
			return;
		}
		// Starting period
		if ($type == 'start') {
			for($i=0;$i<sizeof($actual);$i++) {
				if (isset($tocheck[$i])) {
					if ($actual[$i] > $tocheck[$i]) {
						self::$_temporalBounds[$type] = $period;
						continue;
					} else if ($actual[$i] < $tocheck[$i]) {
						continue;
					}
				}
			}
		// Ending period
		} else if ($type == 'end') {
			for($i=0;$i<sizeof($actual);$i++) {
				if (isset($tocheck[$i])) {
					if ($actual[$i] < $tocheck[$i]) {
						self::$_temporalBounds[$type] = $period;
						continue;

					} else if ($actual[$i] > $tocheck[$i]) {
						continue;
					}
				}
			}
		}
		// echo self::$_temporalBounds[$type]."\n";
	}

	private static function _postProcess($filepath, $nbLines, $uid) {
		$filename = md5(file_get_contents($filepath));
		if (!rename($filepath, dirname(__FILE__).'/files/import/'.$filename)) {
			throw new \Exception("Unable to move \"$filepath\".");
		}
		\mod\arkeogis\ArkeoGIS::updateDatabase(self::$_database['id'], array('lines' => $nbLines, 'sites' => self::$_nbSites, 'period_start' => \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath(self::$_temporalBounds['start']), 'period_end' => \mod\arkeogis\ArkeoGIS::getPeriodIdFromPath(self::$_temporalBounds['end'])));
		\mod\arkeogis\ArkeoGIS::deleteLastCsv(self::$_database['id'], $filename);
		\mod\arkeogis\ArkeoGIS::writeDatabaseLog(self::$_database['id'], $uid, $filename);
	}

}