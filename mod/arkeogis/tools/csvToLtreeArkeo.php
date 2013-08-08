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
				$outp .= "($currentId, $currentParentId, '".pg_escape_string($name_fr)."', '".pg_escape_string($name_de)."', '".pg_escape_string($desc)."'),";
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

$tableName=strtolower(_readline("Table name which will be created ? (don't put the 'ark_' prefix !) "));
if (trim($tableName) == '') {
	echo "No table name defined, exiting.\n";
	exit;
}

$deductedTableKeyPrefix = substr($tableName, 0, 2);
$deductedTableNamePrefix = 'ark_';

$readTableKeyPrefix=strtolower(_readline("table key prefix (default: $deductedTableKeyPrefix) ? "));
$tableKeyPrefix = ($readTableKeyPrefix) ? $readTableKeyPrefix : $deductedTableKeyPrefix;
$tableSitePeriodKeyPrefix = 's'.substr($tableKeyPrefix, 0, 1);

$readTableNamePrefix=strtolower(_readline("table name prefix (default: $deductedTableNamePrefix) ? "));
$tableNamePrefix = ($readTableNamePrefix) ? $readTableNamePrefix : $deductedTableNamePrefix;

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
CREATE TABLE ${tableNamePrefix}${tableName}(${tableKeyPrefix}_id integer PRIMARY KEY, ${tableKeyPrefix}_parentid integer, ${tableKeyPrefix}_name_fr varchar(100), ${tableKeyPrefix}_name_de varchar(100), ${tableKeyPrefix}_desc varchar(100), node_path ltree);
CREATE UNIQUE INDEX idx_${tableNamePrefix}${tableName}_node_path_btree_idx ON ${tableNamePrefix}${tableName} USING btree(node_path);
CREATE INDEX idx_${tableNamePrefix}${tableName}_node_path_gist_idx ON ${tableNamePrefix}${tableName} USING gist(node_path);

CREATE OR REPLACE FUNCTION get_calculated_${tableKeyPrefix}_node_path(param_${tableKeyPrefix}_id integer)
 RETURNS ltree AS
$$
SELECT CASE WHEN p.${tableKeyPrefix}_parentid IS NULL THEN p.${tableKeyPrefix}_id::text::ltree
 ELSE get_calculated_${tableKeyPrefix}_node_path(p.${tableKeyPrefix}_parentid) || p.${tableKeyPrefix}_id::text END
  FROM ${tableNamePrefix}${tableName} As p
  WHERE p.${tableKeyPrefix}_id = $1;
$$
  LANGUAGE sql;

CREATE OR REPLACE FUNCTION trig_update_${tableKeyPrefix}_node_path() RETURNS trigger AS
$$
BEGIN
  IF TG_OP = 'UPDATE' THEN
        IF (COALESCE(OLD.${tableKeyPrefix}_parentid,0) != COALESCE(NEW.${tableKeyPrefix}_parentid,0)  OR  NEW.${tableKeyPrefix}_id != OLD.${tableKeyPrefix}_id) THEN
            UPDATE ${tableNamePrefix}${tableName} SET node_path = get_calculated_${tableKeyPrefix}_node_path(${tableKeyPrefix}_id) 
                WHERE OLD.node_path  @> ${tableNamePrefix}${tableName}.node_path;
        END IF;
  ELSIF TG_OP = 'INSERT' THEN
        UPDATE ${tableNamePrefix}${tableName} SET node_path = get_calculated_${tableKeyPrefix}_node_path(NEW.${tableKeyPrefix}_id) WHERE ${tableNamePrefix}${tableName}.${tableKeyPrefix}_id = NEW.${tableKeyPrefix}_id;
  END IF;
  
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig01_update_${tableKeyPrefix}_node_path AFTER INSERT OR UPDATE 
   ON ${tableNamePrefix}${tableName} FOR EACH ROW
   EXECUTE PROCEDURE trig_update_${tableKeyPrefix}_node_path();

INSERT INTO ${tableNamePrefix}${tableName} (${tableKeyPrefix}_id, ${tableKeyPrefix}_parentid, ${tableKeyPrefix}_name_fr, ${tableKeyPrefix}_name_de, ${tableKeyPrefix}_desc )
	VALUES
	$installContent;

ALTER TABLE ONLY ${tableNamePrefix}siteperiod_${tableName}
    ADD CONSTRAINT ${tableNamePrefix}siteperiod_${tableName}_${tableSitePeriodKeyPrefix}_${tableName}_id_fkey FOREIGN KEY (${tableSitePeriodKeyPrefix}_${tableName}_id) REFERENCES ${tableNamePrefix}${tableName}(${tableKeyPrefix}_id) ON DELETE CASCADE;



INSTALL;

$uninstall = <<< UNINSTALL
ALTER TABLE ONLY ${tableNamePrefix}siteperiod_${tableName} DROP CONSTRAINT ${tableNamePrefix}siteperiod_${tableName}_${tableSitePeriodKeyPrefix}_${tableName}_id_fkey;
DROP INDEX IF EXISTS "idx_${tableNamePrefix}${tableName}_node_path_btree_idx";
DROP INDEX IF EXISTS "idx_${tableNamePrefix}${tableName}_node_path_gist_idx";
DROP FUNCTION IF EXISTS get_calculated_${tableKeyPrefix}_node_path(integer);
DROP TRIGGER trig01_update_${tableKeyPrefix}_node_path ON ${tableNamePrefix}${tableName};
DROP FUNCTION IF EXISTS trig_update_${tableKeyPrefix}_node_path();
DROP TABLE IF EXISTS "${tableNamePrefix}${tableName}";
UNINSTALL;
	
$fpinstall = fopen($filePrefix.'_install.sql', 'w+');
$fpuninstall = fopen($filePrefix.'_uninstall.sql', 'w+');
if ($fpinstall === false)
	die('Unable to write output file');
fputs($fpinstall, $install);
fputs($fpuninstall, $uninstall);
fclose($fpinstall);
fclose($fpuninstall);
