/*
==============================================================================
MODEL : int_outages

DESCRIPTION :
Association des pannes réseau avec les informations des contrats
et des compteurs.

BUSINESS PURPOSE :
Permet d'analyser les pannes selon leur cause, leur gravité,
leur durée, le type de contrat et les caractéristiques des compteurs.

GRANULARITE :
1 ligne = 1 panne réseau.

LAYER :
SILVER

AUTHOR :
Ouattara Seydou
==============================================================================
*/

WITH outages AS (

    SELECT

        OUTAGE_SK,
        OUTAGE_ID,
        METER_ID,
        CONTRACT_ID,
        OUTAGE_START,
        OUTAGE_END,
        DURATION_MINUTES,
        DURATION_HOURS,
        CAUSE,
        SEVERITY,
        STATUS,
        AFFECTED_CUSTOMERS,
        IS_RESOLVED,
        IS_MAJOR_OUTAGE,
        IS_LARGE_OUTAGE,
        CREATED_AT

    FROM {{ ref('stg_landing_outages') }}

),

contracts AS (

    SELECT

        CONTRACT_SK,
        CONTRACT_ID,
        CONTRACT_TYPE,
        ENERGY_TYPE,
        CONTRACT_STATUS,
        COUNTRY,
        CREATED_AT

    FROM {{ ref('stg_landing_contracts') }}

),

meters AS (

    SELECT

        METER_SK,
        METER_ID,
        SERIAL_NUMBER,
        METER_TYPE,
        MANUFACTURER,
        METER_STATUS,
        MAX_POWER_KW,
        COMMUNICATION_TYPE,
        CREATED_AT

    FROM {{ ref('stg_landing_meters') }}

)

SELECT

    -- Outage
    o.OUTAGE_SK,
    o.OUTAGE_ID,
    o.METER_ID,
    o.CONTRACT_ID,

    o.OUTAGE_START,
    o.OUTAGE_END,
    o.DURATION_MINUTES,
    o.DURATION_HOURS,
    o.CAUSE,
    o.SEVERITY,
    o.STATUS,
    o.AFFECTED_CUSTOMERS,
    o.IS_RESOLVED,
    o.IS_MAJOR_OUTAGE,
    o.IS_LARGE_OUTAGE,

    -- Contract
    c.CONTRACT_SK,
    c.CONTRACT_TYPE,
    c.ENERGY_TYPE,
    c.CONTRACT_STATUS,
    c.COUNTRY,

    -- Meter
    m.METER_SK,
    m.SERIAL_NUMBER,
    m.METER_TYPE,
    m.MANUFACTURER,
    m.METER_STATUS,
    m.MAX_POWER_KW,
    m.COMMUNICATION_TYPE,

    -- Audit
    o.CREATED_AT AS OUTAGE_CREATED_AT,
    c.CREATED_AT AS CONTRACT_CREATED_AT,
    m.CREATED_AT AS METER_CREATED_AT

FROM outages o

LEFT JOIN contracts c
       ON o.CONTRACT_ID = c.CONTRACT_ID

LEFT JOIN meters m
       ON o.METER_ID = m.METER_ID