--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-11 18:25:50

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
-- TOC entry 200 (class 1259 OID 19196)
-- Name: Author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Author" (
    "authorId" integer NOT NULL,
    "authorName" text NOT NULL
);


ALTER TABLE public."Author" OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 19204)
-- Name: Book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Book" (
    isbn character varying(17) NOT NULL,
    title text NOT NULL,
    description text,
    edition real,
    "publishDate" date,
    "publicationId" integer
);


ALTER TABLE public."Book" OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 19217)
-- Name: BookAuthor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookAuthor" (
    "bookAuthorId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "authorId" integer NOT NULL
);


ALTER TABLE public."BookAuthor" OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 19222)
-- Name: BookGenre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookGenre" (
    "bookGenreId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "genreId" integer NOT NULL
);


ALTER TABLE public."BookGenre" OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 19212)
-- Name: BookInstance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookInstance" (
    "bookInstanceId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    borrowed boolean NOT NULL
);


ALTER TABLE public."BookInstance" OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 19227)
-- Name: BookLanguage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookLanguage" (
    "bookLangaugeId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "languageId" integer NOT NULL
);


ALTER TABLE public."BookLanguage" OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 19232)
-- Name: BookTranslation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookTranslation" (
    "bookTranslationId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "translatorId" integer NOT NULL
);


ALTER TABLE public."BookTranslation" OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 19237)
-- Name: Borrow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Borrow" (
    "borrowId" integer NOT NULL,
    "bookInstanceId" integer NOT NULL,
    "membershipId" integer NOT NULL,
    quantity smallint,
    "borrowDate" date,
    "expectedReturnDate" date,
    "actualReturnDate" date
);


ALTER TABLE public."Borrow" OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 19242)
-- Name: Genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Genre" (
    "genreId" integer NOT NULL,
    "genreName" text NOT NULL
);


ALTER TABLE public."Genre" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 19250)
-- Name: Language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Language" (
    "languageId" integer NOT NULL,
    "languageName" text NOT NULL
);


ALTER TABLE public."Language" OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 19258)
-- Name: Member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Member" (
    "membershipId" integer NOT NULL,
    "memberName" text NOT NULL,
    "birthDate" date,
    "joinDate" date,
    "phoneNo" character varying(11),
    address text
);


ALTER TABLE public."Member" OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 19329)
-- Name: Publication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Publication" (
    "publicationId" integer NOT NULL,
    "publicationName" text NOT NULL
);


ALTER TABLE public."Publication" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 19266)
-- Name: Translator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Translator" (
    "translatorId" integer NOT NULL,
    "translatorName" text NOT NULL
);


ALTER TABLE public."Translator" OWNER TO postgres;

--
-- TOC entry 2904 (class 2606 OID 19203)
-- Name: Author Author_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Author"
    ADD CONSTRAINT "Author_pkey" PRIMARY KEY ("authorId");


--
-- TOC entry 2910 (class 2606 OID 19221)
-- Name: BookAuthor BookAuthor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookAuthor"
    ADD CONSTRAINT "BookAuthor_pkey" PRIMARY KEY ("bookAuthorId");


--
-- TOC entry 2912 (class 2606 OID 19226)
-- Name: BookGenre BookGenre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookGenre"
    ADD CONSTRAINT "BookGenre_pkey" PRIMARY KEY ("bookGenreId");


--
-- TOC entry 2908 (class 2606 OID 19216)
-- Name: BookInstance BookInstance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookInstance"
    ADD CONSTRAINT "BookInstance_pkey" PRIMARY KEY ("bookInstanceId");


--
-- TOC entry 2914 (class 2606 OID 19231)
-- Name: BookLanguage BookLanguage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookLanguage"
    ADD CONSTRAINT "BookLanguage_pkey" PRIMARY KEY ("bookLangaugeId");


--
-- TOC entry 2916 (class 2606 OID 19236)
-- Name: BookTranslation BookTranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookTranslation"
    ADD CONSTRAINT "BookTranslation_pkey" PRIMARY KEY ("bookTranslationId");


--
-- TOC entry 2906 (class 2606 OID 19211)
-- Name: Book Book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Book"
    ADD CONSTRAINT "Book_pkey" PRIMARY KEY (isbn);


--
-- TOC entry 2918 (class 2606 OID 19241)
-- Name: Borrow Borrow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Borrow"
    ADD CONSTRAINT "Borrow_pkey" PRIMARY KEY ("borrowId");


--
-- TOC entry 2920 (class 2606 OID 19249)
-- Name: Genre Genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Genre"
    ADD CONSTRAINT "Genre_pkey" PRIMARY KEY ("genreId");


--
-- TOC entry 2922 (class 2606 OID 19257)
-- Name: Language Language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Language"
    ADD CONSTRAINT "Language_pkey" PRIMARY KEY ("languageId");


--
-- TOC entry 2924 (class 2606 OID 19265)
-- Name: Member Member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Member"
    ADD CONSTRAINT "Member_pkey" PRIMARY KEY ("membershipId");


--
-- TOC entry 2928 (class 2606 OID 19336)
-- Name: Publication Publisher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Publication"
    ADD CONSTRAINT "Publisher_pkey" PRIMARY KEY ("publicationId");


--
-- TOC entry 2926 (class 2606 OID 19273)
-- Name: Translator Translator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Translator"
    ADD CONSTRAINT "Translator_pkey" PRIMARY KEY ("translatorId");


--
-- TOC entry 2931 (class 2606 OID 19279)
-- Name: BookAuthor BookAuthor_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookAuthor"
    ADD CONSTRAINT "BookAuthor_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."Author"("authorId") NOT VALID;


--
-- TOC entry 2932 (class 2606 OID 19284)
-- Name: BookAuthor BookAuthor_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookAuthor"
    ADD CONSTRAINT "BookAuthor_isbn_fkey" FOREIGN KEY (isbn) REFERENCES public."Book"(isbn) NOT VALID;


--
-- TOC entry 2933 (class 2606 OID 19289)
-- Name: BookGenre BookGenre_genreId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookGenre"
    ADD CONSTRAINT "BookGenre_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES public."Genre"("genreId") NOT VALID;


--
-- TOC entry 2934 (class 2606 OID 19294)
-- Name: BookGenre BookGenre_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookGenre"
    ADD CONSTRAINT "BookGenre_isbn_fkey" FOREIGN KEY (isbn) REFERENCES public."Book"(isbn) NOT VALID;


--
-- TOC entry 2930 (class 2606 OID 19274)
-- Name: BookInstance BookInstance_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookInstance"
    ADD CONSTRAINT "BookInstance_isbn_fkey" FOREIGN KEY (isbn) REFERENCES public."Book"(isbn) NOT VALID;


--
-- TOC entry 2935 (class 2606 OID 19299)
-- Name: BookLanguage BookLanguage_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookLanguage"
    ADD CONSTRAINT "BookLanguage_isbn_fkey" FOREIGN KEY (isbn) REFERENCES public."Book"(isbn) NOT VALID;


--
-- TOC entry 2936 (class 2606 OID 19304)
-- Name: BookLanguage BookLanguage_languageId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookLanguage"
    ADD CONSTRAINT "BookLanguage_languageId_fkey" FOREIGN KEY ("languageId") REFERENCES public."Language"("languageId") NOT VALID;


--
-- TOC entry 2937 (class 2606 OID 19309)
-- Name: BookTranslation BookTranslation_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookTranslation"
    ADD CONSTRAINT "BookTranslation_isbn_fkey" FOREIGN KEY (isbn) REFERENCES public."Book"(isbn) NOT VALID;


--
-- TOC entry 2938 (class 2606 OID 19314)
-- Name: BookTranslation BookTranslation_translatorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookTranslation"
    ADD CONSTRAINT "BookTranslation_translatorId_fkey" FOREIGN KEY ("translatorId") REFERENCES public."Translator"("translatorId") NOT VALID;


--
-- TOC entry 2929 (class 2606 OID 19337)
-- Name: Book Book_publicationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Book"
    ADD CONSTRAINT "Book_publicationId_fkey" FOREIGN KEY ("publicationId") REFERENCES public."Publication"("publicationId") NOT VALID;


--
-- TOC entry 2939 (class 2606 OID 19319)
-- Name: Borrow Borrow_bookInstanceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Borrow"
    ADD CONSTRAINT "Borrow_bookInstanceId_fkey" FOREIGN KEY ("bookInstanceId") REFERENCES public."BookInstance"("bookInstanceId") NOT VALID;


--
-- TOC entry 2940 (class 2606 OID 19324)
-- Name: Borrow Borrow_membershipId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Borrow"
    ADD CONSTRAINT "Borrow_membershipId_fkey" FOREIGN KEY ("membershipId") REFERENCES public."Member"("membershipId") NOT VALID;


-- Completed on 2021-07-11 18:25:50

--
-- PostgreSQL database dump complete
--

