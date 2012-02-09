<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class DatabaseImport {

	private static $_current = array();
	private static $_stored = array();
	private static $_databaseName = '';
	private static $_errors;
	private static $_charset;

	public static function parseCsv($filepath, $separator=';', $charset='utf8', $lf="\n", $skipline=NULL, $lang='fr') {

		// TO BE LINKED WITH TRANSLATION MODULE
		self::$_charset = $charset;
		$stringYes['fr'] = 'oui';
		$stringNo['fr'] = 'non';
		$knowledge['fr'] = array('Non renseigné', 'Littérature, prospecté', 'Littérature prospecté', 'Sondé', 'Fouillé');
		$occupation['fr'] = array('Non renseigné', 'Unique', 'Continue', 'Multiple');

		if (!is_file($filepath) || !is_readable($filepath)) {
			// Check if filename is in current directory (for tests)
			$moduleDir = dirname(__FILE__);
			if (is_file("$moduleDir/$filepath") && is_readable("$moduleDir/$filepath")) {
				$filepath = "$moduleDir/$filepath";
			} else {
				throw new \Exception("File does not exist or is not readable");
			}
		}

		$lineNumber = 0;

		$lines = array_chunk(str_getcsv(str_replace("\n", ';',file_get_contents($filepath)), $separator), 33);

		foreach($lines as $datas) {

			$lineNumber++;
			self::$_current = array();

			if ($lineNumber != NULL && $lineNumber <= $skipline) {
				continue;
			}
			$datas = array_map(array('self', '_cleanString'), $datas);

			// Skip blank lines
			if (!isset($datas[1])) continue;

			# 0 : Site ID
			if (!self::_processSiteId($datas[0])) {
				self::_addError(0, $lineNumber, 'No site unique ID provided');
				continue;
			}

			# 1 : Database
			if (!self::_processDatabaseName($datas[1])) {
				self::_addError(self::$_current[0], $lineNumber, "Database name ($datas[1]) is different from the database name previously defined (".self::$_databaseName.")");
			}

			// Site not already processed
			if (!isset(self::$_stored[self::$_current[0]])) {
				// If this site code already registered as error we do not process it
				if (isset(self::$_errors[self::$_current[0]])) {
						self::_addError(self::$_current[0], $lineNumber, "Site with same id already registered as error, skipping.");
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
						self::_addError(self::$_current[0], $lineNumber, "$dataType ($datas[$k]) is different from the one previously defined with same site id. (".self::$_databaseName.")");
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
							self::_addError(self::$_current[0], $lineNumber, "Site not flagged as centroid but no city name provided.");
							$stop = true;
						} else {
							self::$_current[3] = $datas[3];
						}
						if (empty($datas[4])) {
							self::_addError(self::$_current[0], $lineNumber, "Site not flagged as centroid but no city code provided.");
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
							self::_addError(self::$_current[0], $lineNumber, "Geo coordinates not defined but site not flagged as centroid.");
						}
					}
				} else {
					// Only x0 y0, it's a centroid
					if (empty($datas[8]) && empty($datas[9])) {
						$coords = array('x' => $datas[6], 'y' => $datas[7]);
					} else {
						if (empty($datas[8])) {
							self::_addError(self::$_current[0], $lineNumber, "Wrong coordinates for site.");
							$stop = true;
						} else {
							self::$_current[8] = $datas[8];
						}
						if (empty($datas[9])) {
							self::_addError(self::$_current[0], $lineNumber, "Wrong coordinates for site.");
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
				if (in_array($datas[12], $knowledge[$lang])) {
					self::$_current[12] = $datas[12];
				} else if (!empty($datas[12])) {
					self::_addError(self::$_current[0], $lineNumber, "Knowledge type ($datas[12]) is not referenced.");
				}

				#13 : Occupation
				if (in_array($datas[13], $occupation[$lang])) {
					self::$_current[13] = $datas[13];
				} else if (!empty($datas[13])) {
					self::_addError(self::$_current[0], $lineNumber, "Occupation type ($datas[13]) is not referenced.");
				}
			} else {
				// Site code already registered with no error
			}

		}
		print_r(self::$_errors);
	}

	private static function _processSiteId($siteCode) {
		if (empty($siteCode)) {
			return false;
		} else {
			if (!isset(self::$_stored[$siteCode])) {
				\mod\arkeogis\Site::delete($siteCode);
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

	private static function _addError($code, $lineNumber, $msg) {
		self::$_errors[$code][$lineNumber][] = $msg;
	}

	private static function _cleanString($str) {
		if (self::$_charset != 'utf8') $str = iconv(self::$_charset, 'utf8', $str);
		return trim(str_replace(array('"',';'), array('',"\n"),$str));
	}

}
