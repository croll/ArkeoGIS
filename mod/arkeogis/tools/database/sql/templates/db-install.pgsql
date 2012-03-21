--
-- DO NOT DELETE
--
-- ARK_PERIOD
-- ARK_REALESTATE
-- ARK_FURNITURE
-- ARK_PRODUCTION
--
--

-- ---
-- Table 'ark_database'
-- ---
		
CREATE TABLE "ark_database" (
  "da_id" SERIAL PRIMARY KEY,
  "da_name" VARCHAR(100) UNIQUE NOT NULL,
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
  "ci_id" SERIAL PRIMARY KEY,
  "ci_code" VARCHAR(50),
  "ci_name" VARCHAR(255) DEFAULT NULL,
  "ci_nameupper" VARCHAR(255) DEFAULT NULL,
  "ci_country" CHAR(2) DEFAULT NULL
);
SELECT AddGeometryColumn('ark_city', 'ci_geom', 4326, 'POINT', 2);
CREATE UNIQUE INDEX ark_city_code_idx ON "ark_city" ("ci_code", "ci_country");
CREATE INDEX "ark_city_geom_idx" ON "ark_city" USING GIST ("ci_geom"); 
CREATE INDEX ark_city_name_idx ON "ark_city" ("ci_name");

-- ---
-- Table 'ark_site'
-- ---

CREATE TYPE "ark_site_occupation_type" AS ENUM ('unknown', 'uniq', 'continuous', 'multiple');
		
CREATE TABLE "ark_site" (
  "si_id" SERIAL PRIMARY KEY,
  "si_code" VARCHAR(50),
  "si_database_id" INTEGER NOT NULL REFERENCES "ark_database" ON DELETE CASCADE,
  "si_author_id" INTEGER NOT NULL,
  "si_name" VARCHAR(255) NOT NULL,
  "si_description" TEXT DEFAULT NULL,
  "si_city_id" INTEGER DEFAULT NULL REFERENCES ark_city,
  "si_centroid" SMALLINT NOT NULL DEFAULT 0,
  "si_occupation" ark_site_occupation_type DEFAULT NULL,
  "si_creation" TIMESTAMP NOT NULL,
  "si_modification" TIMESTAMP DEFAULT NULL
);

SELECT AddGeometryColumn('ark_site', 'si_geom', 4326, 'POINT', 3);
CREATE INDEX "ark_site_geom_idx" ON "ark_site" USING GIST ("si_geom"); 
CREATE INDEX ark_site_code_idx ON "ark_site" ("si_code");
CREATE INDEX ark_site_name_idx ON "ark_site" ("si_name");
CREATE INDEX ark_site_databaseidx ON "ark_site" ("si_database_id");

-- ---
-- Table 'ark_site_period'
-- ---
		
CREATE TYPE "ark_siteperiod_knowledge_type" AS ENUM ('unknown', 'literature', 'surveyed', 'excavated');

CREATE TABLE "ark_site_period" (
  "sp_id" SERIAL PRIMARY KEY,
  "sp_site_id" INTEGER NOT NULL REFERENCES "ark_site" ON DELETE CASCADE,
  "sp_period_start" INTEGER NOT NULL REFERENCES "ark_period",
  "sp_period_end" INTEGER NOT NULL REFERENCES "ark_period",
  "sp_period_isrange" SMALLINT NOT NULL DEFAULT 0,
  "sp_knowledge_type" ark_siteperiod_knowledge_type DEFAULT 'unknown',
  "sp_soil_type" VARCHAR(255) DEFAULT NULL,
  "sp_superfical_type" VARCHAR(255) DEFAULT NULL,
  "sp_analysis" VARCHAR(255) DEFAULT NULL,
  "sp_paleosol" VARCHAR(255) DEFAULT NULL,
  "sp_date_dendro" DATE DEFAULT NULL,
  "sp_date_14C" DATE DEFAULT NULL,
  "sp_comment" TEXT DEFAULT NULL,
  "sp_bibliography" TEXT DEFAULT NULL,
  "sp_depth" INTEGER DEFAULT NULL
);

CREATE INDEX ark_siteperiod_site_id_idx ON "ark_site" ("sp_site_id");
CREATE INDEX ark_siteperiod_period_start_idx ON "ark_site" ("sp_period_start");
CREATE INDEX ark_siteperiod_period_end_idx ON "ark_site" ("sp_period_end");

-- ---
-- Table 'ark_siteperiod_realestate'
-- ---
		
CREATE TABLE "ark_siteperiod_realestate" (
  "sr_id" SERIAL PRIMARY KEY,
  "sr_site_period_id" INTEGER NOT NULL REFERENCES "ark_site_period" ON DELETE CASCADE,
  "sr_realestate_id" INTEGER NOT NULL REFERENCES "ark_realestate" ON DELETE CASCADE,
  "sr_exceptional" SMALLINT DEFAULT 0
);

CREATE INDEX "ark_siteperiod_realestate_siteperiod_idx" ON "ark_siteperiod_realestate" ("sr_site_period_id"); 
CREATE INDEX "ark_siteperiod_realestate_realestate_idx" ON "ark_siteperiod_realestate" ("sr_realestate_id"); 

-- ---
-- Table 'ark_siteperiod_furniture'
-- ---
		
CREATE TABLE "ark_siteperiod_furniture" (
  "sf_id" SERIAL PRIMARY KEY,
  "sf_site_period_id" INTEGER NOT NULL REFERENCES "ark_site_period" ON DELETE CASCADE,
  "sf_furniture_id" INTEGER NOT NULL REFERENCES "ark_furniture" ON DELETE CASCADE,
  "sf_exceptional" SMALLINT DEFAULT 0
);

CREATE INDEX "ark_siteperiod_furniture_siteperiod_idx" ON "ark_siteperiod_furniture" ("sf_site_period_id"); 
CREATE INDEX "ark_siteperiod_furniture_furniture_idx" ON "ark_siteperiod_furniture" ("sf_furniture_id"); 

-- ---
-- Table 'ark_siteperiod_production'
-- ---
		
CREATE TABLE "ark_siteperiod_production" (
  "sp_id" SERIAL PRIMARY KEY,
  "sp_site_period_id" INTEGER NOT NULL REFERENCES "ark_site_period" ON DELETE CASCADE,
  "sp_production_id" INTEGER NOT NULL REFERENCES "ark_production" ON DELETE CASCADE,
  "sp_exceptional" SMALLINT DEFAULT 0
);

CREATE INDEX "ark_siteperiod_production_siteperiod_idx" ON "ark_siteperiod_production" ("sp_site_period_id"); 
CREATE INDEX "ark_siteperiod_production_production_idx" ON "ark_siteperiod_production" ("sp_production_id"); 

-- ---
-- Table 'ark_savedquery'
-- ---
CREATE TABLE ark_savedquery (
       "id" serial PRIMARY KEY,
       "id_user" integer,
       "name" varchar(255),
       "query" text
);
CREATE UNIQUE INDEX "ark_savedquery_idx" ON "ark_savedquery" ("id");




-- ARK_CITIESFR
