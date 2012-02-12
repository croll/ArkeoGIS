<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ArkeoGIS {

	public static function deleteSite($code) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=?', array($code));
	}

	public static function getUniquePathFromLabel($label, $type, $parentPath=NULL) {
		if (!preg_match("/^[a-z]+/", $type)) {
			throw new \Exception("Table name invalid");
		}
		$q = 'SELECT "node_path" FROM "ark_'.$type.'" WHERE "'.substr($type, 0, 2).'_name" ilike ?';
		$args = array($label);

		if (!is_null($parentPath)) { 
			$q.= 'AND node_path <@ ?';
			$args[] = $parentPath;
		}
		return \core\Core::$db->fetchAll($q, $args);
	}

}
