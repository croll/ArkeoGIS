<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Ajax {

	public static function showthemap($search) {
    return self::search_sites($search, "si_code, si_name");
  }

	public static function showthesheet($search) {
    $columns="si_name, ";
    $columns.="array_agg((SELECT pe_name_fr FROM ark_period WHERE pe_id=sp_period_start)) AS period_start, ";
    $columns.="array_agg((SELECT pe_name_fr FROM ark_period WHERE pe_id=sp_period_end)) AS period_end, ";
    $columns.="array_agg((SELECT re_name_fr FROM ark_realestate WHERE re_id=sr_realestate_id)) as realestate, ";
    $columns.="array_agg((SELECT fu_name_fr FROM ark_furniture WHERE fu_id=sf_furniture_id)) as furniture, ";
    $columns.="array_agg((SELECT pr_name_fr FROM ark_production WHERE pr_id=sp_production_id)) as production";

    return self::search_sites($search, $columns, array(
                                'ark_site_period' => true,
                                'ark_siteperiod_production' => true,
                                'ark_siteperiod_furniture' => true,
                                'ark_siteperiod_realestate' => true
                              ));
  }

	private static function search_sites($search, $columns, $addtable=array()) {
		$search=$_REQUEST; // override the $search wich is fucked, I don't really know why

		\core\Core::log($search);

		$addtable=array('ark_site_period' => isset($addtable['ark_site_period']) ? $addtable['ark_site_period'] : false,
										'ark_siteperiod_production' => isset($addtable['ark_siteperiod_production']) ? $addtable['ark_siteperiod_production'] : false,
										'ark_siteperiod_furniture' => isset($addtable['ark_siteperiod_furniture']) ? $addtable['ark_siteperiod_furniture'] : false,
										'ark_siteperiod_realestate' => isset($addtable['ark_siteperiod_realestate']) ? $addtable['ark_siteperiod_realestate'] : false);

		$query=' WHERE (1=1) ';
		$args=array();

		if (isset($search['db_include']) && count($search['db_include'])) {
			$query.=' AND si_database_id IN (?)';
			$args[]=$search['db_include'];
		}

		if (isset($search['db_exclude']) && count($search['db_exclude'])) {
			$query.=' AND si_database_id NOT IN (?)';
			$args[]=$search['db_exclude'];
		}

		if (isset($search['period_include']) && count($search['period_include'])) {
			$addtable['ark_site_period']=true;
      $query.=' AND (0=1 ';
			foreach($search['period_include'] as $period) {
				$query.=' OR sp_period_start >= ? AND sp_period_start <= ?';
				$args[]=$period;
				$args[]=$period;
			}
      $query.=')';
		}

		if (isset($search['period_exclude']) && count($search['period_exclude'])) {
			$addtable['ark_site_period']=true;
      $query.=' AND (0=1 ';
			foreach($search['period_exclude'] as $period) {
				$query.=' OR NOT (sp_period_start >= ? AND sp_period_start <= ?)';
				$args[]=$period;
				$args[]=$period;
			}
      $query.=')';
		}

		if (isset($search['centroid_include']) && count($search['centroid_include'])) {
      $query.=' AND si_centroid IN (?)';
      $args[]=$search['centroid_include'];
		}

		if (isset($search['knowledge_include']) && count($search['knowledge_include'])) {
			$addtable['ark_site_period']=true;
			$query.=' AND sp_knowledge_type IN(?)';
			$args[]=$search['knowledge_include'];
		}

		if (isset($search['occupation_include']) && count($search['occupation_include'])) {
      $query.=' AND si_occupation IN (?)';
      $args[]=$search['occupation_include'];
		}

		if (isset($search['production_include']) && count($search['production_include'])) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_production']=true;
			$query.=' AND sp_site_period_id IN (?)';
			$args[]=$search['production_include'];
		}

		if (isset($search['production_exclude']) && count($search['production_exclude'])) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_production']=true;
			$query.=' AND sp_site_period_id NOT IN (?)';
			$args[]=$search['production_include'];
		}

		if (isset($search['production_exceptional']) && $search['production_exceptional'] == 1) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_production']=true;
			$query.=' AND sp_exceptional = 1';
		}

		if (isset($search['furniture_include']) && count($search['furniture_include'])) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_furniture']=true;
			$query.=' AND sf_id IN (?)';
			$args[]=$search['furniture_include'];
		}

		if (isset($search['furniture_exclude']) && count($search['furniture_exclude'])) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_furniture']=true;
			$query.=' AND sf_id NOT IN (?)';
			$args[]=$search['furniture_include'];
		}

		if (isset($search['furniture_exceptional']) && $search['furniture_exceptional'] == 1) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_furniture']=true;
			$query.=' AND sf_exceptional = 1';
		}

		if (isset($search['realestate_include']) && count($search['realestate_include'])) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_realestate']=true;
			$query.=' AND sr_id IN (?)';
			$args[]=$search['realestate_include'];
		}

		if (isset($search['realestate_exclude']) && count($search['realestate_exclude'])) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_realestate']=true;
			$query.=' AND sr_id NOT IN (?)';
			$args[]=$search['realestate_include'];
		}

		if (isset($search['realestate_exceptional']) && $search['realestate_exceptional'] == 1) {
			$addtable['ark_site_period']=true;
			$addtable['ark_siteperiod_realestate']=true;
			$query.=' AND sr_exceptional = 1';
		}


		$select="SELECT $columns";
		$select.=" FROM ark_site";
		if ($addtable['ark_site_period']) {
			$select.=" LEFT JOIN ark_site_period ON sp_site_code = si_code";
		}
		if ($addtable['ark_siteperiod_production']) {
			$select.=" LEFT JOIN ark_siteperiod_production ON sp_site_period_id = ark_site_period.sp_id";
		}
		if ($addtable['ark_siteperiod_furniture']) {
			$select.=" LEFT JOIN ark_siteperiod_furniture ON sf_site_period_id = ark_site_period.sp_id";
		}
		if ($addtable['ark_siteperiod_realestate']) {
			$select.=" LEFT JOIN ark_siteperiod_realestate ON sr_site_period_id = ark_site_period.sp_id";
		}

		$query=$select.' '.$query.' GROUP BY si_code';

		//$query.=' GROUP BY si_code';

		\core\Core::log($query);
		$result=\core\Core::$db->fetchAll($query, $args);
		\core\Core::log($result);
		\core\Core::log('result count: '.count($result));
		return $result;
	}


  
  public static function saveQuery($params) {
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    \core\Core::$db->exec("INSERT INTO ark_savedquery (id_user, name, query) VALUES (?,?,?)",
                          array($uid, $params['name'], $params['query']));
    return 'ok';
  }

  public static function deleteQuery($params) {
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    \core\Core::$db->exec("DELETE FROM ark_savedquery WHERE id_user=? AND id=?",
                          array($uid, $params['queryid']));
    return 'ok';
  }

  public static function loadQuery($params) {
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    return \core\Core::$db->fetchOne("SELECT query FROM ark_savedquery WHERE id_user=? AND id=?",
                                     array($uid, $params['queryid']));
  }

  public static function listQueries($params) {
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    return \core\Core::$db->fetchAll("SELECT * FROM ark_savedquery WHERE id_user=?",
                                     array($uid));
  }
}
