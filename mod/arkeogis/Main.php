<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Main {

  public static function hook_mod_arkeogis_index($hookname, $userdata) {
    if (\mod\user\Main::userIsLoggedIn()) {;
      $page = new \mod\webpage\Main();
      // get lang
      $lang=\mod\lang\Main::getCurrentLang();
      $page->smarty->assign('lang', $lang);
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
    if ($lang == 'de_DE') {
	$present = \mod\page\Main::getPageBySysname('startseite');
    } else if ($lang == 'fr_FR') {
	$present = \mod\page\Main::getPageBySysname('accueil');
    }
    $page->smarty->assign('lang', $lang);
    $page->smarty->assign('present', $present);
    $page->setLayout('arkeogis/public');
    $page->display();
  }
  public static function hook_mod_arkeogis_exemple($hookname, $userdata) {
    // get lang
    $page = new \mod\webpage\Main();
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    if ($lang == 'de_DE') {
	$present = \mod\page\Main::getPageBySysname('startseite');
    } else if ($lang == 'fr_FR') {
	$present = \mod\page\Main::getPageBySysname('accueil');
    }
    $page->smarty->assign('lang', $lang);
    $page->smarty->assign('present', $present);
    $page->setLayout('arkeogis/exemple');
    $page->display();
  }
  public static function hook_mod_arkeogis_manuel($hookname, $userdata) {
    // get lang
    $page = new \mod\webpage\Main();
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    if ($lang == 'de_DE') {
	$present = \mod\page\Main::getPageBySysname('startseite');
    } else if ($lang == 'fr_FR') {
	$present = \mod\page\Main::getPageBySysname('accueil');
    }
    $page->smarty->assign('lang', $lang);
    $page->smarty->assign('present', $present);
    $page->setLayout('arkeogis/manuel');
    $page->display();
  }
  public static function hook_mod_arkeogis_directory($hookname, $userdata) {
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
    $list = $db->fetchAll("SELECT * from ch_user u, ark_database d where u.uid > ?", array(1));
    $quant=$db->fetchOne("SELECT count(u.uid) as quant from ch_user u where uid > ? ", array(1));
    $page = new \mod\webpage\Main();
    // get lang
    $lang=\mod\lang\Main::getCurrentLang();
    $page->smarty->assign('lang', $lang);
    //var_dump($list);
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

  public static function hook_mod_arkeogis_init($hookname, $userdata) {
		\mod\user\Main::redirectIfNotLoggedIn();
		$page = new \mod\webpage\Main();
		$page->setLayout('arkeogis/map');
		$image = new \Imagick();    // Create a new instance an $image class

		$width =  100;        // Some necessary dimensions
		$height = 100; 
		$image->newImage( $width, $height, 'black' );

		$draw = new \ImagickDraw();    //Create a new drawing class (?)

		$draw->setFillColor('yellow');    // Set up some colors to use for fill and outline
		$draw->setStrokeColor('green');

		$draw->rectangle( 5, 5, 40, 40 );    // Draw the circle already 
		//$draw->setStrokeColor('red');
		//$draw->setStrokeDashArray(array(5,5,5));
		
		$draw->scale(2,2);
		$draw->skewX(45);

		$image->drawImage( $draw );    // Apply the stuff from the draw class to the image canvas
		$image->setImageFormat('png');    // Give the image a format
		$image->writeImage(dirname(__FILE__).'/test.png');    // ...Or just write it to a file...
		

		// render
		$page->smarty->assign('image', '/mod/arkeogis/test.png');
		$page->display();

  }

	public static function hook_mod_arkeogis_import($hookname, $userdata, $urlmatches) {
		$page = new \mod\webpage\Main();
		$page->setLayout('arkeogis/import');
		$page->display();
	}

	public static function hook_mod_arkeogis_import_submit($hookname, $userdata, $urlmatches) {
		$params = array('mod' => 'arkeogis', 'file' => 'templates/dbUpload.json');
		$form = new \mod\form\Form($params);
		if ($form->validate()) {
			$separator = $form->getValue('separator');
			$enclosure = $form->getValue('enclosure');
			$file = $form->getValue('dbfile');
			$skipline = $form->getValue('skipline');
			$lang = $form->getValue('select_lang');
			$result =	\mod\arkeogis\DatabaseImport::importCsv($file['tmp_name'], $separator, $enclosure, $skipline, $lang);
			unlink($file['tmp_name']);
			$page = new \mod\webpage\Main();
			$page->smarty->assign("result", $result);
		}
		$page->setLayout('arkeogis/import');
		$page->display();
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

		$q=json_decode($_REQUEST['q'], true);
		
		$columns="si_name, ";
		$columns.="(SELECT node_path FROM ark_period WHERE pe_id=min(sp_period_start)) AS period_start, ";
		$columns.="(SELECT node_path FROM ark_period WHERE pe_id=max(sp_period_end)) AS period_end, ";
		$columns.="array_agg((SELECT node_path FROM ark_realestate WHERE re_id=sr_realestate_id)) as realestate, ";
		$columns.="array_agg((SELECT node_path FROM ark_furniture WHERE fu_id=sf_furniture_id)) as furniture, ";
		$columns.="array_agg((SELECT node_path FROM ark_production WHERE pr_id=sp_production_id)) as production";
		
		$res=ArkeoGIS::search_sites($q, $columns, array(
																										'ark_siteperiod_production' => true,
																										'ark_siteperiod_furniture' => true,
																										'ark_siteperiod_realestate' => true
																										));
		
		$strings=ArkeoGIS::load_strings();
		
		header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
		header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); // Date dans le passé
		header("Content-Type: text");
		header("Content-Disposition: attachment; filename=\"export.csv\"");
		
		printf("\"%s\"\t\"%s\"\t\"%s\"\t\"%s\"\t\"%s\"\t\"%s\"\n",
					 'site name',
					 'period start',
					 'period end',
					 'realestate',
					 'furniture',
					 'production');
		
		foreach($res as $row) {
			printf("\"%s\"\t\"%s\"\t\"%s\"\t\"%s\"\t\"%s\"\t\"%s\"\n",
						 $row['si_name'],
						 ArkeoGIS::node_path_to_str($row['period_start'], $strings['period'], '/'),
						 ArkeoGIS::node_path_to_str($row['period_end'], $strings['period'], '/'),
						 implode(ArkeoGIS::node_path_array_to_str($row['realestate'], $strings['realestate'], '/'), ';'),
						 implode(ArkeoGIS::node_path_array_to_str($row['furniture'], $strings['furniture'], '/'), ';'),
						 implode(ArkeoGIS::node_path_array_to_str($row['production'], $strings['production'], '/'), ';')
						 );
		}
		    
  }

	

}
