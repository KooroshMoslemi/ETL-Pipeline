--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-11 18:21:58

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
-- TOC entry 2 (class 3079 OID 19343)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- TOC entry 434 (class 1255 OID 20046)
-- Name: version_trigger_author(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_author() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."authorId" <> OLD."authorId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Author"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "authorId" = NEW."authorId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Author" ("authorId", __valid, "authorName")
            VALUES (NEW."authorId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."authorName");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Author"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "authorId" = OLD."authorId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_author() OWNER TO postgres;

--
-- TOC entry 436 (class 1255 OID 20082)
-- Name: version_trigger_book(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_book() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."isbn" <> OLD."isbn"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Book"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "isbn" = NEW."isbn"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Book" ("isbn", __valid, "title","description","edition","publishDate","publicationId")
            VALUES (NEW."isbn",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."title",NEW."description",NEW."edition",NEW."publishDate",NEW."publicationId");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Book"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "isbn" = OLD."isbn"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_book() OWNER TO postgres;

--
-- TOC entry 442 (class 1255 OID 20190)
-- Name: version_trigger_bookauthor(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_bookauthor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."bookAuthorId" <> OLD."bookAuthorId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "BookAuthor"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "bookAuthorId" = NEW."bookAuthorId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "BookAuthor" ("bookAuthorId", __valid, "isbn","authorId")
            VALUES (NEW."bookAuthorId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."isbn",NEW."authorId");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "BookAuthor"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "bookAuthorId" = OLD."bookAuthorId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_bookauthor() OWNER TO postgres;

--
-- TOC entry 441 (class 1255 OID 20172)
-- Name: version_trigger_bookgenre(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_bookgenre() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."bookGenreId" <> OLD."bookGenreId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "BookGenre"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "bookGenreId" = NEW."bookGenreId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "BookGenre" ("bookGenreId", __valid, "isbn","genreId")
            VALUES (NEW."bookGenreId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."isbn",NEW."genreId");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "BookGenre"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "bookGenreId" = OLD."bookGenreId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_bookgenre() OWNER TO postgres;

--
-- TOC entry 439 (class 1255 OID 20136)
-- Name: version_trigger_bookinstance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_bookinstance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."bookInstanceId" <> OLD."bookInstanceId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "BookInstance"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "bookInstanceId" = NEW."bookInstanceId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "BookInstance" ("bookInstanceId", __valid, "isbn","borrowed")
            VALUES (NEW."bookInstanceId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."isbn",NEW."borrowed");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "BookInstance"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "bookInstanceId" = OLD."bookInstanceId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_bookinstance() OWNER TO postgres;

--
-- TOC entry 438 (class 1255 OID 20118)
-- Name: version_trigger_booklanguage(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_booklanguage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."bookLangaugeId" <> OLD."bookLangaugeId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "BookLanguage"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "bookLangaugeId" = NEW."bookLangaugeId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "BookLanguage" ("bookLangaugeId", __valid, "isbn","languageId")
            VALUES (NEW."bookLangaugeId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."isbn",NEW."languageId");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "BookLanguage"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "bookLangaugeId" = OLD."bookLangaugeId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_booklanguage() OWNER TO postgres;

--
-- TOC entry 437 (class 1255 OID 20100)
-- Name: version_trigger_booktranslation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_booktranslation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."bookTranslationId" <> OLD."bookTranslationId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "BookTranslation"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "bookTranslationId" = NEW."bookTranslationId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "BookTranslation" ("bookTranslationId", __valid, "isbn","translatorId")
            VALUES (NEW."bookTranslationId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."isbn",NEW."translatorId");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "BookTranslation"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "bookTranslationId" = OLD."bookTranslationId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_booktranslation() OWNER TO postgres;

--
-- TOC entry 440 (class 1255 OID 20154)
-- Name: version_trigger_borrow(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_borrow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."borrowId" <> OLD."borrowId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Borrow"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "borrowId" = NEW."borrowId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Borrow" ("borrowId", __valid, "bookInstanceId","membershipId","quantity","borrowDate","expectedReturnDate","actualReturnDate")
            VALUES (NEW."borrowId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."bookInstanceId",NEW."membershipId",NEW."quantity",NEW."borrowDate",NEW."expectedReturnDate",NEW."actualReturnDate");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Borrow"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "borrowId" = OLD."borrowId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_borrow() OWNER TO postgres;

--
-- TOC entry 433 (class 1255 OID 20028)
-- Name: version_trigger_genre(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_genre() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."genreId" <> OLD."genreId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Genre"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "genreId" = NEW."genreId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Genre" ("genreId", __valid, "genreName")
            VALUES (NEW."genreId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."genreName");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Genre"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "genreId" = OLD."genreId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_genre() OWNER TO postgres;

--
-- TOC entry 432 (class 1255 OID 20010)
-- Name: version_trigger_language(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_language() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."languageId" <> OLD."languageId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Language"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "languageId" = NEW."languageId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Language" ("languageId", __valid, "languageName")
            VALUES (NEW."languageId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."languageName");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Language"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "languageId" = OLD."languageId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_language() OWNER TO postgres;

--
-- TOC entry 430 (class 1255 OID 19974)
-- Name: version_trigger_member(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_member() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."membershipId" <> OLD."membershipId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Member"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "membershipId" = NEW."membershipId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Member" ("membershipId", __valid, "memberName","birthDate","joinDate","phoneNo","address")
            VALUES (NEW."membershipId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."memberName",NEW."birthDate",NEW."joinDate",NEW."phoneNo",NEW."address");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Member"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "membershipId" = OLD."membershipId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_member() OWNER TO postgres;

--
-- TOC entry 435 (class 1255 OID 20064)
-- Name: version_trigger_publication(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_publication() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."publicationId" <> OLD."publicationId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Publication"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "publicationId" = NEW."publicationId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Publication" ("publicationId", __valid, "publicationName")
            VALUES (NEW."publicationId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."publicationName");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Publication"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "publicationId" = OLD."publicationId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_publication() OWNER TO postgres;

--
-- TOC entry 431 (class 1255 OID 19992)
-- Name: version_trigger_translator(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.version_trigger_translator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE'
    THEN
        IF NEW."translatorId" <> OLD."translatorId"
        THEN
            RAISE EXCEPTION 'the ID must not be changed';
        END IF;
        UPDATE  "Translator"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE   "translatorId" = NEW."translatorId"
            AND current_timestamp <@ __valid;
        IF NOT FOUND THEN
            RETURN NULL;
        END IF;
    END IF;
    IF TG_OP IN ('INSERT', 'UPDATE')
    THEN
        INSERT INTO "Translator" ("translatorId", __valid, "translatorName")
            VALUES (NEW."translatorId",
                tstzrange(current_timestamp, TIMESTAMPTZ 'infinity'),
                NEW."translatorName");
        RETURN NEW;
    END IF;
    IF TG_OP = 'DELETE'
    THEN
        UPDATE  "Translator"
        SET     __valid = tstzrange(lower(__valid), current_timestamp)
        WHERE "translatorId" = OLD."translatorId"
            AND current_timestamp <@ __valid;
        IF FOUND THEN
            RETURN OLD;
        ELSE
            RETURN NULL;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.version_trigger_translator() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 213 (class 1259 OID 20038)
-- Name: Author; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Author" (
    "authorId" integer NOT NULL,
    "authorName" text NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."Author" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 20074)
-- Name: Book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Book" (
    isbn character varying(17) NOT NULL,
    title text NOT NULL,
    description text,
    edition real,
    "publishDate" date,
    "publicationId" integer,
    __valid tstzrange
);


ALTER TABLE public."Book" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 20182)
-- Name: BookAuthor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookAuthor" (
    "bookAuthorId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "authorId" integer NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."BookAuthor" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 20164)
-- Name: BookGenre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookGenre" (
    "bookGenreId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "genreId" integer NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."BookGenre" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 20128)
-- Name: BookInstance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookInstance" (
    "bookInstanceId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    borrowed boolean NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."BookInstance" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 20110)
-- Name: BookLanguage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookLanguage" (
    "bookLangaugeId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "languageId" integer NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."BookLanguage" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 20092)
-- Name: BookTranslation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BookTranslation" (
    "bookTranslationId" integer NOT NULL,
    isbn character varying(17) NOT NULL,
    "translatorId" integer NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."BookTranslation" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 20146)
-- Name: Borrow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Borrow" (
    "borrowId" integer NOT NULL,
    "bookInstanceId" integer NOT NULL,
    "membershipId" integer NOT NULL,
    quantity smallint,
    "borrowDate" date,
    "expectedReturnDate" date,
    "actualReturnDate" date,
    __valid tstzrange
);


ALTER TABLE public."Borrow" OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 20020)
-- Name: Genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Genre" (
    "genreId" integer NOT NULL,
    "genreName" text NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."Genre" OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 20002)
-- Name: Language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Language" (
    "languageId" integer NOT NULL,
    "languageName" text NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."Language" OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 19966)
-- Name: Member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Member" (
    "membershipId" integer NOT NULL,
    "memberName" text NOT NULL,
    "birthDate" date,
    "joinDate" date,
    "phoneNo" character varying(11),
    address text,
    __valid tstzrange
);


ALTER TABLE public."Member" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 20056)
-- Name: Publication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Publication" (
    "publicationId" integer NOT NULL,
    "publicationName" text NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."Publication" OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 19984)
-- Name: Translator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Translator" (
    "translatorId" integer NOT NULL,
    "translatorName" text NOT NULL,
    __valid tstzrange
);


ALTER TABLE public."Translator" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 20051)
-- Name: author_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.author_historic AS
 SELECT "Author"."authorId",
    "Author"."authorName"
   FROM public."Author"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Author".__valid);


ALTER TABLE public.author_historic OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 20047)
-- Name: author_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.author_recent AS
 SELECT "Author"."authorId",
    "Author"."authorName"
   FROM public."Author"
  WHERE (CURRENT_TIMESTAMP <@ "Author".__valid);


ALTER TABLE public.author_recent OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 20087)
-- Name: book_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.book_historic AS
 SELECT "Book".isbn,
    "Book".title,
    "Book".description,
    "Book".edition,
    "Book"."publishDate",
    "Book"."publicationId"
   FROM public."Book"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Book".__valid);


ALTER TABLE public.book_historic OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 20083)
-- Name: book_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.book_recent AS
 SELECT "Book".isbn,
    "Book".title,
    "Book".description,
    "Book".edition,
    "Book"."publishDate",
    "Book"."publicationId"
   FROM public."Book"
  WHERE (CURRENT_TIMESTAMP <@ "Book".__valid);


ALTER TABLE public.book_recent OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 20195)
-- Name: bookauthor_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bookauthor_historic AS
 SELECT "BookAuthor"."bookAuthorId",
    "BookAuthor".isbn,
    "BookAuthor"."authorId"
   FROM public."BookAuthor"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "BookAuthor".__valid);


ALTER TABLE public.bookauthor_historic OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 20191)
-- Name: bookauthor_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bookauthor_recent AS
 SELECT "BookAuthor"."bookAuthorId",
    "BookAuthor".isbn,
    "BookAuthor"."authorId"
   FROM public."BookAuthor"
  WHERE (CURRENT_TIMESTAMP <@ "BookAuthor".__valid);


ALTER TABLE public.bookauthor_recent OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 20177)
-- Name: bookgenre_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bookgenre_historic AS
 SELECT "BookGenre"."bookGenreId",
    "BookGenre".isbn,
    "BookGenre"."genreId"
   FROM public."BookGenre"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "BookGenre".__valid);


ALTER TABLE public.bookgenre_historic OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 20173)
-- Name: bookgenre_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bookgenre_recent AS
 SELECT "BookGenre"."bookGenreId",
    "BookGenre".isbn,
    "BookGenre"."genreId"
   FROM public."BookGenre"
  WHERE (CURRENT_TIMESTAMP <@ "BookGenre".__valid);


ALTER TABLE public.bookgenre_recent OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 20141)
-- Name: bookinstance_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bookinstance_historic AS
 SELECT "BookInstance"."bookInstanceId",
    "BookInstance".isbn,
    "BookInstance".borrowed
   FROM public."BookInstance"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "BookInstance".__valid);


ALTER TABLE public.bookinstance_historic OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 20137)
-- Name: bookinstance_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.bookinstance_recent AS
 SELECT "BookInstance"."bookInstanceId",
    "BookInstance".isbn,
    "BookInstance".borrowed
   FROM public."BookInstance"
  WHERE (CURRENT_TIMESTAMP <@ "BookInstance".__valid);


ALTER TABLE public.bookinstance_recent OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 20123)
-- Name: booklanguage_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.booklanguage_historic AS
 SELECT "BookLanguage"."bookLangaugeId",
    "BookLanguage".isbn,
    "BookLanguage"."languageId"
   FROM public."BookLanguage"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "BookLanguage".__valid);


ALTER TABLE public.booklanguage_historic OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 20119)
-- Name: booklanguage_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.booklanguage_recent AS
 SELECT "BookLanguage"."bookLangaugeId",
    "BookLanguage".isbn,
    "BookLanguage"."languageId"
   FROM public."BookLanguage"
  WHERE (CURRENT_TIMESTAMP <@ "BookLanguage".__valid);


ALTER TABLE public.booklanguage_recent OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 20105)
-- Name: booktranslation_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.booktranslation_historic AS
 SELECT "BookTranslation"."bookTranslationId",
    "BookTranslation".isbn,
    "BookTranslation"."translatorId"
   FROM public."BookTranslation"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "BookTranslation".__valid);


ALTER TABLE public.booktranslation_historic OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 20101)
-- Name: booktranslation_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.booktranslation_recent AS
 SELECT "BookTranslation"."bookTranslationId",
    "BookTranslation".isbn,
    "BookTranslation"."translatorId"
   FROM public."BookTranslation"
  WHERE (CURRENT_TIMESTAMP <@ "BookTranslation".__valid);


ALTER TABLE public.booktranslation_recent OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 20159)
-- Name: borrow_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.borrow_historic AS
 SELECT "Borrow"."borrowId",
    "Borrow"."bookInstanceId",
    "Borrow"."membershipId",
    "Borrow".quantity,
    "Borrow"."borrowDate",
    "Borrow"."expectedReturnDate",
    "Borrow"."actualReturnDate"
   FROM public."Borrow"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Borrow".__valid);


ALTER TABLE public.borrow_historic OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 20155)
-- Name: borrow_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.borrow_recent AS
 SELECT "Borrow"."borrowId",
    "Borrow"."bookInstanceId",
    "Borrow"."membershipId",
    "Borrow".quantity,
    "Borrow"."borrowDate",
    "Borrow"."expectedReturnDate",
    "Borrow"."actualReturnDate"
   FROM public."Borrow"
  WHERE (CURRENT_TIMESTAMP <@ "Borrow".__valid);


ALTER TABLE public.borrow_recent OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 20033)
-- Name: genre_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.genre_historic AS
 SELECT "Genre"."genreId",
    "Genre"."genreName"
   FROM public."Genre"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Genre".__valid);


ALTER TABLE public.genre_historic OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 20029)
-- Name: genre_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.genre_recent AS
 SELECT "Genre"."genreId",
    "Genre"."genreName"
   FROM public."Genre"
  WHERE (CURRENT_TIMESTAMP <@ "Genre".__valid);


ALTER TABLE public.genre_recent OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 20015)
-- Name: language_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.language_historic AS
 SELECT "Language"."languageId",
    "Language"."languageName"
   FROM public."Language"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Language".__valid);


ALTER TABLE public.language_historic OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 20011)
-- Name: language_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.language_recent AS
 SELECT "Language"."languageId",
    "Language"."languageName"
   FROM public."Language"
  WHERE (CURRENT_TIMESTAMP <@ "Language".__valid);


ALTER TABLE public.language_recent OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 19979)
-- Name: member_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.member_historic AS
 SELECT "Member"."membershipId",
    "Member"."memberName",
    "Member"."birthDate",
    "Member"."joinDate",
    "Member"."phoneNo",
    "Member".address
   FROM public."Member"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Member".__valid);


ALTER TABLE public.member_historic OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 19975)
-- Name: member_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.member_recent AS
 SELECT "Member"."membershipId",
    "Member"."memberName",
    "Member"."birthDate",
    "Member"."joinDate",
    "Member"."phoneNo",
    "Member".address
   FROM public."Member"
  WHERE (CURRENT_TIMESTAMP <@ "Member".__valid);


ALTER TABLE public.member_recent OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 20069)
-- Name: publication_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.publication_historic AS
 SELECT "Publication"."publicationId",
    "Publication"."publicationName"
   FROM public."Publication"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Publication".__valid);


ALTER TABLE public.publication_historic OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 20065)
-- Name: publication_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.publication_recent AS
 SELECT "Publication"."publicationId",
    "Publication"."publicationName"
   FROM public."Publication"
  WHERE (CURRENT_TIMESTAMP <@ "Publication".__valid);


ALTER TABLE public.publication_recent OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 19997)
-- Name: translator_historic; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.translator_historic AS
 SELECT "Translator"."translatorId",
    "Translator"."translatorName"
   FROM public."Translator"
  WHERE ((current_setting('timerobot.as_of_time'::text))::timestamp with time zone <@ "Translator".__valid);


ALTER TABLE public.translator_historic OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 19993)
-- Name: translator_recent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.translator_recent AS
 SELECT "Translator"."translatorId",
    "Translator"."translatorName"
   FROM public."Translator"
  WHERE (CURRENT_TIMESTAMP <@ "Translator".__valid);


ALTER TABLE public.translator_recent OWNER TO postgres;

--
-- TOC entry 3292 (class 2606 OID 20045)
-- Name: Author Author_authorId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Author"
    ADD CONSTRAINT "Author_authorId___valid_excl" EXCLUDE USING gist ("authorId" WITH =, __valid WITH &&);


--
-- TOC entry 3308 (class 2606 OID 20189)
-- Name: BookAuthor BookAuthor_bookAuthorId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookAuthor"
    ADD CONSTRAINT "BookAuthor_bookAuthorId___valid_excl" EXCLUDE USING gist ("bookAuthorId" WITH =, __valid WITH &&);


--
-- TOC entry 3306 (class 2606 OID 20171)
-- Name: BookGenre BookGenre_bookGenreId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookGenre"
    ADD CONSTRAINT "BookGenre_bookGenreId___valid_excl" EXCLUDE USING gist ("bookGenreId" WITH =, __valid WITH &&);


--
-- TOC entry 3302 (class 2606 OID 20135)
-- Name: BookInstance BookInstance_bookInstanceId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookInstance"
    ADD CONSTRAINT "BookInstance_bookInstanceId___valid_excl" EXCLUDE USING gist ("bookInstanceId" WITH =, __valid WITH &&);


--
-- TOC entry 3300 (class 2606 OID 20117)
-- Name: BookLanguage BookLanguage_bookLangaugeId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookLanguage"
    ADD CONSTRAINT "BookLanguage_bookLangaugeId___valid_excl" EXCLUDE USING gist ("bookLangaugeId" WITH =, __valid WITH &&);


--
-- TOC entry 3298 (class 2606 OID 20099)
-- Name: BookTranslation BookTranslation_bookTranslationId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BookTranslation"
    ADD CONSTRAINT "BookTranslation_bookTranslationId___valid_excl" EXCLUDE USING gist ("bookTranslationId" WITH =, __valid WITH &&);


--
-- TOC entry 3296 (class 2606 OID 20081)
-- Name: Book Book_isbn___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Book"
    ADD CONSTRAINT "Book_isbn___valid_excl" EXCLUDE USING gist (isbn WITH =, __valid WITH &&);


--
-- TOC entry 3304 (class 2606 OID 20153)
-- Name: Borrow Borrow_borrowId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Borrow"
    ADD CONSTRAINT "Borrow_borrowId___valid_excl" EXCLUDE USING gist ("borrowId" WITH =, __valid WITH &&);


--
-- TOC entry 3290 (class 2606 OID 20027)
-- Name: Genre Genre_genreId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Genre"
    ADD CONSTRAINT "Genre_genreId___valid_excl" EXCLUDE USING gist ("genreId" WITH =, __valid WITH &&);


--
-- TOC entry 3288 (class 2606 OID 20009)
-- Name: Language Language_languageId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Language"
    ADD CONSTRAINT "Language_languageId___valid_excl" EXCLUDE USING gist ("languageId" WITH =, __valid WITH &&);


--
-- TOC entry 3284 (class 2606 OID 19973)
-- Name: Member Member_membershipId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Member"
    ADD CONSTRAINT "Member_membershipId___valid_excl" EXCLUDE USING gist ("membershipId" WITH =, __valid WITH &&);


--
-- TOC entry 3294 (class 2606 OID 20063)
-- Name: Publication Publication_publicationId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Publication"
    ADD CONSTRAINT "Publication_publicationId___valid_excl" EXCLUDE USING gist ("publicationId" WITH =, __valid WITH &&);


--
-- TOC entry 3286 (class 2606 OID 19991)
-- Name: Translator Translator_translatorId___valid_excl; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Translator"
    ADD CONSTRAINT "Translator_translatorId___valid_excl" EXCLUDE USING gist ("translatorId" WITH =, __valid WITH &&);


--
-- TOC entry 3313 (class 2620 OID 20055)
-- Name: author_recent author_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER author_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.author_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_author();


--
-- TOC entry 3315 (class 2620 OID 20091)
-- Name: book_recent book_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER book_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.book_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_book();


--
-- TOC entry 3321 (class 2620 OID 20199)
-- Name: bookauthor_recent bookauthor_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bookauthor_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.bookauthor_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_bookauthor();


--
-- TOC entry 3320 (class 2620 OID 20181)
-- Name: bookgenre_recent bookgenre_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bookgenre_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.bookgenre_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_bookgenre();


--
-- TOC entry 3318 (class 2620 OID 20145)
-- Name: bookinstance_recent bookinstance_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bookinstance_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.bookinstance_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_bookinstance();


--
-- TOC entry 3317 (class 2620 OID 20127)
-- Name: booklanguage_recent booklanguage_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER booklanguage_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.booklanguage_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_booklanguage();


--
-- TOC entry 3316 (class 2620 OID 20109)
-- Name: booktranslation_recent booktranslation_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER booktranslation_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.booktranslation_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_booktranslation();


--
-- TOC entry 3319 (class 2620 OID 20163)
-- Name: borrow_recent borrow_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER borrow_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.borrow_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_borrow();


--
-- TOC entry 3312 (class 2620 OID 20037)
-- Name: genre_recent genre_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER genre_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.genre_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_genre();


--
-- TOC entry 3311 (class 2620 OID 20019)
-- Name: language_recent language_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER language_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.language_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_language();


--
-- TOC entry 3309 (class 2620 OID 19983)
-- Name: member_recent member_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER member_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.member_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_member();


--
-- TOC entry 3314 (class 2620 OID 20073)
-- Name: publication_recent publication_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER publication_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.publication_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_publication();


--
-- TOC entry 3310 (class 2620 OID 20001)
-- Name: translator_recent translator_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER translator_trig INSTEAD OF INSERT OR DELETE OR UPDATE ON public.translator_recent FOR EACH ROW EXECUTE FUNCTION public.version_trigger_translator();


-- Completed on 2021-07-11 18:21:58

--
-- PostgreSQL database dump complete
--

