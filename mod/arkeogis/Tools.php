<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Tools {

	public static function getCityCoordinates($name=NULL, $code=NULL) {
		$q = "SELECT ST_X(ci_geom) AS x, ST_Y(ci_geom) AS y FROM ark_city ";
		$args = array();
		if (!empty($name)) {
			$q .= "WHERE ci_nameupper ILIKE ?";
			$args[] = str_replace('?','_',strtoupper(iconv("utf-8", "ascii//TRANSLIT", $name)));
		}
		print_r($args);
		if (!empty($code)) {
			$q .= ((sizeof($args) == 1) ? 'AND' : 'WHERE')." ci_code = ?";
			$args[] = (string)$code;
		}
		if (sizeof($args) == 0) {
			throw new \Exception("City name and code are empty");
		}
		$res = \core\Core::$db->fetchAll($q, $args);
		if (sizeof($res) > 1) {
			throw new \Exception("More than one city found.");
		}
		return $res[0];
	}

	public static function getSquareCentroid($x0, $y0, $x1, $y1) {
		return array('x' => (($x1-$x0)/2), 'y' => (($y1-$y0)/2));
	}
}
