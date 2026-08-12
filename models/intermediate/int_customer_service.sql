/*
==============================================================================
MODEL : int_customer_service

DESCRIPTION :
Association des tickets du service client avec les informations des contrats.

BUSINESS PURPOSE :
Permet d'analyser les tickets selon le type de contrat, le type d'énergie,
la priorité, le statut et les performances du support client.

GRANULARITE :
1 ligne = 1 ticket de support.

LAYER :
SILVER

AUTHOR :
Ouattara Seydou
==============================================================================
*/

WITH customer_service AS (

    SELECT

        TICKET_SK,
        TICKET_ID,
        CUSTOMER_ID,
        CONTRACT_ID,
        TICKET_DATE,
        TICKET_TYPE,
        PRIORITY,
        CHANNEL,
        STATUS,
        ASSIGNED_TEAM,
        RESOLUTION_TIME_HOURS,
        SATISFACTION_SCORE,
        FIRST_CALL_RESOLUTION,
        IS_RESOLVED,
        IS_OPEN,
        IS_IN_PROGRESS,
        IS_HIGH_PRIORITY,
        RESOLVED_WITHIN_24H,
        CREATED_AT

    FROM {{ ref('stg_landing_customer_service') }}

),

contracts AS (

    SELECT

        CONTRACT_SK,
        CONTRACT_ID,
        CONTRACT_TYPE,
        ENERGY_TYPE,
        CONTRACT_STATUS,
        START_DATE,
        END_DATE,
        CREATED_AT

    FROM {{ ref('stg_landing_contracts') }}

)

SELECT

    cs.TICKET_SK,
    cs.TICKET_ID,
    cs.CUSTOMER_ID,
    cs.CONTRACT_ID,

    c.CONTRACT_SK,
    c.CONTRACT_TYPE,
    c.ENERGY_TYPE,
    c.CONTRACT_STATUS,
    c.START_DATE,
    c.END_DATE,

    cs.TICKET_DATE,
    cs.TICKET_TYPE,
    cs.PRIORITY,
    cs.CHANNEL,
    cs.STATUS,
    cs.ASSIGNED_TEAM,

    cs.RESOLUTION_TIME_HOURS,
    cs.SATISFACTION_SCORE,
    cs.FIRST_CALL_RESOLUTION,

    cs.IS_RESOLVED,
    cs.IS_OPEN,
    cs.IS_IN_PROGRESS,
    cs.IS_HIGH_PRIORITY,
    cs.RESOLVED_WITHIN_24H,

    cs.CREATED_AT AS TICKET_CREATED_AT,
    c.CREATED_AT AS CONTRACT_CREATED_AT

FROM customer_service cs

LEFT JOIN contracts c
       ON cs.CONTRACT_ID = c.CONTRACT_ID