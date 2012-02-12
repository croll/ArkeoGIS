<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

define(DAD, 1);
define(CHILD, 2);

class DatabaseImport {

	private static $_current = array();
	private static $_stored = array();
	private static $_databaseName = '';
	private static $_siteErrors;
	private static $_charset;
	private static $_cache;
	private static $_lineNumber = 0;
	private static $_csvDatas = array(); 
	private static $_lang; 
	private static $_strings;

	public static function parseCsv($filepath, $separator=';', $charset='utf8', $lf="\n", $skipline=NULL, $lang='fr') {

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
			if (!self::_processDatabaseName($datas[1])) {
				self::_addError("Database name ($datas[1]) is different from the database name previously defined (".self::$_databaseName.")");
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
						self::_addError("$dataType ($datas[$k]) is different from the one previously defined with same site id. (".self::$_databaseName.")");
						// Store site name
					} else if ($k == 2) {
						self::$_current['name'] = $datas[$k];
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
				if (empty($datas[6]) || empty($datas[7])) {
					// We do not have geo coordinates but it's flagged as centroid
					if (strtolower($datas[11]) == self::$_strings['Yes'][self::$_lang]) {
						// City info not set: error
						if (empty($datas[3])) {
							self::_addError("Site not flagged as centroid but no city name provided.");
							$stop = true;
						}
						if (empty($datas[4])) {
							self::_addError("Site not flagged as centroid but no city code provided.");
							$stop = true;
						}
						if (!$stop) {
							// Get city coords
							try {
								$coords =	\mod\arkeogis\Tools::getCityCoordinates($datas[3], $datas[4]);
							} catch (\Exception $e) {
								self::_addError("Unable to find coordinates from city.");
							}
						}
					} else {
						if ($datas[11] == self::$_strings['No'][self::$_lang]) {
							self::_addError("Geo coordinates not defined but site not flagged as centroid.");
						}
					}
				} else {
					// Only x0 y0, it's a centroid
					if (empty($datas[8]) && empty($datas[9])) {
						$coords = array('x' => $datas[6], 'y' => $datas[7]);
					} else {
						if (empty($datas[8])) {
							self::_addError("Wrong coordinates for site.");
							$stop = true;
						}
						if (empty($datas[9])) {
							self::_addError("Wrong coordinates for site.");
							$stop = true;
						}
						if (!$stop) {
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
				if (!isset($coords['x']) || !isset($coords['y'])) {
					self::_addError("Unable to get site coordinates..");
				} else {
					self::$_current['coords'] = $coords;
				}

			} else {
				// Site code already registered with no error
			}

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
			if (empty($datas[14])) {
				self::_addError("Starting period not defined");
			} else if (empty($datas[15])) {
				self::_addError("Ending period not defined");
			} else {
				self::$_current['period'] = self::_processPeriod($datas[14], $datas[15]);
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
				if (!preg_match("/^[0-9]*\.?[0-9]+$/", $datas[20]) || $datas[20] < 25) {
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
			self::$_current['biblio'] = $datas[31];

			#32 : Comments
			self::$_current['comments'] = $datas[32];

			print_r(self::$_current);
		}
		//print_r(self::$_siteErrors);
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
		// If we have a db dbName set, we check if it matches previously stored db dbName
		if (self::$_databaseName != '' && $dbName != '' && $dbName != self::$_databaseName) {
			return false;	
		} else if (!empty($dbName)) {
			if (self::$_databaseName == NULL && $dbName != '') {
				self::$_databaseName = $dbName;
			}
			self::$_current['database'] = $dbName;
		} else {
			if (empty(self::$_databaseName)) {
				return false;
			}
			if (empty(self::$_current['database'])) {
				self::$_current['database'] = self::$_databaseName;
			}
		}
		return true;
	}

	private static function _checkDifference($num, $value) {
		// If ref already stored, we 'll get already defined values, so return true
		if (isset(self::$_stored[self::$_current['code']]))
			if (empty($value)) return true;
		// For new entry
		if (isset(self::$_stored[self::$_current['code']][$num])) {
			if (self::$_stored[self::$_current['code']][$num] != $value)
				return false;
		}
		return true;
	}

	private static function _processPeriod($start, $end) {
		if (!isset(self::$_cache['period'][$start])) {
			$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($start, 'period');
			if (sizeof($resPath) > 1) {
				self::_addError("Multiple results founds for period ($start)");
				return;
			} 
			self::$_cache['period'][$start] = $resPath[0]['node_path'];
		}
		if (!isset(self::$_cache['period'][$end])) {
			$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($end, 'period');
			if (sizeof($resPath) > 1) {
				self::_addError("Multiple results founds for period ($end)");
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
		for($i=1;$i<=4;$i++) {
			$l = ${'lvl'.$i};
			if (!empty($l)) {
				$str .= $l;
				$h = md5($str);
				if (!isset(self::$_cache[$type][$h])) {
					$parentId = $i-1;
					try {
						$resPath = \mod\arkeogis\ArkeoGIS::getUniquePathFromLabel($l, $type, (($parentId > 0) ? $ids[$parentId] : NULL));

						if (sizeof($resPath) > 1) {
							self::_addError("Multiple results founds for $type");
							return;
						} 

						$ids[$i] = self::$_cache[$type][$h] = $resPath[0]['node_path'];
						//echo "$str == ".$ids[$i].' == '.$ids[$parentId]."\n";
					} catch (\Exception $e) {
						\core\Core::log($e->getMessage());
					}
				}
			}
		}
		if (isset(self::$_cache[$type][$h])) {
			self::$_current[$type] = self::$_cache[$type][$h];
		}	
	}

	private static function _processExceptional($type, $value) {
		if (!empty($value)) {
			if ($value != self::$_strings['Yes'][self::$_lang] && $value != self::$_strings['No'][self::$_lang]) {
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
