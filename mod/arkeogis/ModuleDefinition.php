<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ModuleDefinition extends \core\ModuleDefinition {

	function __construct() {
		$this->description = 'ArkeoGIS Application';
		$this->name = 'arkeogis';
		$this->version = '1.0';
		$this->dependencies = array('ajax', 'cssjs', 'regroute', 'smarty', 'webpage', 'user', 'map', 'form');
		parent::__construct();
	}

	function install() {
		parent::install();
		\mod\regroute\Main::registerRoute($this->id, '#^/$#', 'mod_arkeogis_index');
		\mod\regroute\Main::registerRoute($this->id, '#^/pmmenus$#', 'mod_arkeogis_pmmenus');
		\mod\regroute\Main::registerRoute($this->id, '#^/import/?$#', 'mod_arkeogis_import');
		\mod\regroute\Main::registerRoute($this->id, '#^/import/submit/?$#', 'mod_arkeogis_import_submit');
	}

	function uninstall() {
    \mod\regroute\Main::unregister($this->id);
		parent::uninstall();
	}
}
