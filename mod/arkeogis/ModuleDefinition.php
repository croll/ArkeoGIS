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
		\mod\regroute\Main::registerRoute($this->id, '#^/exemple/$#', 'mod_arkeogis_exemple');
		\mod\regroute\Main::registerRoute($this->id, '#^/manuel/([a-z0-9/-_:@\#]+)?$#', 'mod_arkeogis_manuel');
		\mod\regroute\Main::registerRoute($this->id, '#^/directory/$#', 'mod_arkeogis_directory');
		\mod\regroute\Main::registerRoute($this->id, '#^/databases/$#', 'mod_arkeogis_databases');
		\mod\regroute\Main::registerRoute($this->id, '#^/pmmenus$#', 'mod_arkeogis_pmmenus');
		\mod\regroute\Main::registerRoute($this->id, '#^/import/?$#', 'mod_arkeogis_import');
		\mod\regroute\Main::registerRoute($this->id, '#^/import/submit/?$#', 'mod_arkeogis_import_submit');
		\mod\regroute\Main::registerRoute($this->id, '#^/print_sheet$#', 'mod_arkeogis_print_sheet');
		\mod\regroute\Main::registerRoute($this->id, '#^/export_sheet/(.*)$#', 'mod_arkeogis_export_sheet');
		\mod\regroute\Main::registerRoute($this->id, '#^/get_imported_file/(.*)$#', 'mod_arkeogis_get_imported_file');
		/* create ArkeoGIS groups
		Admin (loup+croll staff)
		Chercheur (un chercheur peut upload sa base et exporter)
		Etudiant (il ne peut pas upload une base ni exporter)
		*/
		/* set Rights */
		/*
		\mod\user\Main::addRight("Manage personal database", "User can create , Import , delete and Export it's own personnal database");
		\mod\user\Main::addRight("View databases", "User can view maps and database");
		\mod\user\Main::addRight("Manage all databases", "User can manage all databases (Warning:Restricted to admin group)");

		\mod\user\Main::addGroup('Chercheur', 1);
		\mod\user\Main::renameGroup('Registered', 'Etudiant');
		// assign rights tio groups
		\mod\user\Main::assignRight('View databases', 'Admin');
		\mod\user\Main::assignRight('View databases', 'Chercheur');
		\mod\user\Main::assignRight('View databases', 'Etudiant');
		\mod\user\Main::assignRight('Manage personal database', 'Chercheur');
		\mod\user\Main::assignRight('Manage all databases', 'Admin');
		\mod\user\Main::assignRight('View page', 'Anonymous');
		\mod\user\Main::assignRight('View page', 'Etudiant');
		\mod\user\Main::assignRight('View page', 'Chercheur');
		 */
	}

	function uninstall() {
		/*
		\mod\user\Main::delRight('View databases');
		\mod\user\Main::delRight('Manage personal database');
		\mod\user\Main::delRight('Manage all databases');
		\mod\user\Main::delGroup('Chercheur');
		\mod\user\Main::renameGroup('Etudiant', 'Registered');
		 */
  	\mod\regroute\Main::unregister($this->id);
		parent::uninstall();
	}
}
