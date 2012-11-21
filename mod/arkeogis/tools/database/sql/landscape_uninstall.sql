DROP INDEX IF EXISTS "idx_landscape_node_path_btree_idx";
DROP INDEX IF EXISTS "idx_landscape_node_path_gist_idx";
DROP FUNCTION IF EXISTS get_calculated_ark__node_path(integer);
DROP TRIGGER trig01_update_ark__node_path ON landscape;
DROP FUNCTION IF EXISTS trig_update_ark__node_path();
DROP TABLE IF EXISTS "landscape";