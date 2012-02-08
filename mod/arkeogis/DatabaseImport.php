<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class DatabaseImport {

	private static $_current = array();
	private static $_stored = array();
	private static $_databaseName = '';
	private static $_errors;

	public static function parseCsv($filepath, $separator, $charset, $lf, $skipline=NULL, $lang='fr') {

		// TO BE LINKED WITH TRANSLATION MODULE
		$stringYes['fr'] = 'oui';
		$knowlegde['fr'] = array('Non renseigné', 'Littérature', 'Sondé', 'Fouillé');
		$occupation['fr'] = array('Non renseigné', 'Unique', 'Continue', 'Multiple');

		if (!is_file($filepath) || !is_readable($filepath)) {
			throw new \Exception("File does not exist or is not readable");
			return;
		}

		$lineNumber = 0;
		$f = fopen($filepath, "r");

		 while (($line = stream_get_line($f, 4000, $lf))) {
			if ($lineNumber != NULL && $lineNumber <= $skipline) {
				$lineNumber++;
				continue;
			}
			if (strlen($line) > 3900) throw new \Exception("Line wrap seems to be bad.");
			$lineNumber++;
			if ($charset != 'utf8') $line=iconv($charset, 'utf8', $line);

			while($datas = explode($separator, $line)) {
				# 0 : Site ID
				if (!self::_processSiteId($datas[0])) {
					self::_addError($lineNumber, 'No site unique ID provided');
				}
				# 1 : Database
				if (!self::_processDatabaseName($datas[1])) {
					self::_addError($lineNumber, "Database name ($datas[1]) is different from the database name previously defined (".self::$_databaseName.")");
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
						self::_addError($lineNumber, "$dataType ($datsa[$k]) is different from the one previously defined with same site id. (".self::$_databaseName.")");
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
					// We do not have geo coordinates but it's flagged has centroid
					if ($datas[11] == $stringYes[$lang]) {
						// City info not set: error
						if (empty($datas[3])) {
							self::_addError($lineNumber, "Site not flagged has centroid but no city name provided.");
							$stop = true;
						} else {
							self::$_current[3] = $datas[3];
						}
						if (empty($datas[4])) {
							self::_addError($lineNumber, "Site not flagged has centroid but no city code provided.");
							$stop = true;
						} else {
							self::$_current[4] = $datas[4];
						}
						if (!$stop) {
							// Get city coords
							$coords =	\mod\arkeogis\Tools::getCityCoordinates($datas[3], $datas[4]);
						}
					} else {
						self::_addError($lineNumber, "Geo coordinates not defined but site not flagged has centroid.");
					}
				} else {
					// Only x0 y0, it's a centroid
					if (empty($datas[8]) && empty($datas[9])) {
						$coords = array('x' => $datas[6], 'y' => $datas[7]);
					} else {
						if (empty($datas[8])) {
							self::_addError($lineNumber, "Wrong coordinates for site.");
							$stop = true;
						} else {
							self::$_current[8] = $datas[8];
						}
						if (empty($datas[9])) {
							self::_addError($lineNumber, "Wrong coordinates for site.");
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
				if (in_array($datas[12], $knowledge[$lang]))
					self::$_current[12] = $datas[12];

				#13 : Occupation
				if (in_array($datas[13], $occupation[$lang]))
					self::$_current[13] = $datas[13];


				// Store data for the site if it is not already done
				if (!is_array(self::$_stored[$currentId]))
					self::$_stored[$currentId] = self::$_current;
			}
		}

		if (!feof($f)) throw new \Exception("File reading failed somewhere");

		fclose($f);
		return substr($outp, 0, -1);
	}

	private static function _processSiteId($siteId) {
		if (empty($siteId)) {
			return false;
		} else {
			if (!isset(self::$_stored[$siteId])) {
				// First time we process this site in current import, delete information if already exists in database
			}
			self::$_current[0] = $siteId;
		}
		return true;
	}

	private static function _processDatabaseName($dbName) {
		// If we have a db dbName set, we check if it matches previously stored db dbName
		if (self::$_databaseName != '' && $dbName != '' && $dbName != self::$_databaseName) {
			return fasle;	
		} else if (!empty($dbName)) {
			if (self::$_databaseName == NULL && $dbName != '') {
				self::$_databaseName = $dbName;
			}
			self::$_current[1] = $dbName;
		}
	}

	private static function _checkDifference($num, $value) {
		$currentId = self::$_current[0];
		if (isset(self::$_stored[$currentId][$num])) {
			if (self::$_stored[$currentId][$num] != $value)
				return false;
		}
		self::$_current[$num] = $value;
		return true;
	}

	private static function _addError($lineNumber, $msg) {
		self::$_errors = true;
	}

}
