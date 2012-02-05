--
-- DO NOT DELETE
--
-- ARK_PERIOD
-- ARK_REALESTATE
-- ARK_FURNITURE
--
--

-- ---
-- Table 'ark_database'
-- ---
		
CREATE TABLE "ark_database" (
  "da_id" SERIAL PRIMARY KEY,
  "da_name" VARCHAR(100) NOT NULL,
  "da_description" TEXT,
  "da_owner_id" INTEGER,
  "da_creation" TIMESTAMP NOT NULL,
  "da_modification" TIMESTAMP DEFAULT NULL
);
CREATE INDEX ark_database_name_idx ON "ark_database" ("da_name");

-- ---
-- Table 'ark_city'
-- ---
		
CREATE TABLE "ark_city" (
  "ci_code" VARCHAR(50) PRIMARY KEY,
  "ci_name" VARCHAR(255) DEFAULT NULL,
  "ci_country" CHAR(2) DEFAULT NULL
);
SELECT AddGeometryColumn('ark_city', 'ci_geom', 4326, 'POINT', 3);
CREATE INDEX "ark_city_geom_idx" ON "ark_city" USING GIST ("ci_geom"); 
CREATE INDEX ark_city_name_idx ON "ark_city" ("ci_name");

-- ---
-- Table 'ark_site'
-- ---

CREATE TYPE "ark_site_occupation_type" AS ENUM ('unknown', 'uniq', 'continuous', 'multiple');
		
CREATE TABLE "ark_site" (
  "si_code" VARCHAR(50) PRIMARY KEY,
  "si_database_id" INTEGER NOT NULL REFERENCES "ark_database",
  "si_author_id" INTEGER NOT NULL,
  "si_name" VARCHAR(255) NOT NULL,
  "si_city_code" VARCHAR(50) DEFAULT NULL REFERENCES ark_city,
  "si_centroid" SMALLINT NOT NULL DEFAULT 0,
  "si_occupation" ark_site_occupation_type DEFAULT NULL,
  "si_creation" TIMESTAMP NOT NULL,
  "si_modification" TIMESTAMP DEFAULT NULL
);

SELECT AddGeometryColumn('ark_site', 'si_geom', 4326, 'POINT', 3);
CREATE INDEX "ark_site_geom_idx" ON "ark_site" USING GIST ("si_geom"); 
CREATE INDEX ark_site_name_idx ON "ark_site" ("si_name");

-- ---
-- Table 'ark_site_period'
-- ---
		
CREATE TYPE "ark_siteperiod_knowlege_type" AS ENUM ('unknown', 'literature', 'surveyed', 'excavated');

CREATE TABLE "ark_site_period" (
  "sp_id" SERIAL PRIMARY KEY,
  "sp_site_code" VARCHAR(50) NOT NULL REFERENCES "ark_site",
  "sp_period_start" INTEGER NOT NULL REFERENCES "ark_period",
  "sp_period_end" INTEGER NOT NULL REFERENCES "ark_period",
  "sp_period_isrange" SMALLINT NOT NULL DEFAULT 0,
  "sp_knowlege_type" ark_siteperiod_knowlege_type DEFAULT NULL,
  "sp_soil_type" VARCHAR(255) DEFAULT NULL,
  "sp_superfical_type" VARCHAR(255) DEFAULT NULL,
  "sp_analysis" VARCHAR(255) DEFAULT NULL,
  "sp_paleosol" VARCHAR(255) DEFAULT NULL,
  "sp_date_dendro" DATE DEFAULT NULL,
  "sp_date_14C" DATE DEFAULT NULL,
  "sp_description" TEXT DEFAULT NULL,
  "sp_comment" TEXT DEFAULT NULL,
  "sp_bibliography" TEXT DEFAULT NULL,
  "sp_depth" INTEGER DEFAULT NULL
);

-- ---
-- Table 'ark_siteperiod_realestate'
-- ---
		
CREATE TABLE "ark_siteperiod_realestate" (
  "sr_id" SERIAL PRIMARY KEY,
  "sr_site_period_id" INTEGER NOT NULL REFERENCES "ark_site_period",
  "sr_realestate_id" INTEGER NOT NULL REFERENCES "ark_realestate",
  "sr_exceptional" SMALLINT DEFAULT 0
);

CREATE INDEX "ark_siteperiod_realestate_siteperiod_idx" ON "ark_siteperiod_realestate" ("sr_site_period_id"); 
CREATE INDEX "ark_siteperiod_realestate_realestate_idx" ON "ark_siteperiod_realestate" ("sr_realestate_id"); 

-- ---
-- Table 'ark_siteperiod_furniture'
-- ---
		
CREATE TABLE "ark_siteperiod_furniture" (
  "fu_id" SERIAL PRIMARY KEY,
  "fu_site_period_id" INTEGER NOT NULL REFERENCES "ark_site_period",
  "fu_furniture_id" INTEGER NOT NULL REFERENCES "ark_furniture",
  "fu_exceptional" SMALLINT DEFAULT 0
);

CREATE INDEX "ark_siteperiod_furniture_siteperiod_idx" ON "ark_siteperiod_furniture" ("fu_site_period_id"); 
CREATE INDEX "ark_siteperiod_furniture_furniture_idx" ON "ark_siteperiod_furniture" ("fu_furniture_id"); 

-- ---
-- Table 'ark_siteperiod_production'
-- ---
		
CREATE TABLE "ark_siteperiod_production" (
  "pr_id" SERIAL PRIMARY KEY,
  "pr_site_period_id" INTEGER NOT NULL REFERENCES "ark_site_period",
  "pr_production_id" INTEGER NOT NULL REFERENCES "ark_production",
  "pr_exceptional" SMALLINT DEFAULT 0
);

CREATE INDEX "ark_siteperiod_production_siteperiod_idx" ON "ark_siteperiod_production" ("pr_site_period_id"); 
CREATE INDEX "ark_siteperiod_production_production_idx" ON "ark_siteperiod_production" ("pr_production_id"); 
