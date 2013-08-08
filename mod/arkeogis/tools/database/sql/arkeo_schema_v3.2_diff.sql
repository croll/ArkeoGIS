ALTER TABLE public.ark_database ADD COLUMN da_issn CHARACTER VARYING(30);
ALTER TABLE public.ark_database ADD COLUMN da_lines INTEGER;
ALTER TABLE public.ark_database ADD COLUMN da_sites INTEGER;
ALTER TABLE public.ark_database ADD COLUMN da_period_start INTEGER;
ALTER TABLE public.ark_database ADD COLUMN da_period_end INTEGER;

CREATE TABLE ark_database_log (
    dl_id integer NOT NULL,
    dl_database_id integer NOT NULL,
    dl_user_id integer NOT NULL,
    dl_date date,
    dl_csv_file character varying(100)
);

ALTER TABLE ONLY ark_database_log
    ADD CONSTRAINT ark_database_log_dl_database_id_fkey FOREIGN KEY (dl_database_id) REFERENCES ark_database(da_id) ON DELETE CASCADE;
