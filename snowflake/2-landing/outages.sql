USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE OUTAGES (

    outage_sk                  NUMBER          NOT NULL,

    outage_id                  VARCHAR(20)     NOT NULL,

    meter_id                   VARCHAR(20),

    contract_id                VARCHAR(20),

    outage_start               TIMESTAMP_NTZ,

    outage_end                 TIMESTAMP_NTZ,

    duration_minutes           NUMBER,

    cause                      VARCHAR(100),

    severity                   VARCHAR(20),

    status                     VARCHAR(30),

    affected_customers         NUMBER,

    created_at                 TIMESTAMP_NTZ

)

COMMENT='Raw outage data loaded from outages.csv';