--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-12 14:12:43

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
-- TOC entry 849 (class 1247 OID 25238)
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'f',
    'm',
    'd'
);


ALTER TYPE public.gender OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 25245)
-- Name: area; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.area (
    area character(10) NOT NULL,
    description character varying(80),
    manager character varying(20)
);


ALTER TABLE public.area OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25248)
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    course_id integer NOT NULL,
    course_name character varying NOT NULL,
    targetgroup character(3) NOT NULL,
    area character(10),
    trainer character varying(20) NOT NULL
);


ALTER TABLE public.course OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25253)
-- Name: course_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_course_id_seq OWNER TO postgres;

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 217
-- Name: course_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_course_id_seq OWNED BY public.course.course_id;


--
-- TOC entry 218 (class 1259 OID 25254)
-- Name: device; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device (
    device_id integer NOT NULL,
    description character varying(50) NOT NULL
);


ALTER TABLE public.device OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25257)
-- Name: device_device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_device_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.device_device_id_seq OWNER TO postgres;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 219
-- Name: device_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_device_id_seq OWNED BY public.device.device_id;


--
-- TOC entry 220 (class 1259 OID 25258)
-- Name: enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollment (
    memname character varying(20) NOT NULL,
    course_id integer NOT NULL
);


ALTER TABLE public.enrollment OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25261)
-- Name: member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member (
    memname character varying(20) NOT NULL,
    is_trainer boolean DEFAULT false NOT NULL,
    email character varying(50) NOT NULL,
    postalcode integer NOT NULL,
    birthday date,
    gender public.gender NOT NULL,
    entry_date date,
    parent character varying(20)
);


ALTER TABLE public.member OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25265)
-- Name: reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation (
    memname character varying(20) NOT NULL,
    timeslot timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE public.reservation OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25269)
-- Name: targetgroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.targetgroup (
    targetgroup character(3) NOT NULL,
    description character varying(60)
);


ALTER TABLE public.targetgroup OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25272)
-- Name: trainer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trainer (
    tname character varying(20) NOT NULL,
    license boolean DEFAULT false,
    start_date date
);


ALTER TABLE public.trainer OWNER TO postgres;

--
-- TOC entry 4720 (class 2604 OID 25276)
-- Name: course course_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course ALTER COLUMN course_id SET DEFAULT nextval('public.course_course_id_seq'::regclass);


--
-- TOC entry 4721 (class 2604 OID 25277)
-- Name: device device_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device ALTER COLUMN device_id SET DEFAULT nextval('public.device_device_id_seq'::regclass);


--
-- TOC entry 4898 (class 0 OID 25245)
-- Dependencies: 215
-- Data for Name: area; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.area VALUES ('athletics ', 'High jump, long jump, decathlon, penthalon, sprint distances and the like', 'nelly');
INSERT INTO public.area VALUES ('martialArt', 'Wrestling, Judo and the like', 'klopp');
INSERT INTO public.area VALUES ('watersport', 'All sports that have to do with water', 'lazy');
INSERT INTO public.area VALUES ('fitness   ', 'Comprises all courses that encrease healthy lifestyle and fitness', 'eva_knirsch');


--
-- TOC entry 4899 (class 0 OID 25248)
-- Dependencies: 216
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course VALUES (1, 'wrestling', 'men', 'martialArt', 'klopp');
INSERT INTO public.course VALUES (2, 'waterball', 'men', 'watersport', 'klopp');
INSERT INTO public.course VALUES (4, 'jogging', 'fam', 'fitness   ', 'lena');
INSERT INTO public.course VALUES (5, 'fitnessKids', 'kid', 'fitness   ', 'klopp');
INSERT INTO public.course VALUES (6, 'high jump', 'fam', 'athletics ', 'lena');
INSERT INTO public.course VALUES (7, 'obstacle race', 'fam', 'athletics ', 'lena');
INSERT INTO public.course VALUES (9, 'free style', 'kid', 'watersport', 'lazy');
INSERT INTO public.course VALUES (10, 'aerobics', 'fam', 'fitness   ', 'lena');
INSERT INTO public.course VALUES (15, 'gymnastics water', 'all', 'watersport', 'lena');
INSERT INTO public.course VALUES (3, 'running', 'men', 'fitness   ', 'lazy');
INSERT INTO public.course VALUES (8, 'swimming', 'fam', 'watersport', 'lena');


--
-- TOC entry 4901 (class 0 OID 25254)
-- Dependencies: 218
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.device VALUES (1, 'treadmill');
INSERT INTO public.device VALUES (2, 'rowing machine');


--
-- TOC entry 4903 (class 0 OID 25258)
-- Dependencies: 220
-- Data for Name: enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enrollment VALUES ('lion', 1);
INSERT INTO public.enrollment VALUES ('lion', 4);
INSERT INTO public.enrollment VALUES ('lion', 5);
INSERT INTO public.enrollment VALUES ('lion', 6);
INSERT INTO public.enrollment VALUES ('lion', 7);
INSERT INTO public.enrollment VALUES ('lion', 10);
INSERT INTO public.enrollment VALUES ('lisa', 6);
INSERT INTO public.enrollment VALUES ('lisa', 9);
INSERT INTO public.enrollment VALUES ('nelly', 1);
INSERT INTO public.enrollment VALUES ('nelly', 4);
INSERT INTO public.enrollment VALUES ('nelly', 5);
INSERT INTO public.enrollment VALUES ('nelly', 6);
INSERT INTO public.enrollment VALUES ('nelly', 7);
INSERT INTO public.enrollment VALUES ('nelly', 10);
INSERT INTO public.enrollment VALUES ('robin', 1);
INSERT INTO public.enrollment VALUES ('robin', 4);
INSERT INTO public.enrollment VALUES ('robin', 5);
INSERT INTO public.enrollment VALUES ('robin', 6);
INSERT INTO public.enrollment VALUES ('robin', 7);
INSERT INTO public.enrollment VALUES ('robin', 10);
INSERT INTO public.enrollment VALUES ('rose', 4);
INSERT INTO public.enrollment VALUES ('rose', 5);
INSERT INTO public.enrollment VALUES ('rose', 6);
INSERT INTO public.enrollment VALUES ('rose', 7);
INSERT INTO public.enrollment VALUES ('rose', 10);
INSERT INTO public.enrollment VALUES ('val', 1);
INSERT INTO public.enrollment VALUES ('val', 4);
INSERT INTO public.enrollment VALUES ('val', 5);
INSERT INTO public.enrollment VALUES ('val', 6);
INSERT INTO public.enrollment VALUES ('valerie', 1);
INSERT INTO public.enrollment VALUES ('valerie', 4);
INSERT INTO public.enrollment VALUES ('valerie', 5);
INSERT INTO public.enrollment VALUES ('valerie', 6);
INSERT INTO public.enrollment VALUES ('valerie', 7);
INSERT INTO public.enrollment VALUES ('valerie', 10);
INSERT INTO public.enrollment VALUES ('figaro', 1);
INSERT INTO public.enrollment VALUES ('hope', 1);
INSERT INTO public.enrollment VALUES ('hope', 5);
INSERT INTO public.enrollment VALUES ('hope', 6);
INSERT INTO public.enrollment VALUES ('hope', 7);
INSERT INTO public.enrollment VALUES ('hope', 10);


--
-- TOC entry 4904 (class 0 OID 25261)
-- Dependencies: 221
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.member VALUES ('coach', true, 'coach@xx.ge', 4565, '1988-12-01', 'm', NULL, NULL);
INSERT INTO public.member VALUES ('figaro', false, 'figaro@xx.ge', 3674, '1989-05-07', 'm', NULL, NULL);
INSERT INTO public.member VALUES ('lazy', true, 'lazy@xx.ge', 4600, '1996-11-25', 'm', NULL, NULL);
INSERT INTO public.member VALUES ('lena', true, 'lena@xx.ge', 105, '1995-01-25', 'f', NULL, NULL);
INSERT INTO public.member VALUES ('lion', false, 'lion@xxx.ge', 103, '1990-10-10', 'm', NULL, NULL);
INSERT INTO public.member VALUES ('nelly', true, 'luke@xx.ge', 4565, '1990-04-21', 'f', NULL, NULL);
INSERT INTO public.member VALUES ('valerie', false, 'val@xx.ge', 105, '1970-03-20', 'f', NULL, NULL);
INSERT INTO public.member VALUES ('robin', false, 'nelly@xx.ge', 4600, '2012-09-16', 'm', '2017-01-01', 'nelly');
INSERT INTO public.member VALUES ('rose', false, 'lion@xx.ge', 107, '2015-02-10', 'f', NULL, 'lion');
INSERT INTO public.member VALUES ('val', false, 'val@xx.ge', 103, '2013-07-12', 'm', '2020-05-01', 'figaro');
INSERT INTO public.member VALUES ('aron', false, 'klopp@xx.ge', 103, '2013-11-06', 'm', '2020-01-01', 'klopp');
INSERT INTO public.member VALUES ('lisa', false, 'figaro@xx.ge', 4600, '2015-11-19', 'f', NULL, 'figaro');
INSERT INTO public.member VALUES ('eva_knirsch', true, 'eva.knirsch@xx.ge', 4600, NULL, 'f', NULL, NULL);
INSERT INTO public.member VALUES ('hope', false, 'hope@xx.ge', 4565, '1965-09-14', 'f', '2016-03-01', NULL);
INSERT INTO public.member VALUES ('luke', false, 'luke@xxx.ge', 4565, '1998-11-22', 'm', NULL, 'hope');
INSERT INTO public.member VALUES ('klopp', true, 'klopp@xx.ge', 4600, '1980-12-24', 'm', '2018-01-01', NULL);


--
-- TOC entry 4905 (class 0 OID 25265)
-- Dependencies: 222
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reservation VALUES ('klopp', '2024-10-14 14:53:15.562498', 2);
INSERT INTO public.reservation VALUES ('figaro', '2024-10-14 14:53:15.562498', 1);
INSERT INTO public.reservation VALUES ('eva_knirsch', '2024-10-19 09:42:43.9336', 1);
INSERT INTO public.reservation VALUES ('hope', '2024-10-13 21:14:42.426565', 1);


--
-- TOC entry 4906 (class 0 OID 25269)
-- Dependencies: 223
-- Data for Name: targetgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.targetgroup VALUES ('all', 'everybody');
INSERT INTO public.targetgroup VALUES ('fam', 'families');
INSERT INTO public.targetgroup VALUES ('kid', 'kinds up to 10');
INSERT INTO public.targetgroup VALUES ('jun', 'young people 10 - 20');
INSERT INTO public.targetgroup VALUES ('sen', 'seniors');
INSERT INTO public.targetgroup VALUES ('men', 'courses for men');
INSERT INTO public.targetgroup VALUES ('wom', 'courses for women');


--
-- TOC entry 4907 (class 0 OID 25272)
-- Dependencies: 224
-- Data for Name: trainer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.trainer VALUES ('coach', true, '2021-10-01');
INSERT INTO public.trainer VALUES ('klopp', true, NULL);
INSERT INTO public.trainer VALUES ('lazy', true, NULL);
INSERT INTO public.trainer VALUES ('lena', false, NULL);
INSERT INTO public.trainer VALUES ('nelly', false, NULL);
INSERT INTO public.trainer VALUES ('eva_knirsch', true, '2024-01-01');


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 217
-- Name: course_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_course_id_seq', 15, true);


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 219
-- Name: device_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.device_device_id_seq', 1, false);


--
-- TOC entry 4726 (class 2606 OID 25279)
-- Name: area area_manager_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area
    ADD CONSTRAINT area_manager_key UNIQUE (manager);


--
-- TOC entry 4728 (class 2606 OID 25281)
-- Name: area area_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area
    ADD CONSTRAINT area_pkey PRIMARY KEY (area);


--
-- TOC entry 4730 (class 2606 OID 25283)
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (course_id);


--
-- TOC entry 4732 (class 2606 OID 25285)
-- Name: device device_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (device_id);


--
-- TOC entry 4734 (class 2606 OID 25287)
-- Name: enrollment enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_pkey PRIMARY KEY (memname, course_id);


--
-- TOC entry 4736 (class 2606 OID 25289)
-- Name: member mem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT mem_pkey PRIMARY KEY (memname);


--
-- TOC entry 4738 (class 2606 OID 25291)
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (memname, timeslot);


--
-- TOC entry 4740 (class 2606 OID 25293)
-- Name: reservation reservation_timeslot_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_timeslot_device_id_key UNIQUE (timeslot, device_id);


--
-- TOC entry 4742 (class 2606 OID 25295)
-- Name: targetgroup targetgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.targetgroup
    ADD CONSTRAINT targetgroup_pkey PRIMARY KEY (targetgroup);


--
-- TOC entry 4744 (class 2606 OID 25297)
-- Name: trainer trainer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trainer
    ADD CONSTRAINT trainer_pkey PRIMARY KEY (tname);


--
-- TOC entry 4745 (class 2606 OID 25298)
-- Name: area area_manager_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.area
    ADD CONSTRAINT area_manager_fkey FOREIGN KEY (manager) REFERENCES public.trainer(tname) ON UPDATE SET NULL ON DELETE SET NULL NOT VALID;


--
-- TOC entry 4746 (class 2606 OID 25303)
-- Name: course course_area_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_area_fkey FOREIGN KEY (area) REFERENCES public.area(area) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- TOC entry 4747 (class 2606 OID 25308)
-- Name: course course_targetgroup_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_targetgroup_fkey FOREIGN KEY (targetgroup) REFERENCES public.targetgroup(targetgroup);


--
-- TOC entry 4748 (class 2606 OID 25313)
-- Name: course course_trainer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_trainer_fkey FOREIGN KEY (trainer) REFERENCES public.trainer(tname);


--
-- TOC entry 4749 (class 2606 OID 25318)
-- Name: enrollment enrollment_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.course(course_id);


--
-- TOC entry 4750 (class 2606 OID 25323)
-- Name: enrollment enrollment_memname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_memname_fkey FOREIGN KEY (memname) REFERENCES public.member(memname) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4751 (class 2606 OID 25328)
-- Name: member member_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_parent_fkey FOREIGN KEY (parent) REFERENCES public.member(memname) ON UPDATE CASCADE NOT VALID;


--
-- TOC entry 4752 (class 2606 OID 25333)
-- Name: reservation reservation_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.device(device_id);


--
-- TOC entry 4753 (class 2606 OID 25338)
-- Name: reservation reservation_memname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_memname_fkey FOREIGN KEY (memname) REFERENCES public.member(memname) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4754 (class 2606 OID 25343)
-- Name: trainer trainer_tname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trainer
    ADD CONSTRAINT trainer_tname_fkey FOREIGN KEY (tname) REFERENCES public.member(memname) NOT VALID;


-- Completed on 2024-11-12 14:12:44

--
-- PostgreSQL database dump complete
--

