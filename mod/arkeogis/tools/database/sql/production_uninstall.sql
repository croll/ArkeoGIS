ALTER TABLE ONLY ark_siteperiod_production DROP CONSTRAINT ark_siteperiod_production_sp_production_id_fkey;
DROP INDEX IF EXISTS "idx_ark_production_node_path_btree_idx";
DROP INDEX IF EXISTS "idx_ark_production_node_path_gist_idx";
DROP FUNCTION IF EXISTS get_calculated_pr_node_path(integer);
DROP TRIGGER trig01_update_pr_node_path ON ark_production;
DROP FUNCTION IF EXISTS trig_update_pr_node_path();
DROP TABLE IF EXISTS "ark_production";