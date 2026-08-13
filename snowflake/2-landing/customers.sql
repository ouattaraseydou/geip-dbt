USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;

CREATE OR REPLACE TABLE CUSTOMERS (

    customer_sk                 NUMBER              NOT NULL,
    customer_id                 VARCHAR(20)         NOT NULL,
    customer_code               VARCHAR(50),

    civility                    VARCHAR(20),
    first_name                  VARCHAR(100),
    middle_name                 VARCHAR(100),
    last_name                   VARCHAR(100),

    gender                      VARCHAR(20),
    birth_date                  DATE,

    nationality                 VARCHAR(100),
    marital_status              VARCHAR(30),

    email                       VARCHAR(255),
    secondary_email             VARCHAR(255),

    mobile_phone                VARCHAR(50),
    home_phone                  VARCHAR(50),
    work_phone                  VARCHAR(50),

    preferred_contact_method    VARCHAR(30),
    preferred_language          VARCHAR(30),

    website                     VARCHAR(255),
    linkedin_profile            VARCHAR(255),

    communication_opt_in        BOOLEAN,

    address_line1               VARCHAR(255),
    address_line2               VARCHAR(255),

    postal_code                 VARCHAR(20),
    city                        VARCHAR(100),
    region                      VARCHAR(100),
    country                     VARCHAR(100),
    country_code                VARCHAR(5),

    latitude                    NUMBER(9,6),
    longitude                   NUMBER(9,6),

    timezone                    VARCHAR(100),

    customer_type               VARCHAR(30),
    customer_segment            VARCHAR(30),
    loyalty_level               VARCHAR(30),

    annual_income               NUMBER(12,2),

    occupation                  VARCHAR(255),
    employer                    VARCHAR(255),

    registration_date           DATE,

    status                      VARCHAR(20),

    risk_score                  NUMBER(5,2),

    acquisition_channel         VARCHAR(50),
    campaign_name               VARCHAR(100),
    referral_source             VARCHAR(100),

    marketing_score             NUMBER(5,2),

    customer_lifetime_value     NUMBER(14,2),

    consent_email               BOOLEAN,
    consent_sms                 BOOLEAN,
    consent_phone               BOOLEAN,

    consent_date                DATE,

    privacy_version             VARCHAR(20),

    effective_start_date        DATE,
    effective_end_date          DATE,

    is_current                  BOOLEAN,

    version_number              NUMBER,

    source_system               VARCHAR(50),
    source_file                 VARCHAR(255),
    batch_id                    NUMBER,

    created_at                  TIMESTAMP_NTZ,
    created_by                  VARCHAR(50),

    updated_at                  TIMESTAMP_NTZ,
    updated_by                  VARCHAR(50),

    load_date                   TIMESTAMP_NTZ

)

COMMENT='Raw customer data loaded from customers.csv';