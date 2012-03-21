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
	(1, NULL, 'Agricole', 'Landwirtschaft', ''),(2, 1, 'Grenier', 'Speicher', ''),(3, 1, 'Silo', 'Silo', ''),(4, NULL, 'Aménagement hydraulique', 'Wasser', ''),(5, 4, 'Bains', 'Bad', ''),(6, 4, 'Canalisation', 'Kanalisierung', ''),(7, 4, 'Puits', 'Brunnen', ''),(8, NULL, 'Céramique', 'Ton', ''),(9, 8, 'Extraction', 'Abbau', ''),(10, 9, 'Local', 'Lokal', ''),(11, 9, 'Régional', 'Regional', ''),(12, 9, 'Suprarégional', 'Überregional', ''),(13, 8, 'Atelier', 'Töpferei', ''),(14, 13, 'Local', 'Lokal', ''),(15, 13, 'Régional', 'Regional', ''),(16, 13, 'Suprarégional', 'Überregional', ''),(17, 13, 'Tuiles', 'Ziegelei', ''),(18, NULL, 'Métal', 'Metall', ''),(19, 18, 'Extraction', 'Abbau', ''),(20, 19, 'Fer', 'Eisen', ''),(21, 19, 'Argent', 'Silber', ''),(22, 19, 'Bronze', 'Bronze', ''),(23, 19, 'Autres', 'Anderes', ''),(24, 19, 'Local', 'Lokal', ''),(25, 19, 'Régional', 'Regional', ''),(26, 18, 'Forge', 'Schmiede', ''),(27, 26, 'Fer', 'Eisen', ''),(28, 26, 'Argent', 'Silber', ''),(29, 26, 'Bronze', 'Bronze', ''),(30, 26, 'Autres', 'Anderes', ''),(31, 26, 'Local', 'Lokal', ''),(32, 26, 'Régional', 'Regional', ''),(33, 18, 'Lingot', 'Barren', ''),(34, 33, 'Fer', 'Eisen', ''),(35, 33, 'Argent', 'Silber', ''),(36, 33, 'Bronze', 'Bronze', ''),(37, 33, 'Autres', 'Anderes', ''),(38, 33, 'Local', 'Lokal', ''),(39, 33, 'Régional', 'Regional', ''),(40, 18, 'Atelier monétaire', 'Prägestätte', ''),(41, 40, 'Fer', 'Eisen', ''),(42, 40, 'Argent', 'Silber', ''),(43, 40, 'Bronze', 'Bronze', ''),(44, 40, 'Autres', 'Anderes', ''),(45, 40, 'Local', 'Lokal', ''),(46, 40, 'Régional', 'Regional', ''),(47, NULL, 'Pierre', 'Stein', ''),(48, 47, 'Atelier', 'Töpferei', ''),(49, 48, 'Meule', 'Mahlstein', ''),(50, 48, 'Architecture', 'Baustein', ''),(51, 48, 'Silex', 'Feuerstein', ''),(52, 47, 'Extraction', 'Abbau', ''),(53, 52, 'Meule', 'Mahlstein', ''),(54, 52, 'Architecture', 'Baustein', ''),(55, 52, 'Silex', 'Feuerstein', ''),(56, 47, 'Chaux', 'Kalk', ''),(57, NULL, 'Charbon', 'Kohle', ''),(58, NULL, 'Sel', 'Salz', ''),(59, NULL, 'Verre', 'Glas', '');