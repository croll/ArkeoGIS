DROP INDEX IF EXISTS "idx_ark_period_node_path_btree_idx";
DROP INDEX IF EXISTS "idx_ark_period_node_path_gist_idx";
DROP FUNCTION IF EXISTS get_calculated_pe_node_path(integer);
DROP TRIGGER trig01_update_pe_node_path ON ark_period;
DROP FUNCTION IF EXISTS trig_update_pe_node_path();
DROP TABLE IF EXISTS "ark_period";