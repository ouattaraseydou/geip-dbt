USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE INVOICES (

    invoice_sk              NUMBER          NOT NULL,

    invoice_id              VARCHAR(20)     NOT NULL,

    contract_id             VARCHAR(20),

    meter_id                VARCHAR(20),

    invoice_date            DATE,

    billing_period_start    DATE,

    billing_period_end      DATE,

    total_kwh               NUMBER(12,2),

    energy_amount           NUMBER(12,2),

    fixed_charge            NUMBER(12,2),

    tax_amount              NUMBER(12,2),

    total_amount            NUMBER(12,2),

    invoice_status          VARCHAR(20),

    due_date                DATE,

    payment_date            DATE,

    created_at              DATE

)

COMMENT='Raw invoice data loaded from invoices.csv';