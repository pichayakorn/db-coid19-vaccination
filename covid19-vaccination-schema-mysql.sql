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
    record_no       INTEGER         NOT NULL    AUTO_INCREMENT,
    personal_id     INTEGER         NOT NULL,
    vaccinate_date  DATE            NOT NULL,
    serial_no       BIGINT          NOT NULL,
    center_id       VARCHAR(10)     NOT NULL,
    FOREIGN KEY (personal_id) REFERENCES person(personal_id),
    FOREIGN KEY (center_id) REFERENCES service_center(center_id),
    PRIMARY KEY (record_no)
);

-- Start vaccine record number from 20001
ALTER TABLE vaccination_record AUTO_INCREMENT = 20001;

-- vaccine record detail view
CREATE OR REPLACE VIEW vaccine_record_detail_view AS
SELECT
    personal_id,
    first_name,
    last_name,
    vaccine_name,
    ROW_NUMBER() OVER (PARTITION BY personal_id ORDER BY vaccinate_date) AS 'dose_no',
    vaccinate_date,
    lot_no,
    serial_no,
    location_name
FROM
    person
    JOIN vaccination_record USING(personal_id)
    JOIN service_center USING(center_id) 
    JOIN location USING(location_id)
    JOIN vaccine_storage USING(lot_no)
    JOIN vaccine USING(vaccine_code);

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
INSERT INTO location VALUES(301,'Ministry of Public Health'                      ,'11000');
INSERT INTO location VALUES(302,'Thai-Nichi Institute of Technology'             ,'10250');
INSERT INTO location VALUES(303,'Siam Paragon'                                   ,'10330');
INSERT INTO location VALUES(304,'Bang Sue Grand Station'                         ,'10900');
INSERT INTO location VALUES(305,'The University of the Thai Chamber of Commerce' ,'10400');

-- VACCINE
-- EG: INSERT INTO vaccine VALUES('MD','Moderna','RNA');
INSERT INTO vaccine VALUES('AZ','AstraZeneca'      ,'Adenovirus vector');
INSERT INTO vaccine VALUES('PZ','Pfizer'           ,'RNA');
INSERT INTO vaccine VALUES('MD','Moderna'          ,'RNA');
INSERT INTO vaccine VALUES('SP','Sinopharm'        ,'Inactivated');
INSERT INTO vaccine VALUES('CV','CoronaVac'        ,'Inactivated');
INSERT INTO vaccine VALUES('JJ','Johnson & Johnson','Adenovirus vector');

-- VACCINE STORAGE
-- EG: INSERT INTO vaccine_storage VALUES('MD-001','MD','2021-05-01','2021-12-01',10000);
INSERT INTO vaccine_storage VALUES('AZ-001','AZ','2021-03-01','2021-09-01',200000);
INSERT INTO vaccine_storage VALUES('CV-001','CV','2021-03-12','2021-09-12',200000);
INSERT INTO vaccine_storage VALUES('CV-002','CV','2021-05-01','2021-11-01',300000);
INSERT INTO vaccine_storage VALUES('MD-001','MD','2021-06-23','2021-12-23',100000);
INSERT INTO vaccine_storage VALUES('PZ-001','PZ','2021-07-14','2022-01-14', 50000);
INSERT INTO vaccine_storage VALUES('SP-001','SP','2021-05-09','2021-11-09',200000);

-- SERVICE CENTER
-- EG: INSERT INTO service_center VALUES('101-B',101,'MD-001','2021-06-14',5000);
INSERT INTO service_center VALUES('301-A',301,'AZ-001','2021-03-14',30000);
INSERT INTO service_center VALUES('301-B',301,'CV-002','2021-05-05',30000);
INSERT INTO service_center VALUES('302-A',302,'AZ-001','2021-04-01', 8000);
INSERT INTO service_center VALUES('303-A',303,'MD-001','2021-06-30', 3000);
INSERT INTO service_center VALUES('304-A',304,'AZ-001','2021-03-17',40000);
INSERT INTO service_center VALUES('304-B',304,'CV-001','2021-03-17',40000);
INSERT INTO service_center VALUES('305-A',305,'SP-001','2021-05-28', 7000);

-- VACCINATION RECORD
-- EG: INSERT INTO vaccination_record VALUES(20001,10001,'2021-06-30',123456789,'101-B');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1105,'2021-04-11',228560673472062,'304-B');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1105,'2021-05-01',294748401543822,'304-B');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1101,'2021-05-17',388060018036570,'302-A');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1103,'2021-05-26',460549216285029,'302-A');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1100,'2021-05-28',516094558049081,'301-B');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1100,'2021-06-14',612308072123963,'301-A');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1105,'2021-07-13',713256717206218,'303-A');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1102,'2021-08-01',829359400392844,'305-A');
INSERT INTO vaccination_record (personal_id,vaccinate_date,serial_no,center_id) VALUES(1102,'2021-08-22',857591375669083,'305-A');

COMMIT;