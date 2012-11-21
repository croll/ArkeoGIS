DROP INDEX IF EXISTS "idx_ark_landscape_node_path_btree_idx";
DROP INDEX IF EXISTS "idx_ark_landscape_node_path_gist_idx";
DROP FUNCTION IF EXISTS get_calculated_la_node_path(integer);
DROP TRIGGER trig01_update_la_node_path ON ark_landscape;
DROP FUNCTION IF EXISTS trig_update_la_node_path();
DROP TABLE IF EXISTS "ark_landscape";