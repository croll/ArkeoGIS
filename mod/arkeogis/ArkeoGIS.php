<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ArkeoGIS {

	/* ********** */
	/*    Site   */
	/* ********** */
	public static function deleteSite($code, $databaseId) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=? AND si_database_id=?', array((string)$code,(int)$databaseId));
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
			return \core\Core::$db->exec_returning('INSERT INTO "ark_site_period" ("sp_site_code", "sp_period_start", "sp_period_end", "sp_period_isrange", "sp_depth", "sp_knowledge_type", "sp_comment", "sp_bibliography") VALUES (?,?,?,?,?,?,?,?) ', $args, 'sp_id');
		} catch (\Exception $e) {
			throw new \Exception('Unable to add site period: '.$e->getmessage());
		}
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
		if (!preg_match("/^[a-z]+$/", $carac))
			throw new \Exception("Carateristic type invalid");
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
			$args = array((int)$sitePeriodId, $caracId, $exceptional);
			\core\Core::$db->exec('INSERT INTO "ark_siteperiod_'.$carac.'" ("'.$prefix.'_site_period_id", "'.$prefix.'_'.$carac.'_id", "'.$prefix.'_exceptional") VALUES (?,?,?)', $args);
		} catch (\Exception $e) {
			throw new \Exception('Unable to add site caracteristic: '.$e->getmessage());
		}
	}


	public static function search_sites($search, $select, $addtable=array(), $limit=100) {
		$addtable=array('ark_siteperiod_production' => isset($addtable['ark_siteperiod_production']) ? $addtable['ark_siteperiod_production'] : false,
										'ark_siteperiod_furniture' => isset($addtable['ark_siteperiod_furniture']) ? $addtable['ark_siteperiod_furniture'] : false,
										'ark_siteperiod_realestate' => isset($addtable['ark_siteperiod_realestate']) ? $addtable['ark_siteperiod_realestate'] : false,
										'ark_database' => isset($addtable['ark_database']) ? $addtable['ark_database'] : false,
										'ark_city' => isset($addtable['ark_city']) ? $addtable['ark_city'] : false);

		$where='sp_period_isrange=1 ';
		$args=array();

		if (isset($search['db_include']) && count($search['db_include'])) {
			$where.=' AND si_database_id IN (?)';
			$args[]=$search['db_include'];
		}

		if (isset($search['db_exclude']) && count($search['db_exclude'])) {
			$where.=' AND si_database_id NOT IN (?)';
			$args[]=$search['db_exclude'];
		}

		if (isset($search['period_include']) && count($search['period_include'])) {
      $where.=' AND (0=1 ';
			foreach($search['period_include'] as $period) {
				$where.=' OR sp_period_start >= ? AND sp_period_start <= ?';
				$args[]=$period;
				$args[]=$period;
			}
      $where.=')';
		}

		if (isset($search['period_exclude']) && count($search['period_exclude'])) {
      $where.=' AND (0=1 ';
			foreach($search['period_exclude'] as $period) {
				$where.=' OR NOT (sp_period_start >= ? AND sp_period_start <= ?)';
				$args[]=$period;
				$args[]=$period;
			}
      $where.=')';
		}

		if (isset($search['centroid_include']) && count($search['centroid_include'])) {
      $where.=' AND si_centroid IN (?)';
      $args[]=$search['centroid_include'];
		}

		if (isset($search['knowledge_include']) && count($search['knowledge_include'])) {
			$where.=' AND sp_knowledge_type IN(?)';
			$args[]=$search['knowledge_include'];
		}

		if (isset($search['occupation_include']) && count($search['occupation_include'])) {
      $where.=' AND si_occupation IN (?)';
      $args[]=$search['occupation_include'];
		}

		if (isset($search['production_include']) && count($search['production_include'])) {
			$addtable['ark_siteperiod_production']=true;
			$where.=' AND sp_production_id IN (?)';
			$args[]=$search['production_include'];
		}

		if (isset($search['production_exclude']) && count($search['production_exclude'])) {
			$addtable['ark_siteperiod_production']=true;
			$where.=' AND sp_production_id NOT IN (?)';
			$args[]=$search['production_exclude'];
		}

		if (isset($search['production_exceptional']) && $search['production_exceptional'] == 1) {
			$addtable['ark_siteperiod_production']=true;
			$where.=' AND sp_exceptional = 1';
		}

		if (isset($search['furniture_include']) && count($search['furniture_include'])) {
			$addtable['ark_siteperiod_furniture']=true;
			$where.=' AND sf_furniture_id IN (?)';
			$args[]=$search['furniture_include'];
		}

		if (isset($search['furniture_exclude']) && count($search['furniture_exclude'])) {
			$addtable['ark_siteperiod_furniture']=true;
			$where.=' AND sf_furniture_id NOT IN (?)';
			$args[]=$search['furniture_exclude'];
		}

		if (isset($search['furniture_exceptional']) && $search['furniture_exceptional'] == 1) {
			$addtable['ark_siteperiod_furniture']=true;
			$where.=' AND sf_exceptional = 1';
		}

		if (isset($search['realestate_include']) && count($search['realestate_include'])) {
			$addtable['ark_siteperiod_realestate']=true;
			$where.=' AND sr_realestate_id IN (?)';
			$args[]=$search['realestate_include'];
		}

		if (isset($search['realestate_exclude']) && count($search['realestate_exclude'])) {
			$addtable['ark_siteperiod_realestate']=true;
			$where.=' AND sr_realestate_id NOT IN (?)';
			$args[]=$search['realestate_exclude'];
		}

		if (isset($search['realestate_exceptional']) && $search['realestate_exceptional'] == 1) {
			$addtable['ark_siteperiod_realestate']=true;
			$where.=' AND sr_exceptional = 1';
		}

		$groupby='si_code';
		$from=" ark_site";
		$from.=" LEFT JOIN ark_site_period ON sp_site_code = si_code";
		if ($addtable['ark_siteperiod_production']) {
			$from.=" LEFT JOIN ark_siteperiod_production ON sp_site_period_id = ark_site_period.sp_id";
		}
		if ($addtable['ark_siteperiod_furniture']) {
			$from.=" LEFT JOIN ark_siteperiod_furniture ON sf_site_period_id = ark_site_period.sp_id";
		}
		if ($addtable['ark_siteperiod_realestate']) {
			$from.=" LEFT JOIN ark_siteperiod_realestate ON sr_site_period_id = ark_site_period.sp_id";
		}
		if ($addtable['ark_database']) {
			$from.=" LEFT JOIN ark_database ON si_database_id = da_id";
			$groupby.=', da_id';
		}
		if ($addtable['ark_city']) {
			$from.=" LEFT JOIN ark_city ON si_city_id = ci_id";
			$groupby.=', ci_id';
		}

		$query='SELECT '.$select.' FROM '.$from.' WHERE '.$where.' GROUP BY '.$groupby.' LIMIT '.$limit;
		$query_count='SELECT COUNT(DISTINCT(ark_site.si_code)) FROM '.$from.' WHERE '.$where;

		return array('total_count' => \core\Core::$db->fetchOne($query_count, $args),
								 'sites' => \core\Core::$db->fetchAll($query, $args));
	}




	/* ************* */
	/*    Database   */
	/* ************* */

	public static function addDatabase($dbName, $dbDescription=NULL, $owner_id=0) {
		$args = array($dbName, $dbDescription, (int)$owner_id);
		return \core\Core::$db->exec_returning('INSERT INTO "ark_database" ("da_name", "da_description", "da_owner_id", "da_creation", "da_modification") VALUES (?,?,?,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)', $args, 'da_id');
	}

	public static function getDatabaseId($dbName) {
		return \core\Core::$db->fetchOne('SELECT "da_id" FROM "ark_database" WHERE "da_name" = ?', (array)$dbName);
	}

	/* ************* */
	/*    Common   */
	/* ************* */

	public static function getUniquePathFromLabel($label, $type, $level=NULL, $parentPath=NULL, $lang='fr') {
		if (!preg_match("/^[a-z]+/", $type)) {
			throw new \Exception("Table name invalid");
		}
		$q = 'SELECT "node_path" FROM "ark_'.$type.'" WHERE "'.substr($type, 0, 2).'_name_'.$lang.'" ilike ? ';
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

	public static function getPeriodIdFromPath($node_path) {
		return \core\Core::$db->fetchOne('SELECT "pe_id" FROM "ark_period" WHERE "node_path" = ?' , array($node_path));
	}

	public static function getCharacteristicIdFromPath($carac, $node_path) {
		if (!preg_match("/^[a-z]+$/", $carac))
			throw new \Exception("Carateristic type invalid");
		$prefix = substr($carac, 0, 2);
		try {
		 	$id = \core\Core::$db->fetchOne('SELECT "'.$prefix.'_id" FROM "ark_'.$carac.'" WHERE "node_path" = ?' , array((string)$node_path));
		} catch (\Exception $e) {
			throw new \Exception($e->getMessage());
		}
		return $id;
	}

	public static function node_path_to_str($node_path, &$strings, $sep) {
		if ($node_path == 'NULL') return '';
		$node_path=explode('.', $node_path);
		foreach($node_path as $k => $v) $node_path[$k]=trim($strings[$v], '"');
		return implode($node_path, $sep);
	}

	public static function node_path_array_to_str($node_path_array, &$strings, $sep) {
		$node_paths=explode(',', trim($node_path_array, '{}'));
		foreach($node_paths as $k=>$v)
			$node_paths[$k]=self::node_path_to_str($v, $strings, $sep);
		return $node_paths;
	}

	private static function idtok($ar) {
		$res=array();
		foreach($ar as $row) $res[$row['id']]=$row['name'];
		return $res;
	}

	public static function load_strings() {
    $lang=\mod\lang\Main::getCurrentLang();
    $lang=substr($lang, 0, 2);
    
		$menus=array();
		
		$menus['db']=self::idtok(\core\Core::$db->fetchAll("select da_id as id, da_name as name from ark_database order by da_id"));
		$menus['period']=self::idtok(\core\Core::$db->fetchAll("select pe_id as id, pe_name_$lang as name from ark_period order by pe_id"));
		$menus['production']=self::idtok(\core\Core::$db->fetchAll("select pr_id as id, pr_name_$lang as name from ark_production order by pr_id"));
		
		$menus['realestate']=self::idtok(\core\Core::$db->fetchAll("select re_id as id, re_name_$lang as name from ark_realestate order by re_id"));
		
		$menus['furniture']=self::idtok(\core\Core::$db->fetchAll("select fu_id as id, fu_name_$lang as name from ark_furniture order by fu_id"));

		return $menus;
	}

	/* ************* */
	/*      Map      */
	/* ************* */
	
	public static function getMarker($shape, $geometry, $knowledge, $period, $exceptional, $centroid, $popupParams) {

		$colors[1]   = '#cbcbcb';
		$colors[2]   = '#8c8c8c';
		$colors[3]   = array('#005702', '#176619', '#468547', '#5D945E');
		$colors[36]  = array('#000099', '#1717A2', '#2E2EAC', '#4646B5');
		$colors[92]  = array('#FF0000', '#FF1717', '#FF2E2E', '#FF4646');
		$colors[103] = array('#FFFF00', '#FFFF17', '#FFFF2E', '#FFFF46');
		$colors[115] = array('#330000', '#461717', '#582E2E', '#6B4646');
		$colors[130] = '#646263';
		$colors[140] = '#474747';

		$params['geometry'] = $geometry;

		if (strstr($knowledge, 'excavated')) 
			$iconParams['size'] = array(25, 25);
		else if (strstr($knowledge, 'surveyed'))
			$iconParams['size'] = array(20, 20);
		else if (strstr($knowledge, 'literature'))
			$iconParams['size'] = array(15, 15);
		else
			$iconParams['size'] = array(10, 10);

		$iconParams['shape'] = $shape;

		$iconParams['strokecolor'] = '#333333';
		$iconParams['strokewidth'] = ($exceptional) ? 2 : 1;

		$iconParams['text'] = ($centroid) ? '#' : NULL;

		$tmp = preg_split('/\./', trim($period, '{}'));
		$num = array_shift($tmp);
		$pos = sizeof($tmp);

		$iconParams['alpha'] = 0.75;
		$iconParams['color'] = $colors[$num][$pos];

		$marker = new \mod\map\Marker('image', $geometry);
		$marker->setIconParams($iconParams);
		$marker->setPopupParams($popupParams);
		return $marker->get();
	}
  

}
