<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Main {

  public static function hook_mod_arkeogis_index($hookname, $userdata) {
    if (\mod\user\Main::userIsLoggedIn()) {;
      $page = new \mod\webpage\Main();
      // get lang
      $lang=\mod\lang\Main::getCurrentLang();
      $page->smarty->assign('lang', $lang);
      $page->smarty->assign('canexport',
                            \mod\user\Main::userBelongsToGroup('Admin')
                            || \mod\user\Main::userBelongsToGroup('Chercheur'));
      $page->setLayout('arkeogis/arkeogis');
      $page->display();
    } else {
      return self::hook_mod_arkeogis_public($hookname, $userdata);
    }
  }

  public static function hook_mod_arkeogis_public($hookname, $userdata) {
    // get lang
    $page = new \mod\webpage\Main();
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    $sysname = \mod\page\Main::getTranslated('accueil', $lang);
    $present = \mod\page\Main::getPageBySysname($sysname);
    $page->smarty->assign('lang', $lang);
    $page->smarty->assign('present', $present);
    $page->setLayout('arkeogis/public');
    $page->display();
  }

  public static function hook_mod_arkeogis_exemple($hookname, $userdata) {
    $page = new \mod\webpage\Main();
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    $page->smarty->assign('lang', $lang);
    $page->setLayout('arkeogis/exemple');
    $page->display();
  }

  public static function hook_mod_arkeogis_manuel($hookname, $userdata, $matches) {
    $page = new \mod\webpage\Main();
    // get lang
    if($matches[1]== NULL) {
	$tab="requetes";
    } else {
	$tab = $matches[1];
    }
    $lang=\mod\lang\Main::getCurrentLang();
    $page->smarty->assign('tab', $tab);
    $page->smarty->assign('lang', $lang);
    $page->setLayout('arkeogis/manuel');
    $page->display();
  }

  public static function display_html_error($error) {
    $page = new \mod\webpage\Main();
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    $page->smarty->assign('lang', $lang);
    $page->smarty->assign('error', $error);
    $page->setLayout('arkeogis/error');
    $page->display();
  }

  public static function hook_mod_arkeogis_directory($hookname, $userdata) {
   
    if (!\mod\user\Main::userIsLoggedIn()) {
    	return false;
     }
    // check for optionals parameters 
    if (isset($matches[1])) {	
		$check=split('/', $matches[1]);
		$params=array();
		for ($i=0; $i <= count($check); $i++) {
			if ($check[$i] != "") {
				$iNext= $i+1;
				$params[$check[$i]]= $check[$iNext];
				$i++;
			}
		}
		if ($params["sort"]) {
			$sort = $params["sort"];
		}	
		if ($params["maxrow"] && (int)$params["maxrow"]) {
			$maxrow=$params["maxrow"];
		}
		if ($params["offset"] && (int)$params["offset"]) {
			$offset=$params["offset"];
		}
		if ($params["filter"]) {
			$filter=$params["filter"];
		}
    }	
    // set default list parameter 
    if (!isset($sort)) $sort="login_asc";		
    if (!isset($maxrow)) $maxrow= 10;		
    if (!isset($offset)) $offset= 0;
    		
    $db=\core\Core::$db;
    $dbPParams=array(); 
    $dbParams[]=1;
    $mid = "";
    if (isset($filter)) {
	$filters = split('@', $filter);
	for($i=0; $i<count($filters); $i++) {
		//var_dump($filters);
		$fd=split(':', $filters[$i]);
		if ($fd[0] == 'login') {
		 	$mid .=" AND u.login like ?";	
			$dbParams[]=$fd[1];
		} else if ($fd[0] == 'full_name') {
		 	$mid .=" AND u.full_name like ?";	
			$dbParams[]=$fd[1];
		} else if ($fd[0] == 'email') {
		 	$mid .=" AND u.email like ?";	
			$dbParams[]=$fd[1];
		}
	}
    }
    $dbParams[]=(int)$maxrow;
    $dbParams[]=(int)$offset;
    $q='SELECT "uid", "login", "full_name", "email" FROM "ch_user" u WHERE u.uid > ?';	
    $q .= $mid;
    $q .= self::order_by($sort);
    $q .=" LIMIT ? OFFSET ?";
    $list = $db->fetchAll($q, $dbParams);
    for($i=0; $i<count($list); $i++) {
		$list[$i]['groups'] = \mod\arkeogis\Tools::getUserGroups($list[$i]['uid']);
		$list[$i]['databases'] = \mod\arkeogis\Tools::getUserDatabases($list[$i]['uid']);

    }
    $quant=$db->fetchOne("SELECT count(u.uid) as quant from ch_user u where uid > ? ", array(1));
    $page = new \mod\webpage\Main();
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    $page->smarty->assign('lang', $lang);
    $page->smarty->assign('list', $list);
    $page->smarty->assign('filter', $filter);
    $page->smarty->assign('sort', $sort);
    $page->smarty->assign('offset', $offset);
    $page->smarty->assign('maxrow', $maxrow);
    $page->smarty->assign('quant', $quant);
    
    $page->smarty->assign('directory_mode', 'list');
    $page->setLayout('arkeogis/directory');
    $page->display();
    }
    private function dbSort($sort) {
		$s=explode('_',$sort);
		$s[1]=strtoupper($s[1]);
		return $s[0]." ".$s[1];
    }
    private function order_by($sort) {
		$sorted = self::dbSort($sort);
		$q =" ORDER BY ".$sorted;
		return $q;
   } 
        private static function load_menus() {
    $lang=\mod\lang\Main::getCurrentLang();
    $lang=substr($lang, 0, 2);
    
		$menus=array();
		
		$menus['db']=\core\Core::$db->fetchAll("select da_id as id, null as parentid, da_name as name, da_id as node_path from ark_database order by id");
		
		$menus['period']=\core\Core::$db->fetchAll("select pe_id as id, pe_parentid as parentid, (pe_name_fr || '\n' || pe_name_de || '\n' || pe_desc) as name, node_path from ark_period order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['production']=\core\Core::$db->fetchAll("select pr_id as id, pr_parentid as parentid, pr_name_$lang as name, node_path from ark_production order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['realestate']=\core\Core::$db->fetchAll("select re_id as id, re_parentid as parentid, re_name_$lang as name, node_path from ark_realestate order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['furniture']=\core\Core::$db->fetchAll("select fu_id as id, fu_parentid as parentid, fu_name_$lang as name, node_path from ark_furniture order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");

		return $menus;
	}
  
  public static function hook_mod_arkeogis_pmmenus($hookname, $userdata) {
		\mod\user\Main::redirectIfNotLoggedIn();
    
		echo "menus=".json_encode(self::load_menus());
	}

	public static function hook_mod_arkeogis_import($hookname, $userdata, $urlmatches) {
		if (\mod\user\Main::userHasRight('Manage personal database') || \mod\user\Main::userHasRight('Manage all databases')) {
		$page = new \mod\webpage\Main();
		$page->setLayout('arkeogis/import');
		$page->display();
		} 
	}

	public static function hook_mod_arkeogis_import_submit($hookname, $userdata, $urlmatches) {
		if (\mod\user\Main::userHasRight('Manage personal database') || \mod\user\Main::userHasRight('Manage all databases')) {

		$params = array('mod' => 'arkeogis', 'file' => 'templates/dbUpload.json');
		$form = new \mod\form\Form($params);
		if ($form->validate()) {
			$separator = $form->getValue('separator');
			$enclosure = $form->getValue('enclosure');
			$file = $form->getValue('dbfile');
			$skipline = $form->getValue('skipline');
			$lang = $form->getValue('select_lang');
			$description = $form->getValue('description');
			$result =	\mod\arkeogis\DatabaseImport::importCsv($file['tmp_name'], $separator, $enclosure, $skipline, $lang, $description);
			unlink($file['tmp_name']);
			$page = new \mod\webpage\Main();
			$page->smarty->assign("result", $result);
		}
		$page->setLayout('arkeogis/import');
		$page->display();
		}
	}

  public static function hook_mod_arkeogis_print_sheet($hookname, $userdata) {
    if (\mod\user\Main::userIsLoggedIn()) {
      $page = new \mod\webpage\Main();
      $page->setLayout('arkeogis/print_sheet');
      $page->display();
    } else {
      return self::hook_mod_arkeogis_public($hookname, $userdata);
    }
  }

  public static function hook_mod_arkeogis_export_sheet($hookname, $userdata) {
    if (!\mod\user\Main::userIsLoggedIn())
			return self::hook_mod_arkeogis_public($hookname, $userdata);

    if (!\mod\user\Main::userBelongsToGroup('Admin') && !\mod\user\Main::userBelongsToGroup('Chercheur'))
      return self::display_html_error(\mod\lang\Main::ch_t('arkeogis', "Vous n'avez pas la permission de télécharger au format csv"));

		$q=json_decode($_REQUEST['q'], true);
		
		$columns="ark_site.si_id, si_code, si_name, si_description, si_city_id, ST_AsGeoJSON(si_geom) as coords, si_centroid, si_occupation, si_creation, si_modification"; // ark_site
		$columns.=", ci_code, ci_name, ci_country, ci_geom"; // ark_city
		$columns.=", da_name, da_description, da_creation, da_modification"; // ark_database
    $columns.=", ark_site_period.sp_id, sp_knowledge_type, sp_comment, sp_bibliography"; // ark_site_period
    $columns.=", sr_exceptional, sf_exceptional, sp_exceptional"; // exceptionals
		$columns.=", (SELECT node_path FROM ark_period WHERE pe_id=sp_period_start) AS period_start";
		$columns.=", (SELECT node_path FROM ark_period WHERE pe_id=sp_period_end) AS period_end";
		$columns.=", (SELECT node_path FROM ark_realestate WHERE re_id=sr_realestate_id) as realestate";
		$columns.=", (SELECT node_path FROM ark_furniture WHERE fu_id=sf_furniture_id) as furniture";
		$columns.=", (SELECT node_path FROM ark_production WHERE pr_id=sp_production_id) as production";

		$res=ArkeoGIS::search_sites($q, $columns, array(
                                  'ark_siteperiod_production' => true,
                                  'ark_siteperiod_furniture' => true,
                                  'ark_siteperiod_realestate' => true,
                                  'ark_city' => true,
                                  'ark_database' => true
                                ),
																false, // limit
                                '', // group_by,
                                '',
																'ark_site.si_code, ark_site.si_id', // orderby
                                false, // getcount
                                false  // onlysprange
    );
		
		$strings=ArkeoGIS::load_strings();
		
		header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
		header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); // Date dans le passé
		header("Content-Type: text/csv");
		header("Content-Disposition: attachment; filename=\"export.csv\"");

    $fp = fopen('php://output', 'w');
    fputcsv($fp, array('SITE_ID_SOURCE', 'BASE_SOURCE', 'NOM_SITE', 'NOM_COMMUNE_PRINCIPALE', 'CODE_COMMUNE', 'SYSTEME_PROJECTION', 'LONGITUDE_X ', 'LATITUDE_Y', 'LONGITUDE_X_BIS', 'LATITUDE_Y_BIS', 'ALTITUDE Z', 'CENTRE_COMMUNE', 'ETAT_CONNAISSANCES', 'OCCUPATION', 'DATATION_DEBUT_PLUS_FINE', 'DATATION_FIN_PLUS_FINE', 'IMMO_NIV1', 'IMMO_NIV2', 'IMMO_NIV3', 'IMMO_NIV4', 'PROFONDEUR_VESTIGES', 'IMMO_EXP', 'MOB_NIV1', 'MOB_NIV2', 'MOB_NIV3', 'MOB_NIV4', 'MOB_EXP', 'PROD_NIV1', 'PROD_NIV2', 'PROD_NIV3', 'PROD_EXP', 'BIBLIOGRAPHIE', 'REMARQUES'), ";", '"');
		
    $latest_siid=-1;
    $latest_spid=-1;
		foreach($res['sites'] as $row) {
      $newsiid=($latest_siid != $row['si_id']);
      $newspid=($latest_spid != $row['sp_id']);
      $coords=json_decode($row['coords']);
      $period_start=ArkeoGIS::node_path_to_array($row['period_start'], $strings['period']);
      $period_end=ArkeoGIS::node_path_to_array($row['period_end'], $strings['period']);
      $realestate=ArkeoGIS::node_path_to_array($row['realestate'], $strings['realestate']);
      $furniture=ArkeoGIS::node_path_to_array($row['furniture'], $strings['furniture']);
      $production=ArkeoGIS::node_path_to_array($row['production'], $strings['production']);
      fputcsv($fp, array(
                $row['si_code'],                                                                       // SITE_ID_SOURCE
                $newsiid ? $row['da_name'] : '',                                                       // BASE_SOURCE
                $newsiid ? $row['si_name'] : '',                                                       // NOM_SITE
                $newsiid ? $row['ci_name'] : '',                                                       // NOM_COMMUNE_PRINCIPALE
                $newsiid ? $row['ci_code'] : '',                                                       // CODE_COMMUNE
                $newsiid ? 'WGS84' : '',                                                               // SYSTEME_PROJECTION
                $newsiid ? $coords->coordinates[0] : '',                                               // LONGITUDE_X
                $newsiid ? $coords->coordinates[1] : '',                                               // LATITUDE_Y
                '',                                                                                    // LONGITUDE_X_BIS
                '',                                                                                    // LATITUDE_Y_BIS
                $newsiid ? ($coords->coordinates[2] == -999 ? '' : $coords->coordinates[2]) : '',      // ALTITUDE Z
                $newsiid ? $row['si_centroid'] : '',                                                   // CENTRE_COMMUNE
                $newsiid && $row['sp_knowledge_type'] ? $strings['knowledge'][$row['sp_knowledge_type']] : '', // ETAT_CONNAISSANCES
                $newsiid ? $strings['occupation'][$row['si_occupation']] : '',                         // OCCUPATION
                $newspid ? (count($period_start) ? $period_start[count($period_start)-1] : '') : '',   // DATATION_DEBUT_PLUS_FINE
                $newspid ? (count($period_end) ? $period_end[count($period_end)-1] : '') : '',         // DATATION_FIN_PLUS_FINE
                isset($realestate[0]) ? $realestate[0] : '',                                           // IMMO_NIV1
                isset($realestate[1]) ? $realestate[1] : '',                                           // IMMO_NIV2
                isset($realestate[2]) ? $realestate[2] : '',                                           // IMMO_NIV3
                isset($realestate[3]) ? $realestate[3] : '',                                           // IMMO_NIV4
                '',                                                                                    // PROFONDEUR_VESTIGES
                $row['sr_exceptional'],                                                                // IMMO_EXP
                isset($furniture[0]) ? $furniture[0] : '',                                             // MOB_NIV1
                isset($furniture[1]) ? $furniture[1] : '',                                             // MOB_NIV2
                isset($furniture[2]) ? $furniture[2] : '',                                             // MOB_NIV3
                isset($furniture[3]) ? $furniture[3] : '',                                             // MOB_NIV4
                $row['sf_exceptional'],                                                                // MOB_EXP
                isset($production[0]) ? $production[0] : '',                                           // PROD_NIV1
                isset($production[1]) ? $production[1] : '',                                           // PROD_NIV2
                isset($production[2]) ? $production[2] : '',                                           // PROD_NIV3
                $newspid ? $row['sp_exceptional'] : '',                                                // PROD_EXP
                $newspid ? $row['sp_bibliography'] : '',                                               // BIBLIOGRAPHIE
                $newspid ? $row['sp_comment'] : ''                                                     // REMARQUES
              ), ";", '"');
      $latest_siid=$row['si_id'];
      $latest_spid=$row['sp_id'];
		}
		    
  }

	

}
