CREATE TABLE ark_furniture(fu_id integer PRIMARY KEY, fu_parentid integer, fu_name varchar(100), node_path ltree);
CREATE UNIQUE INDEX idx_ark_furniture_node_path_btree_idx ON ark_furniture USING btree(node_path);
CREATE INDEX idx_ark_furniture_node_path_gist_idx ON ark_furniture USING gist(node_path);

CREATE OR REPLACE FUNCTION get_calculated_fu_node_path(param_fu_id integer)
 RETURNS ltree AS
$$
SELECT CASE WHEN p.fu_parentid IS NULL THEN p.fu_id::text::ltree
 ELSE get_calculated_fu_node_path(p.fu_parentid) || p.fu_id::text END
  FROM ark_furniture As p
  WHERE p.fu_id = $1;
$$
  LANGUAGE sql;

CREATE OR REPLACE FUNCTION trig_update_fu_node_path() RETURNS trigger AS
$$
BEGIN
  IF TG_OP = 'UPDATE' THEN
        IF (COALESCE(OLD.fu_parentid,0) != COALESCE(NEW.fu_parentid,0)  OR  NEW.fu_id != OLD.fu_id) THEN
            UPDATE ark_furniture SET node_path = get_calculated_fu_node_path(fu_id) 
                WHERE OLD.node_path  @> ark_furniture.node_path;
        END IF;
  ELSIF TG_OP = 'INSERT' THEN
        UPDATE ark_furniture SET node_path = get_calculated_fu_node_path(NEW.fu_id) WHERE ark_furniture.fu_id = NEW.fu_id;
  END IF;
  
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig01_update_fu_node_path AFTER INSERT OR UPDATE 
   ON ark_furniture FOR EACH ROW
   EXECUTE PROCEDURE trig_update_fu_node_path();

INSERT INTO ark_furniture (fu_id, fu_parentid, fu_name)
	VALUES
	(1, NULL, 'Céramique'),(2, 1, 'Indéterminé'),(3, 1, 'Conteneur'),(4, 3, 'Amphore'),(5, 4, 'Dressel 1a'),(6, 4, 'Dressel 1b'),(7, 3, 'Dolium'),(8, 3, 'Autres'),(9, 1, 'Fine'),(10, 9, 'Import'),(11, 10, 'Cannelée'),(12, 10, 'Graphitée'),(13, 10, 'Excisée'),(14, 10, 'Céramique polychrome Br- Ha'),(15, 10, 'Alb-Hegau'),(16, 10, 'Tène balustre'),(17, 10, 'Molette tardive'),(18, 10, 'Arétine'),(19, 10, 'Sigillée'),(20, 10, 'Peignée'),(21, 10, 'Campanienne'),(22, 10, 'Pot Besançon'),(23, 9, 'Locale'),(24, 23, 'Cannelée'),(25, 23, 'Graphitée'),(26, 23, 'Excisée'),(27, 23, 'Céramique polychrome Br- Ha'),(28, 23, 'Alb-Hegau'),(29, 23, 'Tène balustre'),(30, 23, 'Molette tardive'),(31, 23, 'Arétine'),(32, 23, 'Sigillée'),(33, 23, 'Peignée'),(34, 23, 'Campanienne'),(35, 23, 'Pot Besançon'),(36, 9, 'Les deux'),(37, 36, 'Cannelée'),(38, 36, 'Graphitée'),(39, 36, 'Excisée'),(40, 36, 'Céramique polychrome Br- Ha'),(41, 36, 'Alb-Hegau'),(42, 36, 'Tène balustre'),(43, 36, 'Molette tardive'),(44, 36, 'Arétine'),(45, 36, 'Sigillée'),(46, 36, 'Peignée'),(47, 36, 'Campanienne'),(48, 36, 'Pot Besançon'),(49, 1, 'Tuile'),(50, 49, 'Inscription'),(51, 1, 'Brique'),(52, 51, 'Inscription'),(53, NULL, 'Métal'),(54, 53, 'Armement'),(55, 54, 'Epée'),(56, 54, 'Lance'),(57, 54, 'Casque'),(58, 53, 'Harnachement'),(59, 58, 'Char'),(60, 53, 'Parure'),(61, 60, 'Fibule'),(62, 61, 'Fibule S4'),(63, 61, 'Fibule S5'),(64, 61, 'Fibule P1'),(65, 60, 'Plaques de ceinture Hallstattienne'),(66, 60, 'Parure annulaire'),(67, 60, 'Epingle vasiforme'),(68, 60, 'Plaque boucle'),(69, 53, 'Outils'),(70, 69, 'Faucille'),(71, 69, 'Marteau'),(72, 69, 'Hache'),(73, 69, 'Couteau'),(74, 53, 'Autres'),(75, 74, 'Verre'),(76, NULL, 'Monnaies'),(77, 76, 'Or'),(78, 77, 'Sanglier'),(79, 77, 'Grosse tête'),(80, 77, 'Kaletu'),(81, 77, 'Boyenne'),(82, 77, 'Denier'),(83, 77, 'Sesterce'),(84, 77, 'Bas empire'),(85, 76, 'Argent'),(86, 85, 'Sanglier'),(87, 85, 'Grosse tête'),(88, 85, 'Kaletu'),(89, 85, 'Boyenne'),(90, 85, 'Denier'),(91, 85, 'Sesterce'),(92, 85, 'Bas empire'),(93, 76, 'Bronze'),(94, 93, 'Sanglier'),(95, 93, 'Grosse tête'),(96, 93, 'Kaletu'),(97, 93, 'Boyenne'),(98, 93, 'Denier'),(99, 93, 'Sesterce'),(100, 93, 'Bas empire'),(101, 76, 'Potin'),(102, 101, 'Sanglier'),(103, 101, 'Grosse tête'),(104, 101, 'Kaletu'),(105, 101, 'Boyenne'),(106, 101, 'Denier'),(107, 101, 'Sesterce'),(108, 101, 'Bas empire'),(109, NULL, 'Lithique'),(110, 109, 'Silex'),(111, 109, 'Meule');
