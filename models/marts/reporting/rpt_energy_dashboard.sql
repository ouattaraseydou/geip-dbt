{{ config(
    materialized='view'
) }}

-- ============================================================================
-- MODEL       : rpt_energy_dashboard
-- LAYER       : REPORTING
--
-- OBJECTIF
-- --------
-- Construire une vue de synthèse des consommations énergétiques destinée
-- aux outils de Business Intelligence.
--
-- BUSINESS PURPOSE
-- ----------------
-- Cette vue permet d'analyser la consommation énergétique selon :
--
-- • le client
-- • le contrat
-- • le pays
-- • le segment client
-- • le type de contrat
-- • le fournisseur
-- • le type d'énergie
-- • l'année
-- • le trimestre
-- • le mois
-- • la semaine
-- • le jour
-- • la saison
--
-- GRANULARITE
-- -----------
-- 1 ligne =
--      1 Client
--  +   1 Contrat
--  +   1 Date
--
-- SOURCES
-- -------
-- fact_energy_consumption
-- dim_contracts
-- dim_customers
-- dim_date
-- ============================================================================

WITH energy AS (

    --------------------------------------------------------------------------
    -- Table de faits des consommations
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ ref('fact_energy_consumption') }}

),

contracts AS (

    --------------------------------------------------------------------------
    -- Dimension Contrat
    --------------------------------------------------------------------------

    SELECT

        CONTRACT_SK,
        CUSTOMER_SK,

        CONTRACT_ID,
        CONTRACT_TYPE,
        ENERGY_TYPE,
        TARIFF_NAME,
        SUPPLIER_NAME,
        CONTRACT_STATUS

    FROM {{ ref('dim_contracts') }}

),

customers AS (

    --------------------------------------------------------------------------
    -- Dimension Client
    --------------------------------------------------------------------------

    SELECT

        CUSTOMER_SK,

        CUSTOMER_ID,
        CUSTOMER_SEGMENT,
        CUSTOMER_TYPE,
        CUSTOMER_COUNTRY,
        CUSTOMER_REGION,
        LOYALTY_LEVEL

    FROM {{ ref('dim_customers') }}

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
    -- Client
    --------------------------------------------------------------------------

    cu.CUSTOMER_SK,

    cu.CUSTOMER_ID,

    cu.CUSTOMER_SEGMENT,

    cu.CUSTOMER_TYPE,

    cu.CUSTOMER_COUNTRY,

    cu.CUSTOMER_REGION,

    cu.LOYALTY_LEVEL,

    --------------------------------------------------------------------------
    -- Contrat
    --------------------------------------------------------------------------

    co.CONTRACT_SK,

    co.CONTRACT_ID,

    co.CONTRACT_TYPE,

    co.ENERGY_TYPE,

    co.TARIFF_NAME,

    co.SUPPLIER_NAME,

    co.CONTRACT_STATUS,

    --------------------------------------------------------------------------
    -- Calendrier
    --------------------------------------------------------------------------

    d.DATE_SK,

    d.FULL_DATE,

    d.YEAR,

    d.QUARTER,

    d.MONTH,

    d.MONTH_NAME,

    d.WEEK_OF_YEAR,

    d.DAY,

    d.DAY_NAME,

    d.SEASON,

    d.IS_WEEKEND,

    --------------------------------------------------------------------------
    -- KPI Consommation
    --------------------------------------------------------------------------

    COUNT(*)                                  AS NB_READINGS,

    SUM(e.ENERGY_CONSUMED_KWH)                AS TOTAL_KWH,

    AVG(e.ENERGY_CONSUMED_KWH)                AS AVG_KWH,

    MIN(e.ENERGY_CONSUMED_KWH)                AS MIN_KWH,

    MAX(e.ENERGY_CONSUMED_KWH)                AS MAX_KWH,

    SUM(e.PEAK_KWH)                           AS TOTAL_PEAK_KWH,

    SUM(e.OFF_PEAK_KWH)                       AS TOTAL_OFF_PEAK_KWH,

    SUM(e.REACTIVE_ENERGY_KVARH)              AS TOTAL_REACTIVE_KVARH,

    AVG(e.TEMPERATURE)                        AS AVG_TEMPERATURE,

    SUM(e.CO2_EMISSION_KG)                    AS TOTAL_CO2_EMISSION,

    SUM(e.OUTAGE_MINUTES)                     AS TOTAL_OUTAGE_MINUTES,

    --------------------------------------------------------------------------
    -- Qualité des données
    --------------------------------------------------------------------------

    SUM(

        CASE

            WHEN e.QUALITY_FLAG='GOOD'

            THEN 1

            ELSE 0

        END

    ) AS NB_GOOD_READINGS,

    SUM(

        CASE

            WHEN e.QUALITY_FLAG='ESTIMATED'

            THEN 1

            ELSE 0

        END

    ) AS NB_ESTIMATED_READINGS,

    SUM(

        CASE

            WHEN e.QUALITY_FLAG='MISSING'

            THEN 1

            ELSE 0

        END

    ) AS NB_MISSING_READINGS,

    --------------------------------------------------------------------------
    -- Lectures estimées
    --------------------------------------------------------------------------

    SUM(

        CASE

            WHEN e.ESTIMATED_READING

            THEN 1

            ELSE 0

        END

    ) AS NB_ESTIMATED_METERS,

    --------------------------------------------------------------------------
    -- Consommations valides
    --------------------------------------------------------------------------

    SUM(

        CASE

            WHEN e.HAS_CONSUMPTION

            THEN 1

            ELSE 0

        END

    ) AS NB_VALID_CONSUMPTION

FROM energy e

LEFT JOIN contracts co

       ON e.CONTRACT_SK = co.CONTRACT_SK

LEFT JOIN customers cu

       ON e.CUSTOMER_SK = cu.CUSTOMER_SK

LEFT JOIN dates d

       ON e.READING_DATE_SK= d.DATE_SK

GROUP BY

    cu.CUSTOMER_SK,
    cu.CUSTOMER_ID,
    cu.CUSTOMER_SEGMENT,
    cu.CUSTOMER_TYPE,
    cu.CUSTOMER_COUNTRY,
    cu.CUSTOMER_REGION,
    cu.LOYALTY_LEVEL,

    co.CONTRACT_SK,
    co.CONTRACT_ID,
    co.CONTRACT_TYPE,
    co.ENERGY_TYPE,
    co.TARIFF_NAME,
    co.SUPPLIER_NAME,
    co.CONTRACT_STATUS,

    d.DATE_SK,
    d.FULL_DATE,
    d.YEAR,
    d.QUARTER,
    d.MONTH,
    d.MONTH_NAME,
    d.WEEK_OF_YEAR,
    d.DAY,
    d.DAY_NAME,
    d.SEASON,
    d.IS_WEEKEND