<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace mod\arkeogis;

class Ajax {

	public static function periodlist() {
		return \core\Core::$db->fetchAll("select pe_id as id, pe_parentid as parentid, pe_name as name, node_path from ark_period order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
	}
	public static function productionlist() {
		return \core\Core::$db->fetchAll("select pr_id as id, pr_parentid as parentid, pr_name as name, node_path from ark_production order by cast(string_to_array(ltree2text(node_path),'.') as integer[])");
	}
}
