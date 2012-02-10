<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ArkeoGIS {

	public static function deleteSite($code) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=?', array($code));
	}

	public static function getUniquePeriodPathFromLabel($label) {
		$res = \core\Core::$db->fetchAll('SELECT "node_path" FROM "ark_period" WHERE pe_name ilike ?', array($label));
		if (sizeof($res) > 1) {
			throw new \Exception("Multiple periods found with this name");
		} 
		return (is_null($res)) ? null : $res[0]['node_path'];
	}

	public static function getUniqueRealestatePathFromLabel($label, $parentPath=NULL) {
		$q = 'SELECT "node_path" FROM "ark_realestate" WHERE re_name ilike ?';
		$args = array($label);

		if (!is_null($parentPath)) { 
			$q.= 'AND node_path <@ ?';
			$args[] = $parentPath;
		}
		$res = \core\Core::$db->fetchAll($q, $args);

		if (sizeof($res) > 1) {
			throw new \Exception("Multiple periods found with this name");
		} 
		return (is_null($res)) ? null : $res[0]['node_path'];
	}

}
