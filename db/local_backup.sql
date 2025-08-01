--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: magasin_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO magasin_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: produits; Type: TABLE; Schema: public; Owner: magasin_user
--

CREATE TABLE public.produits (
    id integer NOT NULL,
    nom character varying(255),
    categorie character varying(255),
    prix double precision,
    quantite integer
);


ALTER TABLE public.produits OWNER TO magasin_user;

--
-- Name: produits_id_seq; Type: SEQUENCE; Schema: public; Owner: magasin_user
--

CREATE SEQUENCE public.produits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produits_id_seq OWNER TO magasin_user;

--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: magasin_user
--

CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sales_id_seq OWNER TO magasin_user;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: magasin_user
--

CREATE TABLE public.sales (
    id integer DEFAULT nextval('public.sales_id_seq'::regclass) NOT NULL,
    store_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    "saleDate" timestamp without time zone NOT NULL
);


ALTER TABLE public.sales OWNER TO magasin_user;

--
-- Name: stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: magasin_user
--

CREATE SEQUENCE public.stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stocks_id_seq OWNER TO magasin_user;

--
-- Name: stocks; Type: TABLE; Schema: public; Owner: magasin_user
--

CREATE TABLE public.stocks (
    id integer DEFAULT nextval('public.stocks_id_seq'::regclass) NOT NULL,
    store_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.stocks OWNER TO magasin_user;

--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: magasin_user
--

CREATE SEQUENCE public.stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stores_id_seq OWNER TO magasin_user;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: magasin_user
--

CREATE TABLE public.stores (
    id integer DEFAULT nextval('public.stores_id_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.stores OWNER TO magasin_user;

--
-- Data for Name: produits; Type: TABLE DATA; Schema: public; Owner: magasin_user
--

COPY public.produits (id, nom, categorie, prix, quantite) FROM stdin;
2	Lait	Nourriture	1.8	50
3	Savon	Hygiène	3.2	30
1	Pain	Nourriture	2.5	83
0	Laptop Dell	Informatique	999.99	25
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: magasin_user
--

COPY public.sales (id, store_id, product_id, quantity, "saleDate") FROM stdin;
1	1	1	16	2025-06-07 19:58:51.667
2	1	1	1	2025-06-08 10:42:25.191
3	1	1	73	2025-06-08 11:21:27.3
4	1	1	300	2025-06-08 11:58:19.747
5	1	1	1	2025-06-08 11:58:43.676
6	1	1	71	2025-06-08 12:07:19.386
7	1	3	30	2025-06-08 12:08:04.745
8	1	1	1	2025-06-08 12:47:51.064
9	1	1	30	2025-06-08 12:53:44.537
\.


--
-- Data for Name: stocks; Type: TABLE DATA; Schema: public; Owner: magasin_user
--

COPY public.stocks (id, store_id, product_id, quantity) FROM stdin;
2	1	2	1603
3	1	3	930
5	2	2	1600
6	2	3	960
4	2	1	2837
8	3	2	1600
9	3	3	960
7	3	1	2837
11	4	2	1600
12	4	3	960
10	4	1	2837
14	5	2	1600
15	5	3	960
13	5	1	2837
17	6	2	1597
18	6	3	960
20	7	2	1600
21	7	3	960
19	7	1	2837
16	6	1	2835
1	1	1	2353
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: magasin_user
--

COPY public.stores (id, name) FROM stdin;
1	Magasin 1
2	Magasin 2
3	Magasin 3
4	Magasin 4
5	Magasin 5
6	Logistique
7	Maison-Mère
\.


--
-- Name: produits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: magasin_user
--

SELECT pg_catalog.setval('public.produits_id_seq', 1, false);


--
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: magasin_user
--

SELECT pg_catalog.setval('public.sales_id_seq', 9, true);


--
-- Name: stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: magasin_user
--

SELECT pg_catalog.setval('public.stocks_id_seq', 21, true);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: magasin_user
--

SELECT pg_catalog.setval('public.stores_id_seq', 7, true);


--
-- Name: produits produits_pkey; Type: CONSTRAINT; Schema: public; Owner: magasin_user
--

ALTER TABLE ONLY public.produits
    ADD CONSTRAINT produits_pkey PRIMARY KEY (id);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: magasin_user
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: magasin_user
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: stocks stocks_store_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: magasin_user
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stocks_store_id_product_id_key UNIQUE (store_id, product_id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: magasin_user
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

-- ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO magasin_user;


--
-- PostgreSQL database dump complete
--

