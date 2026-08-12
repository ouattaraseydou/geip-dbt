/*
==============================================================================
MODEL : int_meter_consumption

OBJECTIF :
Associer les consommations énergétiques aux caractéristiques des compteurs.
==============================================================================
*/

WITH consumption AS (

    SELECT

        CONSUMPTION_SK,
        METER_ID,
        CONTRACT_ID,
        READING_DATETIME,
        READING_YEAR,
        READING_MONTH,
        READING_DAY,
        READING_HOUR,
        SEASON,
        ENERGY_CONSUMED_KWH,
        PEAK_KWH,
        OFF_PEAK_KWH,
        REACTIVE_ENERGY_KVARH,
        TEMPERATURE,
        CO2_EMISSION_KG,
        ESTIMATED_READING,
        OUTAGE_MINUTES,
        QUALITY_FLAG,
        READING_TYPE,
        HAS_CONSUMPTION,
        CREATED_AT

    FROM {{ ref('stg_landing_energy_consumption') }}

),

meters AS (

    SELECT

        METER_SK,
        METER_ID,
        SERIAL_NUMBER,
        METER_TYPE,
        MANUFACTURER,
        INSTALLATION_DATE,
        LAST_CALIBRATION_DATE,
        METER_STATUS,
        PHASE,
        MAX_POWER_KW,
        COMMUNICATION_TYPE,
        COUNTRY,
        LATITUDE,
        LONGITUDE,
        IS_ACTIVE,
        CREATED_AT

    FROM {{ ref('stg_landing_meters') }}

)

SELECT

    ec.CONSUMPTION_SK,
    ec.CONTRACT_ID,
    ec.METER_ID,

    ec.READING_DATETIME,
    ec.READING_YEAR,
    ec.READING_MONTH,
    ec.READING_DAY,
    ec.READING_HOUR,

    ec.SEASON,

    ec.ENERGY_CONSUMED_KWH,
    ec.PEAK_KWH,
    ec.OFF_PEAK_KWH,
    ec.REACTIVE_ENERGY_KVARH,

    ec.TEMPERATURE,
    ec.CO2_EMISSION_KG,

    ec.ESTIMATED_READING,
    ec.OUTAGE_MINUTES,

    ec.QUALITY_FLAG,
    ec.READING_TYPE,
    ec.HAS_CONSUMPTION,

    m.METER_SK,
    m.SERIAL_NUMBER,
    m.METER_TYPE,
    m.MANUFACTURER,
    m.INSTALLATION_DATE,
    m.LAST_CALIBRATION_DATE,
    m.METER_STATUS,
    m.PHASE,
    m.MAX_POWER_KW,
    m.COMMUNICATION_TYPE,
    m.COUNTRY,
    m.LATITUDE,
    m.LONGITUDE,
    m.IS_ACTIVE,

    ec.CREATED_AT AS CONSUMPTION_CREATED_AT,
    m.CREATED_AT AS METER_CREATED_AT

FROM consumption ec

LEFT JOIN meters m
       ON ec.METER_ID = m.METER_ID