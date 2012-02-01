CREATE TABLE ark_period(pe_id integer PRIMARY KEY, pe_parentid integer, pe_name varchar(100), pe_depends integer, node_path ltree);
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

INSERT INTO ark_period (pe_id, pe_parentid, pe_name, pe_depends)
VALUES
(1, NULL, 'Indéterminé', NULL),
(2, NULL, 'Néolithique', NULL),
(3, NULL, 'Bronze', NULL),
  (4, 3, 'Bronze indeterminé', NULL),
  (5, 3, 'Bronze ancien (BRA)', NULL),
    (6, 5, 'BRA1', NULL),
			(7, 6, 'BRA1a', NULL),
			(8, 6, 'BRA1b', NULL),
    (9, 5, 'BRA2', NULL),
			(10, 9, 'BRA2a', NULL),
			(11, 9, 'BRA2b', NULL),
    (12, 5, 'BRA3', NULL),
			(13, 12, 'BRA3a', NULL),
			(14, 12, 'BRA3b', NULL),
  (15, 3, 'Bronze moyen (BRM)', NULL),
		(16, 15, 'BRM1', NULL),
			(17, 16, 'BRM1a', NULL),
			(18, 16, 'BRM1b', NULL),
		(19, 15, 'BRM2', NULL),
			(20, 19, 'BRM2a', NULL),
			(21, 19, 'BRM2b', NULL),
		(22, 15, 'BRM3', NULL),
			(23, 22, 'BRM3a', NULL),
			(24, 22, 'BRM3b', NULL),
  (25, 3, 'Bronze final (BRF)', NULL),
		(26, 25, 'BRF1', NULL),
			(27, 26, 'BRF1a', NULL),
			(28, 26, 'BRF1b', NULL),
		(29, 25, 'BRF2', NULL),
			(30, 29, 'BRF2a', NULL),
			(31, 29, 'BRF2b', NULL),
		(32, 25, 'BRF3', NULL),
			(33, 32, 'BRF3a', NULL),
			(34, 32, 'BRF3b', NULL),
		(35, 25 , 'BRF/HAC', NULL),
(36, NULL, 'Fer', NULL),
  (37, 36, 'Fer indéterminé', NULL),
  (38, 36, 'Hallstatt indéterminé', NULL),
  (39, 36, 'Hallstatt C (HAC)', NULL),
    (40, 39, 'HAC1', NULL),
			(41, 40, 'HAC1a', NULL),
			(42, 40, 'HAC1b-c', NULL),
    (43, 39, 'HAC2', NULL),
			(44, 43, 'HAC2a', NULL),
			(45, 43, 'HAC2b', NULL),
    (46, 39, 'HAC2/D1', NULL),
  (47, 36, 'Hallstatt D (HAD)', NULL),
    (48, 47, 'HAD1', NULL),
			(49, 48, 'HAD1a', NULL),
			(50, 48, 'HAD1b', NULL),
    (51, 47, 'HAD2', NULL),
			(52, 51, 'HAD2a', NULL),
			(53, 51, 'HAD2b', NULL),
    (54, 47, 'HAD3', NULL),
			(55, 54, 'HAD3a', NULL),
			(56, 54, 'HAD3b', NULL),
    (57, 47, 'HAD3/LTA', NULL),
  (58, 36, 'La Tène intéterminée', NULL),
  (59, 36, 'La Tène A (LTA)', NULL),
    (60, 59, 'LTA1', NULL),
			(61, 60, 'LTA1a', NULL),
			(62, 60, 'LTA1b', NULL),
    (63, 59, 'LTA2', NULL),
			(64, 63, 'LTA2a', NULL),
			(65, 63, 'LTA2b', NULL),
  (66, 36, 'La Tène B (LTB)', NULL),
    (67, 66, 'LTB1', NULL),
			(68, 67, 'LTB1a', NULL),
			(69, 67, 'LTB1b', NULL),
    (70, 66, 'LTB2', NULL),
			(71, 70, 'LTB2a', NULL),
			(72, 70, 'LTB2b', NULL),
  (73, 36, 'La Tène C (LTC)', NULL),
    (74, 73, 'LTC1', NULL),
			(75, 74, 'LTC1a', NULL),
			(76, 74, 'LTC1b', NULL),
    (77, 73, 'LTC2', NULL),
			(78, 77, 'LTC2a', NULL),
			(79, 77, 'LTC2b', NULL),
    (80, 73, 'LTC2/D1', NULL),
  (81, 36, 'La Tène D (LTC)', NULL),
    (82, 81, 'LTD1', NULL),
			(83, 82, 'LTD1a', NULL),
			(84, 82, 'LTD1b', NULL),
    (85, 81, 'LTD2', NULL),
			(86, 85, 'LTD2a', NULL),
			(87, 85, 'LTD2b', NULL),
(88, NULL, 'Gallo-Romain', NULL),
  (89, 88, 'Gallo-Romain indéterminé', NULL),
  (90, 88, 'Période augustéenne', NULL),
    (91, 90, '-40 / +20', NULL),
  (92, 88, 'Haut Empire', NULL),
    (93, 92, '+21 / 100', NULL),
    (94, 92, '+101 / +250', NULL),
  (95, 88, 'Antiquité tardive', NULL),
    (96, 95, '251 / 310 - Constantin', NULL),
    (97, 95, 'IVe siècle / 4. Jhdt', NULL),
    (98, 95, 'Ve siècle / 5. Jhdt', NULL),
  (99, 88, 'Völkerwanderungszeit', NULL),
(100, NULL, 'Mérovingien', NULL),
  (101, 100, 'Mérovingien indéterminé', NULL),
  (102, 100, 'Mérovingien ancien', NULL),
		(103, 102, 'Mérovingien ancien I', NULL),
		(104, 102, 'Mérovingien ancien II', NULL),
		(105, 102, 'Mérovingien ancien III', NULL),
  (106, 100, 'Mérovingien récent', NULL),
		(107, 106, 'Mérovingien récent I', NULL),
		(108, 106, 'Mérovingien récent II', NULL),
		(109, 106, 'Mérovingien récent III', NULL),
  (110, 100, 'Othonien', NULL),
(111, NULL, 'Moyen-âge', NULL),
  (112, 111, 'Moyen-âge indéterminé', NULL),
  (113, 111, 'Moyen-âge I', NULL),
  (114, 111, 'Moyen-âge II', NULL);
