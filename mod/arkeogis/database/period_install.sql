CREATE TABLE ark_period(pe_id integer PRIMARY KEY, pe_parentid integer, pe_name varchar(100), node_path ltree);
CREATE UNIQUE INDEX idx_ark_period_node_path_btree_idx ON ark_period USING btree(node_path);
CREATE INDEX idx_ark_period_node_path_gist_idx ON ark_period USING gist(node_path);

CREATE OR REPLACE FUNCTION get_calculated_pe_node_path(param_pe_id integer)
 RETURNS ltree AS
$$
SELECT CASE WHEN p.pe_parentid IS NULL THEN p.pe_id::text::ltree
 ELSE get_calculated_pe_node_path(p.pe_parentid) || p.pe_id::text END
  FROM ark_period As p
  WHERE p.pe_id = $1;
$$
  LANGUAGE sql;

CREATE OR REPLACE FUNCTION trig_update_pe_node_path() RETURNS trigger AS
$$
BEGIN
  IF TG_OP = 'UPDATE' THEN
        IF (COALESCE(OLD.pe_parentid,0) != COALESCE(NEW.pe_parentid,0)  OR  NEW.pe_id != OLD.pe_id) THEN
            UPDATE ark_period SET node_path = get_calculated_pe_node_path(pe_id) 
                WHERE OLD.node_path  @> ark_period.node_path;
        END IF;
  ELSIF TG_OP = 'INSERT' THEN
        UPDATE ark_period SET node_path = get_calculated_pe_node_path(NEW.pe_id) WHERE ark_period.pe_id = NEW.pe_id;
  END IF;
  
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig01_update_pe_node_path AFTER INSERT OR UPDATE 
   ON ark_period FOR EACH ROW
   EXECUTE PROCEDURE trig_update_pe_node_path();

INSERT INTO ark_period (pe_id, pe_parentid, pe_name)
	VALUES
	(1, NULL, 'Indéterminé'),(2, NULL, 'Néolithique'),(3, NULL, 'Age du Bronze'),(4, 3, 'Bronze Indéterminé (1800 -800 av.JC)'),(5, 3, 'Bronze ancien ( BRA 1800 -1500 av.JC)'),(6, 5, 'BRA1'),(7, 6, 'BRA1a'),(8, 6, 'BRA1b'),(9, 5, 'BRA2'),(10, 9, 'BRA2a'),(11, 9, 'BRA2b'),(12, 5, 'BRA3'),(13, 12, 'BRA3a'),(14, 12, 'BRA3b'),(15, 3, 'Bronze moyen (BRM 1501 –1200 av.JC)'),(16, 15, 'BRM1'),(17, 16, 'BRM1a'),(18, 16, 'BRM1b'),(19, 15, 'BRM2'),(20, 19, 'BRM2a'),(21, 19, 'BRM2b'),(22, 15, 'BRM3'),(23, 22, 'BRM3a'),(24, 22, 'BRM3b'),(25, 3, 'Bronze final (BRF 1201 –800 av.JC)'),(26, 25, 'BRF1 (1201 –1050 av.JC)'),(27, 26, 'BRF1a'),(28, 26, 'BRF1b'),(29, 25, 'BRF2 (1051 –900 av.JC)'),(30, 29, 'BRF2a'),(31, 29, 'BRF2b'),(32, 25, 'BRF3'),(33, 32, 'BRF3a'),(34, 32, 'BRF3b'),(35, 25, 'BRF3/HAC1'),(36, NULL, 'Age du Fer'),(37, 36, 'Fer indéterminé (801 -25 av.JC)'),(38, 37, 'Hallstatt indéterminé (801 -460 av.JC)'),(39, 36, 'Hallstatt C'),(40, 39, 'HAC1'),(41, 40, 'HAC1a'),(42, 40, 'HAC1b-c'),(43, 39, 'HAC2'),(44, 43, 'HAC2a'),(45, 43, 'HAC2b'),(46, 39, 'HAC2/HAD1'),(47, 36, 'Hallstatt D (HAD 621 –460 av.JC)'),(48, 47, 'HAD1 (621 –530 av.JC)'),(49, 48, 'HAD1a'),(50, 48, 'HAD1b'),(51, 47, 'HAD2 (531 –500 av.JC)'),(52, 51, 'HAD2a'),(53, 51, 'HAD2b'),(54, 47, 'HAD3 (501 –460 av.JC)'),(55, 54, 'HAD3a'),(56, 54, 'HAD3b'),(57, 47, 'HAD3/LTA1'),(58, 36, 'La Tène indéterminée (461 -25 av.JC)'),(59, 36, 'La Tène A (LTA 461 -400 av.JC)'),(60, 59, 'LTA1'),(61, 60, 'LTA1a'),(62, 60, 'LTA1b'),(63, 59, 'LTA2'),(64, 63, 'LTA2a'),(65, 63, 'LTA2b'),(66, 36, 'La Tène B (LTB 401 -260 av.JC)'),(67, 66, 'LTB1 (401 -321 av.JC)'),(68, 67, 'LTB1a'),(69, 67, 'LTB1b'),(70, 66, 'LTB2 (321 -260 av.JC)'),(71, 70, 'LTB2a'),(72, 70, 'LTB2b'),(73, 36, 'La Tène C (LTC 261 -140 av.JC)'),(74, 73, 'LTC1 (261 -200 av.JC)'),(75, 74, 'LTC1a'),(76, 74, 'LTC1b'),(77, 73, 'LTC2 (201 -140 av.JC)'),(78, 77, 'LTC2a'),(79, 77, 'LTC2b'),(80, 73, 'LTC2/LTD1'),(81, 36, 'La Tène D (LTD 141 -25 av.JC)'),(82, 81, 'LTD1 (141 -70 av.JC)'),(83, 82, 'LTD1a'),(84, 82, 'LTD1b'),(85, 81, 'LTD2 (71 -25 av.JC)'),(86, 85, 'LTD2a'),(87, 85, 'LTD2b'),(88, NULL, 'Gallo-Romain'),(89, 88, 'Gallo-Romain Indéterminé'),(90, 88, 'Période augustéenne'),(91, 90, '-40  +20  (ap.JC)'),(92, 88, 'Haut Empire'),(93, 92, '+21 +100'),(94, 92, '+101 +250'),(95, 88, 'Antiquité tardive'),(96, 95, '+251 +310'),(97, 95, 'IVe siècle'),(98, 95, 'Ve siècle'),(99, 88, 'Grandes  invasions /'),(100, NULL, 'Mérovingien'),(101, 100, 'Mérovingien Indéterminé'),(102, 100, 'Mérovingien ancien (+451 +600)'),(103, 102, 'Mérovingien ancien I'),(104, 102, 'Mérovingien récent II'),(105, 102, 'Mérovingien récent III'),(106, 100, 'Othonien'),(107, NULL, 'Moyen-âge'),(108, 107, 'Moyen-âge Indéterminé'),(109, 108, 'Moyen-âge I'),(110, 108, 'Moyen-âge II');