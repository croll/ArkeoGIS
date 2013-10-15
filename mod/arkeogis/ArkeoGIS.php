<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ArkeoGIS {

	/* ********** */
	/*    Site   */
	/* ********** */
	public static function deleteSite($code, $databaseId) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=? AND si_database_id=?', array((string)$code,(int)$databaseId));
	}

	public static function addSite($code, $name, $databaseid, $cityid=NULL, $geom=NULL, $centroid, $occupation, $city_name, $city_code, $authorid=0) {
		try {
			$siteId = \core\Core::$db->exec_returning('INSERT INTO "ark_site" ("si_code", "si_name", "si_database_id", "si_city_id", "si_geom", "si_centroid", "si_occupation", "si_author_id", "si_city_name", "si_city_code", "si_creation", "si_modification") VALUES (?,?,?,?,'.$geom.',?,?,?,?,?,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)', array($code, $name, (int)$databaseid, $cityid, (int)$centroid, $occupation, $authorid, $city_name, $city_code), 'si_id');
		} catch (\Exception $e) {
			throw new \Exception('Unable to add site: '.$e->getmessage());
		}
		return $siteId;
	}

	// Site informations fill functions  are splitted into two functions for convenience
	public static function addSitePeriod($siteId, $startid, $endid, $isrange=0, $depth=NULL, $knowledge='unknown', $comment=NULL, $biblio=NULL) {
		if (is_null($isrange)) $isrange = 0;
		$args = array($siteId, $startid, $endid, $isrange, $depth, $knowledge, $comment, $biblio);
		try {
			return \core\Core::$db->exec_returning('INSERT INTO "ark_site_period" ("sp_site_id", "sp_period_start", "sp_period_end", "sp_period_isrange", "sp_depth", "sp_knowledge_type", "sp_comment", "sp_bibliography") VALUES (?,?,?,?,?,?,?,?) ', $args, 'sp_id');
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

	public static function getSitePeriod($siteId, $startid, $endid) {
		$args = array($siteId, (int)$startid, (int)$endid);
		return \core\Core::$db->fetchOne('SELECT "sp_id" FROM "ark_site_period" WHERE "sp_site_id" = ? AND "sp_period_start" = ? AND "sp_period_end" = ?' , $args);
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
		case 'landscape':
			$prefix = 'sl';
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


	private static function fix_overlaped_periods(&$arr) {
		if (in_array(35, $arr) && !in_array(40, $arr)) $arr[]=40; // Age du Bronze >> BRF >> BRF3/HAC1 + Age du Fer >> HAC >> BRF3/HAC1
		if (in_array(40, $arr) && !in_array(35, $arr)) $arr[]=35; // Age du Fer >> HAC >> BRF3/HAC1 + Age du Bronze >> BRF >> BRF3/HAC1
		if (in_array(47, $arr) && !in_array(49, $arr)) $arr[]=49; // Age du Fer >> HAC >> HAC2/HAD1 + Age du Fer >> HAD >> HAC2/HAD1
		if (in_array(49, $arr) && !in_array(47, $arr)) $arr[]=47; // Age du Fer >> HAD >> HAC2/HAD1 + Age du Fer >> HAC >> HAC2/HAD1
		if (in_array(47, $arr) && !in_array(49, $arr)) $arr[]=49; // Age du Fer >> HAC >> HAC2/HAD1 + Age du Fer >> HAD >> HAC2/HAD1
		if (in_array(49, $arr) && !in_array(47, $arr)) $arr[]=47; // Age du Fer >> HAD >> HAC2/HAD1 + Age du Fer >> HAC >> HAC2/HAD1
		if (in_array(59, $arr) && !in_array(62, $arr)) $arr[]=62; // Age du Fer >> HAD >> HAD3/LTA1 + Age du Fer >> LTA >> HAD3/LTA1
		if (in_array(62, $arr) && !in_array(59, $arr)) $arr[]=59; // Age du Fer >> LTA >> HAD3/LTA1 + Age du Fer >> HAD >> HAD3/LTA1
		if (in_array(83, $arr) && !in_array(85, $arr)) $arr[]=85; // Age du Fer >> LTC >> LTC2/LTD1 + Age du Fer >> LTD >> LTC2/LTD1
		if (in_array(85, $arr) && !in_array(83, $arr)) $arr[]=83; // Age du Fer >> LTD >> LTC2/LTD1 + Age du Fer >> LTC >> LTC2/LTD1
		if (in_array(102, $arr) && !in_array(104, $arr)) $arr[]=104; // Gallo-Romain >> Grandes invasions + Mérovingien >> Grandes invasions
		if (in_array(104, $arr) && !in_array(102, $arr)) $arr[]=102; // Mérovingien >> Grandes invasions + Gallo-Romain >> Grandes invasions
	}

	public static function search_sites($search, $select, $addtable=array(), $limit=1500,
                                      $custom_groupby=false, $orderby='ark_site.si_id', $getcount=true,
                                      $onlysprange=true
																			) {
		$addtable=array('ark_siteperiod_production' => isset($addtable['ark_siteperiod_production']) ? $addtable['ark_siteperiod_production'] : false,
										'ark_siteperiod_furniture' => isset($addtable['ark_siteperiod_furniture']) ? $addtable['ark_siteperiod_furniture'] : false,
										'ark_siteperiod_landscape' => isset($addtable['ark_siteperiod_landscape']) ? $addtable['ark_siteperiod_landscape'] : false,
										'ark_siteperiod_realestate' => isset($addtable['ark_siteperiod_realestate']) ? $addtable['ark_siteperiod_realestate'] : false,
										'ark_database' => isset($addtable['ark_database']) ? $addtable['ark_database'] : false,
										'ark_city' => isset($addtable['ark_city']) ? $addtable['ark_city'] : false);

    // sp_period_isrange
		if ($onlysprange) $where='sp_period_isrange=1 ';
    else $where='1=1 ';
		$args=array();

    // databases
		if (isset($search['db_include']) && count($search['db_include'])) {
			$where.=' AND si_database_id IN (?)';
			$args[]=$search['db_include'];
		}

		if (isset($search['db_exclude']) && count($search['db_exclude'])) {
			$where.=' AND (si_database_id NOT IN (?) OR si_database_id IS NULL)';
			$args[]=$search['db_exclude'];
		}

    // period
		if (isset($search['period_include']) && count($search['period_include'])) {
			self::fix_overlaped_periods($search['period_include']);
      $where.=' AND (0=1 ';
			foreach($search['period_include'] as $period) {
				$where.=' OR sp_period_start <= ? AND sp_period_end >= ?';
				$args[]=$period;
				$args[]=$period;
			}
      $where.=')';
		}
		if (isset($search['period_exclude']) && count($search['period_exclude'])) {
			self::fix_overlaped_periods($search['period_exclude']);
      $where.=' AND (sp_period_start IS NULL ';
			foreach($search['period_exclude'] as $period) {
				$where.=' OR NOT (sp_period_start <= ? AND sp_period_end >= ?)';
				$args[]=$period;
				$args[]=$period;
			}
      $where.=')';
		}

    // centroid
		if (isset($search['centroid_include']) && count($search['centroid_include'])) {
      $where.=' AND si_centroid IN (?)';
      $args[]=$search['centroid_include'];
		}

    // konwledge
		if (isset($search['knowledge_include']) && count($search['knowledge_include'])) {
			$where.=' AND sp_knowledge_type IN(?)';
			$args[]=$search['knowledge_include'];
		}

    // occupation
		if (isset($search['occupation_include']) && count($search['occupation_include'])) {
      $where.=' AND si_occupation IN (?)';
      $args[]=$search['occupation_include'];
		}

    //
    // caracterisations (production, furniture, etc.)
		if (isset($search['caracterisation_mode']) && $search['caracterisation_mode'] == 'OR') {
			$andoror="OR";
		} else {
			$andoror="AND";
		}

		$caracswhere=array();

    // production
		$subwhere = '';
		if (isset($search['production_include']) && count($search['production_include'])) {
			$addtable['ark_siteperiod_production']=true;
			$subwhere.='sp_production_id IN (?)';
			$args[]=$search['production_include'];
		}

		if (isset($search['production_exclude']) && count($search['production_exclude'])) {
			$addtable['ark_siteperiod_production']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'(sp_production_id NOT IN (?) OR sp_production_id IS NULL)';
			$args[]=$search['production_exclude'];
		}

		if (isset($search['production_exceptional']) && $search['production_exceptional'] == 1) {
			$addtable['ark_siteperiod_production']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'sp_exceptional = 1';
		}
		if ($subwhere != '') $caracswhere[]=$subwhere;

    // furniture
		$subwhere = '';
		if (isset($search['furniture_include']) && count($search['furniture_include'])) {
			$addtable['ark_siteperiod_furniture']=true;
			$subwhere.='sf_furniture_id IN (?)';
			$args[]=$search['furniture_include'];
		}

		if (isset($search['furniture_exclude']) && count($search['furniture_exclude'])) {
			$addtable['ark_siteperiod_furniture']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'(sf_furniture_id NOT IN (?) OR sf_furniture_id IS NULL)';
			$args[]=$search['furniture_exclude'];
		}

		if (isset($search['furniture_exceptional']) && $search['furniture_exceptional'] == 1) {
			$addtable['ark_siteperiod_furniture']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'sf_exceptional = 1';
		}
		if ($subwhere != '') $caracswhere[]=$subwhere;

    // landscape
		$subwhere = '';
		if (isset($search['landscape_include']) && count($search['landscape_include'])) {
			$addtable['ark_siteperiod_landscape']=true;
			$subwhere.='sl_landscape_id IN (?)';
			$args[]=$search['landscape_include'];
		}

		if (isset($search['landscape_exclude']) && count($search['landscape_exclude'])) {
			$addtable['ark_siteperiod_landscape']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'(sl_landscape_id NOT IN (?) OR sl_landscape_id IS NULL)';
			$args[]=$search['landscape_exclude'];
		}

		if (isset($search['landscape_exceptional']) && $search['landscape_exceptional'] == 1) {
			$addtable['ark_siteperiod_landscape']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'sl_exceptional = 1';
		}
		if ($subwhere != '') $caracswhere[]=$subwhere;

    // realestate
		$subwhere = '';
		if (isset($search['realestate_include']) && count($search['realestate_include'])) {
			$addtable['ark_siteperiod_realestate']=true;
			$subwhere.='sr_realestate_id IN (?)';
			$args[]=$search['realestate_include'];
		}

		if (isset($search['realestate_exclude']) && count($search['realestate_exclude'])) {
			$addtable['ark_siteperiod_realestate']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'(sr_realestate_id NOT IN (?) OR sr_realestate_id IS NULL)';
			$args[]=$search['realestate_exclude'];
		}

		if (isset($search['realestate_exceptional']) && $search['realestate_exceptional'] == 1) {
			$addtable['ark_siteperiod_realestate']=true;
			$subwhere.=($subwhere == '' ? '' : ' AND ').'sr_exceptional = 1';
		}
		if ($subwhere != '') $caracswhere[]=$subwhere;


		if (count($caracswhere) > 0)
			$where.=" AND (".implode($caracswhere, " $andoror ").")";
    // end of caracterisations



    // site_id
		if (isset($search['site_id'])) {
			$where.=' AND si_id = ?';
			$args[]=$search['site_id'];
		}

    // site_code
		if (isset($search['site_code'])) {
			$where.=' AND si_code = ?';
			$args[]=$search['site_code'];
		}

    // database (@todo: we already have db_include filter, why do we have this database filter ?)
		if (isset($search['database_id'])) {
			$addtable['ark_database']=true;
			$where.=' AND da_id = ?';
			$args[]=(int)$search['database_id'];
		}

    // full text search
    if (isset($search['txtsearch']) && !empty($search['txtsearch']) && isset($search['txtsearch_options'])) {
      $where.=' AND ( 0=1 ';

      if (in_array('si_name', $search['txtsearch_options'])) {
        $where.=' OR si_name @@ plainto_tsquery(?)';
        $args[]=$search['txtsearch'];
      }

      if (in_array('sp_comment', $search['txtsearch_options'])) {
        $where.=' OR sp_comment @@ plainto_tsquery(?)';
        $args[]=$search['txtsearch'];
      }

      if (in_array('sp_bibliography', $search['txtsearch_options'])) {
        $where.=' OR sp_bibliography @@ plainto_tsquery(?)';
        $args[]=$search['txtsearch'];
      }

      if (in_array('sp_comment', $search['txtsearch_options'])) {
        $where.=' OR sp_comment @@ plainto_tsquery(?)';
        $args[]=$search['txtsearch'];
      }

      $where.=')';
    }


    // geo search
		if (isset($search['area_include']) && count($search['area_include'])) {
      if (in_array('circle', $search['area_include'])) {
        $where.=' AND ST_Distance_Sphere(si_geom, ST_SetSRID(ST_MakePoint(?, ?), 4326)) < ?';
        $args[]=$search['area_circle']['lng'];
        $args[]=$search['area_circle']['lat'];
        $args[]=$search['area_circle']['radius'];
      }
      if (in_array('rect', $search['area_include'])) {
        $where.=' AND si_geom && ST_SetSRID(ST_MakeBox2D(ST_Point(?, ?), ST_Point(? ,?)), 4326)';
        $args[]=$search['area_bounds']['_southWest']['lng'];
        $args[]=$search['area_bounds']['_southWest']['lat'];
        $args[]=$search['area_bounds']['_northEast']['lng'];
        $args[]=$search['area_bounds']['_northEast']['lat'];
      }
      if (in_array('all', $search['area_include'])) {
        $where.=' AND si_geom && ST_SetSRID(ST_MakeBox2D(ST_Point(?, ?), ST_Point(? ,?)), 4326)';
        $args[]=$search['area_map']['_southWest']['lng'];
        $args[]=$search['area_map']['_southWest']['lat'];
        $args[]=$search['area_map']['_northEast']['lng'];
        $args[]=$search['area_map']['_northEast']['lat'];
      }
      if (in_array('coord', $search['area_include'])) {
        $where.=' AND ST_Distance_Sphere(si_geom, ST_SetSRID(ST_MakePoint(?, ?), 4326)) < ?';
        $args[]=$search['area_coords']['lng'];
        $args[]=$search['area_coords']['lat'];
        $args[]=$search['area_coords']['km'] * 1000;
      }
    }

    ///////////////////////

		$groupby='ark_site.si_id';
		$from=" ark_site";
		$from.=" LEFT JOIN ark_site_period ON sp_site_id = si_id";
		if ($addtable['ark_siteperiod_production']) {
			$from.=" LEFT JOIN ark_siteperiod_production ON sp_site_period_id = ark_site_period.sp_id";
		}
		if ($addtable['ark_siteperiod_furniture']) {
			$from.=" LEFT JOIN ark_siteperiod_furniture ON sf_site_period_id = ark_site_period.sp_id";
		}
		if ($addtable['ark_siteperiod_landscape']) {
			$from.=" LEFT JOIN ark_siteperiod_landscape ON sl_site_period_id = ark_site_period.sp_id";
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

		if ($custom_groupby !== false) $groupby=$custom_groupby;

		$query='SELECT '.$select.' FROM '.$from.' WHERE '.$where.($groupby ? ' GROUP BY '.$groupby : '').($orderby ? ' ORDER BY '.$orderby : '').($limit ? ' LIMIT '.$limit : '');
		$query_count='SELECT COUNT(DISTINCT(ark_site.si_id)) FROM '.$from.' WHERE '.$where;

    error_log(sqltostr($query, $args));

		//error_log(var_export(\core\Core::$db->fetchAll($query, $args), true));
		return array('total_count' => $getcount ? \core\Core::$db->fetchOne($query_count, $args) : 'unwanted',
								 'sites' => \core\Core::$db->fetchAll($query, $args));
	}

	/* ************* */
	/*    Database   */
	/* ************* */

	public static function addDatabase($dbName, $fields, $owner_id=0) {
		$q = 'INSERT INTO "ark_database" ("da_name", "da_owner_id", "da_creation", "da_modification",';
		$args = array($dbName, $owner_id, 'now()', 'now()');
		foreach($fields as $k => $v) {
			$q .= " \"da_$k\",";
			$args[] = $v;
		}
		$q = substr($q, 0, -1).') VALUES (';
		$q .= str_repeat('?,', sizeof($args));
		$q = substr($q, 0, -1).')';
		return \core\Core::$db->exec_returning($q, $args, 'da_id');
	}

	public static function updateDatabase($dbId, $fields) {
		$q = 'UPDATE "ark_database" SET da_modification = now(), ';
		foreach($fields as $k => $v) {
			$q .= " da_$k = ?,";
			$args[] = $v;
		}
		$q = substr($q, 0, -1);
		$args[] = $dbId;
		\core\Core::$db->exec($q.' WHERE "da_id" = ?', $args);
	}

	public static function getDatabaseId($dbName) {
		return \core\Core::$db->fetchOne('SELECT "da_id" FROM "ark_database" WHERE "da_name" = ?', (array)$dbName);
	}

	public static function getDatabaseName($dbId) {
		return \core\Core::$db->fetchOne('SELECT "da_name" FROM "ark_database" WHERE "da_id" = ?', (array)$dbId);
	}

	public static function isDatabaseOwner($dbId, $userId) {
		$uid = \core\Core::$db->fetchOne('SELECT "da_owner_id" FROM "ark_database" WHERE "da_id" = ? AND "da_owner_id" = ?', array($dbId, (int)$userId));
		return (is_int($uid)) ? true : false;
	}

	public static function deleteLastCsv($dbId, $newFile) {
		$filename = \core\Core::$db->fetchOne('SELECT "dl_csv_file" FROM "ark_database_log" WHERE "dl_database_id" = ? ORDER BY dl_id DESC  LIMIT 1 OFFSET 0', (array)$dbId);
		if ($filename) {
			if ($filename != $newFile) {
				if (!unlink(dirname(__FILE__).'/files/import/'.$filename)) {
					throw new \Exception("Unable to remove \"$filename\".");
				}
			}
			\core\Core::$db->exec('UPDATE "ark_database_log" SET dl_csv_file = NULL WHERE dl_database_id = ?', (array)$dbId);
		}
	}

	public static function writeDatabaseLog($dbId, $uid, $csvFile) {
		$q = 'INSERT INTO "ark_database_log" ("dl_database_id", "dl_user_id", "dl_date", "dl_csv_file") VALUES (?,?,now(),?)';
		return \core\Core::$db->exec($q, array($dbId, $uid, $csvFile));
	}

	public static function getDatabaseInfos($dbId) {
		$l = \mod\lang\Main::getCurrentLang();
    		$lang = ($l == 'fr_FR') ? 'fr' : 'de';
  		$langext = ($l == 'fr_FR') ? '' : '_de';

		$q = 'SELECT da_id as id, da_issn as issn, da_name as name, da_description'.$langext.' as description, u.full_name as author, da_type as type, to_char(da_declared_modification, \'DD/MM/YYYY\') as declared_modification_str, da_declared_modification as declared_modification, da_lines as lines, da_sites as sites, (SELECT pe_name_'.$lang.' FROM ark_period WHERE pe_id = da_period_start) as period_start, (SELECT pe_name_'.$lang.' FROM ark_period WHERE pe_id = da_period_end) as period_end, da_scale_resolution as scale_resolution, da_geographical_limit'.$langext.' as geographical_limit, da_published as published FROM ark_database d LEFT JOIN ch_user u ON d.da_owner_id = u.uid WHERE da_id = ?';
		return \core\Core::$db->fetchAll($q, array($dbId));
	}

	public static function getFullDatabaseInfos($dbId) {
		$q = 'SELECT da_id as id, da_issn as issn, da_name as name, da_description as description, da_description_de as description_de, da_type as type, to_char(da_declared_modification, \'DD/MM/YYYY\') as declared_modification_str, da_declared_modification as declared_modification, to_char(da_modification, \'DD-MM-YYYY-HH24-MI\') as modification_str, da_lines as lines, da_sites as sites, da_scale_resolution as scale_resolution, da_geographical_limit as geographical_limit, da_geographical_limit_de as geographical_limit_de, da_published as published, da_owner_id as owner_id, u.full_name as author FROM ark_database d LEFT JOIN ch_user u ON d.da_owner_id = u.uid WHERE da_id = ?';
		return \core\Core::$db->fetchAll($q, array($dbId));
	}

	public static function deleteDatabase($dbId) {
		\core\Core::$db->exec('DELETE FROM "ark_database" WHERE  da_id =?', array((int)$dbId));
	}

	public static function getLastImportFile($dbId) {
		return \core\Core::$db->fetchOne('SELECT dl_csv_file FROM ark_database_log WHERE dl_database_id = ? AND dl_csv_file != \'\'', array((int)$dbId));
	}

	public static function getNumBasesAndSites() {
		$where = '';
		if (!\mod\user\Main::userBelongsToGroup('Admin')) {
     			$where = " WHERE da_published = 't'";
     		}
   		$nbBases = \core\Core::$db->fetchOne('SELECT COUNT(*) FROM "ark_database"'.$where);
		$nbSites = \core\Core::$db->fetchOne('SELECT COUNT(*) FROM ark_site s LEFT JOIN ark_database d ON d.da_id=s.si_database_id '.$where);
		return array('nbBases' => $nbBases, 'nbSites' => $nbSites);
	}

	/* ************* */
	/*    Common   */
	/* ************* */

	public static function sitesToCsv($sites, $filename='export') {
		header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
		header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); // Date dans le passé
		header("Content-Type: text/csv");
		header("Content-Disposition: attachment; filename=\"$filename.csv\"");
		$strings=self::load_strings();
    		$latest_siid=-1;
    		$latest_spid=-1;
 		$fp = fopen('php://output', 'w');
 		    fputcsv($fp, array('SITE_ID_SOURCE', 'BASE_SOURCE', 'NOM_SITE', 'NOM_COMMUNE_PRINCIPALE', 'CODE_COMMUNE', 'SYSTEME_PROJECTION', 'LONGITUDE_X ', 'LATITUDE_Y', 'LONGITUDE_X_BIS', 'LATITUDE_Y_BIS', 'ALTITUDE Z', 'CENTRE_COMMUNE', 'ETAT_CONNAISSANCES', 'OCCUPATION', 'DATATION_DEBUT_PLUS_FINE', 'DATATION_FIN_PLUS_FINE', 'IMMO_NIV1', 'IMMO_NIV2', 'IMMO_NIV3', 'IMMO_NIV4', 'IMMO_EXP', 'MOB_NIV1', 'MOB_NIV2', 'MOB_NIV3', 'MOB_NIV4', 'MOB_EXP', 'PROD_NIV1', 'PROD_NIV2', 'PROD_NIV3', 'PROD_EXP', 'PAYS_NIV1', 'PAYS_NIV2', 'PAYS_NIV3', 'PAYS_NIV4', 'PAYS_EXP', 'BIBLIOGRAPHIE', 'REMARQUES'), ";", '"');
		foreach($sites as $row) {
    			$coords=json_decode($row['coords']);
   			$period_start=ArkeoGIS::node_path_to_array($row['period_start'], $strings['period']);
      			$period_end=ArkeoGIS::node_path_to_array($row['period_end'], $strings['period']);

			$realestates=\core\Core::$db->fetchAll("SELECT r1.node_path, spr1.sr_exceptional as exceptional FROM ark_siteperiod_realestate spr1 LEFT JOIN ark_realestate r1 ON r1.re_id = spr1.sr_realestate_id WHERE spr1.sr_site_period_id = ?", array($row['sp_id']));
			$furnitures=\core\Core::$db->fetchAll("SELECT f1.node_path, spf1.sf_exceptional as exceptional FROM ark_siteperiod_furniture spf1 LEFT JOIN ark_furniture f1 ON f1.fu_id = spf1.sf_furniture_id WHERE spf1.sf_site_period_id = ?", array($row['sp_id']));
			$productions=\core\Core::$db->fetchAll("SELECT p1.node_path, spp1.sp_exceptional as exceptional FROM ark_siteperiod_production spp1 LEFT JOIN ark_production p1 ON p1.pr_id = spp1.sp_production_id WHERE spp1.sp_site_period_id = ?", array($row['sp_id']));
			$landscapes=\core\Core::$db->fetchAll("SELECT l1.node_path, spl1.sl_exceptional as exceptional FROM ark_siteperiod_landscape spl1 LEFT JOIN ark_landscape l1 ON l1.la_id = spl1.sl_landscape_id WHERE spl1.sl_site_period_id = ?", array($row['sp_id']));

			do {
				$newsiid=($latest_siid != $row['si_id']);
				$newspid=($latest_spid != $row['sp_id']);

				$realestate=array_shift($realestates);
				$furniture=array_shift($furnitures);
				$production=array_shift($productions);
				$landscape=array_shift($landscapes);

				$realestate_astr = ArkeoGIS::node_path_to_array($realestate['node_path'], $strings['realestate']);
				$furniture_astr = ArkeoGIS::node_path_to_array($furniture['node_path'], $strings['furniture']);
				$production_astr = ArkeoGIS::node_path_to_array($production['node_path'], $strings['production']);
				$landscape_astr = ArkeoGIS::node_path_to_array($landscape['node_path'], $strings['landscape']);

				fputcsv($fp, array(
				$row['si_code'],                                                                       // SITE_ID_SOURCE
				$newsiid ? $row['da_name'] : '',                                                       // BASE_SOURCE
				$newsiid ? $row['si_name'] : '',                                                       // NOM_SITE
				$newsiid ? $row['si_city_name'] : '',                                                       // NOM_COMMUNE_PRINCIPALE
				$newsiid ? $row['si_city_code'] : '',                                                       // CODE_COMMUNE
				$newsiid ? 'WGS84' : '',                                                               // SYSTEME_PROJECTION
				$newsiid ? $coords->coordinates[0] : '',                                               // LONGITUDE_X
				$newsiid ? $coords->coordinates[1] : '',                                               // LATITUDE_Y
				'',                                                                                    // LONGITUDE_X_BIS
				'',                                                                                    // LATITUDE_Y_BIS
				$newsiid ? ($coords->coordinates[2] == -999 ? '' : $coords->coordinates[2]) : '',      // ALTITUDE Z
				$newsiid ? self::yesno($row['si_centroid']) : '',                                                   // CENTRE_COMMUNE
				$newsiid && $row['sp_knowledge_type'] ? $strings['knowledge'][$row['sp_knowledge_type']] : '', // ETAT_CONNAISSANCES
				$newsiid ? $strings['occupation'][$row['si_occupation']] : '',                         // OCCUPATION
				$newspid ? (count($period_start) ? $period_start[count($period_start)-1] : '') : '',   // DATATION_DEBUT_PLUS_FINE
				$newspid ? (count($period_end) ? $period_end[count($period_end)-1] : '') : '',         // DATATION_FIN_PLUS_FINE
				isset($realestate_astr[0]) ? $realestate_astr[0] : '',                                           // IMMO_NIV1
				isset($realestate_astr[1]) ? $realestate_astr[1] : '',                                           // IMMO_NIV2
				isset($realestate_astr[2]) ? $realestate_astr[2] : '',                                           // IMMO_NIV3
				isset($realestate_astr[3]) ? $realestate_astr[3] : '',                                           // IMMO_NIV4
				//'',                                                                                  // PROFONDEUR_VESTIGES
				isset($realestate_astr[0]) ? self::yesno($realestate['exceptional']) : '',                                                   // IMMO_EXP
				isset($furniture_astr[0]) ? $furniture_astr[0] : '',                                             // MOB_NIV1
				isset($furniture_astr[1]) ? $furniture_astr[1] : '',                                             // MOB_NIV2
				isset($furniture_astr[2]) ? $furniture_astr[2] : '',                                             // MOB_NIV3
				isset($furniture_astr[3]) ? $furniture_astr[3] : '',                                             // MOB_NIV4
				isset($furniture_astr[0]) ? self::yesno($furniture['exceptional']) : '',                                                   // MOB_EXP
				isset($production_astr[0]) ? $production_astr[0] : '',                                           // PROD_NIV1
				isset($production_astr[1]) ? $production_astr[1] : '',                                           // PROD_NIV2
				isset($production_astr[2]) ? $production_astr[2] : '',                                           // PROD_NIV3
				isset($production_astr[0]) ? self::yesno($production['exceptional']) : '',                                   // PROD_EXP
				isset($landscape_astr[0]) ? $landscape_astr[0] : '',                                             // LANDSCAPE_NIV1
				isset($landscape_astr[1]) ? $landscape_astr[1] : '',                                             // LANDSCAPE_NIV2
				isset($landscape_astr[2]) ? $landscape_astr[2] : '',                                             // LANDSCAPE_NIV3
				isset($landscape_astr[3]) ? $landscape_astr[3] : '',                                   // LANDSCAPE_NIV3
				isset($landscape_astr[0]) ? self::yesno($landscape['exceptional']) : '',                                           // LANDSCAPE_EXP
				$newspid ? $row['sp_bibliography'] : '',                                               // BIBLIOGRAPHIE
				$newspid ? $row['sp_comment'] : ''                                                     // REMARQUES
				), ";", '"');
				$latest_siid=$row['si_id'];
				$latest_spid=$row['sp_id'];
			} while (count($realestates) || count($furnitures) || count($productions) || count($landscapes));
		}
	}

	public static function getUniquePathFromLabel($label, $type, $level=NULL, $parentPath=NULL, $lang='fr') {
		if (!preg_match("/^[a-z]+/", $type)) {
			throw new \Exception("Table name invalid");
		}
		$q = 'SELECT "node_path" FROM "ark_'.$type.'" WHERE "'.substr($type, 0, 2).'_name_'.$lang.'" ilike ? ';
		$args = array($label);

		if (!is_null($level)) {
			$q.= 'AND nlevel(node_path) = ? ';
			$args[] = $level;
		}

		if (!is_null($parentPath)) {
			$q.= 'AND node_path <@ ? ';
			$args[] = $parentPath;
		}
		//error_log(sqltostr($q, $args));
		return \core\Core::$db->fetchAll($q, $args);
	}

	public static function getPeriodIdFromPath($node_path) {
		return \core\Core::$db->fetchOne('SELECT "pe_id" FROM "ark_period" WHERE "node_path" = ?' , array($node_path));
	}

	public static function getPeriodNameFromPath($node_path) {
		return \core\Core::$db->fetchOne('SELECT "pe_name_fr" FROM "ark_period" WHERE "node_path" = ?' , array($node_path));
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

	public static function getCharacteristicFromId($carac, $id) {
		$prefix = substr($carac, 0, 2);
		return \core\Core::$db->fetchOne('SELECT "'.$prefix.'_name_fr" FROM "ark_'.$carac.'" WHERE "'.$prefix.'_id" = ?' , array((int)$id));
	}

	public static function node_path_to_str($node_path, &$strings, $sep) {
		if ($node_path == 'NULL' || $node_path=='') return '';
		$node_path=explode('.', $node_path);
		foreach($node_path as $k => $v) $node_path[$k]=trim($strings[$v], '"');
		return implode($node_path, $sep);
	}

	public static function node_path_to_array($node_path, &$strings) {
		if ($node_path == 'NULL' || $node_path=='') return array();
		$node_path=explode('.', $node_path);
		foreach($node_path as $k => $v) $node_path[$k]=trim($strings[$v], '"');
		return $node_path;
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
		$menus['landscape']=self::idtok(\core\Core::$db->fetchAll("select la_id as id, la_name_$lang as name from ark_landscape order by la_id"));
    $menus['knowledge']=array(
															'unknown' => \mod\lang\Main::ch_t('arkeogis', "Non renseigné"),
															'literature' => \mod\lang\Main::ch_t('arkeogis', "Littérature, prospecté"),
															'surveyed' => \mod\lang\Main::ch_t('arkeogis', "Sondé"),
															'excavated' => \mod\lang\Main::ch_t('arkeogis', "Fouillé")
															);

    $menus['occupation']=array(
															 'unknown' => \mod\lang\Main::ch_t('arkeogis', "Non renseigné"),
															 'uniq' => \mod\lang\Main::ch_t('arkeogis', "Unique"),
															 'continuous' => \mod\lang\Main::ch_t('arkeogis', "Continue"),
															 'multiple' => \mod\lang\Main::ch_t('arkeogis', "Multiple")
															 );

		return $menus;
	}

	public static function getSiteInfos($siteId) {
		$strings=ArkeoGIS::load_strings();
		$siteInfos = array();
		$query = "SELECT si_name AS name, si_code AS code, ST_AsGeoJSON(si_geom) AS geom, si_centroid AS centroid, si_occupation AS occupation, to_char(si_creation, 'dd/mm/yyyy') AS creation, to_char(si_modification, 'dd/mm/yyyy') AS modification, si_city_name AS city_name, si_city_code AS city_code, da_name AS dbname, da_owner_id as author FROM ark_site AS si ";
		$query .= "LEFT JOIN ark_database AS da ON si.si_database_id=da.da_id ";
		$query .= "WHERE si.si_id=?";
    $infos = \core\Core::$db->fetchAll($query, array($siteId));
		if (sizeof($infos) > 1) {
			throw new \Exception("Multiple result found for a site id");
		} else if (sizeof($infos) < 1)
			return NULL;
		$geom = json_decode($infos[0]['geom']);
		$siteInfos['database'] = $infos[0]['dbname'];
		$siteInfos['name'] = $infos[0]['name'];
		$siteInfos['code'] = $infos[0]['code'];
		$siteInfos['author'] = \mod\user\Main::getUserFullNameById($infos[0]['author']);
		$siteInfos['geom'] = $geom->coordinates;
		$siteInfos['centroid'] = $infos[0]['centroid'];
		$siteInfos['occupation'] = $infos[0]['occupation'];
		$siteInfos['creation'] = $infos[0]['creation'];
		$siteInfos['modification'] = $infos[0]['modification'];
		$siteInfos['city']['name'] = $infos[0]['city_name'];
		$siteInfos['city']['code'] = $infos[0]['city_code'];
		// Get site periods
		$query = "SELECT sp_id AS id, (SELECT node_path FROM ark_period WHERE pe_id=sp_period_start) AS period_start_path, (SELECT node_path FROM ark_period WHERE pe_id=sp_period_end) AS period_end_path, sp_period_isrange AS isrange, sp_knowledge_type AS knowledge, sp_comment AS comment, sp_bibliography AS bibliography FROM ark_site_period WHERE sp_site_id = ?";
		$datas = array();
		$caracs = array('realestate' => array(), 'production' => array(), 'furniture' => array(), 'landscape' => array());
		foreach(\core\Core::$db->fetchAll($query, array($siteId)) as $pInfos) {
			$periodHash = md5($pInfos['period_start_path'].$pInfos['period_end_path']);
			if (!isset($siteInfos['characteristics'][$periodHash])) {
				$datas['start'] = Arkeogis::node_path_to_array($pInfos['period_start_path'], $strings['period']);
				$datas['end'] = Arkeogis::node_path_to_array($pInfos['period_end_path'], $strings['period']);
				$datas['knowledge'] = $pInfos['knowledge'];
				$datas['comment'] = $pInfos['comment'];
				$datas['bibliography'] = $pInfos['bibliography'];
				$siteInfos['characteristics'][$periodHash]['datas'] = $datas;
				unset($datas);
			}
			$i = sizeof($periodHash);
			// Realestate
			$q = "SELECT node_path, sr_exceptional FROM ark_siteperiod_realestate LEFT JOIN ark_realestate ON ark_siteperiod_realestate.sr_realestate_id=ark_realestate.re_id WHERE ark_siteperiod_realestate.sr_site_period_id = ?";
			foreach(\core\Core::$db->fetchAll($q, array($pInfos['id'])) as $carac) {
				$siteInfos['characteristics'][$periodHash]['caracs'][$i]['realestate'][] = array(Arkeogis::node_path_to_array($carac['node_path'], $strings['realestate']), $carac['sr_exceptional']);
			}
			// Production
			$q = "SELECT node_path, sp_exceptional FROM ark_siteperiod_production LEFT JOIN ark_production ON ark_siteperiod_production.sp_production_id=ark_production.pr_id WHERE ark_siteperiod_production.sp_site_period_id = ?";
			foreach(\core\Core::$db->fetchAll($q, array($pInfos['id'])) as $carac) {
				$siteInfos['characteristics'][$periodHash]['caracs'][$i]['production'][] = array(Arkeogis::node_path_to_array($carac['node_path'], $strings['production']), $carac['sp_exceptional']);
			}
			// Furniture
			$q = "SELECT node_path, sf_exceptional FROM ark_siteperiod_furniture LEFT JOIN ark_furniture ON ark_siteperiod_furniture.sf_furniture_id=ark_furniture.fu_id WHERE ark_siteperiod_furniture.sf_site_period_id = ?";
			foreach(\core\Core::$db->fetchAll($q, array($pInfos['id'])) as $carac) {
				$siteInfos['characteristics'][$periodHash]['caracs'][$i]['furniture'][] = array(Arkeogis::node_path_to_array($carac['node_path'], $strings['furniture']), $carac['sf_exceptional']);
			}
			// Landscape
			$q = "SELECT node_path, sl_exceptional FROM ark_siteperiod_landscape LEFT JOIN ark_landscape ON ark_siteperiod_landscape.sl_landscape_id=ark_landscape.la_id WHERE ark_siteperiod_landscape.sl_site_period_id = ?";
			foreach(\core\Core::$db->fetchAll($q, array($pInfos['id'])) as $carac) {
				$siteInfos['characteristics'][$periodHash]['caracs'][$i]['landscape'][] = array(Arkeogis::node_path_to_array($carac['node_path'], $strings['landscape']), $carac['sl_exceptional']);
			}
		}
	//	\core\Core::log($siteInfos);
		return $siteInfos;
	}

	/* ************* */
	/*      Map      */
	/* ************* */

	public static function getMarker($siteId, $shape, $geometry, $knowledge, $period, $exceptional, $centroid, $popupParams) {

		$colors[1]   = '#cbcbcb';
		$colors[2]   = '#b03fc1';
		$colors[3]   = array('#005702', '#176619', '#468547', '#5D945E');
		$colors[36]  = array('#000099', '#1717A2', '#2E2EAC', '#4646B5');
		$colors[92]  = array('#FF0000', '#FF1717', '#FF2E2E', '#FF4646');
		$colors[103] = array('#FFFF00', '#FFFF17', '#FFFF2E', '#FFFF46');
		$colors[115] = array('#330000', '#461717', '#582E2E', '#6B4646');
		$colors[120] = '#00B5B3';
		$colors[121] = '#FFB135';

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

		$tmp = trim($period, '{}');
		// todo multiple period
		$tmp = preg_split("/,/",$tmp);
		$tmp = $tmp[0];
		$tmp = preg_split('/\./', $tmp);
		$num = array_shift($tmp);
		$pos = sizeof($tmp);

		$iconParams['alpha'] = 0.75;
		$iconParams['color'] = $colors[$num][$pos];

		$marker = new \mod\map\Marker('image', $geometry);
		$marker->setId($siteId);
		$marker->setIconParams($iconParams);
		$marker->setPopupParams($popupParams);
		return $marker->get();
	}

	  public static function getStats() {
	    $res=array();
	    $q = "select count(*) from ark_database";
	    $res['count_db']=\core\Core::$db->fetchOne($q, array());
	    $q = "select count(*) from ark_site";
	    $res['count_site']=\core\Core::$db->fetchOne($q, array());
	    $res['date']=strftime('%x');
	    return $res;
	  }


	public static function yesno($val) {
		return $val ? \mod\lang\Main::ch_t('arkeogis', 'oui') : \mod\lang\Main::ch_t('arkeogis', 'non');
	}

}


// usefull for debugging...
function sqltostr($query, $args) {
	$f=fopen("/tmp/debug-arkeogis.txt", 'a');
  $argc=0;
  $res='';
  for ($i=0; $i<strlen($query); $i++) {
    if ($query[$i] == '?') $res.=\core\Core::$db->quote($args[$argc++]);
    else $res.=$query[$i];
  }
	fprintf($f, "\n%s:\n%s\n", date('r'), $res);
	fclose($f);
  return $res;
}
