--
-- PostgreSQL database cluster dump
--

-- Started on 2023-12-21 15:42:30

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE admin;
ALTER ROLE admin WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE client;
ALTER ROLE client WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:1jkqzIw0vFT3zyGDuEbeMg==$JinjGL1dj10s/AH5PpcjcXsD0NIGuKXX/czO9Hwy6bM=:VyoyTuGkpuXlJPDIN0jELYC0IsNwgCByWE2fKwD+vT0=';
CREATE ROLE customer;
ALTER ROLE customer WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;

--
-- User Configurations
--


--
-- Role memberships
--

GRANT client TO customer WITH INHERIT TRUE GRANTED BY "user";






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg110+1)
-- Dumped by pg_dump version 16.1

-- Started on 2023-12-21 15:42:30

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

-- Completed on 2023-12-21 15:42:31

--
-- PostgreSQL database dump complete
--

--
-- Database "netstream" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg110+1)
-- Dumped by pg_dump version 16.1

-- Started on 2023-12-21 15:42:31

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
-- TOC entry 3494 (class 1262 OID 16384)
-- Name: netstream; Type: DATABASE; Schema: -; Owner: user
--

CREATE DATABASE netstream WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';

ALTER DATABASE netstream OWNER TO "user";

\connect netstream

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
-- TOC entry 2 (class 3079 OID 16583)
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- TOC entry 287 (class 1255 OID 16807)
-- Name: getmovies(character varying); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.getmovies(director_name character varying) RETURNS TABLE(id integer, titre character varying, duree time without time zone, annee date, director_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT "Movie".id, "Movie".titre, "Movie".duree, "Movie".annee, "Movie".director_id
    FROM "Movie"
    INNER JOIN "Director" ON "Movie".director_id = "Director".id
    WHERE "Director".nom = director_name;
END;
$$;


ALTER FUNCTION public.getmovies(director_name character varying) OWNER TO "user";

--
-- TOC entry 245 (class 1255 OID 16777)
-- Name: trigger_update_user(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.trigger_update_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

   
BEGIN

-- Vérifie si les valeurs de la table USER sont modifiés
-- Pour le nom
        IF OLD.nom IS DISTINCT
		FROM NEW.nom THEN
		INSERT INTO UserArchive (user_id, operation_type, old_data, new_data, datecreation)
            VALUES (NEW.id, 'update', OLD.nom, NEW.nom, OLD.datecreation);
END IF;
-- Pour le prénom
IF OLD.prenom IS DISTINCT
		FROM NEW.prenom THEN
		INSERT INTO UserArchive (user_id, operation_type, old_data, new_data, datecreation)
            VALUES (NEW.id, 'update', old.prenom, NEW.prenom, OLD.datecreation);
END IF;
-- Pour le password
IF OLD.password IS DISTINCT
		FROM NEW.password THEN
		INSERT INTO UserArchive (user_id, operation_type, old_data, new_data, datecreation)
            VALUES (NEW.id, 'update', OLD.password, NEW.password, OLD.datecreation);
END IF;

-- Pour le role
IF OLD.role IS DISTINCT
		FROM NEW.role THEN
		INSERT INTO UserArchive (user_id, operation_type, old_data, new_data, datecreation)
            VALUES (NEW.id, 'update', OLD.role, NEW.role, OLD.datecreation);
END IF;

RETURN NEW;
    END;
$$;


ALTER FUNCTION public.trigger_update_user() OWNER TO "user";

--
-- TOC entry 220 (class 1259 OID 16407)
-- Name: Actor_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Actor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Actor_id_seq" OWNER TO "user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16408)
-- Name: Actor; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Actor" (
    id integer DEFAULT nextval('public."Actor_id_seq"'::regclass) NOT NULL,
    nom character varying(25),
    prenom character varying(25),
    role character varying(20),
    birth date,
    age integer
);


ALTER TABLE public."Actor" OWNER TO "user";

--
-- TOC entry 218 (class 1259 OID 16400)
-- Name: Director_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Director_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Director_id_seq" OWNER TO "user";

--
-- TOC entry 219 (class 1259 OID 16401)
-- Name: Director; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Director" (
    id integer DEFAULT nextval('public."Director_id_seq"'::regclass) NOT NULL,
    nom character varying(25),
    prenom character varying(25)
);


ALTER TABLE public."Director" OWNER TO "user";

--
-- TOC entry 225 (class 1259 OID 16442)
-- Name: FavoriteMovie; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."FavoriteMovie" (
    id_user integer,
    id_movie integer
);


ALTER TABLE public."FavoriteMovie" OWNER TO "user";

--
-- TOC entry 222 (class 1259 OID 16414)
-- Name: Movie_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."Movie_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Movie_id_seq" OWNER TO "user";

--
-- TOC entry 223 (class 1259 OID 16415)
-- Name: Movie; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."Movie" (
    id integer DEFAULT nextval('public."Movie_id_seq"'::regclass) NOT NULL,
    titre character varying(80),
    duree time without time zone,
    annee date,
    director_id integer
);


ALTER TABLE public."Movie" OWNER TO "user";

--
-- TOC entry 224 (class 1259 OID 16426)
-- Name: RoleActorMovie; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."RoleActorMovie" (
    id_actor integer,
    id_movie integer
);


ALTER TABLE public."RoleActorMovie" OWNER TO "user";

--
-- TOC entry 216 (class 1259 OID 16393)
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO "user";

--
-- TOC entry 217 (class 1259 OID 16394)
-- Name: User; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public."User" (
    id integer DEFAULT nextval('public."User_id_seq"'::regclass) NOT NULL,
    nom character varying(25),
    prenom character varying(25),
    email character varying(100),
    password character varying(100),
    role character varying(20),
    datecreation timestamp with time zone DEFAULT now()
);


ALTER TABLE public."User" OWNER TO "user";

--
-- TOC entry 228 (class 1259 OID 16763)
-- Name: userarchive; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.userarchive (
    archive_id integer NOT NULL,
    user_id integer,
    operation_type character varying(10),
    old_data text,
    new_data text,
    datecreation timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    date_modification timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.userarchive OWNER TO "user";

--
-- TOC entry 226 (class 1259 OID 16506)
-- Name: userarchive_archive_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.userarchive_archive_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userarchive_archive_id_seq OWNER TO "user";

--
-- TOC entry 227 (class 1259 OID 16762)
-- Name: userarchive_archive_id_seq1; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.userarchive_archive_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.userarchive_archive_id_seq1 OWNER TO "user";

--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 227
-- Name: userarchive_archive_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.userarchive_archive_id_seq1 OWNED BY public.userarchive.archive_id;


--
-- TOC entry 3314 (class 2604 OID 16766)
-- Name: userarchive archive_id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.userarchive ALTER COLUMN archive_id SET DEFAULT nextval('public.userarchive_archive_id_seq1'::regclass);


--
-- TOC entry 3481 (class 0 OID 16408)
-- Dependencies: 221
-- Data for Name: Actor; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public."Actor" (id, nom, prenom, role, birth, age) FROM stdin;
2	Poteau	Florian	Action	2001-05-23	22
3	Katz	Sarah	Comédienne	1975-01-01	48
5	Dampierre	Gerard	cascadeur	2002-12-03	21
1	Drapier	Nicolas	Padoue	2023-12-18	21
\.


--
-- TOC entry 3479 (class 0 OID 16401)
-- Dependencies: 219
-- Data for Name: Director; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public."Director" (id, nom, prenom) FROM stdin;
1	Baudrin	Thomas
\.


--
-- TOC entry 3485 (class 0 OID 16442)
-- Dependencies: 225
-- Data for Name: FavoriteMovie; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public."FavoriteMovie" (id_user, id_movie) FROM stdin;
\.


--
-- TOC entry 3483 (class 0 OID 16415)
-- Dependencies: 223
-- Data for Name: Movie; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public."Movie" (id, titre, duree, annee, director_id) FROM stdin;
1	FitFat	02:30:00	2023-05-24	1
2	titre de film	01:20:53	2020-03-22	1
3	Harry Pother	01:10:34	2001-04-22	1
4	une série	02:22:10	2020-03-20	1
5	Pas d'inspi :(	01:50:22	2020-03-21	1
6	Concepteur développeur dapplications	01:50:43	1992-03-20	1
\.


--
-- TOC entry 3484 (class 0 OID 16426)
-- Dependencies: 224
-- Data for Name: RoleActorMovie; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public."RoleActorMovie" (id_actor, id_movie) FROM stdin;
1	1
2	3
3	4
\.


--
-- TOC entry 3477 (class 0 OID 16394)
-- Dependencies: 217
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public."User" (id, nom, prenom, email, password, role, datecreation) FROM stdin;
1	Poteau	Florian	florianpoteau59@gmail.com	password	ADMIN	2023-12-19 11:02:39.695923+00
2	Diere	John	john.doe@example.com	password123	admin	2023-12-19 11:02:39.695923+00
3	dampierre	gerard	fauxemail@fauxemail.com	pwd	user	2023-12-19 11:06:11.047702+00
\.


--
-- TOC entry 3488 (class 0 OID 16763)
-- Dependencies: 228
-- Data for Name: userarchive; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.userarchive (archive_id, user_id, operation_type, old_data, new_data, datecreation, date_modification) FROM stdin;
1	1	update	prenom: Florian, role: ADMIN	prenom: FlorianED, role: ADMINISTRATEUR	2023-12-19 11:02:39.695923	2023-12-19 15:19:23.092216
2	1	update	nom: Poteause	nom: Poteau	2023-12-19 11:02:39.695923	2023-12-19 15:19:54.151912
3	1	update	nom: Poteau, prenom: FlorianED, role: ADMINISTRATEUR	nom: PoteauSEUR, prenom: FlorianEDoua, role: ADMIN	2023-12-19 11:02:39.695923	2023-12-19 15:20:39.679224
4	1	update	nom: PoteauSEUR, prenom: FlorianEDoua	nom: Poteau, prenom: Florian	2023-12-19 11:02:39.695923	2023-12-19 15:21:21.266381
5	2	update	nom: DIEEEERE	nom: Diere	2023-12-19 11:02:39.695923	2023-12-19 15:21:21.266381
7	1	update	Poteau	Poteause	2023-12-19 11:02:39.695923	2023-12-20 08:35:28.106714
8	1	update	Poteause	Poteau	2023-12-19 11:02:39.695923	2023-12-20 08:36:36.360245
9	1	update	Florian	Florianfd	2023-12-19 11:02:39.695923	2023-12-20 08:36:36.360245
10	2	update	John	Johnatan	2023-12-19 11:02:39.695923	2023-12-20 08:36:36.360245
11	3	update	dampierre	dampierres	2023-12-19 11:06:11.047702	2023-12-20 08:36:36.360245
12	3	update	gerard	gerards	2023-12-19 11:06:11.047702	2023-12-20 08:36:36.360245
13	1	update	Florianfd	Florian	2023-12-19 11:02:39.695923	2023-12-20 08:37:12.757822
14	2	update	Johnatan	John	2023-12-19 11:02:39.695923	2023-12-20 08:37:12.757822
15	3	update	dampierres	dampierre	2023-12-19 11:06:11.047702	2023-12-20 08:37:12.757822
16	3	update	gerards	gerard	2023-12-19 11:06:11.047702	2023-12-20 08:37:12.757822
\.


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 220
-- Name: Actor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public."Actor_id_seq"', 5, true);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 218
-- Name: Director_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public."Director_id_seq"', 1, false);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 222
-- Name: Movie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public."Movie_id_seq"', 6, true);


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 216
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public."User_id_seq"', 1, true);


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 226
-- Name: userarchive_archive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.userarchive_archive_id_seq', 14, true);


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 227
-- Name: userarchive_archive_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.userarchive_archive_id_seq1', 16, true);


--
-- TOC entry 3322 (class 2606 OID 16413)
-- Name: Actor Actor_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Actor"
    ADD CONSTRAINT "Actor_pkey" PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 16406)
-- Name: Director Director_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Director"
    ADD CONSTRAINT "Director_pkey" PRIMARY KEY (id);


--
-- TOC entry 3324 (class 2606 OID 16420)
-- Name: Movie Movie_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Movie"
    ADD CONSTRAINT "Movie_pkey" PRIMARY KEY (id);


--
-- TOC entry 3318 (class 2606 OID 16399)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- TOC entry 3326 (class 2606 OID 16772)
-- Name: userarchive userarchive_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.userarchive
    ADD CONSTRAINT userarchive_pkey PRIMARY KEY (archive_id);


--
-- TOC entry 3332 (class 2620 OID 16778)
-- Name: User update_value; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER update_value BEFORE UPDATE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.trigger_update_user();


--
-- TOC entry 3330 (class 2606 OID 16450)
-- Name: FavoriteMovie FavoriteMovie_id_movie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."FavoriteMovie"
    ADD CONSTRAINT "FavoriteMovie_id_movie_fkey" FOREIGN KEY (id_movie) REFERENCES public."Movie"(id);


--
-- TOC entry 3331 (class 2606 OID 16445)
-- Name: FavoriteMovie FavoriteMovie_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."FavoriteMovie"
    ADD CONSTRAINT "FavoriteMovie_id_user_fkey" FOREIGN KEY (id_user) REFERENCES public."User"(id);


--
-- TOC entry 3327 (class 2606 OID 16421)
-- Name: Movie Movie_director_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."Movie"
    ADD CONSTRAINT "Movie_director_id_fkey" FOREIGN KEY (director_id) REFERENCES public."Director"(id);


--
-- TOC entry 3328 (class 2606 OID 16429)
-- Name: RoleActorMovie RoleActorMovie_id_actor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."RoleActorMovie"
    ADD CONSTRAINT "RoleActorMovie_id_actor_fkey" FOREIGN KEY (id_actor) REFERENCES public."Actor"(id);


--
-- TOC entry 3329 (class 2606 OID 16434)
-- Name: RoleActorMovie RoleActorMovie_id_movie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public."RoleActorMovie"
    ADD CONSTRAINT "RoleActorMovie_id_movie_fkey" FOREIGN KEY (id_movie) REFERENCES public."Movie"(id);


--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE "Actor_id_seq"; Type: ACL; Schema: public; Owner: user
--

REVOKE ALL ON SEQUENCE public."Actor_id_seq" FROM "user";
GRANT SELECT,UPDATE ON SEQUENCE public."Actor_id_seq" TO admin;


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "Actor"; Type: ACL; Schema: public; Owner: user
--

REVOKE ALL ON TABLE public."Actor" FROM "user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Actor" TO admin;
GRANT SELECT ON TABLE public."Actor" TO client;


--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 218
-- Name: SEQUENCE "Director_id_seq"; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT,UPDATE ON SEQUENCE public."Director_id_seq" TO admin;


--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE "Director"; Type: ACL; Schema: public; Owner: user
--

REVOKE ALL ON TABLE public."Director" FROM "user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Director" TO admin;
GRANT SELECT ON TABLE public."Director" TO client;


--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "FavoriteMovie"; Type: ACL; Schema: public; Owner: user
--

REVOKE ALL ON TABLE public."FavoriteMovie" FROM "user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."FavoriteMovie" TO admin;
GRANT SELECT ON TABLE public."FavoriteMovie" TO client;


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE "Movie_id_seq"; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT,UPDATE ON SEQUENCE public."Movie_id_seq" TO admin;


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE "Movie"; Type: ACL; Schema: public; Owner: user
--

REVOKE ALL ON TABLE public."Movie" FROM "user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Movie" TO admin;
GRANT SELECT ON TABLE public."Movie" TO client;


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE "RoleActorMovie"; Type: ACL; Schema: public; Owner: user
--

REVOKE ALL ON TABLE public."RoleActorMovie" FROM "user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."RoleActorMovie" TO admin;
GRANT SELECT ON TABLE public."RoleActorMovie" TO client;


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 216
-- Name: SEQUENCE "User_id_seq"; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT,UPDATE ON SEQUENCE public."User_id_seq" TO admin;


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "User"; Type: ACL; Schema: public; Owner: user
--

REVOKE ALL ON TABLE public."User" FROM "user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."User" TO admin;
GRANT SELECT ON TABLE public."User" TO client;


--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE userarchive_archive_id_seq; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT,UPDATE ON SEQUENCE public.userarchive_archive_id_seq TO admin;


-- Completed on 2023-12-21 15:42:31

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg110+1)
-- Dumped by pg_dump version 16.1

-- Started on 2023-12-21 15:42:31

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

-- Completed on 2023-12-21 15:42:31

--
-- PostgreSQL database dump complete
--

-- Completed on 2023-12-21 15:42:31

--
-- PostgreSQL database cluster dump complete
--

