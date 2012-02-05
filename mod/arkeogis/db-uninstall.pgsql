-- ark_siteperiod_realestate
DROP TABLE IF EXISTS "ark_siteperiod_realestate";
DROP INDEX IF EXISTS "ark_siteperiod_realestate_siteperiod_idx"; 
DROP INDEX "ark_siteperiod_realestate_realestate_idx"; 
-- ark_siteperiod_furniture
DROP TABLE IF EXISTS "ark_siteperiod_furniture";
DROP INDEX IF EXISTS "ark_siteperiod_furniture_siteperiod_idx"; 
DROP INDEX "ark_siteperiod_furniture_furniture_idx"; 
-- ark_siteperiod_production
DROP TABLE IF EXISTS "ark_siteperiod_production";
DROP INDEX IF EXISTS "ark_siteperiod_production_siteperiod_idx"; 
DROP INDEX "ark_siteperiod_production_production_idx"; 
-- ark_site_period
DROP TABLE IF EXISTS "ark_site_period";
DROP TYPE IF EXISTS "ark_siteperiod_knowlege_type";
-- ark_site
DROP TABLE IF EXISTS "ark_site";
DROP INDEX IF EXISTS "ark_site_name_idx";
DROP INDEX IF EXISTS "ark_site_geom_idx";
DROP TYPE IF EXISTS "ark_site_occupation_type";
-- ark_city
DROP TABLE IF EXISTS "ark_city";
DROP INDEX IF EXISTS "ark_city_name_idx";
DROP INDEX IF EXISTS "ark_city_geom_idx";
-- ark_database
DROP TABLE IF EXISTS "ark_database";
DROP INDEX IF EXISTS "ark_database_name_idx";
DROP TABLE IF EXISTS "ark_site";
