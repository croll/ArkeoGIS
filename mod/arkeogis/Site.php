<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Site {

	public static function delete($code) {
		\core\Core::$db->exec('DELETE FROM "ark_site" WHERE si_code=?', array($code));
	}

}
