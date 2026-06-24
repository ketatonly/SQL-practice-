--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-12 14:17:59

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 24799)
-- Name: assistant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assistant (
    assistant_i_d bigint NOT NULL,
    name character varying(50) NOT NULL,
    research_area character varying(80),
    prof_i_d bigint
);


ALTER TABLE public.assistant OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24802)
-- Name: assistant_assistant_i_d_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assistant_assistant_i_d_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assistant_assistant_i_d_seq OWNER TO postgres;

--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 216
-- Name: assistant_assistant_i_d_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assistant_assistant_i_d_seq OWNED BY public.assistant.assistant_i_d;


--
-- TOC entry 217 (class 1259 OID 24803)
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    course_i_d bigint NOT NULL,
    title character varying(50) NOT NULL,
    contact_hours smallint NOT NULL,
    prof_i_d bigint
);


ALTER TABLE public.course OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24806)
-- Name: enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollment (
    stud_i_d bigint NOT NULL,
    course_i_d bigint NOT NULL
);


ALTER TABLE public.enrollment OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24809)
-- Name: examination; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examination (
    stud_i_d bigint NOT NULL,
    course_i_d bigint NOT NULL,
    prof_i_d bigint NOT NULL,
    grade character varying NOT NULL,
    points smallint
);


ALTER TABLE public.examination OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24814)
-- Name: professor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.professor (
    prof_i_d bigint NOT NULL,
    name character varying(50) NOT NULL,
    rank character(2)
);


ALTER TABLE public.professor OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24817)
-- Name: requirement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requirement (
    predecessor bigint NOT NULL,
    successor bigint NOT NULL
);


ALTER TABLE public.requirement OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24820)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    stud_i_d bigint NOT NULL,
    name character varying(50) NOT NULL,
    semester smallint,
    student_email character varying(60)
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 4712 (class 2604 OID 24823)
-- Name: assistant assistant_i_d; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assistant ALTER COLUMN assistant_i_d SET DEFAULT nextval('public.assistant_assistant_i_d_seq'::regclass);


--
-- TOC entry 4888 (class 0 OID 24799)
-- Dependencies: 215
-- Data for Name: assistant; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.assistant VALUES (3002, 'Platon', 'Ideology', 2125);
INSERT INTO public.assistant VALUES (3003, 'Aristoteles', 'Logic', 2125);
INSERT INTO public.assistant VALUES (3004, 'Wittgenstein', 'Speech Theorie', 2126);
INSERT INTO public.assistant VALUES (3005, 'Rhetikus', 'Movement of Planets', 2127);
INSERT INTO public.assistant VALUES (3006, 'Newton', 'Kepler''s laws', 2127);
INSERT INTO public.assistant VALUES (3007, 'Spinoza', 'God and Nature', 2134);


--
-- TOC entry 4890 (class 0 OID 24803)
-- Dependencies: 217
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course VALUES (4052, 'Logic', 4, 2125);
INSERT INTO public.course VALUES (4630, 'Three Critics', 4, 2137);
INSERT INTO public.course VALUES (5001, 'Foundation', 4, 2137);
INSERT INTO public.course VALUES (5022, 'Science and Faith', 2, 2134);
INSERT INTO public.course VALUES (5041, 'Ethics', 4, 2125);
INSERT INTO public.course VALUES (5043, 'Cognition Theory', 3, 2126);
INSERT INTO public.course VALUES (5049, 'maieutics', 2, 2125);
INSERT INTO public.course VALUES (5052, 'philosophy of science', 3, 2126);
INSERT INTO public.course VALUES (5216, 'Bioethics', 2, 2126);
INSERT INTO public.course VALUES (5259, 'Vienna Circle', 2, 2133);


--
-- TOC entry 4891 (class 0 OID 24806)
-- Dependencies: 218
-- Data for Name: enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enrollment VALUES (25403, 5022);
INSERT INTO public.enrollment VALUES (26120, 5001);
INSERT INTO public.enrollment VALUES (27550, 4052);
INSERT INTO public.enrollment VALUES (27550, 5001);
INSERT INTO public.enrollment VALUES (28106, 5041);
INSERT INTO public.enrollment VALUES (28106, 5052);
INSERT INTO public.enrollment VALUES (28106, 5216);
INSERT INTO public.enrollment VALUES (28106, 5259);
INSERT INTO public.enrollment VALUES (29120, 4052);
INSERT INTO public.enrollment VALUES (29120, 4630);
INSERT INTO public.enrollment VALUES (29120, 5001);
INSERT INTO public.enrollment VALUES (29120, 5041);
INSERT INTO public.enrollment VALUES (29120, 5049);
INSERT INTO public.enrollment VALUES (29555, 5001);
INSERT INTO public.enrollment VALUES (29555, 5022);


--
-- TOC entry 4892 (class 0 OID 24809)
-- Dependencies: 219
-- Data for Name: examination; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.examination VALUES (25403, 5001, 2126, 'B', 85);
INSERT INTO public.examination VALUES (25403, 5041, 2125, 'B', 81);
INSERT INTO public.examination VALUES (26120, 5001, 2126, 'B', 88);
INSERT INTO public.examination VALUES (26830, 5001, 2126, 'C', 75);
INSERT INTO public.examination VALUES (27550, 4630, 2137, 'E', 51);
INSERT INTO public.examination VALUES (27550, 5001, 2126, 'C', 74);
INSERT INTO public.examination VALUES (28106, 5001, 2126, 'A', 95);
INSERT INTO public.examination VALUES (29555, 5001, 2126, 'E', 40);


--
-- TOC entry 4893 (class 0 OID 24814)
-- Dependencies: 220
-- Data for Name: professor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.professor VALUES (2125, 'Sokrates', 'C4');
INSERT INTO public.professor VALUES (2126, 'Russel', 'C4');
INSERT INTO public.professor VALUES (2127, 'Kopernikus', 'C3');
INSERT INTO public.professor VALUES (2133, 'Popper', 'C3');
INSERT INTO public.professor VALUES (2134, 'Augustinus', 'C3');
INSERT INTO public.professor VALUES (2136, 'Curie', 'C4');
INSERT INTO public.professor VALUES (2137, 'Kant', 'C4');


--
-- TOC entry 4894 (class 0 OID 24817)
-- Dependencies: 221
-- Data for Name: requirement; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.requirement VALUES (5041, 4630);
INSERT INTO public.requirement VALUES (4052, 5049);
INSERT INTO public.requirement VALUES (5041, 5049);
INSERT INTO public.requirement VALUES (5259, 5052);
INSERT INTO public.requirement VALUES (4630, 5259);


--
-- TOC entry 4895 (class 0 OID 24820)
-- Dependencies: 222
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student VALUES (24002, 'Xenokrates', 18, NULL);
INSERT INTO public.student VALUES (24100, 'Jonas', NULL, 'Jonas@kiu.edu.ge');
INSERT INTO public.student VALUES (24101, 'Jonas', NULL, 'Jonas1@kiu.edu.ge');
INSERT INTO public.student VALUES (24102, 'Jonas', NULL, 'Jonas2@kiu.edu.ge');
INSERT INTO public.student VALUES (25403, 'Jonas', 12, NULL);
INSERT INTO public.student VALUES (26120, 'Fichte', 10, NULL);
INSERT INTO public.student VALUES (26830, 'Aristoxenos', NULL, NULL);
INSERT INTO public.student VALUES (27550, 'Schopenhauer', 0, NULL);
INSERT INTO public.student VALUES (28106, 'Carnap', NULL, NULL);
INSERT INTO public.student VALUES (29120, 'Theophrastos', 0, NULL);
INSERT INTO public.student VALUES (29555, 'Feuerbach', NULL, NULL);
INSERT INTO public.student VALUES (29990, 'Hegel', 0, 'Hegel@kiu.edu.ge');
INSERT INTO public.student VALUES (29991, 'Hegel', 0, 'Hegel1@kiu.edu.ge');
INSERT INTO public.student VALUES (29992, 'Hegel', 0, 'Hegel2@kiu.edu.ge');


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 216
-- Name: assistant_assistant_i_d_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assistant_assistant_i_d_seq', 3007, true);


--
-- TOC entry 4716 (class 2606 OID 24825)
-- Name: assistant assistant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assistant
    ADD CONSTRAINT assistant_pkey PRIMARY KEY (assistant_i_d);


--
-- TOC entry 4719 (class 2606 OID 24827)
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (course_i_d);


--
-- TOC entry 4722 (class 2606 OID 24829)
-- Name: enrollment enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_pkey PRIMARY KEY (course_i_d, stud_i_d);


--
-- TOC entry 4726 (class 2606 OID 24831)
-- Name: examination examination_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examination
    ADD CONSTRAINT examination_pkey PRIMARY KEY (stud_i_d, course_i_d);


--
-- TOC entry 4729 (class 2606 OID 24833)
-- Name: professor professor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.professor
    ADD CONSTRAINT professor_pkey PRIMARY KEY (prof_i_d);


--
-- TOC entry 4732 (class 2606 OID 24835)
-- Name: requirement requirement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requirement
    ADD CONSTRAINT requirement_pkey PRIMARY KEY (predecessor, successor);


--
-- TOC entry 4734 (class 2606 OID 24837)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (stud_i_d);


--
-- TOC entry 4713 (class 2606 OID 24838)
-- Name: student student_semester_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.student
    ADD CONSTRAINT student_semester_check CHECK (((semester >= 1) AND (semester <= 12))) NOT VALID;


--
-- TOC entry 4714 (class 1259 OID 24839)
-- Name: assistant_f_k_prof_i_d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assistant_f_k_prof_i_d ON public.assistant USING btree (prof_i_d);


--
-- TOC entry 4717 (class 1259 OID 24840)
-- Name: course_f_k_course_professor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX course_f_k_course_professor ON public.course USING btree (prof_i_d);


--
-- TOC entry 4720 (class 1259 OID 24841)
-- Name: enrollment_f_k_enrollment_student; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX enrollment_f_k_enrollment_student ON public.enrollment USING btree (stud_i_d);


--
-- TOC entry 4723 (class 1259 OID 24842)
-- Name: examination_f_k__course; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX examination_f_k__course ON public.examination USING btree (course_i_d);


--
-- TOC entry 4724 (class 1259 OID 24843)
-- Name: examination_f_k__professor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX examination_f_k__professor ON public.examination USING btree (prof_i_d);


--
-- TOC entry 4727 (class 1259 OID 24844)
-- Name: professor_index_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX professor_index_name ON public.professor USING btree (name);


--
-- TOC entry 4730 (class 1259 OID 24845)
-- Name: requirement_f_k_requirement_course_2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX requirement_f_k_requirement_course_2 ON public.requirement USING btree (successor);


--
-- TOC entry 4735 (class 1259 OID 24846)
-- Name: student_student_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_student_name ON public.student USING btree (name);


--
-- TOC entry 4740 (class 2606 OID 24847)
-- Name: examination f_k__course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examination
    ADD CONSTRAINT f_k__course FOREIGN KEY (course_i_d) REFERENCES public.course(course_i_d);


--
-- TOC entry 4741 (class 2606 OID 24852)
-- Name: examination f_k__professor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examination
    ADD CONSTRAINT f_k__professor FOREIGN KEY (prof_i_d) REFERENCES public.professor(prof_i_d);


--
-- TOC entry 4742 (class 2606 OID 24857)
-- Name: examination f_k__student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examination
    ADD CONSTRAINT f_k__student FOREIGN KEY (stud_i_d) REFERENCES public.student(stud_i_d);


--
-- TOC entry 4736 (class 2606 OID 24862)
-- Name: assistant f_k_assistant_professor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assistant
    ADD CONSTRAINT f_k_assistant_professor FOREIGN KEY (prof_i_d) REFERENCES public.professor(prof_i_d);


--
-- TOC entry 4737 (class 2606 OID 24867)
-- Name: course f_k_course_professor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT f_k_course_professor FOREIGN KEY (prof_i_d) REFERENCES public.professor(prof_i_d);


--
-- TOC entry 4738 (class 2606 OID 24872)
-- Name: enrollment f_k_enrollment_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT f_k_enrollment_course FOREIGN KEY (course_i_d) REFERENCES public.course(course_i_d);


--
-- TOC entry 4739 (class 2606 OID 24877)
-- Name: enrollment f_k_enrollment_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT f_k_enrollment_student FOREIGN KEY (stud_i_d) REFERENCES public.student(stud_i_d);


--
-- TOC entry 4743 (class 2606 OID 24882)
-- Name: requirement f_k_requirement_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requirement
    ADD CONSTRAINT f_k_requirement_course FOREIGN KEY (predecessor) REFERENCES public.course(course_i_d);


--
-- TOC entry 4744 (class 2606 OID 24887)
-- Name: requirement f_k_requirement_course_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requirement
    ADD CONSTRAINT f_k_requirement_course_2 FOREIGN KEY (successor) REFERENCES public.course(course_i_d);


-- Completed on 2024-11-12 14:17:59

--
-- PostgreSQL database dump complete
--

