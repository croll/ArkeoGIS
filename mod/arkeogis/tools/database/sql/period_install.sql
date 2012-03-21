CREATE TABLE ark_period(pe_id integer PRIMARY KEY, pe_parentid integer, pe_name_fr varchar(100), pe_name_de varchar(100), pe_desc varchar(100), node_path ltree);
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

INSERT INTO ark_period (pe_id, pe_parentid, pe_name_fr, pe_name_de, pe_desc )
	VALUES
	(1, NULL, 'Indéterminé', 'Unbestimmt', ''),(2, NULL, 'Néolithique', 'Neolithikum', ''),(3, NULL, 'Age du Bronze', 'Bronzezeit', ''),(4, 3, 'Bronze Indéterminé', 'Bronzezeit Unbestimmt', '(-1800 -801 av.JC)'),(5, 3, 'Bronze ancien', 'Frühbronzezeit', '(BRA -1800  -1501 av.JC)'),(6, 5, 'BRA1', 'BzA1', ''),(7, 6, 'BRA1a', 'BRA1a', ''),(8, 6, 'BRA1b', 'BRA1b', ''),(9, 5, 'BRA2', 'BzA1-bis', ''),(10, 9, 'BRA2a', 'BRA2a', ''),(11, 9, 'BRA2b', 'BRA2b', ''),(12, 5, 'BRA3', 'Bz A2', ''),(13, 12, 'BRA3a', 'BRA3a', ''),(14, 12, 'BRA3b', 'BRA3b', ''),(15, 3, 'Bronze moyen', 'Mittlere Bronzezeit', '(BRM -1500 -1201 av.JC)'),(16, 15, 'BRM1', 'Bz B1', ''),(17, 16, 'BRM1a', 'BRM1a', ''),(18, 16, 'BRM1b', 'BRM1b', ''),(19, 15, 'BRM2', 'BzB2-BzC1', ''),(20, 19, 'BRM2a', 'BRM2a', ''),(21, 19, 'BRM2b', 'BRM2b', ''),(22, 15, 'BRM3', 'BzC2-BzD', ''),(23, 22, 'BRM3a', 'BRM3a', ''),(24, 22, 'BRM3b', 'HaA1', ''),(25, 3, 'Bronze final', 'Spätbronzezeit', '(BRF -1200 -801 av.JC)'),(26, 25, 'BRF1', 'BzD-HaA1', '(-1200 -1051 av.JC)'),(27, 26, 'BRF1a', 'BzD', ''),(28, 26, 'BRF1b', 'BRF1b', ''),(29, 25, 'BRF2', 'HaA2', '(-1050 -901 av.JC)'),(30, 29, 'BRF2a', 'HaA2', ''),(31, 29, 'BRF2b', 'BRF2b', ''),(32, 25, 'BRF3', 'HaB', '(-900 –801 av.JC)'),(33, 32, 'BRF3a', 'HaB1', ''),(34, 32, 'BRF3b', 'HaB2-B3', ''),(35, 25, 'BRF3/HAC1', 'BRF3/HAC1', ''),(36, NULL, 'Age du Fer', 'Eisenzeit', ''),(37, 36, 'Fer indéterminé', 'Eisenzeit Unbestimmt', '(-800 -25 av.JC)'),(38, 36, 'Hallstatt indéterminé', 'Hallstatt Unbestimmt', '(-800 -461 av.JC)'),(39, 36, 'Hallstatt C', 'Hallstatt C', '(HAC -800 -621 av.JC)'),(40, 39, 'BRF3/HAC1', 'BRF3/HAC1', ''),(41, 39, 'HAC1', 'HAC1', ''),(42, 41, 'HAC1a', 'HAC1a', ''),(43, 41, 'HAC1b-c', 'HAC1b-c', ''),(44, 39, 'HAC2', 'HAC2', ''),(45, 44, 'HAC2a', 'HAC2a', ''),(46, 44, 'HAC2b', 'HAC2b', ''),(47, 39, 'HAC2/HAD1', 'HAC2/HAD1', ''),(48, 36, 'Hallstatt D', 'Hallstatt D', '(HAD -620 – 461 av.JC)'),(49, 48, 'HAC2/HAD1', 'HAC2/HAD1', ''),(50, 48, 'HAD1', 'HAD1', '(-620 -531 av.JC)'),(51, 50, 'HAD1a', 'HAD1a', ''),(52, 50, 'HAD1b', 'HAD1b', ''),(53, 48, 'HAD2', 'HAD2', '(-530 – 501 av.JC)'),(54, 53, 'HAD2a', 'HAD2a', ''),(55, 53, 'HAD2b', 'HAD2b', ''),(56, 48, 'HAD3', 'HAD3', '(-500 – 461 av.JC)'),(57, 56, 'HAD3a', 'HAD3a', ''),(58, 56, 'HAD3b', 'HAD3b', ''),(59, 48, 'HAD3/LTA1', 'HAD3/LTA1', ''),(60, 36, 'La Tène indéterminée', 'La Tène Unbestimmt', '(-461 - 25 av.JC)'),(61, 36, 'La Tène A', 'La Tène A', '(LTA -460 – 401 av.JC)'),(62, 61, 'HAD3/LTA1', 'HAD3/LTA1', ''),(63, 61, 'LTA1', 'LTA1', ''),(64, 63, 'LTA1a', 'LTA1a', ''),(65, 63, 'LTA1b', 'LTA1b', ''),(66, 61, 'LTA2', 'LTA2', ''),(67, 66, 'LTA2a', 'LTA2a', ''),(68, 66, 'LTA2b', 'LTA2b', ''),(69, 36, 'La Tène B', 'La Tène B', '(LTB -400 – 261 av.JC)'),(70, 69, 'LTB1', 'LTB1', '(-400 -321 av.JC)'),(71, 70, 'LTB1a', 'LTB1a', ''),(72, 70, 'LTB1b', 'LTB1b', ''),(73, 69, 'LTB2', 'LTB2', '(-320 -261 av.JC)'),(74, 73, 'LTB2a', 'LTB2a', ''),(75, 73, 'LTB2b', 'LTB2b', ''),(76, 36, 'La Tène C', 'La Tène C', '(LTC -260 -141 av.JC)'),(77, 76, 'LTC1', 'LTC1', '(-260 -201 av.JC)'),(78, 77, 'LTC1a', 'LTC1a', ''),(79, 77, 'LTC1b', 'LTC1b', ''),(80, 76, 'LTC2', 'LTC2', '(-200 -141 av.JC)'),(81, 80, 'LTC2a', 'LTC2a', ''),(82, 80, 'LTC2b', 'LTC2b', ''),(83, 76, 'LTC2/LTD1', 'LTC2/LTD1', ''),(84, 36, 'La Tène D', 'La Tène D', '(LTD -140 -25 av.JC)'),(85, 84, 'LTC2/LTD1', 'LTC2/LTD1', ''),(86, 84, 'LTD1', 'LTD1', '(-140 -71 av.JC)'),(87, 86, 'LTD1a', 'LTD1a', ''),(88, 86, 'LTD1b', 'LTD1b', ''),(89, 84, 'LTD2', 'LTD2', '(-70 -25 av.JC)'),(90, 89, 'LTD2a', 'LTD2a', ''),(91, 89, 'LTD2b', 'LTD2b', ''),(92, NULL, 'Gallo-Romain', 'Gallo-Römisch', ''),(93, 92, 'Gallo-Romain Indéterminé', 'Gallo-Römisch Unbestimmt', ''),(94, 92, 'Période augustéenne', 'Augustäisch', ''),(95, 92, 'Haut Empire', 'Frühe Kaiserzeit', ''),(96, 95, 'Julio-Claudiens Flaviens', 'Flavier', '( +21 +100 ap.JC)'),(97, 95, 'Antonins Sevères', 'Antonins Sevères', '(+101 +260 ap.JC)'),(98, 92, 'Antiquité tardive', 'Spätantike', ''),(99, 98, 'Constantin', 'Constantin', '(+261 +310 ap.JC)'),(100, 98, 'IVe siècle', '4. Jhdt', '(ap.JC)'),(101, 98, 'Ve siècle', '5. Jhdt', '(ap.JC)'),(102, 92, 'Grandes  invasions', 'Völkerwanderungszeit', ''),(103, NULL, 'Mérovingien', 'Merowingerzeit', ''),(104, 103, 'Grandes  invasions', 'Völkerwanderungszeit', ''),(105, 103, 'Mérovingien Indéterminé', 'Merowingerzeit Unbestimmt', '(+451 +720 ap.JC)'),(106, 103, 'Mérovingien ancien', 'Ält. Merowingerzeit', '(+451 +600 ap.JC)'),(107, 106, 'Mérovingien ancien I', 'Ält. Merowingerzeit I', '(+451 +520 ap.JC)'),(108, 106, 'Mérovingien ancien II', 'Ält. Merowingerzeit II', '(+521 +550 ap.JC)'),(109, 106, 'Mérovingien ancient III', 'Ält. Merowingerzeit III', '(+551 +600 ap.JC)'),(110, 103, 'Mérovingien récent', 'Jüng.Merowingerzeit', '(+601 +720 ap.JC)'),(111, 110, 'Mérovingien récent I', 'Jüng. Merowingerzeit I', '(+601 +630 ap.JC)'),(112, 110, 'Mérovingien récent II', 'Jüng. Merowingerzeit II', '(+631 +680 ap.JC)'),(113, 110, 'Mérovingien récent III', 'Jüng. Merowingerzeit III', '(+681 +720 ap.JC)'),(114, 103, 'Carolingien', 'Karolinger', '(+721 +800 ap.JC)'),(115, NULL, 'Moyen-âge', 'Mittelalter', ''),(116, 115, 'Moyen-âge Indéterminé', 'Mittelalter  Unbestimmt', ''),(117, 115, 'Moyen-âge I', 'Mittelalter I', '(8eme. 9eme ap.JC)'),(118, 115, 'Moyen-âge II', 'Mittelalter II', '(10eme.11eme ap.JC)'),(119, 115, 'Moyen-âge classique', 'Spät Mittelalter', '(XIIe-1492 ap.JC)'),(120, NULL, 'Moderne', 'Neuzeitlich', '(1492-1789 ap.JC)'),(121, NULL, 'Contemporaine', 'Zeitgeschichtlich', '(1789 - )');