
ALTER TABLE ONLY public.ark_siteperiod_landscape DROP CONSTRAINT ark_siteperiod_landscape_sf_site_period_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_landscape DROP CONSTRAINT ark_siteperiod_landscape_sf_landscape_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_landscape DROP CONSTRAINT ark_siteperiod_landscape_sl_site_period_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_landscape DROP CONSTRAINT ark_siteperiod_landscape_sl_landscape_id_fkey;
DROP INDEX public.ark_siteperiod_landscape_siteperiod_idx;
DROP INDEX public.ark_siteperiod_landscape_landscape_idx;
ALTER TABLE ONLY public.ark_siteperiod_landscape DROP CONSTRAINT ark_siteperiod_landscape_pkey;
ALTER TABLE ONLY public.ark_landscape DROP CONSTRAINT ark_landscape_pkey;
ALTER TABLE public.ark_siteperiod_landscape ALTER COLUMN sf_id DROP DEFAULT;
DROP SEQUENCE public.ark_siteperiod_landscape_sf_id_seq;
ALTER TABLE public.ark_siteperiod_landscape ALTER COLUMN sl_id DROP DEFAULT;
DROP SEQUENCE public.ark_siteperiod_landscape_sl_id_seq;
DROP TABLE public.ark_siteperiod_landscape;

CREATE TABLE ark_siteperiod_landscape (
    sl_id integer NOT NULL,
    sl_site_period_id integer NOT NULL,
    sl_landscape_id integer NOT NULL,
    sl_exceptional smallint DEFAULT 0
);

CREATE SEQUENCE ark_siteperiod_landscape_sl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE ark_siteperiod_landscape_sl_id_seq OWNED BY ark_siteperiod_landscape.sl_id;

ALTER TABLE ONLY ark_siteperiod_landscape ALTER COLUMN sl_id SET DEFAULT nextval('ark_siteperiod_landscape_sl_id_seq'::regclass);

ALTER TABLE ONLY ark_siteperiod_landscape
    ADD CONSTRAINT ark_siteperiod_landscape_pkey PRIMARY KEY (sl_id);

CREATE INDEX ark_siteperiod_landscape_landscape_idx ON ark_siteperiod_landscape USING btree (sl_landscape_id);

CREATE INDEX ark_siteperiod_landscape_siteperiod_idx ON ark_siteperiod_landscape USING btree (sl_site_period_id);

ALTER TABLE ONLY ark_siteperiod_landscape
    ADD CONSTRAINT ark_siteperiod_landscape_sl_landscape_id_fkey FOREIGN KEY (sl_landscape_id) REFERENCES ark_landscape(la_id) ON DELETE CASCADE;

ALTER TABLE ONLY ark_siteperiod_landscape
    ADD CONSTRAINT ark_siteperiod_landscape_sl_site_period_id_fkey FOREIGN KEY (sl_site_period_id) REFERENCES ark_site_period(sp_id) ON DELETE CASCADE;

CREATE TYPE ark_database_type AS ENUM (
    'inventory',
    'research'
);

CREATE TYPE ark_database_scale_resolution AS ENUM (
    'site',
    'watershed',
    'micro-region',
    'retion',
    'country',
    'region'
);

ALTER TABLE public.ark_database ADD COLUMN da_description_de TEXT;
ALTER TABLE public.ark_database ADD COLUMN da_type ark_database_type;
ALTER TABLE public.ark_database ADD COLUMN da_geographical_limit TEXT;
ALTER TABLE public.ark_database ADD COLUMN da_scale_resolution ark_database_scale_resolution;
