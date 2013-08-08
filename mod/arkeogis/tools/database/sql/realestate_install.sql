CREATE TABLE ark_realestate(re_id integer PRIMARY KEY, re_parentid integer, re_name_fr varchar(100), re_name_de varchar(100), re_desc varchar(100), node_path ltree);
CREATE UNIQUE INDEX idx_ark_realestate_node_path_btree_idx ON ark_realestate USING btree(node_path);
CREATE INDEX idx_ark_realestate_node_path_gist_idx ON ark_realestate USING gist(node_path);

CREATE OR REPLACE FUNCTION get_calculated_re_node_path(param_re_id integer)
 RETURNS ltree AS
$$
SELECT CASE WHEN p.re_parentid IS NULL THEN p.re_id::text::ltree
 ELSE get_calculated_re_node_path(p.re_parentid) || p.re_id::text END
  FROM ark_realestate As p
  WHERE p.re_id = $1;
$$
  LANGUAGE sql;

CREATE OR REPLACE FUNCTION trig_update_re_node_path() RETURNS trigger AS
$$
BEGIN
  IF TG_OP = 'UPDATE' THEN
        IF (COALESCE(OLD.re_parentid,0) != COALESCE(NEW.re_parentid,0)  OR  NEW.re_id != OLD.re_id) THEN
            UPDATE ark_realestate SET node_path = get_calculated_re_node_path(re_id) 
                WHERE OLD.node_path  @> ark_realestate.node_path;
        END IF;
  ELSIF TG_OP = 'INSERT' THEN
        UPDATE ark_realestate SET node_path = get_calculated_re_node_path(NEW.re_id) WHERE ark_realestate.re_id = NEW.re_id;
  END IF;
  
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig01_update_re_node_path AFTER INSERT OR UPDATE 
   ON ark_realestate FOR EACH ROW
   EXECUTE PROCEDURE trig_update_re_node_path();

INSERT INTO ark_realestate (re_id, re_parentid, re_name_fr, re_name_de, re_desc )
	VALUES
	(1, NULL, 'Habitat', 'Siedlung', ''),(2, 1, 'Non renseigné', 'Nicht dokumentiert', ''),(3, 2, 'Indéterminé', 'Unbestimmt', ''),(4, 2, 'Enclos', 'Schanze', ''),(5, 2, 'Ouvert', 'Unbefestigt', ''),(6, 1, 'Groupé', 'Dicht', ''),(7, 6, 'Indéterminé', 'Unbestimmt', ''),(8, 6, 'Enclos', 'Schanze', ''),(9, 6, 'Ouvert', 'Unbefestigt', ''),(10, 1, 'Isolé', 'Alleinstehend', ''),(11, 10, 'Indéterminé', 'Unbestimmt', ''),(12, 10, 'Enclos', 'Schanze', ''),(13, 10, 'Ouvert', 'Unbefestigt', ''),(14, NULL, 'Enceinte', 'Befestigung', ''),(15, 14, 'Mur', 'Mauer', ''),(16, 15, 'Enclos', 'Schanze', ''),(17, 14, 'Fossé', 'Graben', ''),(18, 17, 'Enclos', 'Schanze', ''),(19, 14, 'Fossé et Talus', 'Graben und böschung', ''),(20, 19, 'Enclos', 'Schanze', ''),(21, NULL, 'Funéraire', 'Gräber', ''),(22, 21, 'Non renseigné', 'Nicht dokumentiert', ''),(23, 22, 'Non renseigné', 'Nicht dokumentiert', ''),(24, 23, 'Tombe plate', 'Flachgrab', ''),(25, 23, 'Tumulus', 'Tumulus', ''),(26, 23, 'Enclos Funéraire', 'Grabbezirk', ''),(27, 22, 'Tombe isolée', 'Einzelner Grab', ''),(28, 27, 'Tombe plate', 'Flachgrab', ''),(29, 27, 'Tumulus', 'Tumulus', ''),(30, 27, 'Enclos Funéraire', 'Grabbezirk', ''),(31, 22, 'Nécropole', 'Gräberfeld', ''),(32, 31, 'Tombe plate', 'Flachgrab', ''),(33, 31, 'Tumulus', 'Tumulus', ''),(34, 31, 'Enclos Funéraire', 'Grabbezirk', ''),(35, 21, 'Inhumation', 'Leichengrab', ''),(36, 35, 'Non renseigné', 'Nicht dokumentiert', ''),(37, 36, 'Tombe plate', 'Flachgrab', ''),(38, 36, 'Tumulus', 'Tumulus', ''),(39, 36, 'Enclos Funéraire', 'Grabbezirk', ''),(40, 35, 'Tombe isolée', 'Einzelner Grab', ''),(41, 40, 'Tombe plate', 'Flachgrab', ''),(42, 40, 'Tumulus', 'Tumulus', ''),(43, 40, 'Enclos Funéraire', 'Grabbezirk', ''),(44, 35, 'Nécropole', 'Gräberfeld', ''),(45, 44, 'Tombe plate', 'Flachgrab', ''),(46, 44, 'Tumulus', 'Tumulus', ''),(47, 44, 'Enclos Funéraire', 'Grabbezirk', ''),(48, 21, 'Incinération', 'Brandgrab', ''),(49, 48, 'Non renseigné', 'Nicht dokumentiert', ''),(50, 49, 'Tombe plate', 'Flachgrab', ''),(51, 49, 'Tumulus', 'Tumulus', ''),(52, 49, 'Enclos Funéraire', 'Grabbezirk', ''),(53, 48, 'Tombe isolée', 'Einzelner Grab', ''),(54, 53, 'Tombe plate', 'Flachgrab', ''),(55, 53, 'Tumulus', 'Tumulus', ''),(56, 53, 'Enclos Funéraire', 'Grabbezirk', ''),(57, 48, 'Nécropole', 'Gräberfeld', ''),(58, 57, 'Tombe plate', 'Flachgrab', ''),(59, 57, 'Tumulus', 'Tumulus', ''),(60, 57, 'Enclos Funéraire', 'Grabbezirk', ''),(61, 21, 'Les deux', 'Beides', ''),(62, 61, 'Non renseigné', 'Nicht dokumentiert', ''),(63, 62, 'Tombe plate', 'Flachgrab', ''),(64, 62, 'Tumulus', 'Tumulus', ''),(65, 62, 'Enclos Funéraire', 'Grabbezirk', ''),(66, 61, 'Tombe isolée', 'Einzelner Grab', ''),(67, 66, 'Tombe plate', 'Flachgrab', ''),(68, 66, 'Tumulus', 'Tumulus', ''),(69, 66, 'Enclos Funéraire', 'Grabbezirk', ''),(70, 61, 'Nécropole', 'Gräberfeld', ''),(71, 70, 'Tombe plate', 'Flachgrab', ''),(72, 70, 'Tumulus', 'Tumulus', ''),(73, 70, 'Enclos Funéraire', 'Grabbezirk', ''),(74, NULL, 'Indéterminé', 'Unbestimmt', ''),(75, 74, 'Autres', 'Anderes', ''),(76, 74, 'Fosse', 'Grube', ''),(77, 76, 'Fente néolithique', 'Schlitzgrube', ''),(78, 74, 'Fossé', 'Graben', ''),(79, NULL, 'Rituel', 'Kult', ''),(80, 79, 'Autres', 'Anderes', ''),(81, 80, 'Cours d''eau', 'Wasserlauf', ''),(82, 80, 'Grotte', 'Höhle', ''),(83, 80, 'Source', 'Quelle', ''),(84, 79, 'Edifice religieux', 'Kultgebäude', ''),(85, 84, 'Cours d''eau', 'Wasserlauf', ''),(86, 84, 'Grotte', 'Höhle', ''),(87, 84, 'Source', 'Quelle', ''),(88, NULL, 'Circulation', 'Verkehr', ''),(89, 88, 'Gué', 'Furth', ''),(90, 88, 'Pont', 'Brücke', ''),(91, 88, 'Voie', 'Wege', ''),(92, 91, 'Pente aménagée', 'Steige', ''),(93, 88, 'Quai', 'Kai', ''),(94, NULL, 'Dépôt', 'Hort', ''),(95, 94, 'Monnaies', 'Münzen', ''),(96, 94, 'Métal', 'Metall', ''),(97, 94, 'Non métallique', 'Nicht Metall', ''),(98, NULL, 'Aménagement hydraulique', 'Wasser', ''),(99, 98, 'Autres', 'Anderes', ''),(100, 98, 'Bains', 'Bad', ''),(101, 98, 'Canalisation', 'Kanalisierung', ''),(102, 98, 'Puits', 'Brunnen', '');

ALTER TABLE ONLY ark_siteperiod_realestate
    ADD CONSTRAINT ark_siteperiod_realestate_sr_realestate_id_fkey FOREIGN KEY (sr_realestate_id) REFERENCES ark_realestate(re_id) ON DELETE CASCADE;


