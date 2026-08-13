USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE CUSTOMER_SERVICE (

    ticket_sk               NUMBER          NOT NULL,

    ticket_id               VARCHAR(20)     NOT NULL,

    customer_id             VARCHAR(20),

    contract_id             VARCHAR(20),

    ticket_date             DATE,

    ticket_type             VARCHAR(50),

    priority                VARCHAR(20),

    channel                 VARCHAR(30),

    status                  VARCHAR(30),

    assigned_team           VARCHAR(100),

    resolution_time_hours   NUMBER(6,2),

    satisfaction_score      NUMBER(3,1),

    first_call_resolution   BOOLEAN,

    created_at              TIMESTAMP_NTZ

)

COMMENT='Raw customer service data loaded from customer_service.csv';