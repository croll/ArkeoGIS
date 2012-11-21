#!/usr/bin/php -q
<?php  //  -*- mode:php; tab-width:2; c-basic-offset:2; -*-

namespace tools;

function csvToLtree($filepath, $separator, $charset, $lf, $skipline=NULL) {

	if (!is_file($filepath) || !is_readable($filepath)) {
		throw new \Exception("File does not exist or is not readable");
		return;
	}

	$f = fopen($filepath, "r");
	$lineNumber = 0;
	$currentId = 0;
	$currentParentId = 'NULL';
	$outp = '';
	$level = array();

   while (($line = stream_get_line($f, 4000, $lf))) {
		if ($lineNumber != NULL && $lineNumber <= $skipline) {
			$lineNumber++;
			continue;
		}
		$line=trim($line, "\r\n");
    if (strlen($line) > 3900) throw new \Exception("Line wrap seems to be bad.");
		$lineNumber++;
    if ($charset != 'utf8') $line=iconv($charset, 'utf8', $line);

		foreach(explode($separator, $line) as $k => $v) {
			// Arkeo specific:
			// Separate fr/de/desc
			$data = trim($v, ' "');
			if ($data != '') {
				$os1 = preg_split("/#/", $data);
				$name_fr = (isset($os1[0])) ? trim($os1[0], ' "') : '';
				if (isset($os1[1])) {
					$os2 = preg_split("/¤/", trim($os1[1], ' "'));
					$name_de = (isset($os2[0])) ? trim($os2[0], ' "') : '';
					$desc = (isset($os2[1])) ? trim($os2[1], ' "') : '';
				} else {
					$name_de = $name_fr;
					$desc = '';
				}
				$currentId += 1;
				$level[$k] = $currentId;
				if ($k == 0) {
					$currentParentId = 'NULL';
				} else {
					$os = $k-1;
					$currentParentId = ((isset($level[$os]) ? $level[$os] : $currentId));
				}
				$outp .= "($currentId, $currentParentId, '".$name_fr."', '".$name_de."', '".$desc."'),";
			}
		}
	}

	if (!feof($f)) throw new \Exception("File reading failed somewhere");

	fclose($f);
	return substr($outp, 0, -1);
}

function _readline($prompt = '') {
  echo $prompt;
  return rtrim(fgets(STDIN), "\n");
}

$tableName=strtolower(_readline("Table name which will be created ? "));
if (trim($tableName) == '') {
	echo "No table name defined, exiting.\n";
	exit;
}
$deductedTablePrefix = substr($tableName, 0, 2);
$readTablePrefix=strtolower(_readline("table prefix (default: $deductedTablePrefix) ? "));
$tablePrefix = ($readTablePrefix) ? $readTablePrefix : $deductedTablePrefix;
$fileName=_readline("Name of csv file to parse ? ");
$deductedFilePrefix = 'output';
$readFilePrefix=_readline("Prefix of produced sql files (default is 'output' and will produce output_install.sql and output_uninstall.sql) ");
$filePrefix = ($readFilePrefix) ? $readFilePrefix : $deductedFilePrefix;

try {
	$installContent = csvToLtree($fileName, ';', 'utf8', "\n");
} catch (Exception $e) {
	echo $e->getMessage();
	exit;
}

$install = <<< INSTALL
CREATE TABLE ${tableName}(${tablePrefix}_id integer PRIMARY KEY, ${tablePrefix}_parentid integer, ${tablePrefix}_name_fr varchar(100), ${tablePrefix}_name_de varchar(100), ${tablePrefix}_desc varchar(100), node_path ltree);
CREATE UNIQUE INDEX idx_${tableName}_node_path_btree_idx ON ${tableName} USING btree(node_path);
CREATE INDEX idx_${tableName}_node_path_gist_idx ON ${tableName} USING gist(node_path);

CREATE OR REPLACE FUNCTION get_calculated_${tablePrefix}_node_path(param_${tablePrefix}_id integer)
 RETURNS ltree AS
$$
SELECT CASE WHEN p.${tablePrefix}_parentid IS NULL THEN p.${tablePrefix}_id::text::ltree
 ELSE get_calculated_${tablePrefix}_node_path(p.${tablePrefix}_parentid) || p.${tablePrefix}_id::text END
  FROM ${tableName} As p
  WHERE p.${tablePrefix}_id = $1;
$$
  LANGUAGE sql;

CREATE OR REPLACE FUNCTION trig_update_${tablePrefix}_node_path() RETURNS trigger AS
$$
BEGIN
  IF TG_OP = 'UPDATE' THEN
        IF (COALESCE(OLD.${tablePrefix}_parentid,0) != COALESCE(NEW.${tablePrefix}_parentid,0)  OR  NEW.${tablePrefix}_id != OLD.${tablePrefix}_id) THEN
            UPDATE ${tableName} SET node_path = get_calculated_${tablePrefix}_node_path(${tablePrefix}_id) 
                WHERE OLD.node_path  @> ${tableName}.node_path;
        END IF;
  ELSIF TG_OP = 'INSERT' THEN
        UPDATE ${tableName} SET node_path = get_calculated_${tablePrefix}_node_path(NEW.${tablePrefix}_id) WHERE ${tableName}.${tablePrefix}_id = NEW.${tablePrefix}_id;
  END IF;
  
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig01_update_${tablePrefix}_node_path AFTER INSERT OR UPDATE 
   ON ${tableName} FOR EACH ROW
   EXECUTE PROCEDURE trig_update_${tablePrefix}_node_path();

INSERT INTO ${tableName} (${tablePrefix}_id, ${tablePrefix}_parentid, ${tablePrefix}_name_fr, ${tablePrefix}_name_de, ${tablePrefix}_desc )
	VALUES
	$installContent;
INSTALL;

$uninstall = <<< UNINSTALL
DROP INDEX IF EXISTS "idx_${tableName}_node_path_btree_idx";
DROP INDEX IF EXISTS "idx_${tableName}_node_path_gist_idx";
DROP FUNCTION IF EXISTS get_calculated_${tablePrefix}_node_path(integer);
DROP TRIGGER trig01_update_${tablePrefix}_node_path ON ${tableName};
DROP FUNCTION IF EXISTS trig_update_${tablePrefix}_node_path();
DROP TABLE IF EXISTS "${tableName}";
UNINSTALL;
	
$fpinstall = fopen($filePrefix.'_install.sql', 'w+');
$fpuninstall = fopen($filePrefix.'_uninstall.sql', 'w+');
if ($fpinstall === false)
	die('Unable to write output file');
fputs($fpinstall, $install);
fputs($fpuninstall, $uninstall);
fclose($fpinstall);
fclose($fpuninstall);
