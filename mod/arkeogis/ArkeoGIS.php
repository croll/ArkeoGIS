<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ArkeoGIS {

	/* ********** */
	/*    Site   */
	/* ********** */
	public static function deleteSite($code) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=?', array($code));
	}

	public static function addSite($code, $name, $databaseid, $cityid=NULL, $geom=NULL, $centroid, $occupation, $authorid=0) {
		try {
			\core\Core::$db->exec('INSERT INTO "ark_site" ("si_code", "si_name", "si_database_id", "si_city_id", "si_geom", "si_centroid", "si_occupation", "si_author_id", "si_creation", "si_modification") VALUES (?,?,?,?,'.$geom.',?,?,?,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)', array($code, $name, (int)$databaseid, $cityid, (int)$centroid, $occupation, $authorid));
		} catch (\Exception $e) {
			throw new \Exception('Unable to add site: '.$e->getmessage());
		}
	}

	// Site informations fill functions  are splitted into two functions for convenience
	public static function addSitePeriod($siteCode, $startid, $endid, $isrange=0, $depth=NULL, $knowledge='unknown', $comment=NULL, $biblio=NULL) {
		$args = array($siteCode, $startid, $endid, $isrange, $depth, $knowledge, $comment, $biblio);
		try {
			\core\Core::$db->exec('INSERT INTO "ark_site_period" ("sp_site_code", "sp_period_start", "sp_period_end", "sp_period_isrange", "sp_depth", "sp_knowledge_type", "sp_comment", "sp_bibliography") VALUES (?,?,?,?,?,?,?,?)', $args);
			return (isset(\core\Core::$db->Insert_ID)) ? \core\Core::$db->Insert_ID : NULL;
		} catch (\Exception $e) {
			throw new \Exception('Unable to add site period: '.$e->getmessage());
		}
	}

	public static function getPeriodIdFromPath($node_path) {
		return \core\Core::$db->fetchOne('SELECT "pe_id" FROM "ark_period" WHERE "node_path" = ?' , array($node_path));
	}

	public static function addSitePeriodAditionalInfos($sitePeriodCode, $soil=NULL, $superfical=NULL, $analysis=NULL, $paleosol=NULL, $date_dendro=NULL, $date_14c=NULL) {
		try {
			\core\Core::$db->exec('UPDATE "ark_site_period" SET "sp_soil_type" = ?, "sp_superfical_type" = ?, "sp_analysis" = ?, "sp_paleosol" = ?, "sp_date_dendro" = ?, "sp_date_14C" = ? WHERE sp_id = ?', $args);
		} catch (\Exception $e) {
			throw new \Exception('Unable to add site period additional informations: '.$e->getmessage());
		}
	}

	public static function getSitePeriod($siteCode, $startid, $endid) {
		$args = array($siteCode, (int)$startid, (int)$endid);
		return \core\Core::$db->fetchOne('SELECT "sp_id" FROM "ark_site_period" WHERE "sp_site_code" = ? AND "sp_period_start" = ? AND "sp_period_end" = ?' , $args);
	}

	public static function addSitePeriodCharacteristic($sitePeriodId, $carac, $caracId, $exceptional=0) {
		$args = array((int)$sitePeriodId, $caracId, $exceptional);
		switch($carac) {
			case 'realestate':
				$prefix = 'sr';
			break;
			case 'furniture':
				$prefix = 'sf';
			break;
			case 'production':
				$prefix = 'sp';
			break;
		}
		try {
			\core\Core::$db->exec('INSERT INTO "ark_siteperiod_'.$carac.'" ("'.$prefix.'_site_period_id", "'.$prefix.'_'.$carac.'_id", "'.$prefix.'_exceptional") VALUES (?,?,?)', $args);
		} catch (\Exception $e) {
			throw new \Exception('Unable to add site caracteristic: '.$e->getmessage());
		}
	}

	/* ************* */
	/*    Database   */
	/* ************* */

	public static function addDatabase($dbName, $dbDescription=NULL, $owner_id=0) {
		$args = array($dbName, $dbDescription, (int)$owner_id);
		\core\Core::$db->exec('INSERT INTO "ark_database" ("da_name", "da_description", "da_owner_id", "da_creation", "da_modification") VALUES (?,?,?,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)', $args);
		return (isset(\core\Core::$db->Insert_ID)) ? \core\Core::$db->Insert_ID : NULL;
	}

	public static function getDatabaseId($dbName) {
		return \core\Core::$db->fetchOne('SELECT "da_id" FROM "ark_database" WHERE "da_name" = ?', (array)$dbName);
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
