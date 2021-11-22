--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-11 18:28:03

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
-- TOC entry 3071 (class 0 OID 19196)
-- Dependencies: 200
-- Data for Name: Author; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3083 (class 0 OID 19329)
-- Dependencies: 212
-- Data for Name: Publication; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Publication" VALUES (1, 'Barrons');


--
-- TOC entry 3072 (class 0 OID 19204)
-- Dependencies: 201
-- Data for Name: Book; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Book" VALUES ('978-1-4380-0296-5', 'Essential Words for the TOEFL', 'blah blah ...', 6, '2021-07-11', 1);


--
-- TOC entry 3074 (class 0 OID 19217)
-- Dependencies: 203
-- Data for Name: BookAuthor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3079 (class 0 OID 19242)
-- Dependencies: 208
-- Data for Name: Genre; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3075 (class 0 OID 19222)
-- Dependencies: 204
-- Data for Name: BookGenre; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3073 (class 0 OID 19212)
-- Dependencies: 202
-- Data for Name: BookInstance; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3080 (class 0 OID 19250)
-- Dependencies: 209
-- Data for Name: Language; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3076 (class 0 OID 19227)
-- Dependencies: 205
-- Data for Name: BookLanguage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3082 (class 0 OID 19266)
-- Dependencies: 211
-- Data for Name: Translator; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Translator" VALUES (1, 'Koorosh');
INSERT INTO public."Translator" VALUES (3, 'Nimaa');
INSERT INTO public."Translator" VALUES (4, 'Jafar Nezhad Qomi');


--
-- TOC entry 3077 (class 0 OID 19232)
-- Dependencies: 206
-- Data for Name: BookTranslation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."BookTranslation" VALUES (1, '978-1-4380-0296-5', 1);


--
-- TOC entry 3081 (class 0 OID 19258)
-- Dependencies: 210
-- Data for Name: Member; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3078 (class 0 OID 19237)
-- Dependencies: 207
-- Data for Name: Borrow; Type: TABLE DATA; Schema: public; Owner: postgres
--



-- Completed on 2021-07-11 18:28:03

--
-- PostgreSQL database dump complete
--

