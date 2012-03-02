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
			$page->smarty->assign('lang', $lang);
			$page->setLayout('arkeogis/public');
			$page->display();
  }

  public static function hook_mod_arkeogis_pmmenus($hookname, $userdata) {
		\mod\user\Main::redirectIfNotLoggedIn();
	
    $lang=\mod\lang\Main::getCurrentLang();
    $lang=substr($lang, 0, 2);

		$menus=array();
		
		$menus['db']=\core\Core::$db->fetchAll("select da_id as id, null as parentid, da_name as name, da_id as node_path from ark_database order by id");
		
		$menus['period']=\core\Core::$db->fetchAll("select pe_id as id, pe_parentid as parentid, pe_name_$lang as name, node_path from ark_period order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['production']=\core\Core::$db->fetchAll("select pr_id as id, pr_parentid as parentid, pr_name_$lang as name, node_path from ark_production order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['realestate']=\core\Core::$db->fetchAll("select re_id as id, re_parentid as parentid, re_name_$lang as name, node_path from ark_realestate order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
		
		$menus['furniture']=\core\Core::$db->fetchAll("select fu_id as id, fu_parentid as parentid, fu_name_$lang as name, node_path from ark_furniture order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");

		echo "menus=";
		echo json_encode($menus);
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

}
