USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE PAYMENTS (

    payment_sk                  NUMBER          NOT NULL,

    payment_id                  VARCHAR(20)     NOT NULL,

    invoice_id                  VARCHAR(20),

    contract_id                 VARCHAR(20),

    payment_date                DATE,

    amount_paid                 NUMBER(12,2),

    payment_method              VARCHAR(50),

    payment_status              VARCHAR(20),

    transaction_reference       VARCHAR(100),

    bank_name                   VARCHAR(100),

    currency                    VARCHAR(10),

    created_at                  DATE

)

COMMENT='Raw payment data loaded from payments.csv';