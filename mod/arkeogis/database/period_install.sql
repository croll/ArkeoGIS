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
	(1, NULL, 'Indéterminé'),(2, NULL, 'Néolithique'),(3, NULL, 'Age du Bronze'),(4, 3, 'Bronze Indéterminé (1800 – 800 av.JC)'),(5, 3, 'Bronze ancien (BRA 1800 – 1500 av.JC)'),(6, 5, 'BRA1'),(7, 6, 'BRA1a'),(8, 6, 'BRA1b'),(9, 5, 'BRA2'),(10, 9, 'BRA2a'),(11, 9, 'BRA2b'),(12, 5, 'BRA3'),(13, 12, 'BRA3a'),(14, 12, 'BRA3b'),(15, 3, 'Bronze moyen (BRM 1501 – 1200 av.JC)'),(16, 15, 'BRM1'),(17, 16, 'BRM1a'),(18, 16, 'BRM1b'),(19, 15, 'BRM2'),(20, 19, 'BRM2a'),(21, 19, 'BRM2b'),(22, 15, 'BRM3'),(23, 22, 'BRM3a'),(24, 22, 'BRM3b'),(25, 3, 'Bronze final (BRF 1201 – 800 av.JC)'),(26, 25, 'BRF1 (1201 – 1050 av.JC)'),(27, 26, 'BRF1a'),(28, 26, 'BRF1b'),(29, 25, 'BRF2 (1051 – 900 av.JC)'),(30, 29, 'BRF2a'),(31, 29, 'BRF2b'),(32, 25, 'BRF3'),(33, 32, 'BRF3a'),(34, 32, 'BRF3b'),(35, 25, 'BRF3/HAC1'),(36, NULL, 'Age du Fer'),(37, 36, 'Fer indéterminé (801 – 25 av.JC)'),(38, 36, 'Hallstatt indéterminé (801 – 460 av.JC)'),(39, 36, 'Hallstatt C (HAC 801 –620 av.JC)'),(40, 39, 'BRF3/HAC1'),(41, 39, 'HAC1'),(42, 41, 'HAC1a'),(43, 41, 'HAC1b-c'),(44, 39, 'HAC2'),(45, 44, 'HAC2a'),(46, 44, 'HAC2b'),(47, 39, 'HAC2/HAD1'),(48, 36, 'Hallstatt D (HAD 621 – 460 av.JC)'),(49, 48, 'HAC2/HAD1'),(50, 48, 'HAD1 (621 – 530 av.JC)'),(51, 50, 'HAD1a'),(52, 50, 'HAD1b'),(53, 48, 'HAD2 (531 – 500 av.JC)'),(54, 53, 'HAD2a'),(55, 53, 'HAD2b'),(56, 48, 'HAD3 (501 – 460 av.JC)'),(57, 56, 'HAD3a'),(58, 56, 'HAD3b'),(59, 48, 'HAD3/LTA1'),(60, 36, 'La Tène indéterminée (461 – 25 av.JC)'),(61, 36, 'La Tène A (LTA 461 – 400 av.JC)'),(62, 61, 'HAD3/LTA1'),(63, 61, 'LTA1'),(64, 63, 'LTA1a'),(65, 63, 'LTA1b'),(66, 61, 'LTA2'),(67, 66, 'LTA2a'),(68, 66, 'LTA2b'),(69, 36, 'La Tène B (LTB 401 – 260 av.JC)'),(70, 69, 'LTB1 (401 – 321 av.JC)'),(71, 70, 'LTB1a'),(72, 70, 'LTB1b'),(73, 69, 'LTB2 (321 – 260 av.JC)'),(74, 73, 'LTB2a'),(75, 73, 'LTB2b'),(76, 36, 'La Tène C (LTC 261 – 140 av.JC)'),(77, 76, 'LTC1 (261 – 200 av.JC)'),(78, 77, 'LTC1a'),(79, 77, 'LTC1b'),(80, 76, 'LTC2 (201 – 140 av.JC)'),(81, 80, 'LTC2a'),(82, 80, 'LTC2b'),(83, 76, 'LTC2/LTD1'),(84, 36, 'La Tène D (LTD 141 – 25 av.JC)'),(85, 84, 'LTC2/LTD1'),(86, 84, 'LTD1 (141 – 70 av.JC)'),(87, 86, 'LTD1a'),(88, 86, 'LTD1b'),(89, 84, 'LTD2 (71 – 25 av.JC)'),(90, 89, 'LTD2a'),(91, 89, 'LTD2b'),(92, NULL, 'Gallo-Romain'),(93, 92, 'Gallo-Romain Indéterminé'),(94, 92, 'Période augustéenne'),(95, 94, '-40  +20 (ap.JC)'),(96, 92, 'Haut Empire'),(97, 96, '+21 +100 (ap.JC)'),(98, 96, '+101 +250 (ap.JC)'),(99, 92, 'Antiquité tardive'),(100, 99, '+251 +310 (ap.JC)'),(101, 99, 'IVe siècle'),(102, 99, 'Ve siècle'),(103, 92, 'Grandes  invasions'),(104, NULL, 'Mérovingien'),(105, 104, 'Grandes  invasions'),(106, 104, 'Mérovingien Indéterminé (+451+720 ap.JC)'),(107, 104, 'Mérovingien ancien (+451 +600 ap.JC)'),(108, 107, 'Mérovingien ancien I (+451 +520 ap.JC)'),(109, 107, 'Mérovingien ancien II (+521 +550 ap.JC)'),(110, 107, 'Mérovingien ancient III (+551+600 ap.JC)'),(111, 104, 'Mérovingien récent (+601 +720 ap.JC)'),(112, 111, 'Mérovingien récent I (601-630 ap.JC)'),(113, 111, 'Mérovingien récent II  (631-680 ap.JC)'),(114, 111, 'Mérovingien récent III  (681-720 ap.JC)'),(115, 104, 'Othonien (+721 +800 ap.JC)'),(116, NULL, 'Moyen-âge'),(117, 116, 'Moyen-âge Indéterminé'),(118, 116, 'Moyen-âge I'),(119, 116, 'Moyen-âge II');