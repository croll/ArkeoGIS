<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Main {

  public static function hook_mod_arkeogis_index($hookname, $userdata) {
    if (\mod\user\Main::userIsLoggedIn()) {
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

  public static function hook_mod_user_create_post($hookname, $userdata, $uid) {
    \core\Core::$db->query('INSERT INTO "ark_userinfos" ("uid", "structure") VALUES (?, ?)', array((int)$uid, $_REQUEST['structure']));
  }

  public static function hook_mod_user_update_post($hookname, $userdata, $uid) {
    if (\core\Core::$db->fetchOne('SELECT COUNT(*) FROM "ark_userinfos" WHERE "uid" = ?', array((int)$uid)) > 0)
      \core\Core::$db->query('UPDATE "ark_userinfos" SET "structure"=? WHERE "uid"=?', array($_REQUEST['structure'], (int)$uid));
    else
      \core\Core::$db->query('INSERT INTO "ark_userinfos" ("uid", "structure") VALUES (?, ?)', array((int)$uid, $_REQUEST['structure']));
  }

  public static function hook_mod_user_delete_pre($hookname, $userdata, $uid) {
    \core\Core::$db->query('DELETE FROM "ark_userinfos" WHERE "uid"=?', array((int)$uid));
  }

  public static function hook_mod_user_getUserInfos_post($hookname, $userdata, &$user) {
		$result = \core\Core::$db->query('SELECT * FROM "ark_userinfos" WHERE "uid"=?',
																	array((int)$user['uid']));
    $infos=$result->fetchRow();
    $user['mod']['arkeogis'] = $infos;
  }

  public static function hook_mod_arkeogis_directory($hookname, $userdata, $matches) {
    global $lang;
    if (!\mod\user\Main::userIsLoggedIn()) {
    	return false;
		}
    $page = new \mod\webpage\Main();
    $page->setLayout('arkeogis/directory');
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    $page->smarty->assign('lang', $lang);
    $page->display();
	}

	private static function load_menus() {
    $lang=\mod\lang\Main::getCurrentLang();
    $lang=substr($lang, 0, 2);
		$dalang=$lang == 'fr' ? '' : '_'.$lang;

		$menus=array();

		$menus['db']=\core\Core::$db->fetchAll("select da_id as id, null as parentid, da_name as name, da_id as node_path, da_type, da_scale_resolution, da_description$dalang as description, da_geographical_limit$dalang as geographical_limit, da_declared_modification, full_name, da_sites, da_lines, da_issn, (select pe_name_$lang FROM ark_period WHERE pe_id=da_period_start) as period_start, (select pe_name_$lang FROM ark_period WHERE pe_id=da_period_end) as period_end FROM ark_database LEFT JOIN ch_user ON da_owner_id=uid WHERE da_published = true ORDER BY da_type,da_name,id");

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
				$issn = trim($form->getValue('issn'));
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
				if ($file['error']) {
					$errs=array(1=>"The uploaded file exceeds the upload_max_filesize directive in php.ini",
											2=>"The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form",
											3=>"The uploaded file was only partially uploaded",
											4=>"No file was uploaded",
											6=>"Missing a temporary folder.",
											7=>"Failed to write file to disk",
											8=>"A PHP extension stopped the file upload");
					$err=isset($errs[$file['error']]) ? $errs[$file['error']] : $file['error'];
					self::display_html_error(\mod\lang\Main::ch_t('arkeogis', "Une erreur est survenue lors de l'envoi du fichier : ").$err);
					return;
				}
				$result = \mod\arkeogis\DatabaseImport::importCsv($file['tmp_name'], $separator, $enclosure, $skipline, $lang, $field);
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

    if (!\mod\user\Main::userBelongsToGroup('Admin') && !\mod\user\Main::userBelongsToGroup('Chercheur')) {
      return self::display_html_error(\mod\lang\Main::ch_t('arkeogis', "Vous n'avez pas la permission de télécharger au format csv"));
    }

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

                          \mod\arkeogis\ArkeoGIS::sitesToCsv($res['sites']);

    }

	  public static function hook_mod_arkeogis_databases($hookname, $userdata, $matches) {

	    if (!\mod\user\Main::userIsLoggedIn()) {
	    	return false;
	}
	    $page = new \mod\webpage\Main();
	    $page->setLayout('arkeogis/databases');
	    $page->display();
	}

	  public static function mod_arkeogis_get_imported_file($hookname, $userdata, $matches) {
	     $dbId = (int)$matches[1];
	      if (!\mod\user\Main::userIsLoggedIn() || (!\mod\user\Main::userBelongsToGroup('Admin') && !\mod\arkeogis\ArkeoGIS::isDatabaseOwner($dbId, \mod\user\Main::getUserId($_SESSION['login'])) || !$dbId)) {
	        return false;
	     }
	     $file = \mod\arkeogis\ArkeoGIS::getLastImportFile($dbId);
                  $infos = \mod\arkeogis\ArkeoGIS::getFullDatabaseInfos($dbId);
                  $name = str_replace(' ', '_', \core\Tools::removeAccents($infos[0]['name']));
                  $author = str_replace(' ', '_', \core\Tools::removeAccents($infos[0]['author']));
                  $filename = 'ArkeoGIS-'.$infos[0]['modification_str'].'-'.$name.'-'.$author;
	     if (!$file) return false;
	     	header("Cache-Control: no-cache, must-revalidate");
		header("Expires: Sat, 26 Jul 1997 05:00:00 GMT");
		header("Content-Type: text/csv");
		header("Content-Disposition: attachment; filename=\"$filename.csv\"");
    		$fp = fopen('php://output', 'w');
    		echo file_get_contents(dirname(__FILE__).'/files/import/'.$file);
	  }

    public static function hook_mod_arkeogis_export_database($hookname, $userdata, $matches) {
        $dbId = (int)$matches[1];
                      if (!\mod\user\Main::userIsLoggedIn() || (!\mod\user\Main::userBelongsToGroup('Admin') && !\mod\arkeogis\ArkeoGIS::isDatabaseOwner($dbId, \mod\user\Main::getUserId($_SESSION['login'])) || !$dbId)) {
            return false;
         }
            
        $q = "SELECT si_id, si_code, si_name, si_description, si_city_name, si_city_code, ST_AsGeoJSON(si_geom) as coords, si_centroid, si_occupation, si_creation, si_modification"; // ark_site
        $q.=", da_name, da_description, da_creation, da_modification"; // ark_database
        $q.=", sp_id, sp_knowledge_type, sp_comment, sp_bibliography"; // ark_site_period
        $q.=", (SELECT node_path FROM ark_period WHERE pe_id=sp_period_start) AS period_start";
        $q.=", (SELECT node_path FROM ark_period WHERE pe_id=sp_period_end) AS period_end";
        $q.=" FROM ark_site s LEFT JOIN ark_database d ON s.si_database_id = d.da_id LEFT JOIN ark_site_period sp ON s.si_id = sp.sp_site_id";
        $q.=" WHERE da_id = ?";
        $q.=" GROUP BY si_id, sp_id, da_id";
        $q.=" ORDER BY si_code, si_id, sp_id";

        $infos = \mod\arkeogis\ArkeoGIS::getFullDatabaseInfos($dbId);
        $name = str_replace(' ', '_', \core\Tools::removeAccents($infos[0]['name']));
        $author = str_replace(' ', '_', \core\Tools::removeAccents($infos[0]['author']));
        $filename = 'ArkeoGIS-export-'.date("d-m-Y-H-i").'-'.$name.'-'.$author;

        \mod\arkeogis\ArkeoGIS::sitesToCsv(\core\Core::$db->fetchAll($q, array((int)$dbId)), $filename);
    }
}
