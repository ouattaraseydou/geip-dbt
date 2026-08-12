{{ config(
    materialized='view'
) }}

-- ============================================================================
-- MODEL       : rpt_outage_dashboard
-- LAYER       : REPORTING
--
-- OBJECTIF
-- --------
-- Construire une vue de synthèse des coupures d'électricité destinée aux
-- outils de reporting (Power BI, Tableau, Superset).
--
-- BUSINESS PURPOSE
-- ----------------
-- Cette vue permet d'analyser :
--   • les coupures réseau
--   • leur durée
--   • leur gravité
--   • leur cause
--   • les compteurs concernés
--   • les contrats impactés
--   • le nombre de clients affectés
--
-- GRANULARITE
-- -----------
-- 1 ligne = 1 coupure.
--
-- SOURCES
-- -------
-- fact_outages
-- dim_date
-- ============================================================================

WITH outages AS (

    --------------------------------------------------------------------------
    -- Table de faits des coupures
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ ref('fact_outages') }}

),

dates AS (

    --------------------------------------------------------------------------
    -- Dimension Calendrier
    --------------------------------------------------------------------------

    SELECT

        DATE_SK,
        FULL_DATE,
        YEAR,
        QUARTER,
        MONTH,
        MONTH_NAME,
        WEEK_OF_YEAR,
        DAY,
        DAY_NAME,
        SEASON,
        IS_WEEKEND

    FROM {{ ref('dim_date') }}

)

SELECT

    --------------------------------------------------------------------------
    -- Clés
    --------------------------------------------------------------------------

    o.OUTAGE_SK,

    o.OUTAGE_ID,

    o.CONTRACT_SK,

    o.CONTRACT_ID,

    o.METER_SK,

    o.METER_ID,

    o.OUTAGE_START_DATE_SK,

    --------------------------------------------------------------------------
    -- Calendrier
    --------------------------------------------------------------------------

    d.FULL_DATE                      AS OUTAGE_DATE,

    d.YEAR                           AS OUTAGE_YEAR,

    d.QUARTER                        AS OUTAGE_QUARTER,

    d.MONTH                          AS OUTAGE_MONTH,

    d.MONTH_NAME                     AS OUTAGE_MONTH_NAME,

    d.WEEK_OF_YEAR,

    d.DAY                            AS OUTAGE_DAY,

    d.DAY_NAME                       AS OUTAGE_DAY_NAME,

    d.SEASON,

    d.IS_WEEKEND,

    --------------------------------------------------------------------------
    -- Horodatage
    --------------------------------------------------------------------------

    o.OUTAGE_START,

    o.OUTAGE_END,

    --------------------------------------------------------------------------
    -- Informations Coupure
    --------------------------------------------------------------------------

    o.CAUSE,

    o.SEVERITY,

    o.STATUS,

    --------------------------------------------------------------------------
    -- Informations Contrat
    --------------------------------------------------------------------------

    o.CONTRACT_TYPE,

    o.ENERGY_TYPE,

    o.CONTRACT_STATUS,

    o.COUNTRY,

    --------------------------------------------------------------------------
    -- Informations Compteur
    --------------------------------------------------------------------------

    o.SERIAL_NUMBER,

    o.METER_TYPE,

    o.MANUFACTURER,

    o.METER_STATUS,

    o.MAX_POWER_KW,

    o.COMMUNICATION_TYPE,

    --------------------------------------------------------------------------
    -- Mesures
    --------------------------------------------------------------------------

    o.DURATION_MINUTES,

    o.DURATION_HOURS,

    o.AFFECTED_CUSTOMERS,

    --------------------------------------------------------------------------
    -- Indicateurs existants
    --------------------------------------------------------------------------

    o.IS_RESOLVED,

    o.IS_MAJOR_OUTAGE,

    o.IS_LARGE_OUTAGE,

    o.IS_RESOLVED_STATUS,

    o.IS_CRITICAL,

    o.DURATION_CATEGORY,

    o.IMPACT_CATEGORY,

    o.MANUFACTURER_CATEGORY,

    o.POWER_CATEGORY,

    --------------------------------------------------------------------------
    -- Ancienneté
    --------------------------------------------------------------------------

    o.CONTRACT_AGE_DAYS,

    o.METER_AGE_DAYS,

    --------------------------------------------------------------------------
    -- Audit
    --------------------------------------------------------------------------

    o.OUTAGE_CREATED_AT,

    o.CONTRACT_CREATED_AT,

    o.METER_CREATED_AT

FROM outages o

LEFT JOIN dates d

       ON o.OUTAGE_START_DATE_SK = d.DATE_SK