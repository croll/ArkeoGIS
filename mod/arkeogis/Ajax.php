<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Ajax {

	public static function showthemap($search) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    return ArkeoGIS::search_sites($search, "si_code, si_name");
  }

	public static function showthesheet($search) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $columns="si_name, ";
		$columns.="(SELECT node_path FROM ark_period WHERE pe_id=min(sp_period_start)) AS period_start, ";
		$columns.="(SELECT node_path FROM ark_period WHERE pe_id=max(sp_period_end)) AS period_end, ";
		$columns.="array_agg((SELECT node_path FROM ark_realestate WHERE re_id=sr_realestate_id)) as realestate, ";
		$columns.="array_agg((SELECT node_path FROM ark_furniture WHERE fu_id=sf_furniture_id)) as furniture, ";
		$columns.="array_agg((SELECT node_path FROM ark_production WHERE pr_id=sp_production_id)) as production";

    /*
		$columns="si_name, ";
    $columns.="array_agg((SELECT pe_name_fr FROM ark_period WHERE pe_id=sp_period_start)) AS period_start, ";
    $columns.="array_agg((SELECT pe_name_fr FROM ark_period WHERE pe_id=sp_period_end)) AS period_end, ";
    $columns.="array_agg((SELECT re_name_fr FROM ark_realestate WHERE re_id=sr_realestate_id)) as realestate, ";
    $columns.="array_agg((SELECT fu_name_fr FROM ark_furniture WHERE fu_id=sf_furniture_id)) as furniture, ";
    $columns.="array_agg((SELECT pr_name_fr FROM ark_production WHERE pr_id=sp_production_id)) as production";
    */

    $res=ArkeoGIS::search_sites($search, $columns, array(
                                  'ark_site_period' => true,
                                  'ark_siteperiod_production' => true,
                                  'ark_siteperiod_furniture' => true,
                                  'ark_siteperiod_realestate' => true
                                ));

		$strings=ArkeoGIS::load_strings();
    foreach($res as $k => $row) {
      $res[$k]['period_start'] = ArkeoGIS::node_path_to_str($row['period_start'], $strings['period'], '/');
      $res[$k]['period_end'] = ArkeoGIS::node_path_to_str($row['period_end'], $strings['period'], '/');
      $res[$k]['realestate'] = implode(ArkeoGIS::node_path_array_to_str($row['realestate'], $strings['realestate'], '/'), ';');
      $res[$k]['furniture'] = implode(ArkeoGIS::node_path_array_to_str($row['furniture'], $strings['furniture'], '/'), ';');
      $res[$k]['production'] = implode(ArkeoGIS::node_path_array_to_str($row['production'], $strings['production'], '/'), ';');
    }

    return $res;
  }

  
  public static function saveQuery($params) {
    if (!\mod\user\Main::userIsLoggedIn()) return "not logged";
    $uid = \mod\user\Main::getUserId($_SESSION['login']);
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
}
