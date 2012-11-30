<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Ajax {

	public static function getDbInformations($params) {
    		if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    		$infos = \core\Core::$db->fetchAll("Select da_description AS description, da_description_de AS description_de, TO_CHAR(da_declared_modification, 'DD/MM/YYYY') AS declared_modification, da_type AS type, da_geographical_limit AS geographical_limit, da_scale_resolution AS scale_resolution FROM ark_database WHERE da_name =?",array($params['dbname']));
	  	  $smarty = \mod\smarty\Main::newSmarty();
				$smarty->assign('infos', $infos[0]);
				$smarty->assign('currentLang', \mod\lang\Main::getCurrentLang());
				return $smarty->fetch('arkeogis/databaseInfos');
	}

	private static function implode_unempty($ar, $sep) {
		$res='';
		foreach($ar as $v) {
			if (!empty($v))
				$res.=$v.$sep;
		}
		return substr($res, 0, -strlen($sep));
	}

	public static function showthemap($params) {
		$search = $params['search'];
		$queryNum = $params['queryNum'];
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";

    $lang=\mod\lang\Main::getCurrentLang();
    $lang=substr($lang, 0, 2);
		$columns="da_id, da_name, si_name, si_id, si_code, ST_AsGeoJSON(si_geom) as geom, si_centroid as centroid, (COALESCE(max(sr_exceptional), 0) + COALESCE(max(sf_exceptional), 0) + COALESCE(max(sp_exceptional), 0)) as exceptional, array_agg(sp_knowledge_type) as knowledge, ";
    $columns.="array_agg((SELECT node_path FROM ark_period WHERE pe_id=sp_period_start) order by sp_period_isrange DESC) AS period_start, ";
    $columns.="array_agg((SELECT pe_name_$lang FROM ark_period WHERE pe_id=sp_period_start)) AS period_start_label, ";
    $columns.="array_agg((SELECT node_path FROM ark_period WHERE pe_id=sp_period_end) order by sp_period_isrange DESC) AS period_end, ";
    $columns.="array_agg((SELECT pe_name_$lang FROM ark_period WHERE pe_id=sp_period_end)) AS period_end_label, ";
    $columns.="array_agg((SELECT node_path FROM ark_realestate WHERE re_id=sr_realestate_id) order by ark_site_period.sp_id) as realestate, ";
    $columns.="array_agg((SELECT node_path FROM ark_furniture WHERE fu_id=sf_furniture_id) order by ark_site_period.sp_id) as furniture, ";
    $columns.="array_agg((SELECT node_path FROM ark_production WHERE pr_id=sp_production_id) order by ark_site_period.sp_id) as production, ";
    $columns.="array_agg((SELECT node_path FROM ark_landscape WHERE la_id=sl_landscape_id) order by ark_site_period.sp_id) as landscape ";

    $res = ArkeoGIS::search_sites($search, $columns, array(
																													 'ark_database' => true,
																													 'ark_site_period' => true,
																													 'ark_siteperiod_production' => true,
																													 'ark_siteperiod_furniture' => true,
																													 'ark_siteperiod_realestate' => true,
																													 'ark_siteperiod_landscape' => true
																													 ), 1500, 'ark_site.si_id, da_id', 'ark_site.si_id', true, false);
		$total_count=$res['total_count'];
		$sites=&$res['sites'];
		$sites=&$res['sites'];

		$strings=ArkeoGIS::load_strings();
    foreach($sites as $k => $row) {
			//\core\Core::log($row);
      $sites[$k]['realestate'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['realestate'], $strings['realestate'], '/'), ';');
      $sites[$k]['furniture'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['furniture'], $strings['furniture'], '/'), ';');
      $sites[$k]['production'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['production'], $strings['production'], '/'), ';');
      $sites[$k]['landscape'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['landscape'], $strings['landscape'], '/'), ';');

      $period_start = explode(',', trim($row['period_start'], '{}'));
      $period_end = explode(',', trim($row['period_end'], '{}'));
			$sites[$k]['period_start_label'] = isset($period_start[0]) ? $strings['period'][array_pop(explode('.', $period_start[0]))] : '';
			$sites[$k]['period_end_label'] = isset($period_end[0]) ? $strings['period'][array_pop(explode('.', $period_end[0]))] : '';
    }
		$mapMarkers = array();

		foreach($sites as $site) {
			$coords = json_decode($site['geom'], true);
			$title = '<div><b>'.((!empty($site['si_name'])) ? $site['si_name'] : 'ID: '.$site['si_code']).'</b></div>';
			$content = "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Base de donnée').": </b>$site[da_name]</div>";
			$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Période').': </b>'.$site["period_start_label"]." - ".$site["period_end_label"]."</div>";
			if (!empty($site['realestate']) && !strstr($site['realestate'], 'NULL')) {
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Immobilier').": </b>$site[realestate]</div>";
			} else if (!empty($site['furniture']) && !strstr($site['furniture'], 'NULL')) {
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Mobilier').": </b>$site[furniture]</div>";
			} else if (!empty($site['landscape']) && !strstr($site['landscape'], 'NULL')) {
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Paysage').": </b>$site[landscape]</div>";
			} else if (!empty($site['production']) && !strstr($site['production'], 'NULL')) {
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Production').": </b>$site[production]</div>";
			}
			$popupParams = array('title' => $title, 'content' => $content);
			$shapes = array('circle', 'square', 'triangle', 'diamond', 'parallelogram', 'trianglerectangle', 'rectangle', 'trianglerectangleinverted');
			$m = \mod\arkeogis\ArkeoGIS::getMarker($site['si_id'], $shapes[$queryNum-1], $coords, $site['knowledge'], $site['period_end'], $site['exceptional'], $site['centroid'], $popupParams);
			$mapMarkers[] = $m;
		}
		return array('total_count' => $total_count, 'mapmarkers' => $mapMarkers);
  }

	public static function showthesheet($search) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $columns="ark_site.si_id, da_name, si_city_name, si_name, ";
		$columns.="(SELECT pe_name_fr||'/'||pe_name_de FROM ark_period WHERE pe_id=min(sp_period_start)) AS period_start, ";
		$columns.="(SELECT pe_name_fr||'/'||pe_name_de FROM ark_period WHERE pe_id=max(sp_period_end)) AS period_end, ";
		$columns.="array_agg((SELECT node_path FROM ark_realestate WHERE re_id=sr_realestate_id) order by ark_site_period.sp_id) as realestate, ";
		$columns.="array_agg((SELECT node_path FROM ark_furniture WHERE fu_id=sf_furniture_id) order by ark_site_period.sp_id) as furniture, ";
		$columns.="array_agg((SELECT node_path FROM ark_production WHERE pr_id=sp_production_id) order by ark_site_period.sp_id) as production,";
		$columns.="array_agg((SELECT node_path FROM ark_landscape WHERE la_id=sl_landscape_id) order by ark_site_period.sp_id) as landscape";
    $res=ArkeoGIS::search_sites($search, $columns, array(
																												 'ark_database' => true,
																												 'ark_siteperiod_production' => true,
																												 'ark_siteperiod_furniture' => true,
																												 'ark_siteperiod_realestate' => true,
																												 'ark_siteperiod_landscape' => true
																												 ), 1500, 'ark_site.si_id, da_id', 'ark_site.si_id', true, false);
		$total_count=$res['total_count'];
		$sites=&$res['sites'];

		$strings=ArkeoGIS::load_strings();
    foreach($sites as $k => $row) {
			//\core\Core::log($row);
      //$sites[$k]['period_start'] = ArkeoGIS::node_path_to_str($row['period_start'], $strings['period'], '/');
      //$sites[$k]['period_end'] = ArkeoGIS::node_path_to_str($row['period_end'], $strings['period'], '/');
      $sites[$k]['realestate'] = implode(ArkeoGIS::node_path_array_to_str($row['realestate'], $strings['realestate'], '/'), '<br />');
      $sites[$k]['furniture'] = implode(ArkeoGIS::node_path_array_to_str($row['furniture'], $strings['furniture'], '/'), '<br />');
      $sites[$k]['production'] = implode(ArkeoGIS::node_path_array_to_str($row['production'], $strings['production'], '/'), '<br />');
      $sites[$k]['landscape'] = implode(ArkeoGIS::node_path_array_to_str($row['landscape'], $strings['landscape'], '/'), '<br />');
    }

    return $res;
  }

  
  public static function saveQuery($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    $count=\core\Core::$db->fetchOne("SELECT count(*) FROM ark_savedquery WHERE id_user=? AND name=?",
                                     array($uid, $params['name']));
    if ($count) return 'duplicate';
    \core\Core::$db->exec("INSERT INTO ark_savedquery (id_user, name, query) VALUES (?,?,?)",
                          array($uid, $params['name'], $params['query']));
    return 'ok';
  }

  public static function deleteQuery($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    \core\Core::$db->exec("DELETE FROM ark_savedquery WHERE id_user=? AND id=?",
                          array($uid, $params['queryid']));
    return 'ok';
  }

  public static function loadQuery($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    return \core\Core::$db->fetchOne("SELECT query FROM ark_savedquery WHERE id_user=? AND id=?",
                                     array($uid, $params['queryid']));
  }

  public static function listQueries($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
    return \core\Core::$db->fetchAll("SELECT * FROM ark_savedquery WHERE id_user=?",
                                     array($uid));
  }

	public static function showsitesheet($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
		$siteInfos = ArkeoGIS::getSiteInfos($params['id']);
    $smarty = \mod\smarty\Main::newSmarty();
		$smarty->assign('infos', $siteInfos);
		$title = (!empty($siteInfos['name'])) ? $siteInfos['name'] : 'ID: '.$siteInfos['code'];
		return array('title' => $title, 'content' => $smarty->fetch('arkeogis/sitesheet'));
	}
}
