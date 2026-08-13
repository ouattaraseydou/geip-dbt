USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE CONTRACTS (

    contract_sk                     NUMBER          NOT NULL,
    contract_id                     VARCHAR(20)     NOT NULL,
    customer_id                     VARCHAR(20)     NOT NULL,

    contract_type                   VARCHAR(30),
    energy_type                     VARCHAR(30),
    tariff_name                     VARCHAR(50),

    contract_status                 VARCHAR(20),

    start_date                      DATE,
    end_date                        DATE,

    monthly_fee                     NUMBER(10,2),

    estimated_annual_consumption    NUMBER(12),

    renewable_energy                BOOLEAN,

    payment_frequency               VARCHAR(20),
    payment_method                  VARCHAR(50),

    supplier_name                   VARCHAR(100),

    country                         VARCHAR(5),

    created_at                      DATE,
    updated_at                      TIMESTAMP_NTZ

)

COMMENT='Raw contract data loaded from contracts.csv';