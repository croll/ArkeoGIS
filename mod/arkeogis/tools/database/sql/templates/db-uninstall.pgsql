-- ark_siteperiod_realestate
DROP INDEX IF EXISTS "ark_siteperiod_realestate_siteperiod_idx"; 
DROP INDEX "ark_siteperiod_realestate_realestate_idx"; 
DROP TABLE IF EXISTS "ark_siteperiod_realestate";
-- ark_siteperiod_furniture
DROP INDEX IF EXISTS "ark_siteperiod_furniture_siteperiod_idx"; 
DROP INDEX "ark_siteperiod_furniture_furniture_idx"; 
DROP TABLE IF EXISTS "ark_siteperiod_furniture";
-- ark_siteperiod_production
DROP INDEX IF EXISTS "ark_siteperiod_production_siteperiod_idx"; 
DROP INDEX "ark_siteperiod_production_production_idx"; 
DROP TABLE IF EXISTS "ark_siteperiod_production";
-- ark_site_period
DROP TABLE IF EXISTS "ark_site_period";
DROP TYPE IF EXISTS "ark_siteperiod_knowlege_type";
-- ark_site
DROP INDEX IF EXISTS "ark_site_name_idx";
DROP INDEX IF EXISTS "ark_site_geom_idx";
DROP TABLE IF EXISTS "ark_site";
DROP TYPE IF EXISTS "ark_site_occupation_type";
-- ark_city
DROP INDEX IF EXISTS "ark_city_name_idx";
DROP INDEX IF EXISTS "ark_city_geom_idx";
DROP TABLE IF EXISTS "ark_city";
-- ark_database
DROP INDEX IF EXISTS "ark_database_name_idx";
DROP TABLE IF EXISTS "ark_database";

--
-- DO NOT DELETE
--
-- ARK_PERIOD
-- ARK_REALESTATE
-- ARK_FURNITURE
-- ARK_PRODUCTION
--
