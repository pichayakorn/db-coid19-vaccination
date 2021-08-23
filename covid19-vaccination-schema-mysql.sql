-- Database Design of COVID-19 Vaccination in Bangkok
-- Thai-Nichi Institute of Technology (泰日工業大学)
-- INT-301 Database System: Semester 1/2021
-- DB12 group project
-- @Author:
--          1911310124 Kornkanok Samrit
--          1911310363 Nattawat Sakupiyanon
--          1911310710 Pratch Suntichaikul

-- Script file for MySQL DBMS
-- This script file creates the following tables:
-- person, location, vaccine, vaccine_storage, service_center, vaccination_record
-- and loads the default data rows

DROP DATABASE IF EXISTS db12;
CREATE DATABASE IF NOT EXISTS db12;
USE db12;

DROP TABLE IF EXISTS
    person,
    location,
    vaccine,
    vaccine_storage,
    service_center,
    vaccination_record;

/* *************************************************************** 
***************************CREATING TABLES************************
**************************************************************** */
CREATE TABLE person (
    personal_id     INTEGER         NOT NULL,
    first_name      VARCHAR(14)     NOT NULL,
    last_name       VARCHAR(16)     NOT NULL,
    birth_date      DATE            NOT NULL,
    phone_number    VARCHAR(15),
    PRIMARY KEY (personal_id)
);

CREATE TABLE location (
    location_id     INTEGER         NOT NULL,
    location_name   VARCHAR(50)     NOT NULL,
    postal_code     VARCHAR(10)     NOT NULL,
    PRIMARY KEY (location_id)
);

CREATE TABLE vaccine (
    vaccine_code    CHAR(5)         NOT NULL,
    vaccine_name    VARCHAR(20)     NOT NULL,
    vaccine_type    VARCHAR(20)     NOT NULL,
    PRIMARY KEY (vaccine_code)
);

CREATE TABLE vaccine_storage (
    lot_no          VARCHAR(10)     NOT NULL,
    vaccine_code    CHAR(5)         NOT NULL,
    receive_date    DATE            NOT NULL,
    expire_date     DATE            NOT NULL,
    quantity        INTEGER         NOT NULL,
    FOREIGN KEY (vaccine_code) REFERENCES vaccine(vaccine_code),
    PRIMARY KEY (lot_no)
);

CREATE TABLE service_center (
    center_id       VARCHAR(10)     NOT NULL,
    location_id     INTEGER         NOT NULL,
    lot_no          VARCHAR(10)     NOT NULL,
    receive_date    DATE            NOT NULL,
    quantity        INTEGER         NOT NULL,
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (lot_no) REFERENCES vaccine_storage(lot_no),
    PRIMARY KEY (center_id)
);

CREATE TABLE vaccination_record (
    record_no       INTEGER         NOT NULL,
    personal_id     INTEGER         NOT NULL,
    vaccinate_date  DATE            NOT NULL,
    serial_no       INTEGER         NOT NULL,
    center_id       VARCHAR(10)     NOT NULL,
    FOREIGN KEY (personal_id) REFERENCES person(personal_id),
    FOREIGN KEY (center_id) REFERENCES service_center(center_id),
    PRIMARY KEY (record_no)
);

/* ***************************************************************
***************************INSERTING DATA*************************
**************************************************************** */
-- PERSON
-- EG: INSERT INTO person VALUES(10001,'Nattawat','Sakupiyanon','2001-02-28','085-1234-5678');
INSERT INTO person VALUES (1100,'Javier'  ,'Moreno'      ,'1978-12-06','089-758-1948');
INSERT INTO person VALUES (1101,'Kathy'   ,'Alexander'   ,'1984-09-04','087-597-1534');
INSERT INTO person VALUES (1102,'Tiffany' ,'Elliott'     ,'1989-03-04','089-999-9999');
INSERT INTO person VALUES (1103,'Cherry'  ,'Markham'     ,'1998-09-07','087-493-1937');
INSERT INTO person VALUES (1104,'Norma'   ,'Connor'      ,'1999-04-09','087-493-1999');
INSERT INTO person VALUES (1105,'Nattawat','Sakunpiyanon','2001-02-28','086-774-2615');

-- LOCATION
-- EG: INSERT INTO location VALUES(101,'Ministry of Public Health','11000');

-- VACCINE
-- EG: INSERT INTO vaccine VALUES('MD','Moderna','RNA');
INSERT INTO vaccine VALUES('AZ','AstraZeneca' ,'Adenovirus vector');
INSERT INTO vaccine VALUES('PZ','Pfizer'      ,'RNA');
INSERT INTO vaccine VALUES('MD','Moderna'     ,'RNA');
INSERT INTO vaccine VALUES('SP','Sinopharm'   ,'Inactivated');
INSERT INTO vaccine VALUES('CV','CoronaVac'   ,'Inactivated');

-- VACCINE STORAGE
-- EG: INSERT INTO vaccine_storage VALUES('MD-001','MD','2021-05-01','2021-12-1',10000);

-- SERVICE CENTER
-- EG: INSERT INTO service_center VALUES('101-B',101,'MD-001','2021-06-14',5000);

-- VACCINATION RECORD
-- EG: INSERT INTO vaccination_record VALUES(3001,10001,'2021-06-30',123456789,'101-B');
