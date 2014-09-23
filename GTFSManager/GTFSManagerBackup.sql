--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.4
-- Started on 2014-09-23 11:46:03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 1012344)
-- Name: gtfsx; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA gtfsx;


ALTER SCHEMA gtfsx OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 1013127)
-- Name: prova; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA prova;


ALTER SCHEMA prova OWNER TO postgres;

--
-- TOC entry 256 (class 3079 OID 11756)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2518 (class 0 OID 0)
-- Dependencies: 256
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = gtfsx, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 200 (class 1259 OID 1012867)
-- Name: agency; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE agency (
    agency_id integer NOT NULL,
    agency_fare_url character varying(255),
    agency_gtfs_id character varying(50),
    agency_lang character varying(2),
    agency_name character varying(255),
    agency_phone character varying(20),
    agency_timezone character varying(255) NOT NULL,
    agency_url character varying(255)
);


ALTER TABLE gtfsx.agency OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 1013098)
-- Name: agency_agency_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE agency_agency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.agency_agency_id_seq OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 1012875)
-- Name: calendar; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE calendar (
    service_id integer NOT NULL,
    end_date date,
    friday boolean,
    calendar_gtfs_id character varying(50),
    monday boolean,
    saturday boolean,
    start_date date,
    sunday boolean,
    thursday boolean,
    tuesday boolean,
    wednesday boolean,
    agency_id integer
);


ALTER TABLE gtfsx.calendar OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 1012880)
-- Name: calendar_date; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE calendar_date (
    calendar_date_id integer NOT NULL,
    date date,
    exception_type integer,
    service_id integer,
    CONSTRAINT calendar_date_exception_type_check CHECK (((exception_type >= 1) AND (exception_type <= 2)))
);


ALTER TABLE gtfsx.calendar_date OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 1013100)
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE calendar_date_calendar_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.calendar_date_calendar_date_id_seq OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 1013102)
-- Name: calendar_service_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE calendar_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.calendar_service_id_seq OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 1012886)
-- Name: fare_attribute; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE fare_attribute (
    fare_id integer NOT NULL,
    currency_type character varying(3),
    fare_attribute_gtfs_id character varying(50),
    payment_method integer,
    price double precision,
    transfer_duration integer,
    transfers integer,
    agency_id integer,
    CONSTRAINT fare_attribute_payment_method_check CHECK (((payment_method >= 0) AND (payment_method <= 1))),
    CONSTRAINT fare_attribute_transfers_check CHECK (((transfers >= 0) AND (transfers <= 2)))
);


ALTER TABLE gtfsx.fare_attribute OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 1013104)
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE fare_attribute_fare_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.fare_attribute_fare_id_seq OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 1012893)
-- Name: fare_rule; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE fare_rule (
    fare_rule_id integer NOT NULL,
    contains_id integer,
    destination_id integer,
    fare_id integer,
    origin_id integer,
    route_id integer
);


ALTER TABLE gtfsx.fare_rule OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 1013106)
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE fare_rule_fare_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.fare_rule_fare_rule_id_seq OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 1012898)
-- Name: feed_info; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE feed_info (
    feed_info_id integer NOT NULL,
    feed_description character varying(255),
    feed_end_date date,
    feed_lang character varying(20),
    feed_name character varying(50),
    feed_publisher_name character varying(50),
    feed_publisher_url character varying(255),
    feed_start_date date,
    feed_version character varying(20)
);


ALTER TABLE gtfsx.feed_info OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 1013108)
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE feed_info_feed_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.feed_info_feed_info_id_seq OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 1012906)
-- Name: route; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE route (
    route_id integer NOT NULL,
    route_color character varying(7),
    route_desc character varying(255),
    route_gtfs_id character varying(50),
    route_long_name character varying(255),
    route_short_name character varying(50),
    route_text_color character varying(7),
    route_type integer,
    route_url character varying(255),
    agency_id integer,
    CONSTRAINT route_route_type_check CHECK (((route_type >= 0) AND (route_type <= 7)))
);


ALTER TABLE gtfsx.route OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 1013110)
-- Name: route_route_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE route_route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.route_route_id_seq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 1012915)
-- Name: shape; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE shape (
    shape_id integer NOT NULL,
    shape_encoded_polyline character varying(255),
    agency_id integer
);


ALTER TABLE gtfsx.shape OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 1013112)
-- Name: shape_shape_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE shape_shape_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.shape_shape_id_seq OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 1012920)
-- Name: stop; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE stop (
    stop_id integer NOT NULL,
    stop_code character varying(20),
    stop_desc character varying(255),
    stop_gtfs_id character varying(50),
    stop_lat double precision,
    location_type integer,
    stop_lon double precision,
    stop_name character varying(50),
    stop_timezone character varying(255),
    stop_url character varying(255),
    wheelchair_boarding integer,
    agency_id integer,
    parent_station integer,
    zone_id integer,
    CONSTRAINT stop_location_type_check CHECK (((location_type >= 0) AND (location_type <= 1))),
    CONSTRAINT stop_wheelchair_boarding_check CHECK (((wheelchair_boarding >= 0) AND (wheelchair_boarding <= 2)))
);


ALTER TABLE gtfsx.stop OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 1013114)
-- Name: stop_stop_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE stop_stop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.stop_stop_id_seq OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 1012930)
-- Name: stop_time_relative; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE stop_time_relative (
    stop_time_relative_id integer NOT NULL,
    drop_off_type integer,
    pickup_type integer,
    relative_arrival_time time without time zone,
    relative_departure_time time without time zone,
    shape_dist_traveled double precision,
    stop_headsign character varying(50),
    stop_sequence integer,
    stop_id integer,
    trip_pattern_id integer,
    CONSTRAINT stop_time_relative_drop_off_type_check CHECK (((drop_off_type <= 3) AND (drop_off_type >= 0))),
    CONSTRAINT stop_time_relative_pickup_type_check CHECK (((pickup_type <= 3) AND (pickup_type >= 0))),
    CONSTRAINT stop_time_relative_stop_sequence_check CHECK ((stop_sequence >= 1))
);


ALTER TABLE gtfsx.stop_time_relative OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 1013116)
-- Name: stop_time_relative_stop_time_relative_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE stop_time_relative_stop_time_relative_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.stop_time_relative_stop_time_relative_id_seq OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 1012938)
-- Name: transfer; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE transfer (
    transfer_id integer NOT NULL,
    min_transfer_time integer,
    transfer_type integer,
    agency_id integer,
    from_stop_id integer,
    to_stop_id integer,
    CONSTRAINT transfer_min_transfer_time_check CHECK ((min_transfer_time >= 0)),
    CONSTRAINT transfer_transfer_type_check CHECK (((transfer_type <= 3) AND (transfer_type >= 0)))
);


ALTER TABLE gtfsx.transfer OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 1013118)
-- Name: transfer_transfer_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE transfer_transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.transfer_transfer_id_seq OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 1012945)
-- Name: trip; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE trip (
    trip_id integer NOT NULL,
    bikes_allowed integer,
    block_id character varying(50),
    direction_id integer,
    end_time time without time zone,
    exact_times integer,
    trip_gtfs_id character varying(50),
    headway_secs integer,
    single_trip boolean,
    start_time time without time zone,
    trip_headsign character varying(50),
    trip_short_name character varying(50),
    wheelchair_accessible integer,
    service_id integer,
    route_id integer,
    shape_id integer,
    trip_pattern_id integer,
    CONSTRAINT trip_bikes_allowed_check CHECK (((bikes_allowed >= 0) AND (bikes_allowed <= 2))),
    CONSTRAINT trip_direction_id_check CHECK (((direction_id >= 0) AND (direction_id <= 1))),
    CONSTRAINT trip_exact_times_check CHECK (((exact_times >= 0) AND (exact_times <= 1))),
    CONSTRAINT trip_headway_secs_check CHECK ((headway_secs >= 1)),
    CONSTRAINT trip_wheelchair_accessible_check CHECK (((wheelchair_accessible >= 0) AND (wheelchair_accessible <= 2)))
);


ALTER TABLE gtfsx.trip OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 1012955)
-- Name: trip_pattern; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE trip_pattern (
    trip_pattern_id integer NOT NULL,
    bikes_allowed integer,
    direction_id integer,
    trip_pattern_gtfs_id character varying(50),
    trip_headsign character varying(50),
    trip_short_name character varying(50),
    wheelchair_accessible integer,
    service_id integer,
    route_id integer,
    shape_id integer,
    CONSTRAINT trip_pattern_bikes_allowed_check CHECK (((bikes_allowed >= 0) AND (bikes_allowed <= 2))),
    CONSTRAINT trip_pattern_direction_id_check CHECK (((direction_id >= 0) AND (direction_id <= 1))),
    CONSTRAINT trip_pattern_wheelchair_accessible_check CHECK (((wheelchair_accessible >= 0) AND (wheelchair_accessible <= 2)))
);


ALTER TABLE gtfsx.trip_pattern OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 1013120)
-- Name: trip_pattern_trip_pattern_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE trip_pattern_trip_pattern_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.trip_pattern_trip_pattern_id_seq OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 1013122)
-- Name: trip_trip_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE trip_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.trip_trip_id_seq OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 1012963)
-- Name: zone; Type: TABLE; Schema: gtfsx; Owner: postgres; Tablespace: 
--

CREATE TABLE zone (
    zone_id integer NOT NULL,
    zone_gtfs_id character varying(50),
    name character varying(50),
    agency_id integer
);


ALTER TABLE gtfsx.zone OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 1013124)
-- Name: zone_zone_id_seq; Type: SEQUENCE; Schema: gtfsx; Owner: postgres
--

CREATE SEQUENCE zone_zone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gtfsx.zone_zone_id_seq OWNER TO postgres;

SET search_path = prova, pg_catalog;

--
-- TOC entry 228 (class 1259 OID 1013128)
-- Name: agency; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE agency (
    agency_id integer NOT NULL,
    agency_fare_url character varying(255),
    agency_gtfs_id character varying(50),
    agency_lang character varying(2),
    agency_name character varying(255),
    agency_phone character varying(20),
    agency_timezone character varying(255) NOT NULL,
    agency_url character varying(255)
);


ALTER TABLE prova.agency OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 1013341)
-- Name: agency_agency_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE agency_agency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.agency_agency_id_seq OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 1013136)
-- Name: calendar; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE calendar (
    service_id integer NOT NULL,
    end_date date,
    friday boolean,
    calendar_gtfs_id character varying(50),
    monday boolean,
    saturday boolean,
    start_date date,
    sunday boolean,
    thursday boolean,
    tuesday boolean,
    wednesday boolean,
    agency_id integer
);


ALTER TABLE prova.calendar OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 1013141)
-- Name: calendar_date; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE calendar_date (
    calendar_date_id integer NOT NULL,
    date date,
    exception_type integer,
    service_id integer,
    CONSTRAINT calendar_date_exception_type_check CHECK (((exception_type >= 1) AND (exception_type <= 2)))
);


ALTER TABLE prova.calendar_date OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 1013343)
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE calendar_date_calendar_date_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.calendar_date_calendar_date_id_seq OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 1013345)
-- Name: calendar_service_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE calendar_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.calendar_service_id_seq OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 1013147)
-- Name: fare_attribute; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE fare_attribute (
    fare_id integer NOT NULL,
    currency_type character varying(3),
    fare_attribute_gtfs_id character varying(50),
    payment_method integer,
    price double precision,
    transfer_duration integer,
    transfers integer,
    agency_id integer,
    CONSTRAINT fare_attribute_payment_method_check CHECK (((payment_method >= 0) AND (payment_method <= 1))),
    CONSTRAINT fare_attribute_transfers_check CHECK (((transfers >= 0) AND (transfers <= 2)))
);


ALTER TABLE prova.fare_attribute OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 1013347)
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE fare_attribute_fare_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.fare_attribute_fare_id_seq OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 1013154)
-- Name: fare_rule; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE fare_rule (
    fare_rule_id integer NOT NULL,
    contains_id integer,
    destination_id integer,
    fare_id integer,
    origin_id integer,
    route_id integer
);


ALTER TABLE prova.fare_rule OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 1013349)
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE fare_rule_fare_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.fare_rule_fare_rule_id_seq OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 1013159)
-- Name: feed_info; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE feed_info (
    feed_info_id integer NOT NULL,
    feed_description character varying(255),
    feed_end_date date,
    feed_lang character varying(20),
    feed_name character varying(50),
    feed_publisher_name character varying(50),
    feed_publisher_url character varying(255),
    feed_start_date date,
    feed_version character varying(20)
);


ALTER TABLE prova.feed_info OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 1013351)
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE feed_info_feed_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.feed_info_feed_info_id_seq OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 1013167)
-- Name: frequency; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE frequency (
    frequency_id integer NOT NULL,
    end_time time without time zone,
    exact_times integer,
    headway_secs integer,
    start_time time without time zone,
    trip_id integer,
    CONSTRAINT frequency_exact_times_check CHECK (((exact_times >= 0) AND (exact_times <= 1))),
    CONSTRAINT frequency_headway_secs_check CHECK ((headway_secs >= 1))
);


ALTER TABLE prova.frequency OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 1013353)
-- Name: frequency_frequency_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE frequency_frequency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.frequency_frequency_id_seq OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 1013174)
-- Name: route; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE route (
    route_id integer NOT NULL,
    route_color character varying(7),
    route_desc character varying(255),
    route_gtfs_id character varying(50),
    route_long_name character varying(255),
    route_short_name character varying(50),
    route_text_color character varying(7),
    route_type integer,
    route_url character varying(255),
    agency_id integer,
    CONSTRAINT route_route_type_check CHECK (((route_type >= 0) AND (route_type <= 7)))
);


ALTER TABLE prova.route OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 1013355)
-- Name: route_route_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE route_route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.route_route_id_seq OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 1013183)
-- Name: shape; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE shape (
    shape_id integer NOT NULL,
    shape_encoded_polyline character varying(255),
    agency_id integer
);


ALTER TABLE prova.shape OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 1013357)
-- Name: shape_shape_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE shape_shape_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.shape_shape_id_seq OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 1013188)
-- Name: stop; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE stop (
    stop_id integer NOT NULL,
    stop_code character varying(20),
    stop_desc character varying(255),
    stop_gtfs_id character varying(50),
    stop_lat double precision,
    location_type integer,
    stop_lon double precision,
    stop_name character varying(50),
    stop_timezone character varying(255),
    stop_url character varying(255),
    wheelchair_boarding integer,
    agency_id integer,
    parent_station integer,
    zone_id integer,
    CONSTRAINT stop_location_type_check CHECK (((location_type >= 0) AND (location_type <= 1))),
    CONSTRAINT stop_wheelchair_boarding_check CHECK (((wheelchair_boarding >= 0) AND (wheelchair_boarding <= 2)))
);


ALTER TABLE prova.stop OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 1013359)
-- Name: stop_stop_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE stop_stop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.stop_stop_id_seq OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 1013198)
-- Name: stop_time; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE stop_time (
    stop_time_id integer NOT NULL,
    arrival_time time without time zone,
    continue_from_previous_day boolean,
    departure_time time without time zone,
    drop_off_type integer,
    pickup_type integer,
    shape_dist_traveled double precision,
    stop_headsign character varying(50),
    stop_sequence integer,
    stop_id integer,
    trip_id integer,
    CONSTRAINT stop_time_drop_off_type_check CHECK (((drop_off_type <= 3) AND (drop_off_type >= 0))),
    CONSTRAINT stop_time_pickup_type_check CHECK (((pickup_type <= 3) AND (pickup_type >= 0))),
    CONSTRAINT stop_time_stop_sequence_check CHECK ((stop_sequence >= 1))
);


ALTER TABLE prova.stop_time OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 1013361)
-- Name: stop_time_stop_time_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE stop_time_stop_time_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.stop_time_stop_time_id_seq OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 1013206)
-- Name: transfer; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE transfer (
    transfer_id integer NOT NULL,
    min_transfer_time integer,
    transfer_type integer,
    agency_id integer,
    from_stop_id integer,
    to_stop_id integer,
    CONSTRAINT transfer_min_transfer_time_check CHECK ((min_transfer_time >= 0)),
    CONSTRAINT transfer_transfer_type_check CHECK (((transfer_type <= 3) AND (transfer_type >= 0)))
);


ALTER TABLE prova.transfer OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 1013363)
-- Name: transfer_transfer_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE transfer_transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.transfer_transfer_id_seq OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 1013213)
-- Name: trip; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE trip (
    trip_id integer NOT NULL,
    bikes_allowed integer,
    direction_id integer,
    trip_gtfs_id character varying(50),
    trip_headsign character varying(50),
    trip_short_name character varying(50),
    wheelchair_accessible integer,
    service_id integer,
    route_id integer,
    shape_id integer,
    blockid character varying(50),
    CONSTRAINT trip_bikes_allowed_check CHECK (((bikes_allowed >= 0) AND (bikes_allowed <= 2))),
    CONSTRAINT trip_direction_id_check CHECK (((direction_id >= 0) AND (direction_id <= 1))),
    CONSTRAINT trip_wheelchair_accessible_check CHECK (((wheelchair_accessible >= 0) AND (wheelchair_accessible <= 2)))
);


ALTER TABLE prova.trip OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 1013365)
-- Name: trip_trip_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE trip_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.trip_trip_id_seq OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 1013221)
-- Name: zone; Type: TABLE; Schema: prova; Owner: postgres; Tablespace: 
--

CREATE TABLE zone (
    zone_id integer NOT NULL,
    zone_gtfs_id character varying(50),
    name character varying(50),
    agency_id integer
);


ALTER TABLE prova.zone OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 1013367)
-- Name: zone_zone_id_seq; Type: SEQUENCE; Schema: prova; Owner: postgres
--

CREATE SEQUENCE zone_zone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prova.zone_zone_id_seq OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 172 (class 1259 OID 529839)
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
-- TOC entry 175 (class 1259 OID 529928)
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
-- TOC entry 2519 (class 0 OID 0)
-- Dependencies: 175
-- Name: agency_agency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE agency_agency_id_seq OWNED BY agency.agency_id;


--
-- TOC entry 181 (class 1259 OID 529988)
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
-- TOC entry 183 (class 1259 OID 529996)
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
-- TOC entry 182 (class 1259 OID 529994)
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
-- TOC entry 2520 (class 0 OID 0)
-- Dependencies: 182
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calendar_date_calendar_date_id_seq OWNED BY calendar_date.calendar_date_id;


--
-- TOC entry 180 (class 1259 OID 529986)
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
-- TOC entry 2521 (class 0 OID 0)
-- Dependencies: 180
-- Name: calendar_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE calendar_service_id_seq OWNED BY calendar.service_id;


--
-- TOC entry 187 (class 1259 OID 530036)
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
-- TOC entry 186 (class 1259 OID 530034)
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
-- TOC entry 2522 (class 0 OID 0)
-- Dependencies: 186
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fare_attribute_fare_id_seq OWNED BY fare_attribute.fare_id;


--
-- TOC entry 191 (class 1259 OID 530058)
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
-- TOC entry 190 (class 1259 OID 530056)
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
-- TOC entry 2523 (class 0 OID 0)
-- Dependencies: 190
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE fare_rule_fare_rule_id_seq OWNED BY fare_rule.fare_rule_id;


--
-- TOC entry 199 (class 1259 OID 530159)
-- Name: feed_info; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE feed_info (
    feed_info_id integer NOT NULL,
    feed_publisher_name character varying(50),
    feed_publisher_url character varying(255),
    feed_lang character varying(20),
    feed_start_date date,
    feed_end_date date,
    feed_version character varying(20),
    feed_name character varying(50) NOT NULL,
    feed_description character varying(255)
);


ALTER TABLE public.feed_info OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 530157)
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
-- TOC entry 2524 (class 0 OID 0)
-- Dependencies: 198
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE feed_info_feed_info_id_seq OWNED BY feed_info.feed_info_id;


--
-- TOC entry 179 (class 1259 OID 529974)
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
-- TOC entry 178 (class 1259 OID 529972)
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
-- TOC entry 2525 (class 0 OID 0)
-- Dependencies: 178
-- Name: frequency_frequency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE frequency_frequency_id_seq OWNED BY frequency.frequency_id;


--
-- TOC entry 173 (class 1259 OID 529861)
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
-- TOC entry 174 (class 1259 OID 529902)
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
-- TOC entry 2526 (class 0 OID 0)
-- Dependencies: 174
-- Name: route_route_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE route_route_id_seq OWNED BY route.route_id;


--
-- TOC entry 185 (class 1259 OID 530011)
-- Name: shape; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shape (
    shape_id integer NOT NULL,
    shape_encoded_polyline text NOT NULL,
    agency_id integer NOT NULL
);


ALTER TABLE public.shape OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 530009)
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
-- TOC entry 2527 (class 0 OID 0)
-- Dependencies: 184
-- Name: shape_shape_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shape_shape_id_seq OWNED BY shape.shape_id;


--
-- TOC entry 193 (class 1259 OID 530096)
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
-- TOC entry 192 (class 1259 OID 530094)
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
-- TOC entry 2528 (class 0 OID 0)
-- Dependencies: 192
-- Name: stop_stop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stop_stop_id_seq OWNED BY stop.stop_id;


--
-- TOC entry 195 (class 1259 OID 530119)
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
-- TOC entry 194 (class 1259 OID 530117)
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
-- TOC entry 2529 (class 0 OID 0)
-- Dependencies: 194
-- Name: stop_time_stop_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE stop_time_stop_time_id_seq OWNED BY stop_time.stop_time_id;


--
-- TOC entry 197 (class 1259 OID 530139)
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
-- TOC entry 196 (class 1259 OID 530137)
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
-- TOC entry 2530 (class 0 OID 0)
-- Dependencies: 196
-- Name: transfer_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE transfer_transfer_id_seq OWNED BY transfer.transfer_id;


--
-- TOC entry 177 (class 1259 OID 529966)
-- Name: trip; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trip (
    trip_id integer NOT NULL,
    route_id integer NOT NULL,
    service_id integer,
    trip_headsign character varying(50),
    trip_short_name character varying(50),
    shape_id integer,
    wheelchair_accessible integer,
    bikes_allowed integer,
    direction_id integer,
    trip_gtfs_id character varying(50) NOT NULL,
    block_id character varying(50)
);


ALTER TABLE public.trip OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 529964)
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
-- TOC entry 2531 (class 0 OID 0)
-- Dependencies: 176
-- Name: trip_trip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE trip_trip_id_seq OWNED BY trip.trip_id;


--
-- TOC entry 189 (class 1259 OID 530044)
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
-- TOC entry 188 (class 1259 OID 530042)
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
-- TOC entry 2532 (class 0 OID 0)
-- Dependencies: 188
-- Name: zone_zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE zone_zone_id_seq OWNED BY zone.zone_id;


--
-- TOC entry 2088 (class 2604 OID 637471)
-- Name: agency_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY agency ALTER COLUMN agency_id SET DEFAULT nextval('agency_agency_id_seq'::regclass);


--
-- TOC entry 2094 (class 2604 OID 637472)
-- Name: service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar ALTER COLUMN service_id SET DEFAULT nextval('calendar_service_id_seq'::regclass);


--
-- TOC entry 2095 (class 2604 OID 637473)
-- Name: calendar_date_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar_date ALTER COLUMN calendar_date_id SET DEFAULT nextval('calendar_date_calendar_date_id_seq'::regclass);


--
-- TOC entry 2097 (class 2604 OID 637474)
-- Name: fare_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_attribute ALTER COLUMN fare_id SET DEFAULT nextval('fare_attribute_fare_id_seq'::regclass);


--
-- TOC entry 2099 (class 2604 OID 637475)
-- Name: fare_rule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule ALTER COLUMN fare_rule_id SET DEFAULT nextval('fare_rule_fare_rule_id_seq'::regclass);


--
-- TOC entry 2103 (class 2604 OID 637476)
-- Name: feed_info_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY feed_info ALTER COLUMN feed_info_id SET DEFAULT nextval('feed_info_feed_info_id_seq'::regclass);


--
-- TOC entry 2093 (class 2604 OID 637477)
-- Name: frequency_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY frequency ALTER COLUMN frequency_id SET DEFAULT nextval('frequency_frequency_id_seq'::regclass);


--
-- TOC entry 2089 (class 2604 OID 637478)
-- Name: route_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY route ALTER COLUMN route_id SET DEFAULT nextval('route_route_id_seq'::regclass);


--
-- TOC entry 2096 (class 2604 OID 637479)
-- Name: shape_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shape ALTER COLUMN shape_id SET DEFAULT nextval('shape_shape_id_seq'::regclass);


--
-- TOC entry 2100 (class 2604 OID 637480)
-- Name: stop_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop ALTER COLUMN stop_id SET DEFAULT nextval('stop_stop_id_seq'::regclass);


--
-- TOC entry 2101 (class 2604 OID 637481)
-- Name: stop_time_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop_time ALTER COLUMN stop_time_id SET DEFAULT nextval('stop_time_stop_time_id_seq'::regclass);


--
-- TOC entry 2102 (class 2604 OID 637482)
-- Name: transfer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer ALTER COLUMN transfer_id SET DEFAULT nextval('transfer_transfer_id_seq'::regclass);


--
-- TOC entry 2092 (class 2604 OID 637483)
-- Name: trip_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip ALTER COLUMN trip_id SET DEFAULT nextval('trip_trip_id_seq'::regclass);


--
-- TOC entry 2098 (class 2604 OID 637484)
-- Name: zone_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zone ALTER COLUMN zone_id SET DEFAULT nextval('zone_zone_id_seq'::regclass);


SET search_path = gtfsx, pg_catalog;

--
-- TOC entry 2455 (class 0 OID 1012867)
-- Dependencies: 200
-- Data for Name: agency; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY agency (agency_id, agency_fare_url, agency_gtfs_id, agency_lang, agency_name, agency_phone, agency_timezone, agency_url) FROM stdin;
50		GTT	it	Gruppo Torinese Trasporti		Europe/Rome	http://www.gtt.to.it/
\.


--
-- TOC entry 2533 (class 0 OID 0)
-- Dependencies: 214
-- Name: agency_agency_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('agency_agency_id_seq', 1, true);


--
-- TOC entry 2456 (class 0 OID 1012875)
-- Dependencies: 201
-- Data for Name: calendar; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY calendar (service_id, end_date, friday, calendar_gtfs_id, monday, saturday, start_date, sunday, thursday, tuesday, wednesday, agency_id) FROM stdin;
50	2014-12-14	t	FER5scol	t	f	2014-09-15	f	t	t	t	50
51	2014-12-14	f	FESTscol	f	t	2014-09-15	t	f	f	f	50
\.


--
-- TOC entry 2457 (class 0 OID 1012880)
-- Dependencies: 202
-- Data for Name: calendar_date; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY calendar_date (calendar_date_id, date, exception_type, service_id) FROM stdin;
\.


--
-- TOC entry 2534 (class 0 OID 0)
-- Dependencies: 215
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('calendar_date_calendar_date_id_seq', 1, false);


--
-- TOC entry 2535 (class 0 OID 0)
-- Dependencies: 216
-- Name: calendar_service_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('calendar_service_id_seq', 1, true);


--
-- TOC entry 2458 (class 0 OID 1012886)
-- Dependencies: 203
-- Data for Name: fare_attribute; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY fare_attribute (fare_id, currency_type, fare_attribute_gtfs_id, payment_method, price, transfer_duration, transfers, agency_id) FROM stdin;
\.


--
-- TOC entry 2536 (class 0 OID 0)
-- Dependencies: 217
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('fare_attribute_fare_id_seq', 1, false);


--
-- TOC entry 2459 (class 0 OID 1012893)
-- Dependencies: 204
-- Data for Name: fare_rule; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY fare_rule (fare_rule_id, contains_id, destination_id, fare_id, origin_id, route_id) FROM stdin;
\.


--
-- TOC entry 2537 (class 0 OID 0)
-- Dependencies: 218
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('fare_rule_fare_rule_id_seq', 1, false);


--
-- TOC entry 2460 (class 0 OID 1012898)
-- Dependencies: 205
-- Data for Name: feed_info; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY feed_info (feed_info_id, feed_description, feed_end_date, feed_lang, feed_name, feed_publisher_name, feed_publisher_url, feed_start_date, feed_version) FROM stdin;
\.


--
-- TOC entry 2538 (class 0 OID 0)
-- Dependencies: 219
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('feed_info_feed_info_id_seq', 1, false);


--
-- TOC entry 2461 (class 0 OID 1012906)
-- Dependencies: 206
-- Data for Name: route; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY route (route_id, route_color, route_desc, route_gtfs_id, route_long_name, route_short_name, route_text_color, route_type, route_url, agency_id) FROM stdin;
50	#ffffff		1	Linea 1	1	#000000	3		50
\.


--
-- TOC entry 2539 (class 0 OID 0)
-- Dependencies: 220
-- Name: route_route_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('route_route_id_seq', 1, true);


--
-- TOC entry 2462 (class 0 OID 1012915)
-- Dependencies: 207
-- Data for Name: shape; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY shape (shape_id, shape_encoded_polyline, agency_id) FROM stdin;
50	kdarGaq}m@dBnB|F`EqC~KyA}@yA|FxA~@a@bB|FrDiHnXeFlRxB|AsCfLyA_AcEoBqAo@mAT{BuAkFnSsC}A	50
\.


--
-- TOC entry 2540 (class 0 OID 0)
-- Dependencies: 221
-- Name: shape_shape_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('shape_shape_id_seq', 1, true);


--
-- TOC entry 2463 (class 0 OID 1012920)
-- Dependencies: 208
-- Data for Name: stop; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY stop (stop_id, stop_code, stop_desc, stop_gtfs_id, stop_lat, location_type, stop_lon, stop_name, stop_timezone, stop_url, wheelchair_boarding, agency_id, parent_station, zone_id) FROM stdin;
54			00005	45.0729447752352783	0	7.67568826675415039	Siccardi	Europe/Rome		0	50	\N	\N
53			00004	45.0686182768968564	0	7.6773834228515625	Solferino	Europe/Rome		0	50	\N	\N
50			00001	45.0668868281018078	0	7.6827692985534668	San Carlo	\N		0	50	\N	\N
52			00003	45.0671027884729796	0	7.69313335418701172	Sant'Ottavio	Europe/Rome		0	50	\N	\N
51			00002	45.0665003706643361	0	7.68825173377990634	Carlo Emanuele II	\N		0	50	\N	\N
\.


--
-- TOC entry 2541 (class 0 OID 0)
-- Dependencies: 222
-- Name: stop_stop_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('stop_stop_id_seq', 1, true);


--
-- TOC entry 2464 (class 0 OID 1012930)
-- Dependencies: 209
-- Data for Name: stop_time_relative; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY stop_time_relative (stop_time_relative_id, drop_off_type, pickup_type, relative_arrival_time, relative_departure_time, shape_dist_traveled, stop_headsign, stop_sequence, stop_id, trip_pattern_id) FROM stdin;
50	0	0	00:00:00	00:03:00	\N		1	52	50
54	0	0	00:03:00	00:01:00	\N		5	54	50
53	0	0	00:02:00	00:02:00	\N		4	53	50
52	0	0	00:02:00	00:01:00	\N		3	50	50
51	0	0	00:03:00	00:01:00	\N		2	51	50
\.


--
-- TOC entry 2542 (class 0 OID 0)
-- Dependencies: 223
-- Name: stop_time_relative_stop_time_relative_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('stop_time_relative_stop_time_relative_id_seq', 2, true);


--
-- TOC entry 2465 (class 0 OID 1012938)
-- Dependencies: 210
-- Data for Name: transfer; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY transfer (transfer_id, min_transfer_time, transfer_type, agency_id, from_stop_id, to_stop_id) FROM stdin;
\.


--
-- TOC entry 2543 (class 0 OID 0)
-- Dependencies: 224
-- Name: transfer_transfer_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('transfer_transfer_id_seq', 1, false);


--
-- TOC entry 2466 (class 0 OID 1012945)
-- Dependencies: 211
-- Data for Name: trip; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY trip (trip_id, bikes_allowed, block_id, direction_id, end_time, exact_times, trip_gtfs_id, headway_secs, single_trip, start_time, trip_headsign, trip_short_name, wheelchair_accessible, service_id, route_id, shape_id, trip_pattern_id) FROM stdin;
50	0		0	\N	\N	1-FER5-07:00	\N	t	07:00:00		Linea 1 Andata	0	50	50	50	50
51	0		0	\N	\N	1-FER5-07:30	\N	t	07:30:00		Linea 1 Andata	0	50	50	50	50
\.


--
-- TOC entry 2467 (class 0 OID 1012955)
-- Dependencies: 212
-- Data for Name: trip_pattern; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY trip_pattern (trip_pattern_id, bikes_allowed, direction_id, trip_pattern_gtfs_id, trip_headsign, trip_short_name, wheelchair_accessible, service_id, route_id, shape_id) FROM stdin;
50	0	0	1-FER5		Linea 1 Andata	0	50	50	50
100	0	0	pippo		pippo	0	50	50	\N
\.


--
-- TOC entry 2544 (class 0 OID 0)
-- Dependencies: 225
-- Name: trip_pattern_trip_pattern_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('trip_pattern_trip_pattern_id_seq', 2, true);


--
-- TOC entry 2545 (class 0 OID 0)
-- Dependencies: 226
-- Name: trip_trip_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('trip_trip_id_seq', 1, true);


--
-- TOC entry 2468 (class 0 OID 1012963)
-- Dependencies: 213
-- Data for Name: zone; Type: TABLE DATA; Schema: gtfsx; Owner: postgres
--

COPY zone (zone_id, zone_gtfs_id, name, agency_id) FROM stdin;
\.


--
-- TOC entry 2546 (class 0 OID 0)
-- Dependencies: 227
-- Name: zone_zone_id_seq; Type: SEQUENCE SET; Schema: gtfsx; Owner: postgres
--

SELECT pg_catalog.setval('zone_zone_id_seq', 1, false);


SET search_path = prova, pg_catalog;

--
-- TOC entry 2483 (class 0 OID 1013128)
-- Dependencies: 228
-- Data for Name: agency; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY agency (agency_id, agency_fare_url, agency_gtfs_id, agency_lang, agency_name, agency_phone, agency_timezone, agency_url) FROM stdin;
250	\N	GTT_F	it	GTT	800-019152	Europe/Rome	http://www.sfmtorino.it
251	\N	FS	it	TRENITALIA	\N	Europe/Rome	http://www.sfmtorino.it
\.


--
-- TOC entry 2547 (class 0 OID 0)
-- Dependencies: 242
-- Name: agency_agency_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('agency_agency_id_seq', 5, true);


--
-- TOC entry 2484 (class 0 OID 1013136)
-- Dependencies: 229
-- Data for Name: calendar; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY calendar (service_id, end_date, friday, calendar_gtfs_id, monday, saturday, start_date, sunday, thursday, tuesday, wednesday, agency_id) FROM stdin;
\.


--
-- TOC entry 2485 (class 0 OID 1013141)
-- Dependencies: 230
-- Data for Name: calendar_date; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY calendar_date (calendar_date_id, date, exception_type, service_id) FROM stdin;
\.


--
-- TOC entry 2548 (class 0 OID 0)
-- Dependencies: 243
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('calendar_date_calendar_date_id_seq', 1, false);


--
-- TOC entry 2549 (class 0 OID 0)
-- Dependencies: 244
-- Name: calendar_service_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('calendar_service_id_seq', 1, false);


--
-- TOC entry 2486 (class 0 OID 1013147)
-- Dependencies: 231
-- Data for Name: fare_attribute; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY fare_attribute (fare_id, currency_type, fare_attribute_gtfs_id, payment_method, price, transfer_duration, transfers, agency_id) FROM stdin;
\.


--
-- TOC entry 2550 (class 0 OID 0)
-- Dependencies: 245
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('fare_attribute_fare_id_seq', 1, false);


--
-- TOC entry 2487 (class 0 OID 1013154)
-- Dependencies: 232
-- Data for Name: fare_rule; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY fare_rule (fare_rule_id, contains_id, destination_id, fare_id, origin_id, route_id) FROM stdin;
\.


--
-- TOC entry 2551 (class 0 OID 0)
-- Dependencies: 246
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('fare_rule_fare_rule_id_seq', 1, false);


--
-- TOC entry 2488 (class 0 OID 1013159)
-- Dependencies: 233
-- Data for Name: feed_info; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY feed_info (feed_info_id, feed_description, feed_end_date, feed_lang, feed_name, feed_publisher_name, feed_publisher_url, feed_start_date, feed_version) FROM stdin;
250	\N	\N	\N	sfm_torino_it	\N	\N	\N	\N
\.


--
-- TOC entry 2552 (class 0 OID 0)
-- Dependencies: 247
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('feed_info_feed_info_id_seq', 5, true);


--
-- TOC entry 2489 (class 0 OID 1013167)
-- Dependencies: 234
-- Data for Name: frequency; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY frequency (frequency_id, end_time, exact_times, headway_secs, start_time, trip_id) FROM stdin;
\.


--
-- TOC entry 2553 (class 0 OID 0)
-- Dependencies: 248
-- Name: frequency_frequency_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('frequency_frequency_id_seq', 1, false);


--
-- TOC entry 2490 (class 0 OID 1013174)
-- Dependencies: 235
-- Data for Name: route; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY route (route_id, route_color, route_desc, route_gtfs_id, route_long_name, route_short_name, route_text_color, route_type, route_url, agency_id) FROM stdin;
\.


--
-- TOC entry 2554 (class 0 OID 0)
-- Dependencies: 249
-- Name: route_route_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('route_route_id_seq', 1, false);


--
-- TOC entry 2491 (class 0 OID 1013183)
-- Dependencies: 236
-- Data for Name: shape; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY shape (shape_id, shape_encoded_polyline, agency_id) FROM stdin;
\.


--
-- TOC entry 2555 (class 0 OID 0)
-- Dependencies: 250
-- Name: shape_shape_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('shape_shape_id_seq', 1, false);


--
-- TOC entry 2492 (class 0 OID 1013188)
-- Dependencies: 237
-- Data for Name: stop; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY stop (stop_id, stop_code, stop_desc, stop_gtfs_id, stop_lat, location_type, stop_lon, stop_name, stop_timezone, stop_url, wheelchair_boarding, agency_id, parent_station, zone_id) FROM stdin;
\.


--
-- TOC entry 2556 (class 0 OID 0)
-- Dependencies: 251
-- Name: stop_stop_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('stop_stop_id_seq', 1, false);


--
-- TOC entry 2493 (class 0 OID 1013198)
-- Dependencies: 238
-- Data for Name: stop_time; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY stop_time (stop_time_id, arrival_time, continue_from_previous_day, departure_time, drop_off_type, pickup_type, shape_dist_traveled, stop_headsign, stop_sequence, stop_id, trip_id) FROM stdin;
\.


--
-- TOC entry 2557 (class 0 OID 0)
-- Dependencies: 252
-- Name: stop_time_stop_time_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('stop_time_stop_time_id_seq', 1, false);


--
-- TOC entry 2494 (class 0 OID 1013206)
-- Dependencies: 239
-- Data for Name: transfer; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY transfer (transfer_id, min_transfer_time, transfer_type, agency_id, from_stop_id, to_stop_id) FROM stdin;
\.


--
-- TOC entry 2558 (class 0 OID 0)
-- Dependencies: 253
-- Name: transfer_transfer_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('transfer_transfer_id_seq', 1, false);


--
-- TOC entry 2495 (class 0 OID 1013213)
-- Dependencies: 240
-- Data for Name: trip; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY trip (trip_id, bikes_allowed, direction_id, trip_gtfs_id, trip_headsign, trip_short_name, wheelchair_accessible, service_id, route_id, shape_id, blockid) FROM stdin;
\.


--
-- TOC entry 2559 (class 0 OID 0)
-- Dependencies: 254
-- Name: trip_trip_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('trip_trip_id_seq', 1, false);


--
-- TOC entry 2496 (class 0 OID 1013221)
-- Dependencies: 241
-- Data for Name: zone; Type: TABLE DATA; Schema: prova; Owner: postgres
--

COPY zone (zone_id, zone_gtfs_id, name, agency_id) FROM stdin;
\.


--
-- TOC entry 2560 (class 0 OID 0)
-- Dependencies: 255
-- Name: zone_zone_id_seq; Type: SEQUENCE SET; Schema: prova; Owner: postgres
--

SELECT pg_catalog.setval('zone_zone_id_seq', 1, false);


SET search_path = public, pg_catalog;

--
-- TOC entry 2427 (class 0 OID 529839)
-- Dependencies: 172
-- Data for Name: agency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY agency (agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone, agency_fare_url, agency_gtfs_id) FROM stdin;
51	Metro	http://www.metrotorino.it/index_flash.php	Europe/Rome	it	011/98-65-320		M
400	Gruppo Torinese Trasporti	http://www.gtt.to.it/	Europe/Rome	it			GTT
\.


--
-- TOC entry 2561 (class 0 OID 0)
-- Dependencies: 175
-- Name: agency_agency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('agency_agency_id_seq', 14, true);


--
-- TOC entry 2436 (class 0 OID 529988)
-- Dependencies: 181
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calendar (service_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, start_date, end_date, calendar_gtfs_id, agency_id) FROM stdin;
350	t	t	t	t	t	f	f	2014-07-01	2014-07-31	Estivo fer5	51
301	f	f	f	f	f	t	t	2014-07-01	2014-08-31	FESTest	400
450	t	t	t	t	t	f	f	2014-07-01	2014-08-31	FER5est	400
\.


--
-- TOC entry 2438 (class 0 OID 529996)
-- Dependencies: 183
-- Data for Name: calendar_date; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY calendar_date (calendar_date_id, service_id, date, exception_type) FROM stdin;
50	301	2014-08-15	2
401	450	2014-07-24	2
301	450	2014-08-09	1
250	450	2014-07-09	2
\.


--
-- TOC entry 2562 (class 0 OID 0)
-- Dependencies: 182
-- Name: calendar_date_calendar_date_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calendar_date_calendar_date_id_seq', 8, true);


--
-- TOC entry 2563 (class 0 OID 0)
-- Dependencies: 180
-- Name: calendar_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('calendar_service_id_seq', 13, true);


--
-- TOC entry 2442 (class 0 OID 530036)
-- Dependencies: 187
-- Data for Name: fare_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fare_attribute (fare_id, price, currency_type, transfers, transfer_duration, agency_id, fare_attribute_gtfs_id, payment_method) FROM stdin;
200	1.69999999999999996	EUR	\N	70	400	Suburbano	1
101	1.5	EUR	1	\N	400	Urbano	1
\.


--
-- TOC entry 2564 (class 0 OID 0)
-- Dependencies: 186
-- Name: fare_attribute_fare_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fare_attribute_fare_id_seq', 8, true);


--
-- TOC entry 2446 (class 0 OID 530058)
-- Dependencies: 191
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
-- TOC entry 2565 (class 0 OID 0)
-- Dependencies: 190
-- Name: fare_rule_fare_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fare_rule_fare_rule_id_seq', 31, true);


--
-- TOC entry 2454 (class 0 OID 530159)
-- Dependencies: 199
-- Data for Name: feed_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY feed_info (feed_info_id, feed_publisher_name, feed_publisher_url, feed_lang, feed_start_date, feed_end_date, feed_version, feed_name, feed_description) FROM stdin;
351	5T	http://www.5t.torino.it/5t/	it	2014-09-01	2014-09-30	1.0	2014-09-03 16.42.40	Primo feed
401	5T	http://www.5t.torino.it/5t/	it	\N	\N	1.0.1	2014-09-08 15.24.08	Aggiunte zone a fermate e tariffe
500	5T	http://www.5t.torino.it/5t/	it	\N	\N	1.0.2	2014-09-10 10.53.56	Aggiunti trasferimenti
\.


--
-- TOC entry 2566 (class 0 OID 0)
-- Dependencies: 198
-- Name: feed_info_feed_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('feed_info_feed_info_id_seq', 20, true);


--
-- TOC entry 2434 (class 0 OID 529974)
-- Dependencies: 179
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
-- TOC entry 2567 (class 0 OID 0)
-- Dependencies: 178
-- Name: frequency_frequency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('frequency_frequency_id_seq', 28, true);


--
-- TOC entry 2428 (class 0 OID 529861)
-- Dependencies: 173
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY route (route_id, agency_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, route_gtfs_id) FROM stdin;
2050	51	1	Fermi - Lingotto		1		#ffffff	#400080	1
2100	400	10	Tram		0		#ffffff	#000000	10
1450	400	72	Corso Machiavelli - Via Bertola		3		#ffffff	#400080	72
900	400	VE1	Venaria cimitero - Piazza Massaua	Navetta da Venaria alla fermata della metro di Piazza Massaua	3		#ffffff	#ff0000	VE1
\.


--
-- TOC entry 2568 (class 0 OID 0)
-- Dependencies: 174
-- Name: route_route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('route_route_id_seq', 45, true);


--
-- TOC entry 2440 (class 0 OID 530011)
-- Dependencies: 185
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
-- TOC entry 2569 (class 0 OID 0)
-- Dependencies: 184
-- Name: shape_shape_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shape_shape_id_seq', 37, true);


--
-- TOC entry 2448 (class 0 OID 530096)
-- Dependencies: 193
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
-- TOC entry 2570 (class 0 OID 0)
-- Dependencies: 192
-- Name: stop_stop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('stop_stop_id_seq', 23, true);


--
-- TOC entry 2450 (class 0 OID 530119)
-- Dependencies: 195
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
200	1400	10:05:00	10:06:00	360	2	\N	\N	\N	\N	f
750	1400	10:20:00	10:25:00	357	5	\N	\N	\N	\N	f
450	1501	01:05:00	01:06:00	359	2	\N	\N	\N	\N	f
500	1501	14:02:00	14:03:00	360	3	\N	\N	\N	\N	f
400	1501	01:00:00	01:01:00	358	1	\N	\N	\N	\N	f
\.


--
-- TOC entry 2571 (class 0 OID 0)
-- Dependencies: 194
-- Name: stop_time_stop_time_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('stop_time_stop_time_id_seq', 52, true);


--
-- TOC entry 2452 (class 0 OID 530139)
-- Dependencies: 197
-- Data for Name: transfer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY transfer (transfer_id, from_stop_id, to_stop_id, transfer_type, min_transfer_time, agency_id) FROM stdin;
200	359	360	1	\N	400
151	359	356	3	\N	400
152	356	401	2	10	400
\.


--
-- TOC entry 2572 (class 0 OID 0)
-- Dependencies: 196
-- Name: transfer_transfer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('transfer_transfer_id_seq', 4, true);


--
-- TOC entry 2432 (class 0 OID 529966)
-- Dependencies: 177
-- Data for Name: trip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trip (trip_id, route_id, service_id, trip_headsign, trip_short_name, shape_id, wheelchair_accessible, bikes_allowed, direction_id, trip_gtfs_id, block_id) FROM stdin;
1100	2050	350	Direzione Lingotto	Fermi - Lingotto	1450	1	1	0	t1	\N
1150	2050	350	Fermi	Lingotto - Fermi	\N	1	1	1	t2	\N
3151	2100	301		pluto	1800	0	0	0	t1	\N
3201	900	450	Venaria cimitero	P.zza Massaua - Venaria cimitero	1853	1	2	1	c2	\N
2600	2100	301		pluto	1550	0	0	0	t7	\N
1700	900	301	Venaria cimitero	P.zza Massaua - Venaria cimitero	\N	1	2	1	t6	\N
1400	900	450	Venaria cimitero	P.zza Massaua - Venaria cimitero	1500	1	2	1	t3	\N
1501	900	301	Piazza Massaua	Venaria cimitero - P.zza Massaua	\N	1	2	0	t5	\N
1500	900	450	Piazza Massaua	Venaria cimitero - P.zza Massaua	1401	1	2	0	t4	\N
\.


--
-- TOC entry 2573 (class 0 OID 0)
-- Dependencies: 176
-- Name: trip_trip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trip_trip_id_seq', 64, true);


--
-- TOC entry 2444 (class 0 OID 530044)
-- Dependencies: 189
-- Data for Name: zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY zone (zone_id, name, zone_gtfs_id, agency_id) FROM stdin;
100	Zona A	A	400
150	Zona B1	B	400
\.


--
-- TOC entry 2574 (class 0 OID 0)
-- Dependencies: 188
-- Name: zone_zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('zone_zone_id_seq', 3, true);


SET search_path = gtfsx, pg_catalog;

--
-- TOC entry 2193 (class 2606 OID 1012874)
-- Name: agency_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_pkey PRIMARY KEY (agency_id);


--
-- TOC entry 2197 (class 2606 OID 1012885)
-- Name: calendar_date_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT calendar_date_pkey PRIMARY KEY (calendar_date_id);


--
-- TOC entry 2195 (class 2606 OID 1012879)
-- Name: calendar_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (service_id);


--
-- TOC entry 2199 (class 2606 OID 1012892)
-- Name: fare_attribute_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fare_attribute_pkey PRIMARY KEY (fare_id);


--
-- TOC entry 2201 (class 2606 OID 1012897)
-- Name: fare_rule_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_pkey PRIMARY KEY (fare_rule_id);


--
-- TOC entry 2203 (class 2606 OID 1012905)
-- Name: feed_info_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY feed_info
    ADD CONSTRAINT feed_info_pkey PRIMARY KEY (feed_info_id);


--
-- TOC entry 2205 (class 2606 OID 1012914)
-- Name: route_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_pkey PRIMARY KEY (route_id);


--
-- TOC entry 2207 (class 2606 OID 1012919)
-- Name: shape_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT shape_pkey PRIMARY KEY (shape_id);


--
-- TOC entry 2209 (class 2606 OID 1012929)
-- Name: stop_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_pkey PRIMARY KEY (stop_id);


--
-- TOC entry 2211 (class 2606 OID 1012937)
-- Name: stop_time_relative_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop_time_relative
    ADD CONSTRAINT stop_time_relative_pkey PRIMARY KEY (stop_time_relative_id);


--
-- TOC entry 2213 (class 2606 OID 1012944)
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (transfer_id);


--
-- TOC entry 2217 (class 2606 OID 1012962)
-- Name: trip_pattern_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trip_pattern
    ADD CONSTRAINT trip_pattern_pkey PRIMARY KEY (trip_pattern_id);


--
-- TOC entry 2215 (class 2606 OID 1012954)
-- Name: trip_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_pkey PRIMARY KEY (trip_id);


--
-- TOC entry 2219 (class 2606 OID 1012967)
-- Name: zone_pkey; Type: CONSTRAINT; Schema: gtfsx; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (zone_id);


SET search_path = prova, pg_catalog;

--
-- TOC entry 2221 (class 2606 OID 1013135)
-- Name: agency_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_pkey PRIMARY KEY (agency_id);


--
-- TOC entry 2225 (class 2606 OID 1013146)
-- Name: calendar_date_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT calendar_date_pkey PRIMARY KEY (calendar_date_id);


--
-- TOC entry 2223 (class 2606 OID 1013140)
-- Name: calendar_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (service_id);


--
-- TOC entry 2227 (class 2606 OID 1013153)
-- Name: fare_attribute_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fare_attribute_pkey PRIMARY KEY (fare_id);


--
-- TOC entry 2229 (class 2606 OID 1013158)
-- Name: fare_rule_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_pkey PRIMARY KEY (fare_rule_id);


--
-- TOC entry 2231 (class 2606 OID 1013166)
-- Name: feed_info_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY feed_info
    ADD CONSTRAINT feed_info_pkey PRIMARY KEY (feed_info_id);


--
-- TOC entry 2233 (class 2606 OID 1013173)
-- Name: frequency_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_pkey PRIMARY KEY (frequency_id);


--
-- TOC entry 2235 (class 2606 OID 1013182)
-- Name: route_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_pkey PRIMARY KEY (route_id);


--
-- TOC entry 2237 (class 2606 OID 1013187)
-- Name: shape_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT shape_pkey PRIMARY KEY (shape_id);


--
-- TOC entry 2239 (class 2606 OID 1013197)
-- Name: stop_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_pkey PRIMARY KEY (stop_id);


--
-- TOC entry 2241 (class 2606 OID 1013205)
-- Name: stop_time_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT stop_time_pkey PRIMARY KEY (stop_time_id);


--
-- TOC entry 2243 (class 2606 OID 1013212)
-- Name: transfer_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_pkey PRIMARY KEY (transfer_id);


--
-- TOC entry 2245 (class 2606 OID 1013220)
-- Name: trip_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_pkey PRIMARY KEY (trip_id);


--
-- TOC entry 2247 (class 2606 OID 1013225)
-- Name: zone_pkey; Type: CONSTRAINT; Schema: prova; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (zone_id);


SET search_path = public, pg_catalog;

--
-- TOC entry 2140 (class 2606 OID 1011971)
-- Name: agency_gtfs_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_gtfs_id UNIQUE (agency_gtfs_id);


--
-- TOC entry 2142 (class 2606 OID 529935)
-- Name: agency_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_id PRIMARY KEY (agency_id);


--
-- TOC entry 2158 (class 2606 OID 530001)
-- Name: calendar_date_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT calendar_date_id PRIMARY KEY (calendar_date_id);


--
-- TOC entry 2164 (class 2606 OID 530041)
-- Name: fare_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fare_id PRIMARY KEY (fare_id);


--
-- TOC entry 2170 (class 2606 OID 530063)
-- Name: fare_rule_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_id PRIMARY KEY (fare_rule_id);


--
-- TOC entry 2191 (class 2606 OID 530164)
-- Name: feed_info_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY feed_info
    ADD CONSTRAINT feed_info_id PRIMARY KEY (feed_info_id);


--
-- TOC entry 2153 (class 2606 OID 529979)
-- Name: frequency_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_id PRIMARY KEY (frequency_id);


--
-- TOC entry 2145 (class 2606 OID 529927)
-- Name: route_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_id PRIMARY KEY (route_id);


--
-- TOC entry 2156 (class 2606 OID 529993)
-- Name: service_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT service_id PRIMARY KEY (service_id);


--
-- TOC entry 2162 (class 2606 OID 530016)
-- Name: shape_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT shape_id PRIMARY KEY (shape_id);


--
-- TOC entry 2180 (class 2606 OID 530104)
-- Name: stop_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_id PRIMARY KEY (stop_id);


--
-- TOC entry 2184 (class 2606 OID 530124)
-- Name: stop_time_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT stop_time_id PRIMARY KEY (stop_time_id);


--
-- TOC entry 2189 (class 2606 OID 530144)
-- Name: transfer_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_id PRIMARY KEY (transfer_id);


--
-- TOC entry 2150 (class 2606 OID 529971)
-- Name: trip_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_id PRIMARY KEY (trip_id);


--
-- TOC entry 2168 (class 2606 OID 530049)
-- Name: zone_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_id PRIMARY KEY (zone_id);


--
-- TOC entry 2143 (class 1259 OID 529945)
-- Name: fki_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_agency_id ON route USING btree (agency_id);


--
-- TOC entry 2154 (class 1259 OID 995158)
-- Name: fki_calendar_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_calendar_agency_id ON calendar USING btree (agency_id);


--
-- TOC entry 2165 (class 1259 OID 996636)
-- Name: fki_fare_attribute_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_attribute_agency_id ON fare_attribute USING btree (agency_id);


--
-- TOC entry 2171 (class 1259 OID 530093)
-- Name: fki_fare_rule_contains_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_contains_id ON fare_rule USING btree (contains_id);


--
-- TOC entry 2172 (class 1259 OID 530087)
-- Name: fki_fare_rule_destination_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_destination_id ON fare_rule USING btree (destination_id);


--
-- TOC entry 2173 (class 1259 OID 530075)
-- Name: fki_fare_rule_fare_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_fare_id ON fare_rule USING btree (fare_id);


--
-- TOC entry 2174 (class 1259 OID 530081)
-- Name: fki_fare_rule_origin_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_fare_rule_origin_id ON fare_rule USING btree (origin_id);


--
-- TOC entry 2175 (class 1259 OID 530069)
-- Name: fki_route_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_route_id ON fare_rule USING btree (route_id);


--
-- TOC entry 2159 (class 1259 OID 530008)
-- Name: fki_service_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_service_id ON calendar_date USING btree (service_id);


--
-- TOC entry 2160 (class 1259 OID 1011991)
-- Name: fki_shape_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_shape_agency_id ON shape USING btree (agency_id);


--
-- TOC entry 2146 (class 1259 OID 530022)
-- Name: fki_shape_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_shape_id ON trip USING btree (shape_id);


--
-- TOC entry 2176 (class 1259 OID 530110)
-- Name: fki_sop_zone_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_sop_zone_id ON stop USING btree (zone_id);


--
-- TOC entry 2177 (class 1259 OID 1010056)
-- Name: fki_stop_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_agency_id ON stop USING btree (agency_id);


--
-- TOC entry 2178 (class 1259 OID 530116)
-- Name: fki_stop_parent_station; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_parent_station ON stop USING btree (parent_station);


--
-- TOC entry 2181 (class 1259 OID 530136)
-- Name: fki_stop_time_stop_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_time_stop_id ON stop_time USING btree (stop_id);


--
-- TOC entry 2182 (class 1259 OID 530130)
-- Name: fki_stop_time_trip_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_stop_time_trip_id ON stop_time USING btree (trip_id);


--
-- TOC entry 2185 (class 1259 OID 1012008)
-- Name: fki_transfer_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_transfer_agency_id ON transfer USING btree (agency_id);


--
-- TOC entry 2186 (class 1259 OID 530150)
-- Name: fki_transfer_from_stop_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_transfer_from_stop_id ON transfer USING btree (from_stop_id);


--
-- TOC entry 2187 (class 1259 OID 530156)
-- Name: fki_transfer_to_stop_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_transfer_to_stop_id ON transfer USING btree (to_stop_id);


--
-- TOC entry 2151 (class 1259 OID 529985)
-- Name: fki_trip_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_trip_id ON frequency USING btree (trip_id);


--
-- TOC entry 2147 (class 1259 OID 530055)
-- Name: fki_trip_route_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_trip_route_id ON trip USING btree (route_id);


--
-- TOC entry 2148 (class 1259 OID 530033)
-- Name: fki_trip_service_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_trip_service_id ON trip USING btree (service_id);


--
-- TOC entry 2166 (class 1259 OID 1012002)
-- Name: fki_zone_agency_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_zone_agency_id ON zone USING btree (agency_id);


SET search_path = gtfsx, pg_catalog;

--
-- TOC entry 2283 (class 2606 OID 1013028)
-- Name: fk_17sh542i692aitdqa61rcexdv; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT fk_17sh542i692aitdqa61rcexdv FOREIGN KEY (zone_id) REFERENCES zone(zone_id);


--
-- TOC entry 2279 (class 2606 OID 1013008)
-- Name: fk_2ftgflj3xt0qqxrmqtya7apsr; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY route
    ADD CONSTRAINT fk_2ftgflj3xt0qqxrmqtya7apsr FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2273 (class 2606 OID 1012978)
-- Name: fk_3306mvotugjd8du6ljsl77auj; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fk_3306mvotugjd8du6ljsl77auj FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2289 (class 2606 OID 1013058)
-- Name: fk_5rh6qhq1do15487lumdk6g771; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT fk_5rh6qhq1do15487lumdk6g771 FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 2271 (class 2606 OID 1012968)
-- Name: fk_63y4qu4d0mm7xkot05k8vovwi; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT fk_63y4qu4d0mm7xkot05k8vovwi FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2272 (class 2606 OID 1012973)
-- Name: fk_6pue730u10lt3wj7gfppy2jua; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT fk_6pue730u10lt3wj7gfppy2jua FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 2288 (class 2606 OID 1013053)
-- Name: fk_6ydtcw0mb8dr3vwiowa39i6e5; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_6ydtcw0mb8dr3vwiowa39i6e5 FOREIGN KEY (to_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2275 (class 2606 OID 1012988)
-- Name: fk_73tsf0lj7030hdyg3qbgo58e2; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_73tsf0lj7030hdyg3qbgo58e2 FOREIGN KEY (destination_id) REFERENCES zone(zone_id);


--
-- TOC entry 2280 (class 2606 OID 1013013)
-- Name: fk_95fm314c3pcqgel9ggc96qdxk; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT fk_95fm314c3pcqgel9ggc96qdxk FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2296 (class 2606 OID 1013093)
-- Name: fk_9fq2f6fadsn9w0ypteeld6fmy; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT fk_9fq2f6fadsn9w0ypteeld6fmy FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2287 (class 2606 OID 1013048)
-- Name: fk_b1q4aj3exsdhll99lo9qnvje1; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_b1q4aj3exsdhll99lo9qnvje1 FOREIGN KEY (from_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2294 (class 2606 OID 1013083)
-- Name: fk_bdu7f4k53qkt2vd60ha1b9k9t; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY trip_pattern
    ADD CONSTRAINT fk_bdu7f4k53qkt2vd60ha1b9k9t FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 2286 (class 2606 OID 1013043)
-- Name: fk_cbkkofg6ral3sdqo9ur12gvop; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_cbkkofg6ral3sdqo9ur12gvop FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2281 (class 2606 OID 1013018)
-- Name: fk_cojj6h0valql0anlm43bx22dt; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT fk_cojj6h0valql0anlm43bx22dt FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2276 (class 2606 OID 1012993)
-- Name: fk_fh0aesjlv4c09uy2ntxr4c6kw; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_fh0aesjlv4c09uy2ntxr4c6kw FOREIGN KEY (fare_id) REFERENCES fare_attribute(fare_id);


--
-- TOC entry 2274 (class 2606 OID 1012983)
-- Name: fk_hvpwlqnefthh48reyra2do6sb; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_hvpwlqnefthh48reyra2do6sb FOREIGN KEY (contains_id) REFERENCES zone(zone_id);


--
-- TOC entry 2295 (class 2606 OID 1013088)
-- Name: fk_jwvun8xar8dqgvkw1wgqgo6ar; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY trip_pattern
    ADD CONSTRAINT fk_jwvun8xar8dqgvkw1wgqgo6ar FOREIGN KEY (shape_id) REFERENCES shape(shape_id);


--
-- TOC entry 2285 (class 2606 OID 1013038)
-- Name: fk_k2pboyjvpj0agspyongsg314k; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY stop_time_relative
    ADD CONSTRAINT fk_k2pboyjvpj0agspyongsg314k FOREIGN KEY (trip_pattern_id) REFERENCES trip_pattern(trip_pattern_id);


--
-- TOC entry 2290 (class 2606 OID 1013063)
-- Name: fk_kih9l4qdpsutm02shb5mdrkj6; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT fk_kih9l4qdpsutm02shb5mdrkj6 FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 2278 (class 2606 OID 1013003)
-- Name: fk_moqgd7lqowk9ov1eebpmym16r; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_moqgd7lqowk9ov1eebpmym16r FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 2291 (class 2606 OID 1013068)
-- Name: fk_nw5e5fns65veovx1mevot8v87; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT fk_nw5e5fns65veovx1mevot8v87 FOREIGN KEY (shape_id) REFERENCES shape(shape_id);


--
-- TOC entry 2292 (class 2606 OID 1013073)
-- Name: fk_pvptdem2kecp2bf3wl2r47bol; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT fk_pvptdem2kecp2bf3wl2r47bol FOREIGN KEY (trip_pattern_id) REFERENCES trip_pattern(trip_pattern_id);


--
-- TOC entry 2282 (class 2606 OID 1013023)
-- Name: fk_q1wjsjwqkkqxpkhwn1vech0t6; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT fk_q1wjsjwqkkqxpkhwn1vech0t6 FOREIGN KEY (parent_station) REFERENCES stop(stop_id);


--
-- TOC entry 2277 (class 2606 OID 1012998)
-- Name: fk_qyj5srl1w5glmr0e036k0htha; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_qyj5srl1w5glmr0e036k0htha FOREIGN KEY (origin_id) REFERENCES zone(zone_id);


--
-- TOC entry 2293 (class 2606 OID 1013078)
-- Name: fk_tlvehbhr44t88ol4e40xw4me5; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY trip_pattern
    ADD CONSTRAINT fk_tlvehbhr44t88ol4e40xw4me5 FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 2284 (class 2606 OID 1013033)
-- Name: fk_u8arrxt8m3niv1kt59e8nvos; Type: FK CONSTRAINT; Schema: gtfsx; Owner: postgres
--

ALTER TABLE ONLY stop_time_relative
    ADD CONSTRAINT fk_u8arrxt8m3niv1kt59e8nvos FOREIGN KEY (stop_id) REFERENCES stop(stop_id);


SET search_path = prova, pg_catalog;

--
-- TOC entry 2308 (class 2606 OID 1013291)
-- Name: fk_17sh542i692aitdqa61rcexdv; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT fk_17sh542i692aitdqa61rcexdv FOREIGN KEY (zone_id) REFERENCES zone(zone_id);


--
-- TOC entry 2306 (class 2606 OID 1013271)
-- Name: fk_2ftgflj3xt0qqxrmqtya7apsr; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY route
    ADD CONSTRAINT fk_2ftgflj3xt0qqxrmqtya7apsr FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2299 (class 2606 OID 1013236)
-- Name: fk_3306mvotugjd8du6ljsl77auj; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fk_3306mvotugjd8du6ljsl77auj FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2318 (class 2606 OID 1013321)
-- Name: fk_5rh6qhq1do15487lumdk6g771; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT fk_5rh6qhq1do15487lumdk6g771 FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 2297 (class 2606 OID 1013226)
-- Name: fk_63y4qu4d0mm7xkot05k8vovwi; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT fk_63y4qu4d0mm7xkot05k8vovwi FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2298 (class 2606 OID 1013231)
-- Name: fk_6pue730u10lt3wj7gfppy2jua; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT fk_6pue730u10lt3wj7gfppy2jua FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 2313 (class 2606 OID 1013316)
-- Name: fk_6ydtcw0mb8dr3vwiowa39i6e5; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_6ydtcw0mb8dr3vwiowa39i6e5 FOREIGN KEY (to_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2303 (class 2606 OID 1013246)
-- Name: fk_73tsf0lj7030hdyg3qbgo58e2; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_73tsf0lj7030hdyg3qbgo58e2 FOREIGN KEY (destination_id) REFERENCES zone(zone_id);


--
-- TOC entry 2307 (class 2606 OID 1013276)
-- Name: fk_95fm314c3pcqgel9ggc96qdxk; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT fk_95fm314c3pcqgel9ggc96qdxk FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2319 (class 2606 OID 1013336)
-- Name: fk_9fq2f6fadsn9w0ypteeld6fmy; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT fk_9fq2f6fadsn9w0ypteeld6fmy FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2305 (class 2606 OID 1013266)
-- Name: fk_asr2tqgepw43yq2u5l4bgqr26; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT fk_asr2tqgepw43yq2u5l4bgqr26 FOREIGN KEY (trip_id) REFERENCES trip(trip_id);


--
-- TOC entry 2314 (class 2606 OID 1013311)
-- Name: fk_b1q4aj3exsdhll99lo9qnvje1; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_b1q4aj3exsdhll99lo9qnvje1 FOREIGN KEY (from_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2315 (class 2606 OID 1013306)
-- Name: fk_cbkkofg6ral3sdqo9ur12gvop; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT fk_cbkkofg6ral3sdqo9ur12gvop FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2310 (class 2606 OID 1013281)
-- Name: fk_cojj6h0valql0anlm43bx22dt; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT fk_cojj6h0valql0anlm43bx22dt FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2302 (class 2606 OID 1013251)
-- Name: fk_fh0aesjlv4c09uy2ntxr4c6kw; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_fh0aesjlv4c09uy2ntxr4c6kw FOREIGN KEY (fare_id) REFERENCES fare_attribute(fare_id);


--
-- TOC entry 2304 (class 2606 OID 1013241)
-- Name: fk_hvpwlqnefthh48reyra2do6sb; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_hvpwlqnefthh48reyra2do6sb FOREIGN KEY (contains_id) REFERENCES zone(zone_id);


--
-- TOC entry 2317 (class 2606 OID 1013326)
-- Name: fk_kih9l4qdpsutm02shb5mdrkj6; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT fk_kih9l4qdpsutm02shb5mdrkj6 FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 2311 (class 2606 OID 1013301)
-- Name: fk_mfkpgleq9jk5qtsmte4lctbst; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT fk_mfkpgleq9jk5qtsmte4lctbst FOREIGN KEY (trip_id) REFERENCES trip(trip_id);


--
-- TOC entry 2300 (class 2606 OID 1013261)
-- Name: fk_moqgd7lqowk9ov1eebpmym16r; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_moqgd7lqowk9ov1eebpmym16r FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 2316 (class 2606 OID 1013331)
-- Name: fk_nw5e5fns65veovx1mevot8v87; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT fk_nw5e5fns65veovx1mevot8v87 FOREIGN KEY (shape_id) REFERENCES shape(shape_id);


--
-- TOC entry 2312 (class 2606 OID 1013296)
-- Name: fk_omvcrlnlfyo0oqc70ed6vy1sa; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT fk_omvcrlnlfyo0oqc70ed6vy1sa FOREIGN KEY (stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2309 (class 2606 OID 1013286)
-- Name: fk_q1wjsjwqkkqxpkhwn1vech0t6; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT fk_q1wjsjwqkkqxpkhwn1vech0t6 FOREIGN KEY (parent_station) REFERENCES stop(stop_id);


--
-- TOC entry 2301 (class 2606 OID 1013256)
-- Name: fk_qyj5srl1w5glmr0e036k0htha; Type: FK CONSTRAINT; Schema: prova; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fk_qyj5srl1w5glmr0e036k0htha FOREIGN KEY (origin_id) REFERENCES zone(zone_id);


SET search_path = public, pg_catalog;

--
-- TOC entry 2253 (class 2606 OID 995153)
-- Name: calendar_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2254 (class 2606 OID 530003)
-- Name: calendar_date_service_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY calendar_date
    ADD CONSTRAINT calendar_date_service_id FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 2256 (class 2606 OID 996631)
-- Name: fare_attribute_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_attribute
    ADD CONSTRAINT fare_attribute_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2262 (class 2606 OID 530088)
-- Name: fare_rule_contains_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_contains_id FOREIGN KEY (contains_id) REFERENCES zone(zone_id);


--
-- TOC entry 2261 (class 2606 OID 530082)
-- Name: fare_rule_destination_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_destination_id FOREIGN KEY (destination_id) REFERENCES zone(zone_id);


--
-- TOC entry 2259 (class 2606 OID 530070)
-- Name: fare_rule_fare_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_fare_id FOREIGN KEY (fare_id) REFERENCES fare_attribute(fare_id);


--
-- TOC entry 2260 (class 2606 OID 530076)
-- Name: fare_rule_origin_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_origin_id FOREIGN KEY (origin_id) REFERENCES zone(zone_id);


--
-- TOC entry 2258 (class 2606 OID 530064)
-- Name: fare_rule_route_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fare_rule
    ADD CONSTRAINT fare_rule_route_id FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 2252 (class 2606 OID 529980)
-- Name: frequency_trip_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY frequency
    ADD CONSTRAINT frequency_trip_id FOREIGN KEY (trip_id) REFERENCES trip(trip_id);


--
-- TOC entry 2248 (class 2606 OID 529940)
-- Name: route_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2255 (class 2606 OID 1011986)
-- Name: shape_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shape
    ADD CONSTRAINT shape_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2263 (class 2606 OID 530105)
-- Name: sop_zone_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT sop_zone_id FOREIGN KEY (zone_id) REFERENCES zone(zone_id);


--
-- TOC entry 2265 (class 2606 OID 1010051)
-- Name: stop_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2264 (class 2606 OID 530111)
-- Name: stop_parent_station; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_parent_station FOREIGN KEY (parent_station) REFERENCES stop(stop_id);


--
-- TOC entry 2267 (class 2606 OID 530131)
-- Name: stop_time_stop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT stop_time_stop_id FOREIGN KEY (stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2266 (class 2606 OID 530125)
-- Name: stop_time_trip_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stop_time
    ADD CONSTRAINT stop_time_trip_id FOREIGN KEY (trip_id) REFERENCES trip(trip_id);


--
-- TOC entry 2270 (class 2606 OID 1012003)
-- Name: transfer_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2268 (class 2606 OID 530145)
-- Name: transfer_from_stop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_from_stop_id FOREIGN KEY (from_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2269 (class 2606 OID 530151)
-- Name: transfer_to_stop_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transfer
    ADD CONSTRAINT transfer_to_stop_id FOREIGN KEY (to_stop_id) REFERENCES stop(stop_id);


--
-- TOC entry 2251 (class 2606 OID 530050)
-- Name: trip_route_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_route_id FOREIGN KEY (route_id) REFERENCES route(route_id);


--
-- TOC entry 2250 (class 2606 OID 530028)
-- Name: trip_service_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_service_id FOREIGN KEY (service_id) REFERENCES calendar(service_id);


--
-- TOC entry 2249 (class 2606 OID 530017)
-- Name: trip_shape_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trip
    ADD CONSTRAINT trip_shape_id FOREIGN KEY (shape_id) REFERENCES shape(shape_id);


--
-- TOC entry 2257 (class 2606 OID 1011997)
-- Name: zone_agency_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zone
    ADD CONSTRAINT zone_agency_id FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


--
-- TOC entry 2517 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-09-23 11:46:07

--
-- PostgreSQL database dump complete
--

