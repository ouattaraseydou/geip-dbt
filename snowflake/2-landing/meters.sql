USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE METERS (

    meter_sk                NUMBER          NOT NULL,
    meter_id                VARCHAR(20)     NOT NULL,
    contract_id             VARCHAR(20)     NOT NULL,

    serial_number           VARCHAR(50),

    meter_type              VARCHAR(30),
    manufacturer            VARCHAR(100),

    installation_date       DATE,
    last_calibration_date   DATE,

    meter_status            VARCHAR(20),

    voltage                 VARCHAR(10),
    phase                   VARCHAR(20),

    max_power_kw            NUMBER(6),

    communication_type      VARCHAR(20),

    country                 VARCHAR(5),

    latitude                NUMBER(9,6),
    longitude               NUMBER(9,6),

    created_at              DATE,
    updated_at              TIMESTAMP_NTZ

)

COMMENT='Raw meter data loaded from meters.csv';