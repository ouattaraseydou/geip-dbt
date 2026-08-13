USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE MAINTENANCE (

    maintenance_sk          NUMBER          NOT NULL,

    maintenance_id          VARCHAR(20)     NOT NULL,

    meter_id               VARCHAR(20),

    contract_id            VARCHAR(20),

    maintenance_date       DATE,

    maintenance_type       VARCHAR(50),

    technician             VARCHAR(100),

    priority               VARCHAR(20),

    status                 VARCHAR(30),

    duration_hours         NUMBER(6,2),

    maintenance_cost       NUMBER(12,2),

    result                 VARCHAR(100),

    created_at             DATE

)

COMMENT='Raw maintenance data loaded from maintenance.csv';