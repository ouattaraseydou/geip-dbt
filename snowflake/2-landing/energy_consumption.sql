CREATE OR REPLACE TABLE LANDING.ENERGY_CONSUMPTION (

    consumption_sk NUMBER NOT NULL,

    meter_id VARCHAR(20),
    contract_id VARCHAR(20),

    reading_datetime TIMESTAMP_NTZ,

    reading_year NUMBER,
    reading_month NUMBER,
    reading_day NUMBER,
    reading_hour NUMBER,

    season VARCHAR(20),

    energy_consumed_kwh NUMBER(12,3),
    peak_kwh NUMBER(12,3),
    off_peak_kwh NUMBER(12,3),
    reactive_energy_kvarh NUMBER(12,3),

    voltage NUMBER(6,1),
    electric_current NUMBER(8,2),

    power_factor NUMBER(4,2),
    temperature NUMBER(5,1),

    co2_emission_kg NUMBER(10,3),

    estimated_reading BOOLEAN,

    outage_minutes NUMBER,

    quality_flag VARCHAR(20),

    created_at TIMESTAMP_NTZ

)
COMMENT='Raw smart meter readings loaded from energy_consumption.csv';