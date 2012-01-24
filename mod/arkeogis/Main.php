<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Main {

  public static function hook_mod_arkeogis_init($hookname, $userdata) {
		\mod\user\Main::redirectIfNotLoggedIn();
		$page = new \mod\webpage\Main();
		$page->setLayout('arkeogis/map');
		$page->display();
  }

}
