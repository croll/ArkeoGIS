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
    if(!isset($matches[1]) || $matches[1]== NULL) {
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

  public static function hook_mod_arkeogis_directory($hookname, $userdata, $matches) {
   
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
    $q .= \mod\arkeogis\Tools::order_by($sort);
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
    
	private static function load_menus() {
    $lang=\mod\lang\Main::getCurrentLang();
    $lang=substr($lang, 0, 2);
    
		$menus=array();
		
		$menus['db']=\core\Core::$db->fetchAll("select da_id as id, null as parentid, da_name as name, da_id as node_path, da_type from ark_database order by da_type,da_name,id");
		
		$menus['period']=\core\Core::$db->fetchAll("select pe_id as id, pe_parentid as parentid, (pe_name_fr || '\n' || pe_name_de) as name, node_path from ark_period order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");

		$menus['production']=\core\Core::$db->fetchAll("select pr_id as id, pr_parentid as parentid, pr_name_$lang as name, node_path from ark_production order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['realestate']=\core\Core::$db->fetchAll("select re_id as id, re_parentid as parentid, re_name_$lang as name, node_path from ark_realestate order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['furniture']=\core\Core::$db->fetchAll("select fu_id as id, fu_parentid as parentid, fu_name_$lang as name, node_path from ark_furniture order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");

		$menus['landscape']=\core\Core::$db->fetchAll("select la_id as id, la_parentid as parentid, la_name_$lang as name, node_path from ark_landscape order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");

		return $menus;
	}
  
  public static function hook_mod_arkeogis_pmmenus($hookname, $userdata) {
		\mod\user\Main::redirectIfNotLoggedIn();
    
		echo "menus=".json_encode(self::load_menus());
	}

	public static function hook_mod_arkeogis_import($hookname, $userdata, $urlmatches) {
		if (\mod\user\Main::userHasRight('Manage personal database') || \mod\user\Main::userHasRight('Manage all databases')) {
			$page = new \mod\webpage\Main();
			$lang=\mod\lang\Main::getCurrentLang();
			$page->smarty->assign('lang', $lang);
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
				$field = array();
				$description = trim($form->getValue('description'));
				if (!empty($description))
					$field['description'] = $description;
				$description_de = trim($form->getValue('description_de'));
				if (!empty($description_de))
					$field['description_de'] = $description_de;
				$declared_modification = trim($form->getValue('declared_modification'));
				if (!empty($declared_modification))
					$field['declared_modification'] = $declared_modification;
				$type = $form->getValue('select_type');
				if (!empty($type))
					$field['type'] = $type;
				$scale_resolution = trim($form->getValue('select_scale_resolution'));
				if (!empty($scale_resolution))
					$field['scale_resolution'] = $scale_resolution;
				$geographical_limit = trim($form->getValue('geographical_limit'));
				if (!empty($geographical_limit))
					$field['geographical_limit'] = $geographical_limit;
				$geographical_limit_de = trim($form->getValue('geographical_limit_de'));
				if (!empty($geographical_limit_de))
					$field['geographical_limit_de'] = $geographical_limit_de;
				if (!empty($issn))
					$field['issn'] = $issn;
				$result =	\mod\arkeogis\DatabaseImport::importCsv($file['tmp_name'], $separator, $enclosure, $skipline, $lang, $field);
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

  public static function hook_mod_arkeogis_export_sheet($hookname, $userdata, $urlmatches) {
    if (!\mod\user\Main::userIsLoggedIn())
			return self::hook_mod_arkeogis_public($hookname, $userdata);

    if (!\mod\user\Main::userBelongsToGroup('Admin') && !\mod\user\Main::userBelongsToGroup('Chercheur'))
      return self::display_html_error(\mod\lang\Main::ch_t('arkeogis', "Vous n'avez pas la permission de télécharger au format csv"));

		$q=json_decode(urldecode($urlmatches[1]), true);
		
		$columns="ark_site.si_id, si_code, si_name, si_description, si_city_name, si_city_code, ST_AsGeoJSON(si_geom) as coords, si_centroid, si_occupation, si_creation, si_modification"; // ark_site
		$columns.=", da_name, da_description, da_creation, da_modification"; // ark_database
		$columns.=", ark_site_period.sp_id, sp_knowledge_type, sp_comment, sp_bibliography"; // ark_site_period
		$columns.=", (SELECT node_path FROM ark_period WHERE pe_id=sp_period_start) AS period_start";
		$columns.=", (SELECT node_path FROM ark_period WHERE pe_id=sp_period_end) AS period_end";

		$res=ArkeoGIS::search_sites($q, $columns, array(
																										'ark_city' => false,
																										'ark_database' => true
																										),
																false, // limit
                                'ark_site.si_id, ark_site_period.sp_id, da_id', // group_by,
                                '',
																'ark_site.si_code, ark_site.si_id, ark_site_period.sp_id', // orderby
                                false, // getcount
                                false  // onlysprange
																);
		
		$strings=ArkeoGIS::load_strings();
		
		header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
		header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); // Date dans le passé
		header("Content-Type: text/csv");
		header("Content-Disposition: attachment; filename=\"export.csv\"");

    $fp = fopen('php://output', 'w');
    fputcsv($fp, array('SITE_ID_SOURCE', 'BASE_SOURCE', 'NOM_SITE', 'NOM_COMMUNE_PRINCIPALE', 'CODE_COMMUNE', 'SYSTEME_PROJECTION', 'LONGITUDE_X ', 'LATITUDE_Y', 'LONGITUDE_X_BIS', 'LATITUDE_Y_BIS', 'ALTITUDE Z', 'CENTRE_COMMUNE', 'ETAT_CONNAISSANCES', 'OCCUPATION', 'DATATION_DEBUT_PLUS_FINE', 'DATATION_FIN_PLUS_FINE', 'IMMO_NIV1', 'IMMO_NIV2', 'IMMO_NIV3', 'IMMO_NIV4', 'IMMO_EXP', 'MOB_NIV1', 'MOB_NIV2', 'MOB_NIV3', 'MOB_NIV4', 'MOB_EXP', 'PROD_NIV1', 'PROD_NIV2', 'PROD_NIV3', 'PROD_EXP', 'PAYS_NIV1', 'PAYS_NIV2', 'PAYS_NIV3', 'PAYS_NIV4', 'PAYS_EXP', 'BIBLIOGRAPHIE', 'REMARQUES'), ";", '"');
		
    $latest_siid=-1;
    $latest_spid=-1;
		foreach($res['sites'] as $row) {
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

	public static function yesno($val) {
		return $val ? \mod\lang\Main::ch_t('arkeogis', 'oui') : \mod\lang\Main::ch_t('arkeogis', 'non');
	}

}
