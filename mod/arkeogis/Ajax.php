<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Ajax {

	public static function getDbInformations($params) {
		if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
		$infos = \core\Core::$db->fetchAll("Select da_description AS description, da_description_de AS description_de, TO_CHAR(da_declared_modification, 'DD/MM/YYYY') AS declared_modification, da_type AS type, da_geographical_limit AS geographical_limit, da_geographical_limit_de AS geographical_limit_de, da_scale_resolution AS scale_resolution FROM ark_database WHERE da_name =?",array($params['dbname']));
		$smarty = \mod\smarty\Main::newSmarty();
		$smarty->assign('infos', $infos[0]);
		$smarty->assign('currentLang', \mod\lang\Main::getCurrentLang());
		return $smarty->fetch('arkeogis/databaseInfos');
	}

	private static function implode_unempty($ar, $sep) {
		$res='';
		foreach($ar as $v) {
			if (!empty($v) &&  !strstr($res, $v.$sep))
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
																													 ), 100000, 'ark_site.si_id, da_id', 'ark_site.si_id', true, false);
		$total_count=$res['total_count'];
		$sites=&$res['sites'];
		$sites=&$res['sites'];

		$strings=ArkeoGIS::load_strings();
    foreach($sites as $k => $row) {
			//\core\Core::log($row);
      $sites[$k]['realestate'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['realestate'], $strings['realestate'], '/'), ' -- ');
      $sites[$k]['furniture'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['furniture'], $strings['furniture'], '/'), ' -- ');
      $sites[$k]['production'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['production'], $strings['production'], '/'), ' -- ');
      $sites[$k]['landscape'] = self::implode_unempty(ArkeoGIS::node_path_array_to_str($row['landscape'], $strings['landscape'], '/'), ' -- ');

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
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Immobilier').": </b><br />$site[realestate]</div>";
			}
			if (!empty($site['furniture']) && !strstr($site['furniture'], 'NULL')) {
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Mobilier').": </b><br />$site[furniture]</div>";
			}
			if (!empty($site['landscape']) && !strstr($site['landscape'], 'NULL')) {
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Paysage').": </b><br />$site[landscape]</div>";
			}
			if (!empty($site['production']) && !strstr($site['production'], 'NULL')) {
				$content .= "<div><b>".\mod\lang\Main::ch_t('arkeogis', 'Production').": </b><br />$site[production]</div>";
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
		$columns.="(SELECT pe_name_fr||'/'||pe_name_de FROM ark_period WHERE pe_id=max(sp_period_end)) AS period_end ";

    $res=ArkeoGIS::search_sites($search, $columns, array(
																												 'ark_database' => true
																												 ), 1500, 'ark_site.si_id, da_id', 'ark_site.si_id', true, false);
		$total_count=$res['total_count'];
		$sites=&$res['sites'];

		$strings=ArkeoGIS::load_strings();
    foreach($sites as $k => $row) {
			//\core\Core::log($row);
      //$sites[$k]['period_start'] = ArkeoGIS::node_path_to_str($row['period_start'], $strings['period'], '/');
      //$sites[$k]['period_end'] = ArkeoGIS::node_path_to_str($row['period_end'], $strings['period'], '/');

			$realestate=\core\Core::$db->fetchOne("SELECT array_agg(r1.node_path) FROM ark_site_period sp1 LEFT JOIN ark_siteperiod_realestate spr1 ON spr1.sr_site_period_id = sp1.sp_id LEFT JOIN ark_realestate r1 ON r1.re_id = spr1.sr_realestate_id WHERE sp1.sp_site_id = ?", array($row['si_id']));
			$furniture=\core\Core::$db->fetchOne("SELECT array_agg(f1.node_path) FROM ark_site_period sp1 LEFT JOIN ark_siteperiod_furniture spf1 ON spf1.sf_site_period_id = sp1.sp_id LEFT JOIN ark_furniture f1 ON f1.fu_id = spf1.sf_furniture_id WHERE sp1.sp_site_id = ?", array($row['si_id']));
			$production=\core\Core::$db->fetchOne("SELECT array_agg(p1.node_path) FROM ark_site_period sp1 LEFT JOIN ark_siteperiod_production spp1 ON spp1.sp_site_period_id = sp1.sp_id LEFT JOIN ark_production p1 ON p1.pr_id = spp1.sp_production_id WHERE sp1.sp_site_id = ?", array($row['si_id']));
			$landscape=\core\Core::$db->fetchOne("SELECT array_agg(l1.node_path) FROM ark_site_period sp1 LEFT JOIN ark_siteperiod_landscape spl1 ON spl1.sl_site_period_id = sp1.sp_id LEFT JOIN ark_landscape l1 ON l1.la_id = spl1.sl_landscape_id WHERE sp1.sp_site_id = ?", array($row['si_id']));

      $sites[$k]['realestate'] = implode(ArkeoGIS::node_path_array_to_str($realestate, $strings['realestate'], '/'), '<br />');
      $sites[$k]['furniture'] = implode(ArkeoGIS::node_path_array_to_str($furniture, $strings['furniture'], '/'), '<br />');
      $sites[$k]['production'] = implode(ArkeoGIS::node_path_array_to_str($production, $strings['production'], '/'), '<br />');
      $sites[$k]['landscape'] = implode(ArkeoGIS::node_path_array_to_str($landscape, $strings['landscape'], '/'), '<br />');
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

  public static function directory($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";

    $pagination = false;
    if ( isset($_REQUEST["page"]) ) {
      $pagination = true;
      $page = intval($_REQUEST["page"]);
      $perpage = intval($_REQUEST["perpage"]);
    }

    // this variables Omnigrid will send only if serverSort option is true
    $sorton = isset($_REQUEST["sorton"]) ? $_REQUEST["sorton"] : '';
    $sortby = isset($_REQUEST["sortby"]) ? $_REQUEST["sortby"] : '';

    if (!in_array($sorton, array('login','full_name','email','structure','databases','groups'))) $sorton='login';
    if (!in_array($sortby, array('ASC', 'DESC'))) $sortby='ASC';

    $n = ( $page -1 ) * $perpage;

    $q='SELECT count(u.uid) FROM "ch_user" u
        LEFT JOIN ark_userinfos ui ON u.uid=ui.uid';
    $total = \core\Core::$db->fetchOne($q, []);

    $limit = "";

    if ( $pagination )
      $limit = "OFFSET $n LIMIT $perpage";

    $q='SELECT "u"."uid", "login", "full_name", "email", "structure",
        array_to_string(ARRAY(select d.da_name FROM ark_database d WHERE d.da_owner_id = u.uid ORDER BY d.da_name), \', \') as databases,
        array_to_string(ARRAY(select g.name FROM ch_user_group ug LEFT JOIN ch_group g ON g.gid=ug.gid WHERE ug.uid=u.uid), \', \') as groups
        FROM "ch_user" u
        LEFT JOIN ark_userinfos ui ON u.uid=ui.uid ORDER BY '.$sorton.' '.$sortby.' '.$limit;

    $ret = \core\Core::$db->fetchAll($q, []);

    $ret = array("page"=>$page, "total"=>$total, "data"=>$ret);

    return $ret;
	}


  public static function databases($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";

    $l = \mod\lang\Main::getCurrentLang();
    $lang = ($l == 'fr_FR') ? 'fr' : 'de';
    $langext = ($l == 'fr_FR') ? '' : '_de';

    $pagination = false;
    if ( isset($_REQUEST["page"]) ) {
      $pagination = true;
      $page = intval($_REQUEST["page"]);
      $perpage = intval($_REQUEST["perpage"]);
    }

    // this variables Omnigrid will send only if serverSort option is true
    $sorton = isset($_REQUEST["sorton"]) ? $_REQUEST["sorton"] : '';
    $sortby = isset($_REQUEST["sortby"]) ? $_REQUEST["sortby"] : '';

    if ($sorton == 'declared_modification_str') $sorton = 'declared_modification';
    if ($sorton == 'published_str') $sorton = 'published';
    if (!in_array($sorton, array('issn','name','author','type','declared_modification', 'lines', 'sites', 'period_start', 'period_end', 'scale_resolution', 'status', 'description'))) $sorton='issn';
    if (!in_array($sortby, array('ASC', 'DESC'))) $sortby='ASC';
    $n = ( $page -1 ) * $perpage;

    $q='SELECT count(1) FROM "ark_database"';
    $total = \core\Core::$db->fetchOne($q, []);

    $limit = "";

    $scaleTranslations = array('site' => 'Site', 'watershed' => 'Bassin versant', 'micro-region' => 'Micro-région', 'region' => 'Région', 'country' => 'Pays', 'europe' => 'Europe');

    if ( $pagination )
      $limit = "OFFSET $n LIMIT $perpage";

    $q='SELECT da_id as id, da_issn as issn, da_name as name, da_description'.$langext.' as description, u.full_name as author, da_type as type, to_char(da_declared_modification, \'DD/MM/YYYY\') as declared_modification_str, da_declared_modification as declared_modification, da_lines as lines, da_sites as sites, (SELECT pe_name_'.$lang.' FROM ark_period WHERE pe_id = da_period_start) as period_start, (SELECT pe_name_'.$lang.' FROM ark_period WHERE pe_id = da_period_end) as period_end, da_scale_resolution as scale_resolution, da_geographical_limit'.$langext.' as geographical_limit, da_published as published FROM ark_database d LEFT JOIN ch_user u ON d.da_owner_id = u.uid ORDER BY '.$sorton.' '.$sortby.' '.$limit;

    $ret = \core\Core::$db->fetchAll($q, []);
    $outp = array();
    foreach($ret as $r) {
        $r['type'] = \mod\lang\Main::ch_t('arkeogis', $r['type']);
        if (isset($scaleTranslations[$r['scale_resolution']])) {
          $r['scale_resolution'] = \mod\lang\Main::ch_t('arkeogis', $scaleTranslations[$r['scale_resolution']]);
        }
        $r['published_str'] = ($r['published'] == 't') ? '<img src="/mod/arkeogis/img/status-ok.png" alt="" />' : '<img src="/mod/arkeogis/img/status-pending.png" alt="" />';;
        array_push($outp, $r);
    }

    $ret = array("page"=>$page, "total"=>$total, "data"=>$outp);

    return $ret;
  }

  public static function showdatabasesheet($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $scaleTranslations = array('site' => 'Site', 'watershed' => 'Bassin versant', 'micro-region' => 'Micro-région', 'region' => 'Région', 'country' => 'Pays', 'europe' => 'Europe');
    $databaseInfos = array();
    $ret = ArkeoGIS::getDatabaseInfos((int)$params['id']);
    $ret[0]['type'] = \mod\lang\Main::ch_t('arkeogis', $ret[0]['type']);
    if (isset($scaleTranslations[$ret[0]['scale_resolution']])) {
      $ret[0]['scale_resolution'] = \mod\lang\Main::ch_t('arkeogis', $scaleTranslations[$ret[0]['scale_resolution']]);
    }
    $smarty = \mod\smarty\Main::newSmarty();
    $smarty->assign('infos', $ret[0]);
    $response = array('title' => $ret[0]['name'], 'content' => $smarty->fetch('arkeogis/databasesheet'), 'footer' => '');
    if (\mod\user\Main::userBelongsToGroup('Admin') || \mod\arkeogis\ArkeoGIS::isDatabaseOwner((int)$params['id'], \mod\user\Main::getUserId($_SESSION['login']))) {
        $response['footer'] .= '<input type="button" class="btn btn-primary" value="'.\mod\lang\Main::ch_t('arkeogis', 'Modifier').'" onclick="showEditDatabase('.$ret[0]['id'].')" />';
    }
    if (\mod\user\Main::userBelongsToGroup('Admin')) {
        $response['footer'] .= '<input type="button" class="btn btn-danger" value="'.\mod\lang\Main::ch_t('arkeogis', 'Supprimer').'" onclick="if(confirm(\''.\mod\lang\Main::ch_t('arkeogis', 'Êtes vous sûr de vouloir supprimer cette base ?').'\')) {deleteDatabase('.$ret[0]['id'].');}" />';
    }
    $file = \mod\arkeogis\ArkeoGIS::getLastImportFile((int)$params['id']);
     if ($file) {
        if (is_file(dirname(__FILE__).'/files/import/'.$file) && is_readable(dirname(__FILE__).'/files/import/'.$file)) {
           $response['footer'] .= '<input type="button" class="btn" value="'.\mod\lang\Main::ch_t('arkeogis', 'Télécharger le fichier d\'import').'" onclick="downloadLastImport('.(int)$params['id'].')" />';
        }
     }
    $response['footer'] .= '<input type="button" class="btn" value="'.\mod\lang\Main::ch_t('arkeogis', 'Fermer').'" onclick="modalWin.hide()" />';
    return $response;
  }

  public static function showEditDatabase($params) {
     if (!\mod\user\Main::userIsLoggedIn() || (!\mod\user\Main::userBelongsToGroup('Admin') && !\mod\arkeogis\ArkeoGIS::isDatabaseOwner((int)$params['id'], \mod\user\Main::getUserId($_SESSION['login'])) || !$params['id'])) {
        return false;
     }
     $scaleTranslations = array('site' => 'Site', 'watershed' => 'Bassin versant', 'micro-region' => 'Micro-région', 'region' => 'Région', 'country' => 'Pays', 'europe' => 'Europe');
     $databaseInfos = array();
     $ret = ArkeoGIS::getFullDatabaseInfos((int)$params['id']);
     $smarty = \mod\smarty\Main::newSmarty();
     $ret[0]['published'] = ($ret[0]['published']) ? 1 : 0;
     $smarty->assign('infos', $ret[0]);
     $response = array('title' => \mod\lang\Main::ch_t('arkeogis', 'Edition of the base').' '.$ret[0]['name'], 'content' => $smarty->fetch('arkeogis/databasesEdit'));
     $response['footer'] = '<input type="button" class="btn btn-primary" value="'.\mod\lang\Main::ch_t('arkeogis', 'Modifier').'" onclick="editDatabase('.$ret[0]['id'].')" />';
     $response['footer'] .= '<input type="button" class="btn" value="'.\mod\lang\Main::ch_t('arkeogis', 'Fermer').'" onclick="modalWin.hide()" />';
     return $response;
  }

  public static function editDatabase($params) {
     if (!\mod\user\Main::userIsLoggedIn() || (!\mod\user\Main::userBelongsToGroup('Admin') && !\mod\arkeogis\ArkeoGIS::isDatabaseOwner((int)$params['id'], \mod\user\Main::getUserId($_SESSION['login'])) || !$params['id'])) {
        return false;
     }
     $acceptedParams = array('name', 'declared_modification', 'issn', 'scale_resolution', 'type', 'geographical_limit', 'geographical_limit_de', 'description', 'description_de', 'published');
     $dbParans = array();
     while(list($k, $v) = each($params)) {
       if (in_array($k, $acceptedParams)) {
          $dbParams[$k] = \core\Tools::cleanString($v);
       }
     }
     if (isset($dbParams['declared_modification']) && empty($dbParams['declared_modification'])) {
        unset($dbParams['declared_modification']);
     }
     if (isset($dbParams['published'])) {
       $dbParams['published'] = ($dbParams['published'] == 0) ? 'f' : 't'; 
     } 
     if (!\mod\user\Main::userBelongsToGroup('Admin')) {
        unset($dbParams['published']);
     }

      $owner_id = \core\Core::$db->fetchOne('SELECT uid FROM "ch_user" WHERE full_name = ?', array($params['author']));
      if ($owner_id) {
          $dbParams['owner_id'] = $owner_id;
      }

     \mod\arkeogis\ArkeoGIS::updateDatabase((int)$params['id'], $dbParams);
     return true;
  }

  public static function deleteDatabase($params) {
     if (!\mod\user\Main::userIsLoggedIn() || !\mod\user\Main::userBelongsToGroup('Admin') || !$params['id']) {
        return false;
     }
     \mod\arkeogis\ArkeoGIS::deleteDatabase($params['id']);
     return true;
  }

}
