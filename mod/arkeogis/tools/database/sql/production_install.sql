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
	(1, NULL, 'Agricole', 'Landwirtschaft', ''),(2, 1, 'Grenier', 'Speicher', ''),(3, 1, 'Silo', 'Silo', ''),(4, NULL, 'Aménagement hydraulique', 'Wasser', ''),(5, 4, 'Bains', 'Bad', ''),(6, 4, 'Puits', 'Brunnen', ''),(7, NULL, 'Céramique', 'Ton', ''),(8, 7, 'Extraction', 'Abbau', ''),(9, 8, 'Local', 'Lokal', ''),(10, 8, 'Régional', 'Regional', ''),(11, 8, 'Suprarégional', 'Überregional', ''),(12, 7, 'Atelier', 'Töpferei', ''),(13, 12, 'Local', 'Lokal', ''),(14, 12, 'Régional', 'Regional', ''),(15, 12, 'Suprarégional', 'Überregional', ''),(16, 12, 'Tuiles', 'Ziegelei', ''),(17, NULL, 'Métal', 'Metall', ''),(18, 17, 'Extraction', 'Abbau', ''),(19, 18, 'Fer', 'Eisen', ''),(20, 18, 'Argent', 'Silber', ''),(21, 18, 'Bronze', 'Bronze', ''),(22, 18, 'Autres', 'Anderes', ''),(23, 18, 'Local', 'Lokal', ''),(24, 18, 'Régional', 'Regional', ''),(25, 17, 'Forge', 'Schmiede', ''),(26, 25, 'Fer', 'Eisen', ''),(27, 25, 'Argent', 'Silber', ''),(28, 25, 'Bronze', 'Bronze', ''),(29, 25, 'Autres', 'Anderes', ''),(30, 25, 'Local', 'Lokal', ''),(31, 25, 'Régional', 'Regional', ''),(32, 17, 'Lingot', 'Barren', ''),(33, 32, 'Fer', 'Eisen', ''),(34, 32, 'Argent', 'Silber', ''),(35, 32, 'Bronze', 'Bronze', ''),(36, 32, 'Autres', 'Anderes', ''),(37, 32, 'Local', 'Lokal', ''),(38, 32, 'Régional', 'Regional', ''),(39, 17, 'Atelier monétaire', 'Prägestätte', ''),(40, 39, 'Fer', 'Eisen', ''),(41, 39, 'Argent', 'Silber', ''),(42, 39, 'Bronze', 'Bronze', ''),(43, 39, 'Autres', 'Anderes', ''),(44, 39, 'Local', 'Lokal', ''),(45, 39, 'Régional', 'Regional', ''),(46, NULL, 'Pierre', 'Stein', ''),(47, 46, 'Atelier', 'Töpferei', ''),(48, 47, 'Meule', 'Mahlstein', ''),(49, 47, 'Architecture', 'Baustein', ''),(50, 47, 'Silex', 'Feuerstein', ''),(51, 46, 'Extraction', 'Abbau', ''),(52, 51, 'Meule', 'Mahlstein', ''),(53, 51, 'Architecture', 'Baustein', ''),(54, 51, 'Silex', 'Feuerstein', ''),(55, 46, 'Chaux', 'Kalk', ''),(56, NULL, 'Charbon', 'Kohle', ''),(57, NULL, 'Sel', 'Salz', ''),(58, NULL, 'Verre', 'Glas', '');