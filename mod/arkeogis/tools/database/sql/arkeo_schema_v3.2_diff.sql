ALTER TABLE public.ark_database ADD COLUMN da_issn CHARACTER VARYING(30);
ALTER TABLE public.ark_database ADD COLUMN da_lines INTEGER;
ALTER TABLE public.ark_database ADD COLUMN da_sites INTEGER;
ALTER TABLE public.ark_database ADD COLUMN da_period_start INTEGER;
ALTER TABLE public.ark_database ADD COLUMN da_period_end INTEGER;
ALTER TABLE public.ark_database ADD COLUMN da_published BOOLEAN DEFAULT true;

CREATE SEQUENCE ark_database_log_dl_id_seq;

CREATE TABLE ark_database_log (
    dl_id integer NOT NULL  default nextval('ark_database_log_dl_id_seq'),
    dl_database_id integer NOT NULL,
    dl_user_id integer NOT NULL,
    dl_date timestamp,
    dl_csv_file character varying(100)
);

ALTER SEQUENCE  ark_database_log_dl_id_seq owned by ark_database_log.dl_id;

ALTER TABLE ONLY ark_database_log
    ADD CONSTRAINT ark_database_log_dl_database_id_fkey FOREIGN KEY (dl_database_id) REFERENCES ark_database(da_id) ON DELETE CASCADE;

ALTER TABLE public.ark_database_log OWNER TO captainhook;

CREATE TABLE "ark_userinfos" ("uid" int NOT NULL, "structure" varchar(255));
ALTER TABLE public.ark_userinfos OWNER TO captainhook;

INSERT INTO ch_regroute (regexp, hook, flags) VALUES ('#^/databases/?$#', 'mod_arkeogis_databases', 1);
INSERT INTO ch_hook (name, mid, callback, position) VALUES ('mod_arkeogis_databases', 40, '\mod\arkeogis\Main::hook_mod_arkeogis_databases',0);
