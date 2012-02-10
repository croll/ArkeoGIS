<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class DatabaseImport {

	private static $_current = array();
	private static $_stored = array();
	private static $_databaseName = '';
	private static $_siteErrors;
	private static $_charset;
	private static $_cache;
	private static $_lineNumber = 0;
	private static $_csvDatas = array(); 

	public static function parseCsv($filepath, $separator=';', $charset='utf8', $lf="\n", $skipline=NULL, $lang='fr') {

		// TO BE LINKED WITH TRANSLATION MODULE
		self::$_charset = $charset;
		$stringYes['fr'] = 'oui';
		$stringNo['fr'] = 'non';
		$knowledge['fr'] = array('non renseigné', 'littérature, prospecté', 'littérature prospecté', 'sondé', 'fouillé');
		$occupation['fr'] = array('non renseigné', 'unique', 'continue', 'multiple');

		$_cache['period'] = array();
		$_cache['realestate'] = array();
		$_cache['furniture'] = array();
		$_cache['production'] = array();

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
			if (!isset(self::$_stored[self::$_current[0]])) {
				// If this site code already registered as error we do not process it
				if (isset(self::$_siteErrors[self::$_current[0]])) {
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

				if (empty($datas[6]) || empty($datas[7])) {
					$coords = NULL;
					// We do not have geo coordinates but it's flagged as centroid
					if ($datas[11] == $stringYes[$lang]) {
						// City info not set: error
						if (empty($datas[3])) {
							self::_addError("Site not flagged as centroid but no city name provided.");
							$stop = true;
						} else {
							self::$_current[3] = $datas[3];
						}
						if (empty($datas[4])) {
							self::_addError("Site not flagged as centroid but no city code provided.");
							$stop = true;
						} else {
							self::$_current[4] = $datas[4];
						}
						if (!$stop) {
							// Get city coords
							$coords =	\mod\arkeogis\Tools::getCityCoordinates($datas[3], $datas[4]);
						}
					} else {
						if ($datas[11] == $stringNo[$lang]) {
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
						} else {
							self::$_current[8] = $datas[8];
						}
						if (empty($datas[9])) {
							self::_addError("Wrong coordinates for site.");
							$stop = true;
						} else {
							self::$_current[9] = $datas[9];
						}
						if (!$stop) {
							// Get city coords
							$coords =	\mod\arkeogis\Tools::getSquareCentroid($datas[6], $datas[7], $datas[8], $datas[9]);
						}
					}
				}

				# 12 : Knowledge
				if (in_array(strtolower($datas[12]), $knowledge[$lang])) {
					self::$_current[12] = $datas[12];
				} else if (!empty($datas[12])) {
					self::_addError("Knowledge type ($datas[12]) is not referenced.");
				}

				# 13 : Occupation
				if (in_array(strtolower($datas[13]), $occupation[$lang])) {
					self::$_current[13] = $datas[13];
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
				# 19 : Realestate level 3
				if (empty($datas[16]) && (!empty($datas[17]) || !empty($datas[18]) || !empty($datas[19]))) {
					self::_addError("Period level 1 not set but next periods are defined");	
				} else {
					if (!empty($datas[16]))
						self::_processRealestate($datas[16], $datas[17], $datas[18], $datas[19]);
				}

			} else {
				// Site code already registered with no error
			}

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
			self::$_current[0] = $siteCode;
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
			self::$_current[1] = $dbName;
		} else {
			if (empty(self::$_databaseName)) {
				return false;
			}
			if (empty(self::$_current[1])) {
				self::$_current[1] = self::$_databaseName;
			}
		}
		return true;
	}

	private static function _checkDifference($num, $value) {
		// If ref already stored, we 'll get already defined values, so return true
		if (isset(self::$_stored[self::$_current[0]]))
			if (empty($value)) return true;
		// For new entry
		if (isset(self::$_stored[self::$_current[0]][$num])) {
			if (self::$_stored[self::$_current[0]][$num] != $value)
				return false;
		}
		self::$_current[$num] = $value;
		return true;
	}

	private static function _processPeriod($start, $end) {
		if (!isset(self::$_cache['period'][$start])) {
			try {
				$_cache['period'][$start] = \mod\arkeogis\ArkeoGIS::getUniquePeriodPathFromLabel($start);
			} catch (Exception $e) {
				self::_addError($e->getMessage());
				return;
			}
		}
		if (!isset(self::$_cache['period'][$end])) {
			try {
				$_cache['period'][$end] = \mod\arkeogis\ArkeoGIS::getUniquePeriodPathFromLabel($end);
			} catch (Exception $e) {
				self::_addError($e->getMessage());
				return;
			}
		}
		return array('start' => $_cache['period'][$start], 'end' => $_cache['period'][$end]);
	}

	private static function _processRealestate($lvl1, $lvl2, $lvl3, $lvl4) {
		// Get level 1 from ID
		$lvl1hash = md5($lvl1);
		if (!isset(self::$_cache['realestate'][$lvl1hash])) {
			try {
				$_cache['realestate'][$lvl1hash] = \mod\arkeogis\ArkeoGIS::getUniqueRealestatePathFromLabel($lvl1);
			} catch (Exception $e) {
				self::_addError($e->getMessage());
				return;
			}
		}
		// If level 2 is set, we try to find it with level 1 id and level 2 name
		if (!empty($lvl2)) {
			$lvl2hash = md5($lvl2);
			print_r($_cache);
			die();
			echo $_cache['realestate'][$lvl1hash];
			if (!isset(self::$_cache['realestate'][$lvl2hash])) {
				try {
					$_cache['realestate'][$lvl2hash] = \mod\arkeogis\ArkeoGIS::getUniqueRealestatePathFromLabel($lvl2, self::$_cache['realestate'][$lvl1hash]);
				} catch (Exception $e) {
					self::_addError($e->getMessage());
					return;
				}
			}
		}
	}

	private static function _addError($msg) {
		$num = (!isset(self::$_siteErrors[self::$_current[0]]) || (!isset(self::$_siteErrors[self::$_current[0]][self::$_lineNumber]))) ? 0 : $num = sizeof(self::$_siteErrors[self::$_current[0]][self::$_lineNumber])+1;
		self::$_siteErrors[self::$_current[0]][self::$_lineNumber]['csvDatas'] = self::$_csvDatas;
		self::$_siteErrors[self::$_current[0]][self::$_lineNumber]['msg'][] = $msg;
	}

	private static function _cleanString($str) {
		if (self::$_charset != 'utf8') $str = iconv(self::$_charset, 'utf8', $str);
		return trim(str_replace(array('"',';','NULL','null'), array('',"\n",NULL,NULL),$str));
	}

}
