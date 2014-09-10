--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.4
-- Started on 2014-09-10 14:41:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 198 (class 3079 OID 11756)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2144 (class 0 OID 0)
-- Dependencies: 198
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 529839)
-- Name: agency; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE agency (
    agency_id integer NOT NULL,
    agency_name character varying(255) NOT NULL,
    agency_url character varying(255) NOT NULL,
    agency_timezone character varying(50) NOT NULL,
    agency_lang character varying(2),
    agency_phone character varying(20),
    agency_fare_url character varying(255),
    agency_gtfs_id character varying(50) NOT NULL
);


ALTER TABLE public.agency OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 529928)
-- Name: agency_agency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE agency_agency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agency_agency_id_seq OWNER TO postgres;

--
-- TOC entry 2145 (class 0 OID 0)
-- Dependencies: 173
-- Name: agency_agency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agency_agency_id_seq OWNED BY agency.agency_id;


--
-- TOC entry 179 (class 1259 OID 529988)
-- Name: calendar; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calendar (
    service_id integer NOT NULL,
    monday boolean NOT NULL,
    tuesday boolean NOT NULL,
    wednesday boolean NOT NULL,
    thursday boolean NOT NULL,
    friday boolean NOT NULL,
    saturday boolean NOT NULL,
    sunday boolean NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    calendar_gtfs_id character varying(50) NOT NULL,
    agency_id integer NOT NULL
);


ALTER TABLE public.calendar OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 529996)
-- Name: calendar_date; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE calendar_date (
    calendar_date_id integer NOT NULL,
    service_id integer NOT NULL,
    date date NOT NULL,
    exception_type integer NOT NULL
);


ALTER TABLE public.calendar_date OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 529994)
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calendar_date_calendar_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calendar_date_calendar_date_id_seq OWNER TO postgres;

--
-- TOC entry 2146 (class 0 OID 0)
-- Dependencies: 180
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calendar_date_calendar_date_id_seq OWNED BY calendar_date.calendar_date_id;


--
-- TOC entry 178 (class 1259 OID 529986)
-- Name: calendar_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE calendar_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calendar_service_id_seq OWNER TO postgres;

--
-- TOC entry 2147 (class 0 OID 0)
-- Dependencies: 178
-- Name: calendar_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calendar_service_id_seq OWNED BY calendar.service_id;


--
-- TOC entry 185 (class 1259 OID 530036)
-- Name: fare_attribute; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fare_attribute (
    fare_id integer NOT NULL,
    price double precision NOT NULL,
    currency_type character varying(3) NOT NULL,
    transfers integer,
    transfer_duration integer,
    agency_id integer NOT NULL,
    fare_attribute_gtfs_id character varying(50) NOT NULL,
    payment_method integer NOT NULL
);


ALTER TABLE public.fare_attribute OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 530034)
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fare_attribute_fare_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fare_attribute_fare_id_seq OWNER TO postgres;

--
-- TOC entry 2148 (class 0 OID 0)
-- Dependencies: 184
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fare_attribute_fare_id_seq OWNED BY fare_attribute.fare_id;


--
-- TOC entry 189 (class 1259 OID 530058)
-- Name: fare_rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fare_rule (
    fare_rule_id integer NOT NULL,
    fare_id integer NOT NULL,
    route_id integer,
    origin_id integer,
    destination_id integer,
    contains_id integer
);


ALTER TABLE public.fare_rule OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 530056)
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fare_rule_fare_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fare_rule_fare_rule_id_seq OWNER TO postgres;

--
-- TOC entry 2149 (class 0 OID 0)
-- Dependencies: 188
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fare_rule_fare_rule_id_seq OWNED BY fare_rule.fare_rule_id;


--
-- TOC entry 197 (class 1259 OID 530159)
-- Name: feed_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE feed_info (
    feed_info_id integer NOT NULL,
    feed_publisher_name character varying(50) NOT NULL,
    feed_publisher_url character varying(255) NOT NULL,
    feed_lang character varying(20) NOT NULL,
    feed_start_date date,
    feed_end_date date,
    feed_version character varying(20),
    feed_name character varying(50) NOT NULL,
    feed_description character varying(255)
);


ALTER TABLE public.feed_info OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 530157)
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE feed_info_feed_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feed_info_feed_info_id_seq OWNER TO postgres;

--
-- TOC entry 2150 (class 0 OID 0)
-- Dependencies: 196
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE feed_info_feed_info_id_seq OWNED BY feed_info.feed_info_id;


--
-- TOC entry 177 (class 1259 OID 529974)
-- Name: frequency; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE frequency (
    frequency_id integer NOT NULL,
    trip_id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    headway_secs integer NOT NULL,
    exact_times integer
);


ALTER TABLE public.frequency OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 529972)
-- Name: frequency_frequency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE frequency_frequency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.frequency_frequency_id_seq OWNER TO postgres;

--
-- TOC entry 2151 (class 0 OID 0)
-- Dependencies: 176
-- Name: frequency_frequency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE frequency_frequency_id_seq OWNED BY frequency.frequency_id;


--
-- TOC entry 171 (class 1259 OID 529861)
-- Name: route; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE route (
    route_id integer NOT NULL,
    agency_id integer,
    route_short_name character varying(50) NOT NULL,
    route_long_name character varying(255) NOT NULL,
    route_desc character varying(255),
    route_type integer NOT NULL,
    route_url character varying(255),
    route_color character varying(7) DEFAULT '#FFFFFF'::character varying,
    route_text_color character varying(7) DEFAULT '#000000'::character varying,
    route_gtfs_id character varying(50) NOT NULL
);


ALTER TABLE public.route OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 529902)
-- Name: route_route_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE route_route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.route_route_id_seq OWNER TO postgres;

--
-- TOC entry 2152 (class 0 OID 0)
-- Dependencies: 172
-- Name: route_route_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE route_route_id_seq OWNED BY route.route_id;


--
-- TOC entry 183 (class 1259 OID 530011)
-- Name: shape; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shape (
    shape_id integer NOT NULL,
    shape_encoded_polyline text NOT NULL,
    agency_id integer NOT NULL
);


ALTER TABLE public.shape OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 530009)
-- Name: shape_shape_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shape_shape_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shape_shape_id_seq OWNER TO postgres;

--
-- TOC entry 2153 (class 0 OID 0)
-- Dependencies: 182
-- Name: shape_shape_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shape_shape_id_seq OWNED BY shape.shape_id;


--
-- TOC entry 191 (class 1259 OID 530096)
-- Name: stop; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stop (
    stop_id integer NOT NULL,
    stop_code character varying(20),
    stop_name character varying(50) NOT NULL,
    zone_id integer,
    stop_url character varying(255),
    parent_station integer,
    stop_timezone character varying(50),
    wheelchair_boarding integer,
    stop_desc character varying(255),
    location_type integer,
    stop_lat double precision NOT NULL,
    stop_lon double precision NOT NULL,
    agency_id integer NOT NULL,
    stop_gtfs_id character varying(50) NOT NULL
);


ALTER TABLE public.stop OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 530094)
-- Name: stop_stop_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE stop_stop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stop_stop_id_seq OWNER TO postgres;

--
-- TOC entry 2154 (class 0 OID 0)
-- Dependencies: 190
-- Name: stop_stop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stop_stop_id_seq OWNED BY stop.stop_id;


--
-- TOC entry 193 (class 1259 OID 530119)
-- Name: stop_time; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stop_time (
    stop_time_id integer NOT NULL,
    trip_id integer NOT NULL,
    arrival_time time without time zone NOT NULL,
    departure_time time without time zone NOT NULL,
    stop_id integer NOT NULL,
    stop_sequence integer NOT NULL,
    stop_headsign character varying(50),
    pickup_type integer,
    drop_off_type integer,
    shape_dist_traveled double precision,
    continue_from_previous_day boolean
);


ALTER TABLE public.stop_time OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 530117)
-- Name: stop_time_stop_time_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE stop_time_stop_time_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stop_time_stop_time_id_seq OWNER TO postgres;

--
-- TOC entry 2155 (class 0 OID 0)
-- Dependencies: 192
-- Name: stop_time_stop_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stop_time_stop_time_id_seq OWNED BY stop_time.stop_time_id;


--
-- TOC entry 195 (class 1259 OID 530139)
-- Name: transfer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE transfer (
    transfer_id integer NOT NULL,
    from_stop_id integer NOT NULL,
    to_stop_id integer NOT NULL,
    transfer_type integer NOT NULL,
    min_transfer_time integer,
    agency_id integer NOT NULL
);


ALTER TABLE public.transfer OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 530137)
-- Name: transfer_transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transfer_transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfer_transfer_id_seq OWNER TO postgres;

--
-- TOC entry 2156 (class 0 OID 0)
-- Dependencies: 194
-- Name: transfer_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE transfer_transfer_id_seq OWNED BY transfer.transfer_id;


--
-- TOC entry 175 (class 1259 OID 529966)
-- Name: trip; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trip (
    trip_id integer NOT NULL,
    route_id integer NOT NULL,
    service_id integer,
    trip_headsign character varying(50),
    trip_short_name character varying(50),
    block_id integer,
    shape_id integer,
    wheelchair_accessible integer,
    bikes_allowed integer,
    direction_id integer,
    trip_gtfs_id character varying(50) NOT NULL
);


ALTER TABLE public.trip OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 529964)
-- Name: trip_trip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trip_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trip_trip_id_seq OWNER TO postgres;

--
-- TOC entry 2157 (class 0 OID 0)
-- Dependencies: 174
-- Name: trip_trip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trip_trip_id_seq OWNED BY trip.trip_id;


--
-- TOC entry 187 (class 1259 OID 530044)
-- Name: zone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE zone (
    zone_id integer NOT NULL,
    name character varying(50),
    zone_gtfs_id character varying(50) NOT NULL,
    agency_id integer NOT NULL
);


ALTER TABLE public.zone OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 530042)
-- Name: zone_zone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE zone_zone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.zone_zone_id_seq OWNER TO postgres;

--
-- TOC entry 2158 (class 0 OID 0)
-- Dependencies: 186
-- Name: zone_zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE zone_zone_id_seq OWNED BY zone.zone_id;


--
-- TOC entry 1910 (class 2604 OID 637471)
-- Name: agency_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agency ALTER COLUMN agency_id SET DEFAULT nextval('agency_agency_id_seq'::regclass);


--
-- TOC entry 1916 (class 2604 OID 637472)
-- Name: service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar ALTER COLUMN service_id SET DEFAULT nextval('calendar_service_id_seq'::regclass);


--
-- TOC entry 1917 (class 2604 OID 637473)
-- Name: calendar_date_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar_date ALTER COLUMN calendar_date_id SET DEFAULT nextval('calendar_date_calendar_date_id_seq'::regclass);


--
-- TOC entry 1919 (class 2604 OID 637474)
-- Name: fare_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_attribute ALTER COLUMN fare_id SET DEFAULT nextval('fare_attribute_fare_id_seq'::regclass);


--
-- TOC entry 1921 (class 2604 OID 637475)
-- Name: fare_rule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule ALTER COLUMN fare_rule_id SET DEFAULT nextval('fare_rule_fare_rule_id_seq'::regclass);


--
-- TOC entry 1925 (class 2604 OID 637476)
-- Name: feed_info_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feed_info ALTER COLUMN feed_info_id SET DEFAULT nextval('feed_info_feed_info_id_seq'::regclass);


--
-- TOC entry 1915 (class 2604 OID 637477)
-- Name: frequency_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY frequency ALTER COLUMN frequency_id SET DEFAULT nextval('frequency_frequency_id_seq'::regclass);


--
-- TOC entry 1911 (class 2604 OID 637478)
-- Name: route_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY route ALTER COLUMN route_id SET DEFAULT nextval('route_route_id_seq'::regclass);


--
-- TOC entry 1918 (class 2604 OID 637479)
-- Name: shape_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shape ALTER COLUMN shape_id SET DEFAULT nextval('shape_shape_id_seq'::regclass);


--
-- TOC entry 1922 (class 2604 OID 637480)
-- Name: stop_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop ALTER COLUMN stop_id SET DEFAULT nextval('stop_stop_id_seq'::regclass);


--
-- TOC entry 1923 (class 2604 OID 637481)
-- Name: stop_time_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop_time ALTER COLUMN stop_time_id SET DEFAULT nextval('stop_time_stop_time_id_seq'::regclass);


--
-- TOC entry 1924 (class 2604 OID 637482)
-- Name: transfer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer ALTER COLUMN transfer_id SET DEFAULT nextval('transfer_transfer_id_seq'::regclass);


--
-- TOC entry 1914 (class 2604 OID 637483)
-- Name: trip_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip ALTER COLUMN trip_id SET DEFAULT nextval('trip_trip_id_seq'::regclass);


--
-- TOC entry 1920 (class 2604 OID 637484)
-- Name: zone_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN zone_id SET DEFAULT nextval('zone_zone_id_seq'::regclass);


--
-- TOC entry 2109 (class 0 OID 529839)
-- Dependencies: 170
-- Data for Name: agency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY agency (agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone, agency_fare_url, agency_gtfs_id) FROM stdin;
51	Metro	http://www.metrotorino.it/index_flash.php	Europe/Rome	it	011/98-65-320		M
400	Gruppo Torinese Trasporti	http://www.gtt.to.it/	Europe/Rome	it			GTT
\.


--
-- TOC entry 2159 (class 0 OID 0)
-- Dependencies: 173
-- Name: agency_agency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('agency_agency_id_seq', 14, true);


--
-- TOC entry 2118 (class 0 OID 529988)
-- Dependencies: 179
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calendar (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date, calendar_gtfs_id, agency_id) FROM stdin;
350	t	t	t	t	t	f	f	2014-07-01	2014-07-31	Estivo fer5	51
301	f	f	f	f	f	t	t	2014-07-01	2014-08-31	FESTest	400
450	t	t	t	t	t	f	f	2014-07-01	2014-08-31	FER5est	400
\.


--
-- TOC entry 2120 (class 0 OID 529996)
-- Dependencies: 181
-- Data for Name: calendar_date; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calendar_date (calendar_date_id, service_id, date, exception_type) FROM stdin;
50	301	2014-08-15	2
401	450	2014-07-24	2
301	450	2014-08-09	1
250	450	2014-07-09	2
\.


--
-- TOC entry 2160 (class 0 OID 0)
-- Dependencies: 180
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calendar_date_calendar_date_id_seq', 8, true);


--
-- TOC entry 2161 (class 0 OID 0)
-- Dependencies: 178
-- Name: calendar_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calendar_service_id_seq', 13, true);


--
-- TOC entry 2124 (class 0 OID 530036)
-- Dependencies: 185
-- Data for Name: fare_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fare_attribute (fare_id, price, currency_type, transfers, transfer_duration, agency_id, fare_attribute_gtfs_id, payment_method) FROM stdin;
200	1.69999999999999996	EUR	\N	70	400	Suburbano	1
101	1.5	EUR	1	\N	400	Urbano	1
\.


--
-- TOC entry 2162 (class 0 OID 0)
-- Dependencies: 184
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fare_attribute_fare_id_seq', 8, true);


--
-- TOC entry 2128 (class 0 OID 530058)
-- Dependencies: 189
-- Data for Name: fare_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fare_rule (fare_rule_id, fare_id, route_id, origin_id, destination_id, contains_id) FROM stdin;
807	101	2100	\N	\N	\N
808	101	1450	\N	\N	\N
850	200	900	\N	\N	\N
805	200	1450	\N	\N	\N
1451	200	\N	100	150	\N
\.


--
-- TOC entry 2163 (class 0 OID 0)
-- Dependencies: 188
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fare_rule_fare_rule_id_seq', 31, true);


--
-- TOC entry 2136 (class 0 OID 530159)
-- Dependencies: 197
-- Data for Name: feed_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY feed_info (feed_info_id, feed_publisher_name, feed_publisher_url, feed_lang, feed_start_date, feed_end_date, feed_version, feed_name, feed_description) FROM stdin;
351	5T	http://www.5t.torino.it/5t/	it	2014-09-01	2014-09-30	1.0	2014-09-03 16.42.40	Primo feed
401	5T	http://www.5t.torino.it/5t/	it	\N	\N	1.0.1	2014-09-08 15.24.08	Aggiunte zone a fermate e tariffe
500	5T	http://www.5t.torino.it/5t/	it	\N	\N	1.0.2	2014-09-10 10.53.56	Aggiunti trasferimenti
\.


--
-- TOC entry 2164 (class 0 OID 0)
-- Dependencies: 196
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('feed_info_feed_info_id_seq', 10, true);


--
-- TOC entry 2116 (class 0 OID 529974)
-- Dependencies: 177
-- Data for Name: frequency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY frequency (frequency_id, trip_id, start_time, end_time, headway_secs, exact_times) FROM stdin;
1350	3151	23:00:00	01:35:00	20	0
1351	3151	00:57:00	02:00:00	1	0
1352	3151	02:05:00	03:00:00	2	0
1150	2600	23:00:00	01:35:00	20	0
1401	3201	06:00:00	09:00:00	15	0
150	1400	06:00:00	09:00:00	15	0
951	2600	02:05:00	03:00:00	2	0
950	2600	00:57:00	02:00:00	1	0
\.


--
-- TOC entry 2165 (class 0 OID 0)
-- Dependencies: 176
-- Name: frequency_frequency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('frequency_frequency_id_seq', 28, true);


--
-- TOC entry 2110 (class 0 OID 529861)
-- Dependencies: 171
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY route (route_id, agency_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, route_gtfs_id) FROM stdin;
2050	51	1	Fermi - Lingotto		1		#ffffff	#400080	1
2100	400	10	Tram		0		#ffffff	#000000	10
900	400	VE1	Venaria cimitero - Piazza Massaua	Navetta da Venaria alla fermata della metro di Piazza Massaua	3		#ffffff	#ff0000	VE1
1450	400	72	Corso Machiavelli - Via Bertola		3		#ffffff	#400080	72
\.


--
-- TOC entry 2166 (class 0 OID 0)
-- Dependencies: 172
-- Name: route_route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('route_route_id_seq', 45, true);


--
-- TOC entry 2122 (class 0 OID 530011)
-- Dependencies: 183
-- Data for Name: shape; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shape (shape_id, shape_encoded_polyline, agency_id) FROM stdin;
1450	}{brGusim@pLceA}AslAs@k`@gAiw@{@el@{@}o@	51
1550	}tarGok{m@`Jc^xDgNeK_HjFmR	400
1401	}tarGok{m@lDpAdJ{]oD{A	400
1800	}tarGok{m@`Jc^xDgNeK_HjFmR	400
1853	qg`rGcu}m@mP_HyNnFqFtRpEfW	400
1500	qg`rGcu}m@mP_HyNnFqFtRpEfW	400
\.


--
-- TOC entry 2167 (class 0 OID 0)
-- Dependencies: 182
-- Name: shape_shape_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shape_shape_id_seq', 37, true);


--
-- TOC entry 2130 (class 0 OID 530096)
-- Dependencies: 191
-- Data for Name: stop; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY stop (stop_id, stop_code, stop_name, zone_id, stop_url, parent_station, stop_timezone, wheelchair_boarding, stop_desc, location_type, stop_lat, stop_lon, agency_id, stop_gtfs_id) FROM stdin;
450		Racconigi	\N		\N	\N	0		0	45.0757329578783583	7.64908075332641513	51	6001
451		Rivoli	\N		\N	\N	0		0	45.0755208183282647	7.64420986175537109	51	6002
500		Monte Grappa	\N		\N	\N	0		0	45.0752177604619888	7.63637781143188388	51	6003
501		Pozzo Strada	\N		\N	\N	0		0	45.0749147009884865	7.62914657592773349	51	6004
550		Massaua	\N		\N	\N	0		0	45.0745510274988206	7.62013435363769442	51	6005
551		Marche	\N		\N	\N	0		0	45.0742934240433328	7.61479139328002841	51	6006
600		Paradiso	\N		\N	\N	0		0	45.0738236735763138	7.60236740112304688	51	6007
601		Fermi	\N		\N	\N	0		0	45.0759905548447506	7.59114503860473633	51	6008
650		Bernini	\N		\N	\N	0	Fermata di Piazza Bernini	0	45.0759905548447506	7.65575408935546875	51	6009
361		Giolitti	\N		\N	\N	0		0	45.0624878787724086	7.69377708435058594	400	5010
356		XX Settembre	\N		\N	Europe/Rome	0		0	45.0697472896550622	7.68199682235717773	400	5001
401		XVIII Dicembre	150		\N	\N	0		1	45.0737479070103362	7.66809225082397461	400	5007
360		Vanchiglia	\N		\N	Europe/Rome	0		0	45.0652765715424124	7.69521474838256836	400	5005
359		Sant'Ottavio	\N		\N	Europe/Rome	0		0	45.0678074955879993	7.6940131187438956	400	5004
358		Verdi	\N		\N	Europe/Rome	0		0	45.0690198745944812	7.69085884094238281	400	5003
357		Bogino	\N		\N	Europe/Rome	0		0	45.0679741992262279	7.68697500228881747	400	5002
\.


--
-- TOC entry 2168 (class 0 OID 0)
-- Dependencies: 190
-- Name: stop_stop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('stop_stop_id_seq', 23, true);


--
-- TOC entry 2132 (class 0 OID 530119)
-- Dependencies: 193
-- Data for Name: stop_time; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY stop_time (stop_time_id, trip_id, arrival_time, departure_time, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, continue_from_previous_day) FROM stdin;
2606	3201	10:00:00	10:01:00	361	1	\N	\N	\N	\N	f
2607	3201	10:20:00	10:25:00	357	5	\N	\N	\N	\N	f
2609	3201	10:05:00	10:06:00	360	2	\N	\N	\N	\N	f
2605	3201	10:15:00	10:16:00	358	4	\N	\N	\N	\N	f
2608	3201	06:00:00	08:00:00	359	3		0	0	\N	f
702	1100	10:04:00	10:05:00	551	3	\N	\N	\N	\N	f
703	1100	10:06:00	10:07:00	550	4	\N	\N	\N	\N	f
1451	1100	10:15:00	10:16:00	501	5		0	0	\N	f
1452	1100	10:20:00	10:21:00	451	7	\N	\N	\N	\N	f
1453	1100	10:00:00	10:01:00	600	2	\N	\N	\N	\N	f
1550	1100	10:17:00	10:18:00	500	6		0	0	\N	f
1600	1100	10:10:00	10:11:00	601	1		0	0	\N	f
2553	3151	23:58:00	00:02:00	356	1		0	0	\N	f
2552	3151	00:05:00	00:06:00	357	2		0	0	\N	f
2551	3151	00:09:00	00:10:00	358	3		0	0	\N	f
2550	3151	00:12:00	00:13:00	359	4		0	0	\N	f
2051	2600	00:09:00	00:10:00	358	3		0	0	\N	t
2350	2600	00:12:00	00:13:00	359	4		0	0	\N	t
2050	2600	00:05:00	00:06:00	357	2		0	0	\N	t
2052	2600	23:58:00	00:02:00	356	1		0	0	\N	f
650	1700	05:05:00	05:06:00	359	3	\N	\N	\N	\N	f
350	1700	00:05:00	00:06:00	360	2	\N	\N	\N	\N	f
651	1700	07:07:00	07:52:00	358	4	\N	\N	\N	\N	f
300	1700	00:00:00	00:01:00	361	1	\N	\N	\N	\N	f
100	1400	10:00:00	10:01:00	361	1	\N	\N	\N	\N	f
250	1400	10:15:00	10:16:00	358	4	\N	\N	\N	\N	f
1651	1400	06:00:00	08:00:00	359	3		0	0	\N	f
750	1400	10:20:00	10:25:00	357	5	\N	\N	\N	\N	f
200	1400	10:05:00	10:06:00	360	2	\N	\N	\N	\N	f
450	1501	01:05:00	01:06:00	359	2	\N	\N	\N	\N	f
500	1501	14:02:00	14:03:00	360	3	\N	\N	\N	\N	f
400	1501	01:00:00	01:01:00	358	1	\N	\N	\N	\N	f
\.


--
-- TOC entry 2169 (class 0 OID 0)
-- Dependencies: 192
-- Name: stop_time_stop_time_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('stop_time_stop_time_id_seq', 52, true);


--
-- TOC entry 2134 (class 0 OID 530139)
-- Dependencies: 195
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY transfer (transfer_id, from_stop_id, to_stop_id, transfer_type, min_transfer_time, agency_id) FROM stdin;
200	359	360	1	\N	400
151	359	356	3	\N	400
152	356	401	2	10	400
\.


--
-- TOC entry 2170 (class 0 OID 0)
-- Dependencies: 194
-- Name: transfer_transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('transfer_transfer_id_seq', 4, true);


--
-- TOC entry 2114 (class 0 OID 529966)
-- Dependencies: 175
-- Data for Name: trip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trip (trip_id, route_id, service_id, trip_headsign, trip_short_name, block_id, shape_id, wheelchair_accessible, bikes_allowed, direction_id, trip_gtfs_id) FROM stdin;
1100	2050	350	Direzione Lingotto	Fermi - Lingotto	\N	1450	1	1	0	t1
1150	2050	350	Fermi	Lingotto - Fermi	\N	\N	1	1	1	t2
3151	2100	301		pluto	\N	1800	0	0	0	t1
3201	900	450	Venaria cimitero	P.zza Massaua - Venaria cimitero	\N	1853	1	2	1	c2
2600	2100	301		pluto	\N	1550	0	0	0	t7
1700	900	301	Venaria cimitero	P.zza Massaua - Venaria cimitero	\N	\N	1	2	1	t6
1400	900	450	Venaria cimitero	P.zza Massaua - Venaria cimitero	\N	1500	1	2	1	t3
1501	900	301	Piazza Massaua	Venaria cimitero - P.zza Massaua	\N	\N	1	2	0	t5
1500	900	450	Piazza Massaua	Venaria cimitero - P.zza Massaua	\N	1401	1	2	0	t4
\.


--
-- TOC entry 2171 (class 0 OID 0)
-- Dependencies: 174
-- Name: trip_trip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trip_trip_id_seq', 64, true);


--
-- TOC entry 2126 (class 0 OID 530044)
-- Dependencies: 187
-- Data for Name: zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY zone (zone_id, name, zone_gtfs_id, agency_id) FROM stdin;
100	Zona A	A	400
150	Zona B1	B	400
\.


--
-- TOC entry 2172 (class 0 OID 0)
-- Dependencies: 186
-- Name: zone_zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('zone_zone_id_seq', 3, true);


--
-- TOC entry 1927 (class 2606 OID 1011971)
-- Name: agency_gtfs_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_gtfs_id UNIQUE (agency_gtfs_id);


--
-- TOC entry 1929 (class 2606 OID 529935)
-- Name: agency_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_id PRIMARY KEY (agency_id);


--
-- TOC entry 1945 (class 2606 OID 530001)
-- Name: calendar_date_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT calendar_date_id PRIMARY KEY (calendar_date_id);


--
-- TOC entry 1951 (class 2606 OID 530041)
-- Name: fare_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fare_id PRIMARY KEY (fare_id);


--
-- TOC entry 1957 (class 2606 OID 530063)
-- Name: fare_rule_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_id PRIMARY KEY (fare_rule_id);


--
-- TOC entry 1978 (class 2606 OID 530164)
-- Name: feed_info_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY feed_info
    ADD CONSTRAINT feed_info_id PRIMARY KEY (feed_info_id);


--
-- TOC entry 1940 (class 2606 OID 529979)
-- Name: frequency_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_id PRIMARY KEY (frequency_id);


--
-- TOC entry 1932 (class 2606 OID 529927)
-- Name: route_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_id PRIMARY KEY (route_id);


--
-- TOC entry 1943 (class 2606 OID 529993)
-- Name: service_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT service_id PRIMARY KEY (service_id);


--
-- TOC entry 1949 (class 2606 OID 530016)
-- Name: shape_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT shape_id PRIMARY KEY (shape_id);


--
-- TOC entry 1967 (class 2606 OID 530104)
-- Name: stop_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_id PRIMARY KEY (stop_id);


--
-- TOC entry 1971 (class 2606 OID 530124)
-- Name: stop_time_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT stop_time_id PRIMARY KEY (stop_time_id);


--
-- TOC entry 1976 (class 2606 OID 530144)
-- Name: transfer_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_id PRIMARY KEY (transfer_id);


--
-- TOC entry 1937 (class 2606 OID 529971)
-- Name: trip_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_id PRIMARY KEY (trip_id);


--
-- TOC entry 1955 (class 2606 OID 530049)
-- Name: zone_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_id PRIMARY KEY (zone_id);


--
-- TOC entry 1930 (class 1259 OID 529945)
-- Name: fki_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_agency_id ON route USING btree (agency_id);


--
-- TOC entry 1941 (class 1259 OID 995158)
-- Name: fki_calendar_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_calendar_agency_id ON calendar USING btree (agency_id);


--
-- TOC entry 1952 (class 1259 OID 996636)
-- Name: fki_fare_attribute_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_attribute_agency_id ON fare_attribute USING btree (agency_id);


--
-- TOC entry 1958 (class 1259 OID 530093)
-- Name: fki_fare_rule_contains_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_contains_id ON fare_rule USING btree (contains_id);


--
-- TOC entry 1959 (class 1259 OID 530087)
-- Name: fki_fare_rule_destination_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_destination_id ON fare_rule USING btree (destination_id);


--
-- TOC entry 1960 (class 1259 OID 530075)
-- Name: fki_fare_rule_fare_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_fare_id ON fare_rule USING btree (fare_id);


--
-- TOC entry 1961 (class 1259 OID 530081)
-- Name: fki_fare_rule_origin_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_origin_id ON fare_rule USING btree (origin_id);


--
-- TOC entry 1962 (class 1259 OID 530069)
-- Name: fki_route_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_route_id ON fare_rule USING btree (route_id);


--
-- TOC entry 1946 (class 1259 OID 530008)
-- Name: fki_service_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_service_id ON calendar_date USING btree (service_id);


--
-- TOC entry 1947 (class 1259 OID 1011991)
-- Name: fki_shape_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_shape_agency_id ON shape USING btree (agency_id);


--
-- TOC entry 1933 (class 1259 OID 530022)
-- Name: fki_shape_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_shape_id ON trip USING btree (shape_id);


--
-- TOC entry 1963 (class 1259 OID 530110)
-- Name: fki_sop_zone_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_sop_zone_id ON stop USING btree (zone_id);


--
-- TOC entry 1964 (class 1259 OID 1010056)
-- Name: fki_stop_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_agency_id ON stop USING btree (agency_id);


--
-- TOC entry 1965 (class 1259 OID 530116)
-- Name: fki_stop_parent_station; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_parent_station ON stop USING btree (parent_station);


--
-- TOC entry 1968 (class 1259 OID 530136)
-- Name: fki_stop_time_stop_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_time_stop_id ON stop_time USING btree (stop_id);


--
-- TOC entry 1969 (class 1259 OID 530130)
-- Name: fki_stop_time_trip_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_time_trip_id ON stop_time USING btree (trip_id);


--
-- TOC entry 1972 (class 1259 OID 1012008)
-- Name: fki_transfer_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_transfer_agency_id ON transfer USING btree (agency_id);


--
-- TOC entry 1973 (class 1259 OID 530150)
-- Name: fki_transfer_from_stop_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_transfer_from_stop_id ON transfer USING btree (from_stop_id);


--
-- TOC entry 1974 (class 1259 OID 530156)
-- Name: fki_transfer_to_stop_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_transfer_to_stop_id ON transfer USING btree (to_stop_id);


--
-- TOC entry 1938 (class 1259 OID 529985)
-- Name: fki_trip_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_trip_id ON frequency USING btree (trip_id);


--
-- TOC entry 1934 (class 1259 OID 530055)
-- Name: fki_trip_route_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_trip_route_id ON trip USING btree (route_id);


--
-- TOC entry 1935 (class 1259 OID 530033)
-- Name: fki_trip_service_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_trip_service_id ON trip USING btree (service_id);


--
-- TOC entry 1953 (class 1259 OID 1012002)
-- Name: fki_zone_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_zone_agency_id ON zone USING btree (agency_id);


--
-- TOC entry 1984 (class 2606 OID 995153)
-- Name: calendar_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 1985 (class 2606 OID 530003)
-- Name: calendar_date_service_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT calendar_date_service_id FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 1987 (class 2606 OID 996631)
-- Name: fare_attribute_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fare_attribute_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 1993 (class 2606 OID 530088)
-- Name: fare_rule_contains_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_contains_id FOREIGN KEY (contains_id) REFERENCES zone(zone_id);


--
-- TOC entry 1992 (class 2606 OID 530082)
-- Name: fare_rule_destination_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_destination_id FOREIGN KEY (destination_id) REFERENCES zone(zone_id);


--
-- TOC entry 1990 (class 2606 OID 530070)
-- Name: fare_rule_fare_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_fare_id FOREIGN KEY (fare_id) REFERENCES fare_attribute(fare_id);


--
-- TOC entry 1991 (class 2606 OID 530076)
-- Name: fare_rule_origin_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_origin_id FOREIGN KEY (origin_id) REFERENCES zone(zone_id);


--
-- TOC entry 1989 (class 2606 OID 530064)
-- Name: fare_rule_route_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_route_id FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 1983 (class 2606 OID 529980)
-- Name: frequency_trip_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_trip_id FOREIGN KEY (trip_id) REFERENCES trip(trip_id);


--
-- TOC entry 1979 (class 2606 OID 529940)
-- Name: route_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 1986 (class 2606 OID 1011986)
-- Name: shape_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT shape_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 1994 (class 2606 OID 530105)
-- Name: sop_zone_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT sop_zone_id FOREIGN KEY (zone_id) REFERENCES zone(zone_id);


--
-- TOC entry 1996 (class 2606 OID 1010051)
-- Name: stop_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 1995 (class 2606 OID 530111)
-- Name: stop_parent_station; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_parent_station FOREIGN KEY (parent_station) REFERENCES stop(stop_id);


--
-- TOC entry 1998 (class 2606 OID 530131)
-- Name: stop_time_stop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT stop_time_stop_id FOREIGN KEY (stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 1997 (class 2606 OID 530125)
-- Name: stop_time_trip_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT stop_time_trip_id FOREIGN KEY (trip_id) REFERENCES trip(trip_id);


--
-- TOC entry 2001 (class 2606 OID 1012003)
-- Name: transfer_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 1999 (class 2606 OID 530145)
-- Name: transfer_from_stop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_from_stop_id FOREIGN KEY (from_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2000 (class 2606 OID 530151)
-- Name: transfer_to_stop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_to_stop_id FOREIGN KEY (to_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 1982 (class 2606 OID 530050)
-- Name: trip_route_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_route_id FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 1981 (class 2606 OID 530028)
-- Name: trip_service_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_service_id FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 1980 (class 2606 OID 530017)
-- Name: trip_shape_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_shape_id FOREIGN KEY (shape_id) REFERENCES shape(shape_id);


--
-- TOC entry 1988 (class 2606 OID 1011997)
-- Name: zone_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2143 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-09-10 14:41:58

--
-- PostgreSQL database dump complete
--

