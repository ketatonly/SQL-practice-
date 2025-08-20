--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-12 14:05:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 850 (class 1247 OID 25106)
-- Name: quality; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.quality AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
);


ALTER TYPE public.quality OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 25127)
-- Name: finances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.finances (
    org_id integer NOT NULL,
    p_id integer NOT NULL,
    amount numeric(8,2) NOT NULL
);


ALTER TABLE public.finances OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25130)
-- Name: organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization (
    org_id integer NOT NULL,
    org_name character varying(100) NOT NULL
);


ALTER TABLE public.organization OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25133)
-- Name: organization_org_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_org_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organization_org_id_seq OWNER TO postgres;

--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 217
-- Name: organization_org_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_org_id_seq OWNED BY public.organization.org_id;


--
-- TOC entry 218 (class 1259 OID 25134)
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    p_id integer NOT NULL,
    p_title character varying(100) NOT NULL,
    t_cost numeric(10,2) NOT NULL,
    startdate date,
    enddate date
);


ALTER TABLE public.project OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25137)
-- Name: project_p_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.project_p_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_p_id_seq OWNER TO postgres;

--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 219
-- Name: project_p_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.project_p_id_seq OWNED BY public.project.p_id;


--
-- TOC entry 220 (class 1259 OID 25138)
-- Name: r_water; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.r_water (
    rw_id integer NOT NULL,
    rw_name character varying(40) NOT NULL,
    rw_quality public.quality,
    rw_length numeric,
    rw_flows_into integer
);


ALTER TABLE public.r_water OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25143)
-- Name: researcher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.researcher (
    r_email character varying(80) NOT NULL,
    r_name character varying NOT NULL,
    org_id integer NOT NULL
);


ALTER TABLE public.researcher OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25148)
-- Name: rw_research; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rw_research (
    rw_id integer NOT NULL,
    p_id integer NOT NULL
);


ALTER TABLE public.rw_research OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25151)
-- Name: s_water; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.s_water (
    sw_id integer NOT NULL,
    sw_name character varying(50) NOT NULL,
    sw_quality public.quality NOT NULL,
    surface numeric,
    CONSTRAINT s_water_sw_id_check CHECK (((sw_id >= 2000) AND (sw_id <= 2999)))
);


ALTER TABLE public.s_water OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25157)
-- Name: sw_research; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sw_research (
    sw_id integer NOT NULL,
    p_id integer NOT NULL
);


ALTER TABLE public.sw_research OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25160)
-- Name: works_on; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.works_on (
    r_email character varying(80) NOT NULL,
    p_id integer NOT NULL,
    w_function character varying(100) NOT NULL
);


ALTER TABLE public.works_on OWNER TO postgres;

--
-- TOC entry 4724 (class 2604 OID 25163)
-- Name: organization org_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization ALTER COLUMN org_id SET DEFAULT nextval('public.organization_org_id_seq'::regclass);


--
-- TOC entry 4725 (class 2604 OID 25164)
-- Name: project p_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project ALTER COLUMN p_id SET DEFAULT nextval('public.project_p_id_seq'::regclass);


--
-- TOC entry 4901 (class 0 OID 25127)
-- Dependencies: 215
-- Data for Name: finances; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.finances VALUES (2, 1, 10000.00);
INSERT INTO public.finances VALUES (2, 2, 100000.00);
INSERT INTO public.finances VALUES (2, 3, 1000.00);
INSERT INTO public.finances VALUES (3, 3, 4000.00);
INSERT INTO public.finances VALUES (4, 2, 15000.00);


--
-- TOC entry 4902 (class 0 OID 25130)
-- Dependencies: 216
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.organization VALUES (1, 'GreenGeorgia');
INSERT INTO public.organization VALUES (2, 'Nature Bank');
INSERT INTO public.organization VALUES (3, 'RiverManagement');
INSERT INTO public.organization VALUES (4, 'NatureFund');
INSERT INTO public.organization VALUES (5, 'FutureFoundation');


--
-- TOC entry 4904 (class 0 OID 25134)
-- Dependencies: 218
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.project VALUES (1, 'Research on sodium content of water bodies in Georgia.', 100000.00, '2024-01-03', '2025-01-03');
INSERT INTO public.project VALUES (2, 'Improving water quality', 2000000.00, '2020-01-03', NULL);
INSERT INTO public.project VALUES (3, 'Fish wealth', 5000.00, '2023-03-01', NULL);
INSERT INTO public.project VALUES (4, 'Endemic water species', 20000.00, '2024-08-01', NULL);


--
-- TOC entry 4906 (class 0 OID 25138)
-- Dependencies: 220
-- Data for Name: r_water; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.r_water VALUES (1000, 'Rioni', '2', 400, NULL);
INSERT INTO public.r_water VALUES (1001, 'Mtkvari', '1', 560, NULL);
INSERT INTO public.r_water VALUES (1002, 'Aragvi', '5', 120, 1001);
INSERT INTO public.r_water VALUES (1003, 'MtisChala', '8', NULL, 1010);
INSERT INTO public.r_water VALUES (1004, 'Alasani', '1', 1000, NULL);
INSERT INTO public.r_water VALUES (1005, 'Kvirila', '5', NULL, 1000);
INSERT INTO public.r_water VALUES (1006, 'WhiteAragvi', '5', NULL, 1002);
INSERT INTO public.r_water VALUES (1007, 'Lekhura', '8', NULL, 1006);
INSERT INTO public.r_water VALUES (1008, 'BlackAragvi', '7', NULL, 1002);
INSERT INTO public.r_water VALUES (1009, 'BzovisTskali', '10', NULL, 1008);
INSERT INTO public.r_water VALUES (1010, 'Tskatsitela', '6', NULL, 1005);
INSERT INTO public.r_water VALUES (1011, 'KhevsuretiAragvi', '7', NULL, 1006);
INSERT INTO public.r_water VALUES (1015, 'Enguri', NULL, NULL, 1000);


--
-- TOC entry 4907 (class 0 OID 25143)
-- Dependencies: 221
-- Data for Name: researcher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.researcher VALUES ('aron@banknature.ge', 'aron', 2);
INSERT INTO public.researcher VALUES ('hope@naturefund.ge', 'hope', 4);
INSERT INTO public.researcher VALUES ('klopp@gg.ge', 'klopp', 1);
INSERT INTO public.researcher VALUES ('lion@mgmtriver.ge', 'lion', 3);
INSERT INTO public.researcher VALUES ('lisa@naturefund.ge', 'lisa', 4);
INSERT INTO public.researcher VALUES ('neil@mgmtriver.ge', 'neil', 3);
INSERT INTO public.researcher VALUES ('summer@naturefund.ge', 'summer', 4);
INSERT INTO public.researcher VALUES ('winter@gg.ge', 'winter', 1);


--
-- TOC entry 4908 (class 0 OID 25148)
-- Dependencies: 222
-- Data for Name: rw_research; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rw_research VALUES (1001, 1);
INSERT INTO public.rw_research VALUES (1004, 2);


--
-- TOC entry 4909 (class 0 OID 25151)
-- Dependencies: 223
-- Data for Name: s_water; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.s_water VALUES (2000, 'KIU_lake', '10', NULL);
INSERT INTO public.s_water VALUES (2001, 'KoditskaroLake', '9', NULL);
INSERT INTO public.s_water VALUES (2002, 'Parawani', '9', NULL);
INSERT INTO public.s_water VALUES (2003, 'SaghamoLake', '8', NULL);
INSERT INTO public.s_water VALUES (2005, 'Lisi Lake', '4', NULL);
INSERT INTO public.s_water VALUES (2010, 'Lake Tabatsquri', '8', NULL);


--
-- TOC entry 4910 (class 0 OID 25157)
-- Dependencies: 224
-- Data for Name: sw_research; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sw_research VALUES (2000, 1);
INSERT INTO public.sw_research VALUES (2001, 1);


--
-- TOC entry 4911 (class 0 OID 25160)
-- Dependencies: 225
-- Data for Name: works_on; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.works_on VALUES ('aron@banknature.ge', 2, 'Controller');
INSERT INTO public.works_on VALUES ('hope@naturefund.ge', 2, 'Project Manager');
INSERT INTO public.works_on VALUES ('klopp@gg.ge', 1, 'Project Manager');
INSERT INTO public.works_on VALUES ('klopp@gg.ge', 4, 'Data Specialist');
INSERT INTO public.works_on VALUES ('lisa@naturefund.ge', 2, 'Specialist');
INSERT INTO public.works_on VALUES ('summer@naturefund.ge', 2, 'Specialist');
INSERT INTO public.works_on VALUES ('summer@naturefund.ge', 4, 'Project Manager');


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 217
-- Name: organization_org_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_org_id_seq', 1, false);


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 219
-- Name: project_p_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.project_p_id_seq', 1, false);


--
-- TOC entry 4731 (class 2606 OID 25166)
-- Name: finances finances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finances
    ADD CONSTRAINT finances_pkey PRIMARY KEY (org_id, p_id);


--
-- TOC entry 4733 (class 2606 OID 25168)
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (org_id);


--
-- TOC entry 4726 (class 2606 OID 25169)
-- Name: project project_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.project
    ADD CONSTRAINT project_check CHECK (((startdate IS NULL) OR (enddate IS NULL) OR (enddate > startdate))) NOT VALID;


--
-- TOC entry 4735 (class 2606 OID 25171)
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (p_id);


--
-- TOC entry 4727 (class 2606 OID 25172)
-- Name: r_water r_water_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.r_water
    ADD CONSTRAINT r_water_check CHECK ((rw_flows_into IS DISTINCT FROM rw_id)) NOT VALID;


--
-- TOC entry 4737 (class 2606 OID 25174)
-- Name: r_water r_water_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.r_water
    ADD CONSTRAINT r_water_pkey PRIMARY KEY (rw_id);


--
-- TOC entry 4728 (class 2606 OID 25175)
-- Name: r_water r_water_rw_id_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.r_water
    ADD CONSTRAINT r_water_rw_id_check CHECK (((rw_id >= 1000) AND (rw_id <= 1999))) NOT VALID;


--
-- TOC entry 4739 (class 2606 OID 25177)
-- Name: researcher researcher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.researcher
    ADD CONSTRAINT researcher_pkey PRIMARY KEY (r_email);


--
-- TOC entry 4741 (class 2606 OID 25179)
-- Name: rw_research rw_research_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rw_research
    ADD CONSTRAINT rw_research_pkey PRIMARY KEY (rw_id, p_id);


--
-- TOC entry 4743 (class 2606 OID 25181)
-- Name: s_water s_water_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.s_water
    ADD CONSTRAINT s_water_pkey PRIMARY KEY (sw_id);


--
-- TOC entry 4745 (class 2606 OID 25183)
-- Name: sw_research sw_research_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sw_research
    ADD CONSTRAINT sw_research_pkey PRIMARY KEY (sw_id, p_id);


--
-- TOC entry 4747 (class 2606 OID 25185)
-- Name: works_on works_on_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.works_on
    ADD CONSTRAINT works_on_pkey PRIMARY KEY (r_email, p_id);


--
-- TOC entry 4748 (class 2606 OID 25186)
-- Name: finances finances_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finances
    ADD CONSTRAINT finances_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organization(org_id) ON UPDATE CASCADE;


--
-- TOC entry 4749 (class 2606 OID 25191)
-- Name: finances finances_p_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finances
    ADD CONSTRAINT finances_p_id_fkey FOREIGN KEY (p_id) REFERENCES public.project(p_id) ON UPDATE CASCADE;


--
-- TOC entry 4750 (class 2606 OID 25196)
-- Name: r_water r_water_flows_into_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.r_water
    ADD CONSTRAINT r_water_flows_into_fkey FOREIGN KEY (rw_flows_into) REFERENCES public.r_water(rw_id) ON UPDATE CASCADE NOT VALID;


--
-- TOC entry 4751 (class 2606 OID 25201)
-- Name: researcher researcher_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.researcher
    ADD CONSTRAINT researcher_org_id_fkey FOREIGN KEY (org_id) REFERENCES public.organization(org_id) ON UPDATE CASCADE;


--
-- TOC entry 4752 (class 2606 OID 25206)
-- Name: rw_research rw_research_p_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rw_research
    ADD CONSTRAINT rw_research_p_id_fkey FOREIGN KEY (p_id) REFERENCES public.project(p_id) ON UPDATE CASCADE;


--
-- TOC entry 4753 (class 2606 OID 25211)
-- Name: rw_research rw_research_rw_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rw_research
    ADD CONSTRAINT rw_research_rw_id_fkey FOREIGN KEY (rw_id) REFERENCES public.r_water(rw_id) ON UPDATE CASCADE;


--
-- TOC entry 4754 (class 2606 OID 25216)
-- Name: sw_research sw_research_p_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sw_research
    ADD CONSTRAINT sw_research_p_id_fkey FOREIGN KEY (p_id) REFERENCES public.project(p_id) ON UPDATE CASCADE;


--
-- TOC entry 4755 (class 2606 OID 25221)
-- Name: sw_research sw_research_sw_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sw_research
    ADD CONSTRAINT sw_research_sw_id_fkey FOREIGN KEY (sw_id) REFERENCES public.s_water(sw_id) ON UPDATE CASCADE;


--
-- TOC entry 4756 (class 2606 OID 25226)
-- Name: works_on works_on_p_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.works_on
    ADD CONSTRAINT works_on_p_id_fkey FOREIGN KEY (p_id) REFERENCES public.project(p_id) ON UPDATE CASCADE;


--
-- TOC entry 4757 (class 2606 OID 25231)
-- Name: works_on works_on_r_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.works_on
    ADD CONSTRAINT works_on_r_email_fkey FOREIGN KEY (r_email) REFERENCES public.researcher(r_email) ON UPDATE CASCADE;


-- Completed on 2024-11-12 14:05:57

--
-- PostgreSQL database dump complete
--

