CREATE TABLE ark_production(pr_id integer PRIMARY KEY, pr_parentid integer, pr_name varchar(100), node_path ltree);
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

INSERT INTO ark_production (pr_id, pr_parentid, pr_name)
	VALUES
	(1, NULL, '"Agricole"'),(2, 1, '"Grenier"'),(3, 1, '"Silo"'),(4, NULL, '"Aménagement hydraulique "'),(5, 4, '"Bains"'),(6, 4, '"Puits"'),(7, NULL, '"Céramique"'),(8, 7, '"Extraction"'),(9, 8, '"Local"'),(10, 8, '"Régional"'),(11, 8, '"Suprarégional"'),(12, 7, '"Atelier"'),(13, 12, '"Local"'),(14, 12, '"Régional"'),(15, 12, '"Suprarégional"'),(16, 12, '"Tuiles"'),(17, NULL, '"Métal"'),(18, 17, '"Extraction"'),(19, 18, '"Fer"'),(20, 18, '"Argent"'),(21, 18, '"Bronze"'),(22, 18, '"Autre"'),(23, 18, '"Local"'),(24, 18, '"Régional"'),(25, 17, '"Forge"'),(26, 25, '"Fer"'),(27, 25, '"Argent"'),(28, 25, '"Bronze"'),(29, 25, '"Autre"'),(30, 25, '"Local"'),(31, 25, '"Régional"'),(32, 17, '"Lingot"'),(33, 32, '"Fer"'),(34, 32, '"Argent"'),(35, 32, '"Bronze"'),(36, 32, '"Autre"'),(37, 32, '"Local"'),(38, 32, '"Régional"'),(39, 17, '"Atelier monétaire"'),(40, 39, '"Fer"'),(41, 40, '"Précision intitulé"'),(42, 39, '"Argent"'),(43, 39, '"Bronze"'),(44, 39, '"Autre"'),(45, 39, '"Local"'),(46, 39, '"Régional"'),(47, NULL, '"Pierre"'),(48, 47, '"Atelier"'),(49, 48, '"Meule"'),(50, 49, '"Correction intitulé"'),(51, 48, '"Architecture"'),(52, 48, '"Silex"'),(53, 47, '"Extraction"'),(54, 53, '"Meule"'),(55, 53, '"Architecture"'),(56, 53, '"Silex"'),(57, 47, '"Chaux"'),(58, NULL, '"Charbon"'),(59, NULL, '"Sel"'),(60, NULL, '"Verre"');