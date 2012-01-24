<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ModuleDefinition extends \core\ModuleDefinition {

	function __construct() {
		$this->description = 'ArkeoGIS Application';
		$this->name = 'arkeogis';
		$this->version = '1.0';
		$this->dependencies = array('ajax', 'cssjs', 'regroute', 'smarty', 'webpage', 'field', 'user', 'map');
		parent::__construct();
	}

	function install() {
		parent::install();
		\mod\regroute\Main::registerRoute($this->id, '#^/$#', 'mod_arkeogis_init');
	}

	function uninstall() {
    \mod\regroute\Main::unregister($this->id);
		parent::uninstall();
	}
}
