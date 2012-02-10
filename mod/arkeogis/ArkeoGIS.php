<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class ArkeoGIS {

	public static function deleteSite($code) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=?', array($code));
	}

	public static function getPeriodFromLabel($label) {
		$res = \core\Core::$db->exec('SELECT * FROM "ark_period" WHERE pe_code=?', array($label));
		print_r($res);
	}

}
