ALTER TABLE ONLY ark_siteperiod_furniture DROP CONSTRAINT ark_siteperiod_furniture_sf_furniture_id_fkey;
DROP INDEX IF EXISTS "idx_ark_furniture_node_path_btree_idx";
DROP INDEX IF EXISTS "idx_ark_furniture_node_path_gist_idx";
DROP FUNCTION IF EXISTS get_calculated_fu_node_path(integer);
DROP TRIGGER trig01_update_fu_node_path ON ark_furniture;
DROP FUNCTION IF EXISTS trig_update_fu_node_path();
DROP TABLE IF EXISTS "ark_furniture";