CREATE TABLE ark_furniture(fu_id integer PRIMARY KEY, fu_parentid integer, fu_name_fr varchar(100), fu_name_de varchar(100), fu_desc varchar(100), node_path ltree);
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

INSERT INTO ark_furniture (fu_id, fu_parentid, fu_name_fr, fu_name_de, fu_desc )
	VALUES
	(1, NULL, 'Céramique', 'Keramik', ''),(2, 1, 'Indéterminé', 'Unbestimmt', ''),(3, 1, 'Conteneur', 'Behälter', ''),(4, 3, 'Amphore', 'Amphore', ''),(5, 4, 'Dressel 1a', 'Dressel 1a', ''),(6, 4, 'Dressel 1b', 'Dressel 1b', ''),(7, 3, 'Dolium', 'Dolium', ''),(8, 3, 'Autres', 'Anderes', ''),(9, 1, 'Fine', 'Feinkeramik', ''),(10, 9, 'Import', 'Importware', ''),(11, 10, 'Cannelée', 'kanneliert', ''),(12, 10, 'Graphitée', 'Graphitton', ''),(13, 10, 'Excisée', 'Geritzt', ''),(14, 10, 'Céramique polychrome Br- Ha', 'Polychrome Alb-Hegau-Salem', ''),(15, 10, 'Tène balustre', 'Stark profilierter Latènestil', ''),(16, 10, 'Molette tardive', 'Spätantike Rädchenverzierung', ''),(17, 10, 'Arétine', 'Arretina', ''),(18, 10, 'Sigillée', 'Terra sigilata', ''),(19, 10, 'Peignée', 'Kammstrich', ''),(20, 10, 'Campanienne', 'Campanienne', ''),(21, 10, 'Pot Besançon', 'Pot Besançon', ''),(22, 9, 'Locale', 'Lokale Ware', ''),(23, 22, 'Cannelée', 'kanneliert', ''),(24, 22, 'Graphitée', 'Graphitton', ''),(25, 22, 'Excisée', 'Geritzt', ''),(26, 22, 'Céramique polychrome Br- Ha', 'PolychromeAlb-Hegau-Salem', ''),(27, 22, 'Tène balustre', 'Stark profilierter Latènestil', ''),(28, 22, 'Molette tardive', 'Spätantike Rädchenverzierung', ''),(29, 22, 'Arétine', 'Arretina', ''),(30, 22, 'Sigillée', 'Terra sigilata', ''),(31, 22, 'Peignée', 'Kammstrich', ''),(32, 22, 'Campanienne', 'Campanienne', ''),(33, 22, 'Pot Besançon', 'Pot Besançon', ''),(34, 9, 'Les deux', 'Beide', ''),(35, 34, 'Cannelée', 'kanneliert', ''),(36, 34, 'Graphitée', 'Graphitton', ''),(37, 34, 'Excisée', 'Geritzt', ''),(38, 34, 'Céramique polychrome Br- Ha', 'PolychromeAlb-Hegau-Salem', ''),(39, 34, 'Tène balustre', 'Stark profilierter Latènestil', ''),(40, 34, 'Molette tardive', 'Spätantike Rädchenverzierung', ''),(41, 34, 'Arétine', 'Arretina', ''),(42, 34, 'Sigillée', 'Terra sigilata', ''),(43, 34, 'Peignée', 'Kammstrich', ''),(44, 34, 'Campanienne', 'Campanienne', ''),(45, 34, 'Pot Besançon', 'Pot Besançon', ''),(46, 1, 'Tuile', 'Ziegel', ''),(47, 46, 'Inscription', 'Inschrift', ''),(48, 1, 'Brique', 'Baustein', ''),(49, 48, 'Inscription', 'Inschrift', ''),(50, NULL, 'Métal', 'Metall', ''),(51, 50, 'Armement', 'Waffen Rüstungen', ''),(52, 51, 'Epée', 'Schwert', ''),(53, 51, 'Lance', 'Lance', ''),(54, 51, 'Casque', 'Helm', ''),(55, 50, 'Harnachement', 'Pferdegeschirr', ''),(56, 55, 'Char', 'Wagen', ''),(57, 50, 'Parure', 'Tracht', ''),(58, 57, 'Fibule', 'Fibel', ''),(59, 58, 'Fibule S4', 'Schlangenfibel S4', ''),(60, 58, 'Fibule S5', 'Schlangenfibel S5', ''),(61, 58, 'Fibule P1', 'Paukenfibel PW', ''),(62, 57, 'Plaques de ceinture Hallstattienne', 'Gürtelblech', ''),(63, 57, 'Parure annulaire', 'Ring', ''),(64, 57, 'Epingle vasiforme', 'Vasenkopfnadel', ''),(65, 57, 'Plaque boucle', 'Gürtelschnalle', ''),(66, 50, 'Outils', 'Werkzeuge', ''),(67, 66, 'Faucille', 'Sichel', ''),(68, 66, 'Marteau', 'Hammer', ''),(69, 66, 'Hache', 'Axt', ''),(70, 66, 'Couteau', 'Messer', ''),(71, 50, 'Autres', 'Anderes', ''),(72, 71, 'Verre', 'Glas', ''),(73, NULL, 'Monnaies', 'Münzen', ''),(74, 73, 'Or', 'Gold', ''),(75, 74, 'Sanglier', 'Potin au Sanglier', ''),(76, 74, 'Grosse tête', 'Potin à la grosse tête', ''),(77, 74, 'Kaletedu', 'Kaletedu-Quinar', ''),(78, 74, 'Boïenne', 'Boïenne', ''),(79, 74, 'Denier', 'Denare', ''),(80, 74, 'Sesterce', 'Sesterz', ''),(81, 74, 'Bas empire', 'Spätantike', ''),(82, 73, 'Argent', 'Silber', ''),(83, 82, 'Sanglier', 'Potin au Sanglier', ''),(84, 82, 'Grosse tête', 'Potin à la grosse tête', ''),(85, 82, 'Kaletedu', 'Kaletedu-Quinar', ''),(86, 82, 'Boïenne', 'Boïenne', ''),(87, 82, 'Denier', 'Denare', ''),(88, 82, 'Sesterce', 'Sesterz', ''),(89, 82, 'Bas empire', 'Spätantike', ''),(90, 73, 'Bronze', 'Bronze', ''),(91, 90, 'Sanglier', 'Potin au Sanglier', ''),(92, 90, 'Grosse tête', 'Potin à la grosse tête', ''),(93, 90, 'Kaletedu', 'Kaletedu-Quinar', ''),(94, 90, 'Boïenne', 'Boïenne', ''),(95, 90, 'Denier', 'Denare', ''),(96, 90, 'Sesterce', 'Sesterz', ''),(97, 90, 'Bas empire', 'Spätantike', ''),(98, 73, 'Potin', 'Potinmûnze', ''),(99, 98, 'Sanglier', 'Potin au Sanglier', ''),(100, 98, 'Grosse tête', 'Potin à la grosse tête', ''),(101, 98, 'Kaletedu', 'Kaletedu-Quinar', ''),(102, 98, 'Boïenne', 'Boïenne', ''),(103, 98, 'Denier', 'Denare', ''),(104, 98, 'Sesterce', 'Sesterz', ''),(105, 98, 'Bas empire', 'Spätantike', ''),(106, NULL, 'Lithique', 'Stein', ''),(107, 106, 'Silex', 'Feuerstein', ''),(108, 106, 'Meule', 'Mahlstein', '');