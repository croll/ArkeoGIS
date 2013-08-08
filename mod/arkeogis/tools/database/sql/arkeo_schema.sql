--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.ch_config DROP CONSTRAINT ch_config_id_user_fkey;
ALTER TABLE ONLY public.ark_database_log DROP CONSTRAINT ark_database_log_dl_database_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_realestate DROP CONSTRAINT ark_siteperiod_realestate_sr_site_period_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_realestate DROP CONSTRAINT ark_siteperiod_realestate_sr_realestate_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_production DROP CONSTRAINT ark_siteperiod_production_sp_site_period_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_production DROP CONSTRAINT ark_siteperiod_production_sp_production_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_furniture DROP CONSTRAINT ark_siteperiod_furniture_sf_site_period_id_fkey;
ALTER TABLE ONLY public.ark_siteperiod_furniture DROP CONSTRAINT ark_siteperiod_furniture_sf_furniture_id_fkey;
ALTER TABLE ONLY public.ark_site DROP CONSTRAINT ark_site_si_database_id_fkey;
ALTER TABLE ONLY public.ark_site DROP CONSTRAINT ark_site_si_city_id_fkey;
ALTER TABLE ONLY public.ark_site_period DROP CONSTRAINT ark_site_period_sp_site_id_fkey;
ALTER TABLE ONLY public.ark_site_period DROP CONSTRAINT ark_site_period_sp_period_start_fkey;
ALTER TABLE ONLY public.ark_site_period DROP CONSTRAINT ark_site_period_sp_period_end_fkey;
DROP TRIGGER trig01_update_re_node_path ON public.ark_realestate;
DROP TRIGGER trig01_update_pr_node_path ON public.ark_production;
DROP TRIGGER trig01_update_pe_node_path ON public.ark_period;
DROP TRIGGER trig01_update_fu_node_path ON public.ark_furniture;
DROP INDEX public.idx_ark_realestate_node_path_gist_idx;
DROP INDEX public.idx_ark_realestate_node_path_btree_idx;
DROP INDEX public.idx_ark_production_node_path_gist_idx;
DROP INDEX public.idx_ark_production_node_path_btree_idx;
DROP INDEX public.idx_ark_period_node_path_gist_idx;
DROP INDEX public.idx_ark_period_node_path_btree_idx;
DROP INDEX public.idx_ark_furniture_node_path_gist_idx;
DROP INDEX public.idx_ark_furniture_node_path_btree_idx;
DROP INDEX public.ch_user_group_uid_idx;
DROP INDEX public.ch_user_group_gid_idx;
DROP INDEX public.ch_smarty_plugins_name_idx;
DROP INDEX public.ch_smarty_plugins_id_module_idx;
DROP INDEX public.ch_smarty_override_orig_idx;
DROP INDEX public.ch_smarty_override_id_module_idx;
DROP INDEX public.ch_right_name_idx;
DROP INDEX public.ch_regroute_id_module_idx;
DROP INDEX public.ch_module_name_idx;
DROP INDEX public.ch_hook_mid_idx;
DROP INDEX public.ch_group_right_rid_idx;
DROP INDEX public.ch_group_right_gid_idx;
DROP INDEX public.ch_config_name_idx;
DROP INDEX public.ch_config_id_user_idx;
DROP INDEX public.ch_config_id_module_idx;
DROP INDEX public.ark_siteperiod_site_id_idx;
DROP INDEX public.ark_siteperiod_realestate_siteperiod_idx;
DROP INDEX public.ark_siteperiod_realestate_realestate_idx;
DROP INDEX public.ark_siteperiod_production_siteperiod_idx;
DROP INDEX public.ark_siteperiod_production_production_idx;
DROP INDEX public.ark_siteperiod_period_start_idx;
DROP INDEX public.ark_siteperiod_period_end_idx;
DROP INDEX public.ark_siteperiod_furniture_siteperiod_idx;
DROP INDEX public.ark_siteperiod_furniture_furniture_idx;
DROP INDEX public.ark_site_name_idx;
DROP INDEX public.ark_site_geom_idx;
DROP INDEX public.ark_site_databaseidx;
DROP INDEX public.ark_site_code_idx;
DROP INDEX public.ark_savedquery_idx;
DROP INDEX public.ark_database_name_idx;
DROP INDEX public.ark_city_name_idx;
DROP INDEX public.ark_city_geom_idx;
DROP INDEX public.ark_city_code_idx;
ALTER TABLE ONLY public.ch_user DROP CONSTRAINT ch_user_pkey;
ALTER TABLE ONLY public.ch_user_group DROP CONSTRAINT ch_user_group_pkey;
ALTER TABLE ONLY public.ch_right DROP CONSTRAINT ch_right_pkey;
ALTER TABLE ONLY public.ch_page DROP CONSTRAINT ch_page_pkey;
ALTER TABLE ONLY public.ch_module DROP CONSTRAINT ch_module_pkey;
ALTER TABLE ONLY public.ch_hook DROP CONSTRAINT ch_hook_pkey;
ALTER TABLE ONLY public.ch_group_right DROP CONSTRAINT ch_group_right_pkey;
ALTER TABLE ONLY public.ch_group DROP CONSTRAINT ch_group_pkey;
ALTER TABLE ONLY public.ch_config DROP CONSTRAINT ch_config_id_module_name_id_user_key;
ALTER TABLE ONLY public.ark_siteperiod_realestate DROP CONSTRAINT ark_siteperiod_realestate_pkey;
ALTER TABLE ONLY public.ark_siteperiod_production DROP CONSTRAINT ark_siteperiod_production_pkey;
ALTER TABLE ONLY public.ark_siteperiod_furniture DROP CONSTRAINT ark_siteperiod_furniture_pkey;
ALTER TABLE ONLY public.ark_site DROP CONSTRAINT ark_site_pkey;
ALTER TABLE ONLY public.ark_site_period DROP CONSTRAINT ark_site_period_pkey;
ALTER TABLE ONLY public.ark_savedquery DROP CONSTRAINT ark_savedquery_pkey;
ALTER TABLE ONLY public.ark_realestate DROP CONSTRAINT ark_realestate_pkey;
ALTER TABLE ONLY public.ark_production DROP CONSTRAINT ark_production_pkey;
ALTER TABLE ONLY public.ark_period DROP CONSTRAINT ark_period_pkey;
ALTER TABLE ONLY public.ark_furniture DROP CONSTRAINT ark_furniture_pkey;
ALTER TABLE ONLY public.ark_database DROP CONSTRAINT ark_database_pkey;
ALTER TABLE ONLY public.ark_database DROP CONSTRAINT ark_database_da_name_key;
ALTER TABLE ONLY public.ark_city DROP CONSTRAINT ark_city_pkey;
ALTER TABLE public.ch_user_group ALTER COLUMN ugid DROP DEFAULT;
ALTER TABLE public.ch_user ALTER COLUMN uid DROP DEFAULT;
ALTER TABLE public.ch_right ALTER COLUMN rid DROP DEFAULT;
ALTER TABLE public.ch_page ALTER COLUMN pid DROP DEFAULT;
ALTER TABLE public.ch_module ALTER COLUMN mid DROP DEFAULT;
ALTER TABLE public.ch_hook ALTER COLUMN hid DROP DEFAULT;
ALTER TABLE public.ch_group_right ALTER COLUMN grid DROP DEFAULT;
ALTER TABLE public.ch_group ALTER COLUMN gid DROP DEFAULT;
ALTER TABLE public.ark_siteperiod_realestate ALTER COLUMN sr_id DROP DEFAULT;
ALTER TABLE public.ark_siteperiod_production ALTER COLUMN sp_id DROP DEFAULT;
ALTER TABLE public.ark_siteperiod_furniture ALTER COLUMN sf_id DROP DEFAULT;
ALTER TABLE public.ark_site_period ALTER COLUMN sp_id DROP DEFAULT;
ALTER TABLE public.ark_site ALTER COLUMN si_id DROP DEFAULT;
ALTER TABLE public.ark_savedquery ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.ark_database ALTER COLUMN da_id DROP DEFAULT;
ALTER TABLE public.ark_city ALTER COLUMN ci_id DROP DEFAULT;
DROP SEQUENCE public.ch_user_uid_seq;
DROP SEQUENCE public.ch_user_group_ugid_seq;
DROP TABLE public.ch_user_group;
DROP TABLE public.ch_user;
DROP TABLE public.ch_smarty_plugins;
DROP TABLE public.ch_smarty_override;
DROP SEQUENCE public.ch_right_rid_seq;
DROP TABLE public.ch_right;
DROP TABLE public.ch_regroute;
DROP SEQUENCE public.ch_page_pid_seq;
DROP TABLE public.ch_page;
DROP SEQUENCE public.ch_module_mid_seq;
DROP TABLE public.ch_module;
DROP SEQUENCE public.ch_hook_hid_seq;
DROP TABLE public.ch_hook;
DROP SEQUENCE public.ch_group_right_grid_seq;
DROP TABLE public.ch_group_right;
DROP SEQUENCE public.ch_group_gid_seq;
DROP TABLE public.ch_group;
DROP TABLE public.ch_config;
DROP SEQUENCE public.ark_siteperiod_realestate_sr_id_seq;
DROP TABLE public.ark_siteperiod_realestate;
DROP SEQUENCE public.ark_siteperiod_production_sp_id_seq;
DROP TABLE public.ark_siteperiod_production;
DROP SEQUENCE public.ark_siteperiod_furniture_sf_id_seq;
DROP TABLE public.ark_siteperiod_furniture;
DROP SEQUENCE public.ark_site_si_id_seq;
DROP SEQUENCE public.ark_site_period_sp_id_seq;
DROP TABLE public.ark_site_period;
DROP TABLE public.ark_site;
DROP SEQUENCE public.ark_savedquery_id_seq;
DROP TABLE public.ark_savedquery;
DROP TABLE public.ark_realestate;
DROP TABLE public.ark_production;
DROP TABLE public.ark_period;
DROP TABLE public.ark_furniture;
DROP SEQUENCE public.ark_database_da_id_seq;
DROP TABLE public.ark_database;
DROP SEQUENCE public.ark_city_ci_id_seq;
DROP TABLE public.ark_city;
SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ark_city; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_city (
    ci_id integer NOT NULL,
    ci_code character varying(50),
    ci_name character varying(255) DEFAULT NULL::character varying,
    ci_nameupper character varying(255) DEFAULT NULL::character varying,
    ci_country character(2) DEFAULT NULL::bpchar,
    ci_geom geometry,
    CONSTRAINT enforce_dims_ci_geom CHECK ((st_ndims(ci_geom) = 2)),
    CONSTRAINT enforce_geotype_ci_geom CHECK (((geometrytype(ci_geom) = 'POINT'::text) OR (ci_geom IS NULL))),
    CONSTRAINT enforce_srid_ci_geom CHECK ((st_srid(ci_geom) = 4326))
);


ALTER TABLE public.ark_city OWNER TO arkeogisadm;

--
-- Name: ark_city_ci_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_city_ci_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_city_ci_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_city_ci_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_city_ci_id_seq OWNED BY ark_city.ci_id;

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

--
-- Name: ark_database; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_database (
    da_id integer NOT NULL,
    da_name character varying(100) NOT NULL,
    da_description text,
    da_description_de text,
    da_owner_id integer,
    da_type ark_database_type,
    da_geographical_limit text,
    da_geographical_limit_de text,
    da_issn character varying(30),
    da_lines integer,
    da_period_start integer,
    da_period_end integer,
    da_creation timestamp without time zone NOT NULL,
    da_modification timestamp without time zone
);


ALTER TABLE public.ark_database OWNER TO arkeogisadm;

--
-- Name: ark_database_da_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_database_da_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_database_da_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_database_da_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_database_da_id_seq OWNED BY ark_database.da_id;

--
-- Name: ark_furniture; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_database_log (
    dl_id integer NOT NULL,
    dl_database_id integer NOT NULL,
    dl_user_id integer NOT NULL,
    dl_date date,
    dl_csv_file character varying(100)
);


ALTER TABLE public.ark_database_log OWNER TO arkeogisadm;

--
-- Name: ark_site_occupation_type; Type: TYPE; Schema: public; Owner: captainhook
--

CREATE TYPE ark_site_occupation_type AS ENUM (
    'unknown',
    'uniq',
    'continuous',
    'multiple'
);


ALTER TYPE public.ark_site_occupation_type OWNER TO captainhook;

--
-- Name: ark_siteperiod_knowledge_type; Type: TYPE; Schema: public; Owner: captainhook
--

CREATE TYPE ark_siteperiod_knowledge_type AS ENUM (
    'unknown',
    'literature',
    'surveyed',
    'excavated'
);


ALTER TYPE public.ark_siteperiod_knowledge_type OWNER TO captainhook;


--
-- Name: ark_furniture; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_furniture (
    fu_id integer NOT NULL,
    fu_parentid integer,
    fu_name_fr character varying(100),
    fu_name_de character varying(100),
    fu_desc character varying(100),
    node_path ltree
);


ALTER TABLE public.ark_furniture OWNER TO arkeogisadm;

--
-- Name: ark_period; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_period (
    pe_id integer NOT NULL,
    pe_parentid integer,
    pe_name_fr character varying(100),
    pe_name_de character varying(100),
    pe_desc character varying(100),
    node_path ltree
);


ALTER TABLE public.ark_period OWNER TO arkeogisadm;

--
-- Name: ark_production; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_production (
    pr_id integer NOT NULL,
    pr_parentid integer,
    pr_name_fr character varying(100),
    pr_name_de character varying(100),
    pr_desc character varying(100),
    node_path ltree
);


ALTER TABLE public.ark_production OWNER TO arkeogisadm;

--
-- Name: ark_realestate; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_realestate (
    re_id integer NOT NULL,
    re_parentid integer,
    re_name_fr character varying(100),
    re_name_de character varying(100),
    re_desc character varying(100),
    node_path ltree
);


ALTER TABLE public.ark_realestate OWNER TO arkeogisadm;

--
-- Name: ark_savedquery; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_savedquery (
    id integer NOT NULL,
    id_user integer,
    name character varying(255),
    query text
);


ALTER TABLE public.ark_savedquery OWNER TO arkeogisadm;

--
-- Name: ark_savedquery_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_savedquery_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_savedquery_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_savedquery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_savedquery_id_seq OWNED BY ark_savedquery.id;


--
-- Name: ark_site; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_site (
    si_id integer NOT NULL,
    si_code character varying(50),
    si_database_id integer NOT NULL,
    si_author_id integer NOT NULL,
    si_name character varying(255) NOT NULL,
    si_description text,
    si_city_id integer,
    si_centroid smallint DEFAULT 0 NOT NULL,
    si_occupation ark_site_occupation_type,
    si_city_name character varying(255) NOT NULL,
    si_city_code character varying(255) NOT NULL,
    si_creation timestamp without time zone NOT NULL,
    si_modification timestamp without time zone,
    si_geom geometry,
    CONSTRAINT enforce_dims_si_geom CHECK ((st_ndims(si_geom) = 3)),
    CONSTRAINT enforce_geotype_si_geom CHECK (((geometrytype(si_geom) = 'POINT'::text) OR (si_geom IS NULL))),
    CONSTRAINT enforce_srid_si_geom CHECK ((st_srid(si_geom) = 4326))
);


ALTER TABLE public.ark_site OWNER TO arkeogisadm;

--
-- Name: ark_site_period; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_site_period (
    sp_id integer NOT NULL,
    sp_site_id integer NOT NULL,
    sp_period_start integer NOT NULL,
    sp_period_end integer NOT NULL,
    sp_period_isrange smallint DEFAULT 0 NOT NULL,
    sp_knowledge_type ark_siteperiod_knowledge_type DEFAULT 'unknown'::ark_siteperiod_knowledge_type,
    sp_soil_type character varying(255) DEFAULT NULL::character varying,
    sp_superfical_type character varying(255) DEFAULT NULL::character varying,
    sp_analysis character varying(255) DEFAULT NULL::character varying,
    sp_paleosol character varying(255) DEFAULT NULL::character varying,
    sp_date_dendro date,
    "sp_date_14C" date,
    sp_comment text,
    sp_bibliography text,
    sp_depth integer
);


ALTER TABLE public.ark_site_period OWNER TO arkeogisadm;

--
-- Name: ark_site_period_sp_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_site_period_sp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_site_period_sp_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_site_period_sp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_site_period_sp_id_seq OWNED BY ark_site_period.sp_id;


--
-- Name: ark_site_si_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_site_si_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_site_si_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_site_si_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_site_si_id_seq OWNED BY ark_site.si_id;


--
-- Name: ark_siteperiod_furniture; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_siteperiod_furniture (
    sf_id integer NOT NULL,
    sf_site_period_id integer NOT NULL,
    sf_furniture_id integer NOT NULL,
    sf_exceptional smallint DEFAULT 0
);


ALTER TABLE public.ark_siteperiod_furniture OWNER TO arkeogisadm;

--
-- Name: ark_siteperiod_furniture_sf_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_siteperiod_furniture_sf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_siteperiod_furniture_sf_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_siteperiod_furniture_sf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_siteperiod_furniture_sf_id_seq OWNED BY ark_siteperiod_furniture.sf_id;


--
-- Name: ark_siteperiod_production; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_siteperiod_production (
    sp_id integer NOT NULL,
    sp_site_period_id integer NOT NULL,
    sp_production_id integer NOT NULL,
    sp_exceptional smallint DEFAULT 0
);


ALTER TABLE public.ark_siteperiod_production OWNER TO arkeogisadm;

--
-- Name: ark_siteperiod_production_sp_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_siteperiod_production_sp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_siteperiod_production_sp_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_siteperiod_production_sp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_siteperiod_production_sp_id_seq OWNED BY ark_siteperiod_production.sp_id;


--
-- Name: ark_siteperiod_realestate; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ark_siteperiod_realestate (
    sr_id integer NOT NULL,
    sr_site_period_id integer NOT NULL,
    sr_realestate_id integer NOT NULL,
    sr_exceptional smallint DEFAULT 0
);


ALTER TABLE public.ark_siteperiod_realestate OWNER TO arkeogisadm;

--
-- Name: ark_siteperiod_realestate_sr_id_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ark_siteperiod_realestate_sr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ark_siteperiod_realestate_sr_id_seq OWNER TO arkeogisadm;

--
-- Name: ark_siteperiod_realestate_sr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ark_siteperiod_realestate_sr_id_seq OWNED BY ark_siteperiod_realestate.sr_id;


--
-- Name: ch_config; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_config (
    id_module integer NOT NULL,
    name character varying(255) NOT NULL,
    value text NOT NULL,
    id_user integer
);


ALTER TABLE public.ch_config OWNER TO arkeogisadm;

--
-- Name: ch_group; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_group (
    gid integer NOT NULL,
    name character varying(255) NOT NULL,
    status smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.ch_group OWNER TO arkeogisadm;

--
-- Name: ch_group_gid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_group_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_group_gid_seq OWNER TO arkeogisadm;

--
-- Name: ch_group_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_group_gid_seq OWNED BY ch_group.gid;


--
-- Name: ch_group_right; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_group_right (
    grid integer NOT NULL,
    gid integer NOT NULL,
    rid integer
);


ALTER TABLE public.ch_group_right OWNER TO arkeogisadm;

--
-- Name: ch_group_right_grid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_group_right_grid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_group_right_grid_seq OWNER TO arkeogisadm;

--
-- Name: ch_group_right_grid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_group_right_grid_seq OWNED BY ch_group_right.grid;


--
-- Name: ch_hook; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_hook (
    hid integer NOT NULL,
    name character varying(255) NOT NULL,
    mid integer,
    callback character varying(255) NOT NULL,
    userdata character varying(255),
    "position" integer NOT NULL
);


ALTER TABLE public.ch_hook OWNER TO arkeogisadm;

--
-- Name: ch_hook_hid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_hook_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_hook_hid_seq OWNER TO arkeogisadm;

--
-- Name: ch_hook_hid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_hook_hid_seq OWNED BY ch_hook.hid;


--
-- Name: ch_module; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_module (
    mid integer NOT NULL,
    name character varying(50) NOT NULL,
    active smallint DEFAULT 0
);


ALTER TABLE public.ch_module OWNER TO arkeogisadm;

--
-- Name: ch_module_mid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_module_mid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_module_mid_seq OWNER TO arkeogisadm;

--
-- Name: ch_module_mid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_module_mid_seq OWNED BY ch_module.mid;


--
-- Name: ch_page; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_page (
    pid integer NOT NULL,
    sysname character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    authorid integer DEFAULT 0 NOT NULL,
    published smallint DEFAULT 0 NOT NULL,
    content text,
    lang character varying(5),
    id_lang_reference integer,
    created timestamp without time zone,
    updated timestamp without time zone
);


ALTER TABLE public.ch_page OWNER TO arkeogisadm;

--
-- Name: ch_page_pid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_page_pid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_page_pid_seq OWNER TO arkeogisadm;

--
-- Name: ch_page_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_page_pid_seq OWNED BY ch_page.pid;


--
-- Name: ch_regroute; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_regroute (
    id_module integer,
    regexp character varying(255) NOT NULL,
    hook character varying(255) NOT NULL,
    flags integer NOT NULL
);


ALTER TABLE public.ch_regroute OWNER TO arkeogisadm;

--
-- Name: ch_right; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_right (
    rid integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(100) DEFAULT NULL::character varying
);


ALTER TABLE public.ch_right OWNER TO arkeogisadm;

--
-- Name: ch_right_rid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_right_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_right_rid_seq OWNER TO arkeogisadm;

--
-- Name: ch_right_rid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_right_rid_seq OWNED BY ch_right.rid;


--
-- Name: ch_smarty_override; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_smarty_override (
    id_module integer,
    orig character varying(255) NOT NULL,
    replace character varying(255) NOT NULL
);


ALTER TABLE public.ch_smarty_override OWNER TO arkeogisadm;

--
-- Name: ch_smarty_plugins; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TYPE ch_smarty_plugintype AS ENUM (
	'function',
	'block',
	'compiler',
	'modifier',
	'preFilter',
	'postFilter',
	'outputFilter'
);

ALTER TYPE public.ch_smarty_plugintype OWNER TO arkeogisadm;

CREATE TABLE ch_smarty_plugins (
    id_module integer,
    name character varying(255) NOT NULL,
    type ch_smarty_plugintype NOT NULL,
    method character varying(255) NOT NULL
);

ALTER TABLE public.ch_smarty_plugins OWNER TO arkeogisadm;

--
-- Name: ch_user; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_user (
    uid integer NOT NULL,
    full_name character varying(255) NOT NULL,
    login character varying(32) NOT NULL,
    pass character varying(32) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    hash character varying(64) DEFAULT NULL::character varying,
    status smallint DEFAULT 1 NOT NULL,
    created timestamp without time zone,
    updated timestamp without time zone,
    last_connexion timestamp without time zone
);


ALTER TABLE public.ch_user OWNER TO arkeogisadm;

--
-- Name: ch_user_group; Type: TABLE; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE TABLE ch_user_group (
    ugid integer NOT NULL,
    uid integer NOT NULL,
    gid integer
);


ALTER TABLE public.ch_user_group OWNER TO arkeogisadm;

--
-- Name: ch_user_group_ugid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_user_group_ugid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_user_group_ugid_seq OWNER TO arkeogisadm;

--
-- Name: ch_user_group_ugid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_user_group_ugid_seq OWNED BY ch_user_group.ugid;


--
-- Name: ch_user_uid_seq; Type: SEQUENCE; Schema: public; Owner: arkeogisadm
--

CREATE SEQUENCE ch_user_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_user_uid_seq OWNER TO arkeogisadm;

--
-- Name: ch_user_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: arkeogisadm
--

ALTER SEQUENCE ch_user_uid_seq OWNED BY ch_user.uid;


--
-- Name: ci_id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_city ALTER COLUMN ci_id SET DEFAULT nextval('ark_city_ci_id_seq'::regclass);


--
-- Name: da_id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_database ALTER COLUMN da_id SET DEFAULT nextval('ark_database_da_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_savedquery ALTER COLUMN id SET DEFAULT nextval('ark_savedquery_id_seq'::regclass);


--
-- Name: si_id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_site ALTER COLUMN si_id SET DEFAULT nextval('ark_site_si_id_seq'::regclass);


--
-- Name: sp_id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_site_period ALTER COLUMN sp_id SET DEFAULT nextval('ark_site_period_sp_id_seq'::regclass);


--
-- Name: sf_id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_furniture ALTER COLUMN sf_id SET DEFAULT nextval('ark_siteperiod_furniture_sf_id_seq'::regclass);


--
-- Name: sp_id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_production ALTER COLUMN sp_id SET DEFAULT nextval('ark_siteperiod_production_sp_id_seq'::regclass);


--
-- Name: sr_id; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_realestate ALTER COLUMN sr_id SET DEFAULT nextval('ark_siteperiod_realestate_sr_id_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_group ALTER COLUMN gid SET DEFAULT nextval('ch_group_gid_seq'::regclass);


--
-- Name: grid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_group_right ALTER COLUMN grid SET DEFAULT nextval('ch_group_right_grid_seq'::regclass);


--
-- Name: hid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_hook ALTER COLUMN hid SET DEFAULT nextval('ch_hook_hid_seq'::regclass);


--
-- Name: mid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_module ALTER COLUMN mid SET DEFAULT nextval('ch_module_mid_seq'::regclass);


--
-- Name: pid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_page ALTER COLUMN pid SET DEFAULT nextval('ch_page_pid_seq'::regclass);


--
-- Name: rid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_right ALTER COLUMN rid SET DEFAULT nextval('ch_right_rid_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_user ALTER COLUMN uid SET DEFAULT nextval('ch_user_uid_seq'::regclass);


--
-- Name: ugid; Type: DEFAULT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_user_group ALTER COLUMN ugid SET DEFAULT nextval('ch_user_group_ugid_seq'::regclass);


--
-- Name: ark_city_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_city
    ADD CONSTRAINT ark_city_pkey PRIMARY KEY (ci_id);


--
-- Name: ark_database_da_name_key; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_database
    ADD CONSTRAINT ark_database_da_name_key UNIQUE (da_name);


--
-- Name: ark_database_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_database
    ADD CONSTRAINT ark_database_pkey PRIMARY KEY (da_id);

--
-- Name: ark_database_log_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_database_log
    ADD CONSTRAINT ark_database_log_pkey PRIMARY KEY (dl_id);

--
-- Name: ark_furniture_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_furniture
    ADD CONSTRAINT ark_furniture_pkey PRIMARY KEY (fu_id);


--
-- Name: ark_period_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_period
    ADD CONSTRAINT ark_period_pkey PRIMARY KEY (pe_id);


--
-- Name: ark_production_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_production
    ADD CONSTRAINT ark_production_pkey PRIMARY KEY (pr_id);


--
-- Name: ark_realestate_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_realestate
    ADD CONSTRAINT ark_realestate_pkey PRIMARY KEY (re_id);


--
-- Name: ark_savedquery_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_savedquery
    ADD CONSTRAINT ark_savedquery_pkey PRIMARY KEY (id);


--
-- Name: ark_site_period_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_site_period
    ADD CONSTRAINT ark_site_period_pkey PRIMARY KEY (sp_id);


--
-- Name: ark_site_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_site
    ADD CONSTRAINT ark_site_pkey PRIMARY KEY (si_id);


--
-- Name: ark_siteperiod_furniture_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_siteperiod_furniture
    ADD CONSTRAINT ark_siteperiod_furniture_pkey PRIMARY KEY (sf_id);


--
-- Name: ark_siteperiod_production_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_siteperiod_production
    ADD CONSTRAINT ark_siteperiod_production_pkey PRIMARY KEY (sp_id);


--
-- Name: ark_siteperiod_realestate_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ark_siteperiod_realestate
    ADD CONSTRAINT ark_siteperiod_realestate_pkey PRIMARY KEY (sr_id);


--
-- Name: ch_config_id_module_name_id_user_key; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_config
    ADD CONSTRAINT ch_config_id_module_name_id_user_key UNIQUE (id_module, name, id_user);


--
-- Name: ch_group_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_group
    ADD CONSTRAINT ch_group_pkey PRIMARY KEY (gid);


--
-- Name: ch_group_right_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_group_right
    ADD CONSTRAINT ch_group_right_pkey PRIMARY KEY (grid);


--
-- Name: ch_hook_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_hook
    ADD CONSTRAINT ch_hook_pkey PRIMARY KEY (hid);


--
-- Name: ch_module_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_module
    ADD CONSTRAINT ch_module_pkey PRIMARY KEY (mid);


--
-- Name: ch_page_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_page
    ADD CONSTRAINT ch_page_pkey PRIMARY KEY (pid);


--
-- Name: ch_right_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_right
    ADD CONSTRAINT ch_right_pkey PRIMARY KEY (rid);


--
-- Name: ch_user_group_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_user_group
    ADD CONSTRAINT ch_user_group_pkey PRIMARY KEY (ugid);


--
-- Name: ch_user_pkey; Type: CONSTRAINT; Schema: public; Owner: arkeogisadm; Tablespace: 
--

ALTER TABLE ONLY ch_user
    ADD CONSTRAINT ch_user_pkey PRIMARY KEY (uid);


--
-- Name: ark_city_code_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE UNIQUE INDEX ark_city_code_idx ON ark_city USING btree (ci_code, ci_country);


--
-- Name: ark_city_geom_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_city_geom_idx ON ark_city USING gist (ci_geom);


--
-- Name: ark_city_name_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_city_name_idx ON ark_city USING btree (ci_name);


--
-- Name: ark_database_name_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_database_name_idx ON ark_database USING btree (da_name);


--
-- Name: ark_savedquery_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE UNIQUE INDEX ark_savedquery_idx ON ark_savedquery USING btree (id);


--
-- Name: ark_site_code_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_site_code_idx ON ark_site USING btree (si_code);


--
-- Name: ark_site_databaseidx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_site_databaseidx ON ark_site USING btree (si_database_id);


--
-- Name: ark_site_geom_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_site_geom_idx ON ark_site USING gist (si_geom);


--
-- Name: ark_site_name_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_site_name_idx ON ark_site USING btree (si_name);


--
-- Name: ark_siteperiod_furniture_furniture_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_furniture_furniture_idx ON ark_siteperiod_furniture USING btree (sf_furniture_id);


--
-- Name: ark_siteperiod_furniture_siteperiod_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_furniture_siteperiod_idx ON ark_siteperiod_furniture USING btree (sf_site_period_id);


--
-- Name: ark_siteperiod_period_end_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_period_end_idx ON ark_site_period USING btree (sp_period_end);


--
-- Name: ark_siteperiod_period_start_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_period_start_idx ON ark_site_period USING btree (sp_period_start);


--
-- Name: ark_siteperiod_production_production_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_production_production_idx ON ark_siteperiod_production USING btree (sp_production_id);


--
-- Name: ark_siteperiod_production_siteperiod_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_production_siteperiod_idx ON ark_siteperiod_production USING btree (sp_site_period_id);


--
-- Name: ark_siteperiod_realestate_realestate_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_realestate_realestate_idx ON ark_siteperiod_realestate USING btree (sr_realestate_id);


--
-- Name: ark_siteperiod_realestate_siteperiod_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_realestate_siteperiod_idx ON ark_siteperiod_realestate USING btree (sr_site_period_id);


--
-- Name: ark_siteperiod_site_id_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ark_siteperiod_site_id_idx ON ark_site_period USING btree (sp_site_id);


--
-- Name: ch_config_id_module_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_config_id_module_idx ON ch_config USING btree (id_module);


--
-- Name: ch_config_id_user_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_config_id_user_idx ON ch_config USING btree (id_user);


--
-- Name: ch_config_name_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_config_name_idx ON ch_config USING btree (name);


--
-- Name: ch_group_right_gid_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_group_right_gid_idx ON ch_group_right USING btree (gid);


--
-- Name: ch_group_right_rid_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_group_right_rid_idx ON ch_group_right USING btree (rid);


--
-- Name: ch_hook_mid_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_hook_mid_idx ON ch_hook USING btree (mid);


--
-- Name: ch_module_name_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_module_name_idx ON ch_module USING btree (name);


--
-- Name: ch_regroute_id_module_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_regroute_id_module_idx ON ch_regroute USING btree (id_module);


--
-- Name: ch_right_name_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_right_name_idx ON ch_right USING btree (name);


--
-- Name: ch_smarty_override_id_module_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_smarty_override_id_module_idx ON ch_smarty_override USING btree (id_module);


--
-- Name: ch_smarty_override_orig_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_smarty_override_orig_idx ON ch_smarty_override USING btree (orig);


--
-- Name: ch_smarty_plugins_id_module_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_smarty_plugins_id_module_idx ON ch_smarty_plugins USING btree (id_module);


--
-- Name: ch_smarty_plugins_name_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_smarty_plugins_name_idx ON ch_smarty_plugins USING btree (name);


--
-- Name: ch_user_group_gid_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_user_group_gid_idx ON ch_user_group USING btree (gid);


--
-- Name: ch_user_group_uid_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX ch_user_group_uid_idx ON ch_user_group USING btree (uid);


--
-- Name: idx_ark_furniture_node_path_btree_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE UNIQUE INDEX idx_ark_furniture_node_path_btree_idx ON ark_furniture USING btree (node_path);


--
-- Name: idx_ark_furniture_node_path_gist_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX idx_ark_furniture_node_path_gist_idx ON ark_furniture USING gist (node_path);


--
-- Name: idx_ark_period_node_path_btree_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE UNIQUE INDEX idx_ark_period_node_path_btree_idx ON ark_period USING btree (node_path);


--
-- Name: idx_ark_period_node_path_gist_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX idx_ark_period_node_path_gist_idx ON ark_period USING gist (node_path);


--
-- Name: idx_ark_production_node_path_btree_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE UNIQUE INDEX idx_ark_production_node_path_btree_idx ON ark_production USING btree (node_path);


--
-- Name: idx_ark_production_node_path_gist_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX idx_ark_production_node_path_gist_idx ON ark_production USING gist (node_path);


--
-- Name: idx_ark_realestate_node_path_btree_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE UNIQUE INDEX idx_ark_realestate_node_path_btree_idx ON ark_realestate USING btree (node_path);


--
-- Name: idx_ark_realestate_node_path_gist_idx; Type: INDEX; Schema: public; Owner: arkeogisadm; Tablespace: 
--

CREATE INDEX idx_ark_realestate_node_path_gist_idx ON ark_realestate USING gist (node_path);


--
-- Name: trig01_update_fu_node_path; Type: TRIGGER; Schema: public; Owner: arkeogisadm
--

CREATE TRIGGER trig01_update_fu_node_path AFTER INSERT OR UPDATE ON ark_furniture FOR EACH ROW EXECUTE PROCEDURE trig_update_fu_node_path();


--
-- Name: trig01_update_pe_node_path; Type: TRIGGER; Schema: public; Owner: arkeogisadm
--

CREATE TRIGGER trig01_update_pe_node_path AFTER INSERT OR UPDATE ON ark_period FOR EACH ROW EXECUTE PROCEDURE trig_update_pe_node_path();


--
-- Name: trig01_update_pr_node_path; Type: TRIGGER; Schema: public; Owner: arkeogisadm
--

CREATE TRIGGER trig01_update_pr_node_path AFTER INSERT OR UPDATE ON ark_production FOR EACH ROW EXECUTE PROCEDURE trig_update_pr_node_path();


--
-- Name: trig01_update_re_node_path; Type: TRIGGER; Schema: public; Owner: arkeogisadm
--

CREATE TRIGGER trig01_update_re_node_path AFTER INSERT OR UPDATE ON ark_realestate FOR EACH ROW EXECUTE PROCEDURE trig_update_re_node_path();


--
-- Name: ark_site_period_sp_period_end_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_site_period
    ADD CONSTRAINT ark_site_period_sp_period_end_fkey FOREIGN KEY (sp_period_end) REFERENCES ark_period(pe_id);


--
-- Name: ark_site_period_sp_period_start_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_site_period
    ADD CONSTRAINT ark_site_period_sp_period_start_fkey FOREIGN KEY (sp_period_start) REFERENCES ark_period(pe_id);


--
-- Name: ark_site_period_sp_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_site_period
    ADD CONSTRAINT ark_site_period_sp_site_id_fkey FOREIGN KEY (sp_site_id) REFERENCES ark_site(si_id) ON DELETE CASCADE;


--
-- Name: ark_site_si_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_site
    ADD CONSTRAINT ark_site_si_city_id_fkey FOREIGN KEY (si_city_id) REFERENCES ark_city(ci_id);


--
-- Name: ark_site_si_database_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_site
    ADD CONSTRAINT ark_site_si_database_id_fkey FOREIGN KEY (si_database_id) REFERENCES ark_database(da_id) ON DELETE CASCADE;


--
-- Name: ark_siteperiod_furniture_sf_furniture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_furniture
    ADD CONSTRAINT ark_siteperiod_furniture_sf_furniture_id_fkey FOREIGN KEY (sf_furniture_id) REFERENCES ark_furniture(fu_id) ON DELETE CASCADE;


--
-- Name: ark_siteperiod_furniture_sf_site_period_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_furniture
    ADD CONSTRAINT ark_siteperiod_furniture_sf_site_period_id_fkey FOREIGN KEY (sf_site_period_id) REFERENCES ark_site_period(sp_id) ON DELETE CASCADE;


--
-- Name: ark_siteperiod_production_sp_production_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_production
    ADD CONSTRAINT ark_siteperiod_production_sp_production_id_fkey FOREIGN KEY (sp_production_id) REFERENCES ark_production(pr_id) ON DELETE CASCADE;


--
-- Name: ark_siteperiod_production_sp_site_period_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_production
    ADD CONSTRAINT ark_siteperiod_production_sp_site_period_id_fkey FOREIGN KEY (sp_site_period_id) REFERENCES ark_site_period(sp_id) ON DELETE CASCADE;


--
-- Name: ark_siteperiod_realestate_sr_realestate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_realestate
    ADD CONSTRAINT ark_siteperiod_realestate_sr_realestate_id_fkey FOREIGN KEY (sr_realestate_id) REFERENCES ark_realestate(re_id) ON DELETE CASCADE;


--
-- Name: ark_siteperiod_realestate_sr_site_period_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_siteperiod_realestate
    ADD CONSTRAINT ark_siteperiod_realestate_sr_site_period_id_fkey FOREIGN KEY (sr_site_period_id) REFERENCES ark_site_period(sp_id) ON DELETE CASCADE;


--
-- Name: ch_config_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ch_config
    ADD CONSTRAINT ch_config_id_user_fkey FOREIGN KEY (id_user) REFERENCES ch_user(uid) ON DELETE CASCADE;


--
-- Name: ark_database_log_dl_database_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: arkeogisadm
--

ALTER TABLE ONLY ark_database_log
    ADD CONSTRAINT ark_database_log_dl_database_id_fkey FOREIGN KEY (dl_database_id) REFERENCES ark_database(da_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

