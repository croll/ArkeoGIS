<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ArkeoGIS {

	/* ********** */
	/*    Site   */
	/* ********** */
	public static function deleteSite($code) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=?', array($code));
	}

	public static function addSite($code, $name, $databaseid, $cityid=NULL, $geom=NULL, $centroid, $occupation, $authorid) {
		\core\Core::$db->exec('INSERT INTO "ark_site" ("si_code", "si_name", "si_database_id", "si_city_id", "si_geom", "si_cendroid", "si_occupation", "si_author_id", "si_creation", "si_modification") VALUES (?,?,?,?,?,?,?,?,?,?,?)', array($code, $name, (int)$databaseid, $cityid, $geom, $centroid, $occupation, $authorid));
	}

	// Site informations fill functions  are splitted into two functions for convenience
	public static function addSitePeriod($siteCode, $startid, $endid, $isrange=0, $depth=NULL, $knowledge='unknown', $comment=NULL, $biblio=NULL) {
		\core\Core::$db->exec('INSERT INTO "ark_site_period" ("sp_site_code", "sp_period_start", "sp_period_end", "sp_period_isrange", "sp_depth", "sp_knowledge_type", "sp_comment", "sp_bibliography") VALUES (?,?,?,?,?,?,?,?)', $args;
		return (isset(\core\Core::$db->Insert_ID)) ? \core\Core::$db->Insert_ID : NULL;
	}

	public static function addSitePeriodAditionalInfos($sitePeriodCode, $soil=NULL, $superfical=NULL, $analysis=NULL, $paleosol=NULL, $date_dendro=NULL, $date_14c=NULL) {
		\core\Core::$db->exec('UPDATE "ark_site_period" SET "sp_soil_type" = ?, "sp_superfical_type" = ?, "sp_analysis" = ?, "sp_paleosol" = ?, "sp_date_dendro" = ?, "sp_date_14C" = ? WHERE sp_id = ?', $args);
	}

	/* ************* */
	/*    Database   */
	/* ************* */

	public static function addDatabase($dbName, $dbDescription=NULL, $owner_id=0) {
		$args = array($dbName, $dbDescription, (int)$owener_id);
		\core\Core::$db->exec('INSERT INTO "ark_database" ("da_name", "da_description", "da_owner_id", "da_creation", "da_modification") VALUES (?,?,?,current_timestamp(),current_timestamp())?', $args);
		return (isset(\core\Core::$db->Insert_ID)) ? \core\Core::$db->Insert_ID : NULL;
	}

	public static function getDatabaseId($dbName) {
		return \core\Core::$db->fetchOne('select "da_id" FROM "ark_databse" WHERE "da_name" = ?', (array)$dbName);
	}

	/* ************* */
	/*    Common   */
	/* ************* */

	public static function getUniquePathFromLabel($label, $type, $level=NULL, $parentPath=NULL) {
		if (!preg_match("/^[a-z]+/", $type)) {
			throw new \Exception("Table name invalid");
		}
		$q = 'SELECT "node_path" FROM "ark_'.$type.'" WHERE "'.substr($type, 0, 2).'_name" ilike ? ';
		$args = array($label);

		if (!is_null($level)) {
			 $q.= 'AND nlevel(node_path) = ?';
			 $args[] = $level;
		}

		if (!is_null($parentPath)) { 
			$q.= 'AND node_path <@ ?';
			$args[] = $parentPath;
		}
		return \core\Core::$db->fetchAll($q, $args);
	}

}
