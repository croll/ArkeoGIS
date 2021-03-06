<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Tools {

	public static function getCityInfos($name=NULL, $code=NULL) {
		$q = "SELECT ci_id AS id, ST_X(ci_geom) AS x, ST_Y(ci_geom) AS y FROM ark_city ";
		$args = array();
		if (!empty($name)) {
			$q .= "WHERE ci_nameupper ILIKE ?";
			$args[] = str_replace('?','_',strtoupper(iconv("utf-8", "ascii//TRANSLIT", $name)));
		}
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
		return (isset($res[0])) ? $res[0] : null;
	}

	public static function getSquareCentroid($x0, $y0, $x1, $y1) {
		return array('x' => ($x0+($x1-$x0)/2), 'y' => ($y0+($y1-$y0)/2));
	}

	public static function transformPoint($point, $from, $to) {
		$args = array($from, $to);
		$p = \core\Core::$db->fetchOne("SELECT ST_AsText(ST_Transform(ST_GeomFromText('POINT(".(float)$point['x']." ".(float)$point['y'].")', ?), ?)) AS geom", $args);
		if (!preg_match("/POINT\((-?[0-9\.]+) +(-?[0-9\.]+)\)/", $p, $m)) 
			return NULL;
		return array('x' => $m[1], 'y' => $m[2]);
	}
	public static function getUserGroups($uid) {
	return  implode('' , \mod\user\Main::getUserGroups($uid, 'name'));
    	}
    
	public static function getUserDatabases($uid) {
    		$db=\core\Core::$db;
		$dbs = $db->fetchAll('SELECT "da_name" FROM "ark_database" WHERE "da_owner_id"=?', array($uid));
		$dbstring='';
		foreach ($dbs as $key) {
			$dbstring .= $key['da_name'].',';
		}
		return $dbstring;
    	}
	public static function dbSort($sort) {
		$s=explode('_',$sort);
		$s[1]=strtoupper($s[1]);
		return $s[0]." ".$s[1];
    	}
    	public static  function order_by($sort) {
		$sorted = self::dbSort($sort);
		$q =" ORDER BY ".$sorted;
		return $q;
   	} 
}
