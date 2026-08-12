/*
==============================================================================
MODEL : int_maintenance

DESCRIPTION :
Association des interventions de maintenance avec les informations
des contrats et des compteurs.

BUSINESS PURPOSE :
Permet d'analyser les opérations de maintenance selon le type de contrat,
le type de compteur, les coûts, la durée et les techniciens.

GRANULARITE :
1 ligne = 1 intervention de maintenance.

LAYER :
SILVER

AUTHOR :
Ouattara Seydou
==============================================================================
*/

WITH maintenance AS (

    SELECT

        MAINTENANCE_SK,
        MAINTENANCE_ID,
        METER_ID,
        CONTRACT_ID,
        MAINTENANCE_DATE,
        MAINTENANCE_TYPE,
        TECHNICIAN,
        PRIORITY,
        STATUS,
        DURATION_HOURS,
        MAINTENANCE_COST,
        RESULT,
        IS_COMPLETED,
        IS_HIGH_PRIORITY,
        IS_LONG_MAINTENANCE,
        IS_HIGH_COST,
        CREATED_AT

    FROM {{ ref('stg_landing_maintenance') }}

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

    -- Maintenance
    mt.MAINTENANCE_SK,
    mt.MAINTENANCE_ID,
    mt.METER_ID,
    mt.CONTRACT_ID,

    mt.MAINTENANCE_DATE,
    mt.MAINTENANCE_TYPE,
    mt.TECHNICIAN,
    mt.PRIORITY,
    mt.STATUS,

    mt.DURATION_HOURS,
    mt.MAINTENANCE_COST,
    mt.RESULT,

    mt.IS_COMPLETED,
    mt.IS_HIGH_PRIORITY,
    mt.IS_LONG_MAINTENANCE,
    mt.IS_HIGH_COST,

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
    mt.CREATED_AT AS MAINTENANCE_CREATED_AT,
    c.CREATED_AT AS CONTRACT_CREATED_AT,
    m.CREATED_AT AS METER_CREATED_AT

FROM maintenance mt

LEFT JOIN contracts c
       ON mt.CONTRACT_ID = c.CONTRACT_ID

LEFT JOIN meters m
       ON mt.METER_ID = m.METER_ID