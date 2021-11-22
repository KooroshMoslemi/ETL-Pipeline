--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-11 18:24:36

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
-- TOC entry 3482 (class 0 OID 20038)
-- Dependencies: 213
-- Data for Name: Author; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3484 (class 0 OID 20074)
-- Dependencies: 219
-- Data for Name: Book; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Book" VALUES ('978-1-4380-0296-5', 'Essential Words for the TOEFL', 'blah blah ...', 6, '2021-07-11', 1, '["2021-07-11 18:14:07.540293+04:30",infinity)');


--
-- TOC entry 3490 (class 0 OID 20182)
-- Dependencies: 237
-- Data for Name: BookAuthor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3489 (class 0 OID 20164)
-- Dependencies: 234
-- Data for Name: BookGenre; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3487 (class 0 OID 20128)
-- Dependencies: 228
-- Data for Name: BookInstance; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3486 (class 0 OID 20110)
-- Dependencies: 225
-- Data for Name: BookLanguage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3485 (class 0 OID 20092)
-- Dependencies: 222
-- Data for Name: BookTranslation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."BookTranslation" VALUES (1, '978-1-4380-0296-5', 1, '["2021-07-11 18:14:07.54853+04:30",infinity)');


--
-- TOC entry 3488 (class 0 OID 20146)
-- Dependencies: 231
-- Data for Name: Borrow; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3481 (class 0 OID 20020)
-- Dependencies: 210
-- Data for Name: Genre; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3480 (class 0 OID 20002)
-- Dependencies: 207
-- Data for Name: Language; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3478 (class 0 OID 19966)
-- Dependencies: 201
-- Data for Name: Member; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3483 (class 0 OID 20056)
-- Dependencies: 216
-- Data for Name: Publication; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Publication" VALUES (1, 'Barrons', '["2021-07-11 18:14:07.529701+04:30",infinity)');


--
-- TOC entry 3479 (class 0 OID 19984)
-- Dependencies: 204
-- Data for Name: Translator; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Translator" VALUES (1, 'Koorosh', '["2021-07-11 18:14:07.499817+04:30",infinity)');
INSERT INTO public."Translator" VALUES (4, 'Jafar Nezhad Qomi', '["2021-07-11 18:18:05.730218+04:30",infinity)');
INSERT INTO public."Translator" VALUES (2, 'Ali', '["2021-07-11 18:14:07.499817+04:30","2021-07-11 18:18:05.7384+04:30")');
INSERT INTO public."Translator" VALUES (3, 'Nima', '["2021-07-11 18:14:07.499817+04:30","2021-07-11 18:18:05.752166+04:30")');
INSERT INTO public."Translator" VALUES (3, 'Nimaa', '["2021-07-11 18:18:05.752166+04:30",infinity)');


-- Completed on 2021-07-11 18:24:37

--
-- PostgreSQL database dump complete
--

