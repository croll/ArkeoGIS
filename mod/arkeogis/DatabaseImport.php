<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

define(DAD, 1);
define(CHILD, 2);

class DatabaseImport {

	private static $_current = array();
	private static $_stored = array();
	private static $_database = array();
	private static $_siteErrors;
	private static $_charset;
	private static $_cache;
	private static $_lineNumber = 0;
	private static $_csvDatas = array(); 
	private static $_lang; 
	private static $_strings;

	public static function importCsv($filepath, $separator=';', $charset='utf8', $lf="\n", $skipline=NULL, $lang='fr') {

		// TO BE LINKED WITH TRANSLATION MODULE
		self::$_lang = $lang;
		self::$_charset = $charset;
		self::$_strings['Yes']['fr'] = 'oui';
		self::$_strings['No']['fr'] = 'non';
		$knowledge['fr'] = array('non renseigné', 'littérature, prospecté', 'littérature prospecté', 'sondé', 'fouillé');
		$occupation['fr'] = array('non renseigné', 'unique', 'continue', 'multiple');

		self::$_cache['period'] = array();
		self::$_cache['realestate'] = array();
		self::$_cache['furniture'] = array();
		self::$_cache['production'] = array();

		$strings['fr']['bronze indéterminé'] = 'Bronze Indéterminé (1800 – 800 av.JC)';
		$strings['fr']['bronze ancien'] = 'Bronze ancien (BRA 1800 – 1500 av.JC)';
		$strings['fr']['bronze moyen'] = 'Bronze moyen (BRM 1501 – 1200 av.JC)';
		$strings['fr']['bronze final'] = 'Bronze final (BRF 1201 – 800 av.JC)';
		$strings['fr']['brf1'] = 'BRF1 (1201 – 1050 av.JC)';
		$strings['fr']['brf2'] = 'BRF2 (1051 – 900 av.JC)';
		$strings['fr']['fer indéterminé'] = 'Fer indéterminé (801 – 25 av.JC)';
		$strings['fr']['hallstatt indéterminé'] = 'Hallstatt indéterminé (801 – 460 av.JC)';
		$strings['fr']['hallstatt C'] = 'Hallstatt C (HAC 801 –620 av.JC)';
		$strings['fr']['hallstatt D'] = 'Hallstatt D (HAD 621 – 460 av.JC)';
		$strings['fr']['had1'] = 'HAD1 (621 – 530 av.JC)';
		$strings['fr']['had2'] = 'HAD2 (531 – 500 av.JC)';
		$strings['fr']['had3'] = 'HAD3 (501 – 460 av.JC)';
		$strings['fr']['la tène indéterminée'] = 'La Tène indéterminée (461 – 25 av.JC)';
		$strings['fr']['la tène a'] = 'La Tène A (LTA 461 – 400 av.JC)';
		$strings['fr']['la tène b'] = 'La Tène B (LTB 401 – 260 av.JC)';
		$strings['fr']['ltb1'] = 'LTB1 (401 – 321 av.JC)';
		$strings['fr']['ltb2'] = 'LTB2 (321 – 260 av.JC)';
		$strings['fr']['la tène c'] = 'La Tène C (LTC 261 – 140 av.JC)';
		$strings['fr']['ltc1'] = 'LTC1 (261 – 200 av.JC)';
		$strings['fr']['ltc2'] = 'LTC2 (201 – 140 av.JC)';
		$strings['fr']['la tène d'] = 'La Tène D (LTD 141 – 25 av.JC)';
		$strings['fr']['ltd1'] = 'TD1 (141 – 70 av.JC)';
		$strings['fr']['ltd2'] = 'LTD2 (71 – 25 av.JC)';
		$strings['fr']['-40  +20'] = '-40  +20 (ap.JC)';
		$strings['fr']['+21 +100'] = '+21 +100 (ap.JC)';
		$strings['fr']['+101 +250'] = '+101 +250 (ap.JC)';
		$strings['fr']['+251 +310'] = '+251 +310 (ap.JC)';
		$strings['fr']['mérovingien indéterminé'] = 'Mérovingien Indéterminé (+451+720 ap.JC)';
		$strings['fr']['mérovingien ancien'] = 'Mérovingien ancien (+451 +600 ap.JC)';
		$strings['fr']['mérovingien ancien I'] = 'Mérovingien ancien I (+451 +520 ap.JC)';
		$strings['fr']['mérovingien ancien II'] = 'Mérovingien ancien II (+521 +550 ap.JC)';
		$strings['fr']['mérovingien ancien III'] = 'Mérovingien ancient III (+551+600 ap.JC)';
		$strings['fr']['mérovingien récent'] = 'Mérovingien récent (+601 +720 ap.JC)';
		$strings['fr']['mérovingien récent I'] = 'Mérovingien récent I (601-630 ap.JC)';
		$strings['fr']['mérovingien récent II'] = 'Mérovingien récent II  (631-680 ap.JC)';
		$strings['fr']['mérovingien récent III'] = 'Mérovingien récent III  (681-720 ap.JC)';

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

		foreach($lines as $datas) {

			self::$_lineNumber++;
			self::$_current = array();
			self::$_csvDatas = implode(';', $datas);

			if (self::$_lineNumber != NULL && self::$_lineNumber <= $skipline) {
				continue;
			}
			$datas = array_map(array('self', '_cleanString'), $datas);

			// Skip blank lines
			if (!isset($datas[1])) continue;

			# 0 : Site ID
			if (!self::_processSiteId($datas[0])) {
				self::_addError('No site unique ID provided');
				continue;
			}

			# 1 : Database
			self::_processDatabaseName($datas[1]);

			/* 
			 * Site not already processed
			 */
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
					if (empty($datas[6]) || empty($datas[7])) {
							// City info not set: error
							if (empty($datas[3])) {
								self::_addError("Site flagged as centroid but no city name provided.");
							} else if (empty($datas[4])) {
								self::_addError("Site flagged as centroid but no city code provided.");
							} else {
								// Get city coords
								try {
									$cityInfos =	\mod\arkeogis\Tools::getCityInfos($datas[3], $datas[4]);
									$coords = array('x' => $cityInfos['x'], 'y' => $cityInfos['y']);
									self::$_current['cityid'] = $cityInfos['id'];	
								} catch (\Exception $e) {
									self::_addError("Unable to find coordinates from city.");
								}
							}
						} else {
							if ($datas[11] != self::$_strings['Yes'][self::$_lang]) {
								self::_addError("Geo coordinates not defined but site not flagged as centroid.");
							}
						}
					// Si is not a centroid
				} else {
					// Only x0 y0
					if (empty($datas[8]) && empty($datas[9])) {
						$coords = array('x' => $datas[6], 'y' => $datas[7]);
					} else {
						if (empty($datas[8])) {
							self::_addError("Wrong coordinates for site.");
						} else if (empty($datas[9])) {
							self::_addError("Wrong coordinates for site.");
						} else {
							// Get city coords
							try {
								$coords =	\mod\arkeogis\Tools::getSquareCentroid($datas[6], $datas[7], $datas[8], $datas[9]);
							} catch (\Exception $e) {
								self::_addError("Unable to find centroid coordinates.");
							}
						}
					}
				}

				// Compute coords
				if (isset($coords['x']) && isset($coords['y'])) {
					if (!empty($datas[5]) && $datas[5] != 4326 && strtolower($datas[5]) != 'wgs84') {
						// Check if geom exists
						if (!\core\Core::$db->fetchOne('SELECT count(srtext) FROM "spatial_ref_sys" WHERE "srid" = 4326')) {
							self::_addError("EPSG code provided not found ($datas[5]) it must be numeric, see http://www.epsg-registry.org/");
						} else {
							try {
								$coords = \mod\arkeogis\Tools::transformPoint($coords, $datas[5], 4326);
							} catch (\Exception $e) {
								self::$_addError("Unable to transform coordinates in WGS84. Error: ".$e->getMessage());
								$coords = null;
							}
						}
					}
					if (is_array($coords))
						self::$_current['geom'] = "ST_GeomFromText('POINT($coords[x] $coords[y])', $datas[5])";
				}
				
			} // End of first time site processing

			# 12 : Knowledge
			if (in_array(strtolower($datas[12]), $knowledge[self::$_lang])) {
				self::$_current['knowledge'] = $datas[12];
			} else if (!empty($datas[12])) {
				self::_addError("Knowledge type ($datas[12]) is not referenced.");
			}

			# 13 : Occupation
			if (in_array(strtolower($datas[13]), $occupation[self::$_lang])) {
				self::$_current['occupation'] = $datas[13];
			} else if (!empty($datas[13])) {
				self::_addError("Occupation type ($datas[13]) is not referenced.");
			}

			# 14 : Period start
			# 15 : Period end
			// We have starting and ending period
			if (!empty($datas[14]) && !empty($datas[15])) {
					$os = strtolower($datas[14]);
					$datas[14] = (isset($strings['fr'][$os])) ? $strings['fr'][$os] : $datas[14];
					$os = strtolower($datas[15]);
					$datas[15] = (isset($strings['fr'][$os])) ? $strings['fr'][$os] : $datas[15];
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
					// It'as a continious occupation
					if ($datas[13] == 'continuous') {
						self::$_current['period'] = self::$_stored[self::$_current['code']]['period'];
					} else {
						self::_addError('Starting and/or ending period not found and occupation for this site not defined as continious');
					}
					
				}	// Done with new site, next it's common to new/already processed site
			}

			# 16 : Realestate level 1
			# 17 : Realestate level 2
			# 18 : Realestate level 3
			# 19 : Realestate level 4
			if (empty($datas[16]) && (!empty($datas[17]) || !empty($datas[18]) || !empty($datas[19]))) {
				self::_addError("Realestate level 1 not set but some other realestate fields are defined");	
			} else {
				if (!empty($datas[16]))
					self::_processLtree($datas[16], $datas[17], $datas[18], $datas[19], 'realestate');
			}

			# 20 : Depth
			if (!empty($datas[20])) {
				if (!preg_match("/^[0-9]*\.?[0-9]+$/", $datas[20]) || $datas[20] < 10) {
					self::_addError("Depth invalid ($datas[20])");	
				} else {
					self::$_current['depth'] == $datas[20];
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
			if (!empty($datas[31])) 
				self::$_current['biblio'] = $datas[31];

			#32 : Comments
			if (!empty($datas[32])) 
				self::$_current['comments'] = $datas[32];
			
			//print_r(self::$_current);

			// If no error
			if (!isset(self::$_siteErrors[self::$_current['code']])) {
				// If it's first time we process this site 
				if (!self::$_stored[self::$_current['code']]) {
					// Store site informations if needed to get information to children with same id
					print_r($_current);
					//\mod\arkeogis\ArkeoGIS::addSite(self::$_current['code'], self::$_current['name'], self::$_current['database']['id'], self::$_current['city']['id'], self::$_current['geom'], self::$_current['centroid'], self::$_current['occupation'], self::$_current['owner']);
					self::$_stored[self::$_current['code']] = self::$_current;
				}
			}

		}
		print_r(self::$_siteErrors);
	}

	private static function _processSiteId($siteCode) {
		if (empty($siteCode)) {
			return false;
		} else {
			if (!isset(self::$_stored[$siteCode])) {
				\mod\arkeogis\ArkeoGIS::deleteSite($siteCode);
			}
			self::$_current['code'] = $siteCode;
		}
		return true;
	}

	private static function _processDatabaseName($dbName) {
		// Db name provided
		if (!empty($dbName)) {
			// we check if it matches previously stored db dbName
			if (!empty(self::$_database['name']) && $dbName != self::$_database['name']) {
				self::_addError("Database name ($dbName) is different from the database name previously defined (".self::$_database['name'].")");
				return false;
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
					self::_addError("Unable to register database name $dbName");
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
			$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($start, 'period');
			if (sizeof($resPath) > 1) {
				self::_addError("Multiple results found for period ($start)");
				return;
			} else if (empty($resPath)) {
				self::_addError("No matching starting period found ($start)");
				return;
			}
			self::$_cache['period'][$start] = $resPath[0]['node_path'];
		}
		if (!isset(self::$_cache['period'][$end])) {
			$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($end, 'period');
			if (sizeof($resPath) > 1) {
				self::_addError("Multiple results found for period ($end)");
				return;
			} else if (empty($resPath)) {
				self::_addError("No matching ending period found ($end)");
				return;
			}
			self::$_cache['period'][$end] = $resPath[0]['node_path'];
		}
		return array('start' => self::$_cache['period'][$start], 'end' => self::$_cache['period'][$end]);
	}

	private static function _processLtree($lvl1, $lvl2, $lvl3, $lvl4, $type) {
		$hash = md5($lvl1.$lvl2.$lvl3.$lvl4);

		if (isset(self::$_cache[$type][$hash])) {
			return self::$_cache[$type][$hash];
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
					$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($l, $type, $i, (($parentId > 0) ? $ids[$parentId] : NULL));
					if (sizeof($resPath) > 1) {
						self::_addError("Multiple results found for $type ($str)");
					} else {
						$ids[$i] = self::$_cache[$type][$h] = $resPath[0]['node_path'];
					}	
				} else {
					$ids[$i] = self::$_cache[$type][$h];
				}
			}
		}
		if (isset(self::$_cache[$type][$h])) {
			self::$_current[$type] = self::$_cache[$type][$h];
		}	
	}

	private static function _processExceptional($type, $value) {
		if (!empty($value)) {
			if (strtolower($value) != strtolower(self::$_strings['Yes'][self::$_lang]) && strtolower($value) != strtolower(self::$_strings['No'][self::$_lang])) {
				self::_addError(ucfirst($type)." exceptional flag invalid ($value)");	
			}
			if (strtolower($value) == $strings['Yes'][self::$_lang]) {
				self::$_current['furniture_ex'] = $value;
			}
		}
	}

	private static function _addError($msg) {
		$num = (!isset(self::$_siteErrors[self::$_current['code']]) || (!isset(self::$_siteErrors[self::$_current['code']][self::$_lineNumber]))) ? 0 : $num = sizeof(self::$_siteErrors[self::$_current['code']][self::$_lineNumber])+1;
		self::$_siteErrors[self::$_current['code']][self::$_lineNumber]['csvDatas'] = self::$_csvDatas;
		self::$_siteErrors[self::$_current['code']][self::$_lineNumber]['msg'][] = $msg;
	}

	private static function _cleanString($str) {
		if (self::$_charset != 'utf8') $str = iconv(self::$_charset, 'utf8', $str);
		return trim(str_replace(array('"',';','NULL','null'), array('',"\n",NULL,NULL),$str));
	}

}
