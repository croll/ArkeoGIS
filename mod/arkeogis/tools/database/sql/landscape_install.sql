CREATE TABLE ark_landscape(la_id integer PRIMARY KEY, la_parentid integer, la_name_fr varchar(100), la_name_de varchar(100), la_desc varchar(100), node_path ltree);
CREATE UNIQUE INDEX idx_ark_landscape_node_path_btree_idx ON ark_landscape USING btree(node_path);
CREATE INDEX idx_ark_landscape_node_path_gist_idx ON ark_landscape USING gist(node_path);

CREATE OR REPLACE FUNCTION get_calculated_la_node_path(param_la_id integer)
 RETURNS ltree AS
$$
SELECT CASE WHEN p.la_parentid IS NULL THEN p.la_id::text::ltree
 ELSE get_calculated_la_node_path(p.la_parentid) || p.la_id::text END
  FROM ark_landscape As p
  WHERE p.la_id = $1;
$$
  LANGUAGE sql;

CREATE OR REPLACE FUNCTION trig_update_la_node_path() RETURNS trigger AS
$$
BEGIN
  IF TG_OP = 'UPDATE' THEN
        IF (COALESCE(OLD.la_parentid,0) != COALESCE(NEW.la_parentid,0)  OR  NEW.la_id != OLD.la_id) THEN
            UPDATE ark_landscape SET node_path = get_calculated_la_node_path(la_id) 
                WHERE OLD.node_path  @> ark_landscape.node_path;
        END IF;
  ELSIF TG_OP = 'INSERT' THEN
        UPDATE ark_landscape SET node_path = get_calculated_la_node_path(NEW.la_id) WHERE ark_landscape.la_id = NEW.la_id;
  END IF;
  
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig01_update_la_node_path AFTER INSERT OR UPDATE 
   ON ark_landscape FOR EACH ROW
   EXECUTE PROCEDURE trig_update_la_node_path();

INSERT INTO ark_landscape (la_id, la_parentid, la_name_fr, la_name_de, la_desc )
	VALUES
	(1, NULL, 'Diagnostic négatif', 'Ergebnislose Bohrung', ''),(2, NULL, 'Analyses', 'Analysen', ''),(3, 2, '14C', '14C', ''),(4, 3, 'Non renseigné', 'Nicht dokumentiert', ''),(5, 3, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(6, 3, 'Intrasite', 'In einer Fundstelle', ''),(7, 2, 'Anthracologie', 'Anthrakologie', ''),(8, 7, 'Non renseigné', 'Nicht dokumentiert', ''),(9, 7, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(10, 7, 'Intrasite', 'In einer Fundstelle', ''),(11, 2, 'Anthropologie', 'Anthropologie', ''),(12, 11, 'Non renseigné', 'Nicht dokumentiert', ''),(13, 11, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(14, 11, 'Intrasite', 'In einer Fundstelle', ''),(15, 2, 'Carpologie', 'Karpologie', ''),(16, 15, 'Non renseigné', 'Nicht dokumentiert', ''),(17, 15, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(18, 15, 'Intrasite', 'In einer Fundstelle', ''),(19, 2, 'Dendrochronologie', 'Dendrochronologie', ''),(20, 19, 'Non renseigné', 'Nicht dokumentiert', ''),(21, 19, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(22, 19, 'Intrasite', 'In einer Fundstelle', ''),(23, 2, 'Entomologie', 'Entomologie', ''),(24, 23, 'Non renseigné', 'Nicht dokumentiert', ''),(25, 23, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(26, 23, 'Intrasite', 'In einer Fundstelle', ''),(27, 2, 'Faune', 'Fauna', ''),(28, 27, 'Non renseigné', 'Nicht dokumentiert', ''),(29, 27, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(30, 27, 'Intrasite', 'In einer Fundstelle', ''),(31, 2, 'Malacofaune', 'Malacofauna', ''),(32, 31, 'Non renseigné', 'Nicht dokumentiert', ''),(33, 31, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(34, 31, 'Intrasite', 'In einer Fundstelle', ''),(35, 2, 'Paléomagnetisme', 'Paläomagnetik', ''),(36, 35, 'Non renseigné', 'Nicht dokumentiert', ''),(37, 35, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(38, 35, 'Intrasite', 'In einer Fundstelle', ''),(39, 2, 'Palynologie', 'Palynologie', ''),(40, 39, 'Non renseigné', 'Nicht dokumentiert', ''),(41, 39, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(42, 39, 'Intrasite', 'In einer Fundstelle', ''),(43, 2, 'Percolation des vases', 'Perkolation der Keramik', ''),(44, 43, 'Non renseigné', 'Nicht dokumentiert', ''),(45, 43, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(46, 43, 'Intrasite', 'In einer Fundstelle', ''),(47, 2, 'Phytolithes', 'Phytolithes', ''),(48, 47, 'Non renseigné', 'Nicht dokumentiert', ''),(49, 47, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(50, 47, 'Intrasite', 'In einer Fundstelle', ''),(51, NULL, 'Formation superficielle', 'Boden', ''),(52, 51, 'Analyses', 'Analysen', ''),(53, 52, 'Non renseigné', 'Nicht dokumentiert', ''),(54, 53, 'Non renseigné', 'Nicht dokumentiert', ''),(55, 53, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(56, 53, 'Intrasite', 'In einer Fundstelle', ''),(57, 52, 'Autres', 'Andere', ''),(58, 57, 'Non renseigné', 'Nicht dokumentiert', ''),(59, 57, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(60, 57, 'Intrasite', 'In einer Fundstelle', ''),(61, 52, 'Granulométrie', 'Korngrößenverteilung', ''),(62, 61, 'Non renseigné', 'Nicht dokumentiert', ''),(63, 61, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(64, 61, 'Intrasite', 'In einer Fundstelle', ''),(65, 52, 'Hydrologie', 'Hydrologie', ''),(66, 65, 'Non renseigné', 'Nicht dokumentiert', ''),(67, 65, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(68, 65, 'Intrasite', 'In einer Fundstelle', ''),(69, 52, 'Pédologie', 'Pedologie', ''),(70, 69, 'Non renseigné', 'Nicht dokumentiert', ''),(71, 69, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(72, 69, 'Intrasite', 'In einer Fundstelle', ''),(73, 52, 'Phosphates', 'Phosphaten', ''),(74, 73, 'Non renseigné', 'Nicht dokumentiert', ''),(75, 73, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(76, 73, 'Intrasite', 'In einer Fundstelle', ''),(77, 51, 'Paléochenal daté', 'Datierte Paläofahrrinne', ''),(78, 77, 'Non renseigné', 'Nicht dokumentiert', ''),(79, 77, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(80, 77, 'Intrasite', 'In einer Fundstelle', ''),(81, 51, 'Paléosol', 'Paläoboden', ''),(82, 81, 'Non renseigné', 'Nicht dokumentiert', ''),(83, 81, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(84, 81, 'Intrasite', 'In einer Fundstelle', ''),(85, 51, 'Petrologie', 'Petrologie', ''),(86, 85, 'Non renseigné', 'Nicht dokumentiert', ''),(87, 85, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(88, 85, 'Intrasite', 'In einer Fundstelle', ''),(89, 51, 'Sédimentologie', 'Sedimentologie', ''),(90, 89, 'Non renseigné', 'Nicht dokumentiert', ''),(91, 89, 'Extrasite', 'Ausserhalb einer Fundstelle', ''),(92, 89, 'Intrasite', 'In einer Fundstelle', ''),(93, NULL, 'Structure agraire', 'Agrar', ''),(94, 93, 'Indéterminé', 'Unbestimmt', ''),(95, 93, 'Crêtes de labours_Ackerberg', 'Ackerberg', ''),(96, 93, 'Champ bombé', 'Wölbacker', ''),(97, 93, 'Enclos', 'Schanze', ''),(98, 93, 'Muret', 'Trennmauer', ''),(99, 93, 'Murger_Steinrudel', 'Steinrudel ', ''),(100, 99, 'Non renseigné', 'Nicht dokumentiert', ''),(101, 99, 'Autres', 'Andere', ''),(102, 99, 'Calcaire', 'Kalk', ''),(103, 99, 'Gneiss', 'Gneis', ''),(104, 99, 'Granite', 'Granit', ''),(105, 99, 'Grès', 'Sandstein', ''),(106, 93, 'Parcellaire fossile', 'Altflur', ''),(107, 93, 'Rideau de culture', 'Terrassen Raine', ''),(108, 93, 'Terrasse agricole', 'Ackerterrasse', '');