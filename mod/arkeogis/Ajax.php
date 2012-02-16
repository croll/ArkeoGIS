<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Ajax {

	public static function periodlist() {
		return \core\Core::$db->fetchAll("select * from ark_period order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
	}
}
