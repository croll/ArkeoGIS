CREATE TABLE ark_production(pr_id integer PRIMARY KEY, pr_parentid integer, pr_name_fr varchar(100), pr_name_de varchar(100), pr_desc varchar(100), node_path ltree);
CREATE UNIQUE INDEX idx_ark_production_node_path_btree_idx ON ark_production USING btree(node_path);
CREATE INDEX idx_ark_production_node_path_gist_idx ON ark_production USING gist(node_path);

CREATE OR REPLACE FUNCTION get_calculated_pr_node_path(param_pr_id integer)
 RETURNS ltree AS
$$
SELECT CASE WHEN p.pr_parentid IS NULL THEN p.pr_id::text::ltree
 ELSE get_calculated_pr_node_path(p.pr_parentid) || p.pr_id::text END
  FROM ark_production As p
  WHERE p.pr_id = $1;
$$
  LANGUAGE sql;

CREATE OR REPLACE FUNCTION trig_update_pr_node_path() RETURNS trigger AS
$$
BEGIN
  IF TG_OP = 'UPDATE' THEN
        IF (COALESCE(OLD.pr_parentid,0) != COALESCE(NEW.pr_parentid,0)  OR  NEW.pr_id != OLD.pr_id) THEN
            UPDATE ark_production SET node_path = get_calculated_pr_node_path(pr_id) 
                WHERE OLD.node_path  @> ark_production.node_path;
        END IF;
  ELSIF TG_OP = 'INSERT' THEN
        UPDATE ark_production SET node_path = get_calculated_pr_node_path(NEW.pr_id) WHERE ark_production.pr_id = NEW.pr_id;
  END IF;
  
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig01_update_pr_node_path AFTER INSERT OR UPDATE 
   ON ark_production FOR EACH ROW
   EXECUTE PROCEDURE trig_update_pr_node_path();

INSERT INTO ark_production (pr_id, pr_parentid, pr_name_fr, pr_name_de, pr_desc )
	VALUES
	(1, NULL, 'Agricole', 'Landwirtschaft', ''),(2, 1, 'Grenier', 'Speicher', ''),(3, 1, 'Silo', 'Silo', ''),(4, NULL, 'Céramique', 'Ton', ''),(5, 4, 'Extraction', 'Abbau', ''),(6, 4, 'Atelier', 'Töpferei', ''),(7, 6, 'Local', 'Lokal', ''),(8, 6, 'Régional', 'Regional', ''),(9, 6, 'Suprarégional', 'Überregional', ''),(10, 4, 'Atelier de TCA', 'Ziegelei', ''),(11, 10, 'Local', 'Lokal', ''),(12, 10, 'Régional', 'Regional', ''),(13, 10, 'Suprarégional', 'Überregional', ''),(14, NULL, 'Métal', 'Metall', ''),(15, 14, 'Extraction', 'Abbau', ''),(16, 15, 'Fer', 'Eisen', ''),(17, 16, 'Local', 'Lokal', ''),(18, 16, 'Régional', 'Regional', ''),(19, 15, 'Argent', 'Silber', ''),(20, 19, 'Local', 'Lokal', ''),(21, 19, 'Régional', 'Regional', ''),(22, 15, 'Bronze', 'Bronze', ''),(23, 22, 'Local', 'Lokal', ''),(24, 22, 'Régional', 'Regional', ''),(25, 15, 'Or', 'Gold', ''),(26, 25, 'Local', 'Lokal', ''),(27, 25, 'Régional', 'Regional', ''),(28, 15, 'Cuivre', 'Kupfer', ''),(29, 28, 'Local', 'Lokal', ''),(30, 28, 'Régional', 'Regional', ''),(31, 15, 'Autres', 'Anderes', ''),(32, 31, 'Local', 'Lokal', ''),(33, 31, 'Régional', 'Regional', ''),(34, 14, 'Réduction', 'Reduzierung', ''),(35, 34, 'Fer', 'Eisen', ''),(36, 35, 'Local', 'Lokal', ''),(37, 35, 'Régional', 'Regional', ''),(38, 34, 'Argent', 'Silber', ''),(39, 38, 'Local', 'Lokal', ''),(40, 38, 'Régional', 'Regional', ''),(41, 34, 'Bronze', 'Bronze', ''),(42, 41, 'Local', 'Lokal', ''),(43, 41, 'Régional', 'Regional', ''),(44, 34, 'Or', 'Gold', ''),(45, 44, 'Local', 'Lokal', ''),(46, 44, 'Régional', 'Regional', ''),(47, 34, 'Cuivre', 'Kupfer', ''),(48, 47, 'Local', 'Lokal', ''),(49, 47, 'Régional', 'Regional', ''),(50, 34, 'Autres', 'Anderes', ''),(51, 50, 'Local', 'Lokal', ''),(52, 50, 'Régional', 'Regional', ''),(53, 14, 'Forge', 'Schmiede', ''),(54, 53, 'Fer', 'Eisen', ''),(55, 54, 'Local', 'Lokal', ''),(56, 54, 'Régional', 'Regional', ''),(57, 53, 'Argent', 'Silber', ''),(58, 57, 'Local', 'Lokal', ''),(59, 57, 'Régional', 'Regional', ''),(60, 53, 'Bronze', 'Bronze', ''),(61, 60, 'Local', 'Lokal', ''),(62, 60, 'Régional', 'Regional', ''),(63, 53, 'Or', 'Gold', ''),(64, 63, 'Local', 'Lokal', ''),(65, 63, 'Régional', 'Regional', ''),(66, 53, 'Cuivre', 'Kupfer', ''),(67, 66, 'Local', 'Lokal', ''),(68, 66, 'Régional', 'Regional', ''),(69, 53, 'Autres', 'Anderes', ''),(70, 69, 'Local', 'Lokal', ''),(71, 69, 'Régional', 'Regional', ''),(72, 14, 'Atelier monétaire', 'Prägestätte', ''),(73, 72, 'Fer', 'Eisen', ''),(74, 73, 'Local', 'Lokal', ''),(75, 73, 'Régional', 'Regional', ''),(76, 72, 'Argent', 'Silber', ''),(77, 76, 'Local', 'Lokal', ''),(78, 76, 'Régional', 'Regional', ''),(79, 72, 'Bronze', 'Bronze', ''),(80, 79, 'Local', 'Lokal', ''),(81, 79, 'Régional', 'Regional', ''),(82, 72, 'Or', 'Gold', ''),(83, 82, 'Local', 'Lokal', ''),(84, 82, 'Régional', 'Regional', ''),(85, 72, 'Cuivre', 'Kupfer', ''),(86, 85, 'Local', 'Lokal', ''),(87, 85, 'Régional', 'Regional', ''),(88, 72, 'Autres', 'Anderes', ''),(89, 88, 'Local', 'Lokal', ''),(90, 88, 'Régional', 'Regional', ''),(91, NULL, 'Pierre', 'Stein', ''),(92, 91, 'Atelier', 'Steinmetz', ''),(93, 92, 'Meule', 'Mahlstein', ''),(94, 93, 'Grès', 'Sandstein', ''),(95, 93, 'Calcaire', 'Kalkstein', ''),(96, 93, 'Basalte', 'Basalt', ''),(97, 93, 'Rhyolite', 'Rhyolith', ''),(98, 93, 'Silex', 'Silex', ''),(99, 93, 'Autres', 'Anderes', ''),(100, 92, 'Architecture', 'Baustein', ''),(101, 100, 'Grès', 'Sandstein', ''),(102, 100, 'Calcaire', 'Kalkstein', ''),(103, 100, 'Basalte', 'Basalt', ''),(104, 100, 'Rhyolite', 'Rhyolith', ''),(105, 100, 'Silex', 'Silex', ''),(106, 100, 'Autres', 'Anderes', ''),(107, 92, 'Outils', 'Werkzeug', ''),(108, 107, 'Grès', 'Sandstein', ''),(109, 107, 'Calcaire', 'Kalkstein', ''),(110, 107, 'Basalte', 'Basalt', ''),(111, 107, 'Rhyolite', 'Rhyolith', ''),(112, 107, 'Silex', 'Silex', ''),(113, 107, 'Autres', 'Anderes', ''),(114, 91, 'Extraction', 'Abbau', ''),(115, 114, 'Meule', 'Mahlstein', ''),(116, 115, 'Grès', 'Sandstein', ''),(117, 115, 'Calcaire', 'Kalkstein', ''),(118, 115, 'Basalte', 'Basalt', ''),(119, 115, 'Rhyolite', 'Rhyolith', ''),(120, 115, 'Silex', 'Silex', ''),(121, 115, 'Autres', 'Anderes', ''),(122, 114, 'Architecture', 'Baustein', ''),(123, 122, 'Grès', 'Sandstein', ''),(124, 122, 'Calcaire', 'Kalkstein', ''),(125, 122, 'Basalte', 'Basalt', ''),(126, 122, 'Rhyolite', 'Rhyolith', ''),(127, 122, 'Silex', 'Silex', ''),(128, 122, 'Autres', 'Anderes', ''),(129, 114, 'Outils', 'Werkzeug', ''),(130, 129, 'Grès', 'Sandstein', ''),(131, 129, 'Calcaire', 'Kalkstein', ''),(132, 129, 'Basalte', 'Basalt', ''),(133, 129, 'Rhyolite', 'Rhyolith', ''),(134, 129, 'Silex', 'Silex', ''),(135, 129, 'Autres', 'Anderes', ''),(136, 91, 'Non renseigné', 'Nicht dokumentiert', ''),(137, 136, 'Meule', 'Mahlstein', ''),(138, 137, 'Grès', 'Sandstein', ''),(139, 137, 'Calcaire', 'Kalkstein', ''),(140, 137, 'Basalte', 'Basalt', ''),(141, 137, 'Rhyolite', 'Rhyolith', ''),(142, 137, 'Silex', 'Silex', ''),(143, 137, 'Autres', 'Anderes', ''),(144, 136, 'Architecture', 'Baustein', ''),(145, 144, 'Grès', 'Sandstein', ''),(146, 144, 'Calcaire', 'Kalkstein', ''),(147, 144, 'Basalte', 'Basalt', ''),(148, 144, 'Rhyolite', 'Rhyolith', ''),(149, 144, 'Silex', 'Silex', ''),(150, 144, 'Autres', 'Anderes', ''),(151, 136, 'Outils', 'Werkzeug', ''),(152, 151, 'Grès', 'Sandstein', ''),(153, 151, 'Calcaire', 'Kalkstein', ''),(154, 151, 'Basalte', 'Basalt', ''),(155, 151, 'Rhyolite', 'Rhyolith', ''),(156, 151, 'Silex', 'Silex', ''),(157, 151, 'Autres', 'Anderes', ''),(158, 91, 'Chaux', 'Kalk', ''),(159, NULL, 'Charbon', 'Kohle', ''),(160, NULL, 'Sel', 'Salz', ''),(161, NULL, 'Verre', 'Glas', ''),(162, NULL, 'Autres', 'Anderes', '');

ALTER TABLE ONLY ark_siteperiod_production
    ADD CONSTRAINT ark_siteperiod_production_sp_production_id_fkey FOREIGN KEY (sp_production_id) REFERENCES ark_production(pr_id) ON DELETE CASCADE;


