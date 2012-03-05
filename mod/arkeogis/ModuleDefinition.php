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
		\mod\regroute\Main::registerRoute($this->id, '#^/public$#', 'mod_arkeogis_public');
		\mod\regroute\Main::registerRoute($this->id, '#^/directory$#', 'mod_arkeogis_directory');
		\mod\regroute\Main::registerRoute($this->id, '#^/pmmenus$#', 'mod_arkeogis_pmmenus');
		\mod\regroute\Main::registerRoute($this->id, '#^/import/?$#', 'mod_arkeogis_import');
		\mod\regroute\Main::registerRoute($this->id, '#^/import/submit/?$#', 'mod_arkeogis_import_submit');
		/* create ArkeoGIS groups 
		Admin (loup+croll staff) 
		Chercheur (un chercheur peut upload sa base et exporter)
		Etudiant (il ne peut pas upload une base ni exporter)
		*/
		\mod\user\Main::addGroup('Chercheur', 1);
		\mod\user\Main::renameGroup('Registered', 'Etudiant');
			
	}

	function uninstall() {
		\mod\user\Main::delGroup('Chercheur');
		\mod\user\Main::renameGroup('Etudiant', 'Registered');
    		\mod\regroute\Main::unregister($this->id);
		parent::uninstall();
	}
}
