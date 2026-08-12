{{ config(
    materialized='table'
) }}

-- ============================================================================
-- MODEL       : dim_contracts
-- LAYER       : GOLD
--
-- OBJECTIF
-- --------
-- Construire la dimension Contrat.
--
-- GRANULARITE
-- -----------
-- 1 ligne = 1 contrat.
--
-- SOURCE
-- ------
-- int_customer_contracts
-- dim_date
-- ============================================================================

WITH source AS (

    SELECT

        CUSTOMER_SK,

        CONTRACT_SK,
        CONTRACT_ID,

        CONTRACT_TYPE,
        ENERGY_TYPE,
        TARIFF_NAME,

        SUPPLIER_NAME,

        CONTRACT_STATUS,

        CONTRACT_START_DATE,
        CONTRACT_END_DATE,

        MONTHLY_FEE,
        ESTIMATED_ANNUAL_CONSUMPTION,

        RENEWABLE_ENERGY,

        PAYMENT_FREQUENCY,
        PAYMENT_METHOD,

        CONTRACT_COUNTRY,

        CONTRACT_CREATED_AT,
        CONTRACT_UPDATED_AT

    FROM {{ ref('int_customer_contracts') }}

),

start_dates AS (

    SELECT
        DATE_SK,
        FULL_DATE
    FROM {{ ref('dim_date') }}

),

end_dates AS (

    SELECT
        DATE_SK,
        FULL_DATE
    FROM {{ ref('dim_date') }}

),

created_dates AS (

    SELECT
        DATE_SK,
        FULL_DATE
    FROM {{ ref('dim_date') }}

),

updated_dates AS (

    SELECT
        DATE_SK,
        FULL_DATE
    FROM {{ ref('dim_date') }}

),

contracts_ranked AS (

    SELECT

        s.CUSTOMER_SK,

        s.CONTRACT_SK,
        s.CONTRACT_ID,

        s.CONTRACT_TYPE,
        s.ENERGY_TYPE,
        s.TARIFF_NAME,

        s.SUPPLIER_NAME,

        s.CONTRACT_STATUS,

        ----------------------------------------------------------------------
        -- Clés de dates
        ----------------------------------------------------------------------

        start_date.DATE_SK     AS CONTRACT_START_DATE_SK,

        end_date.DATE_SK       AS CONTRACT_END_DATE_SK,

        created_date.DATE_SK   AS CONTRACT_CREATED_DATE_SK,

        updated_date.DATE_SK   AS CONTRACT_UPDATED_DATE_SK,

        ----------------------------------------------------------------------
        -- Dates métier
        ----------------------------------------------------------------------

        s.CONTRACT_START_DATE,

        s.CONTRACT_END_DATE,

        s.CONTRACT_CREATED_AT,

        s.CONTRACT_UPDATED_AT,

        ----------------------------------------------------------------------
        -- Attributs métier
        ----------------------------------------------------------------------

        s.MONTHLY_FEE,

        s.ESTIMATED_ANNUAL_CONSUMPTION,

        s.RENEWABLE_ENERGY,

        s.PAYMENT_FREQUENCY,

        s.PAYMENT_METHOD,

        s.CONTRACT_COUNTRY,

        ----------------------------------------------------------------------
        -- Déduplication
        ----------------------------------------------------------------------

        ROW_NUMBER() OVER (

            PARTITION BY s.CONTRACT_ID

            ORDER BY s.CONTRACT_UPDATED_AT DESC

        ) AS RN

    FROM source s

    LEFT JOIN start_dates start_date
        ON TO_DATE(s.CONTRACT_START_DATE) = start_date.FULL_DATE

    LEFT JOIN end_dates end_date
        ON TO_DATE(s.CONTRACT_END_DATE) = end_date.FULL_DATE

    LEFT JOIN created_dates created_date
        ON TO_DATE(s.CONTRACT_CREATED_AT) = created_date.FULL_DATE

    LEFT JOIN updated_dates updated_date
        ON TO_DATE(s.CONTRACT_UPDATED_AT) = updated_date.FULL_DATE

),

final AS (

    SELECT

        ----------------------------------------------------------------------
        -- Clés
        ----------------------------------------------------------------------

        CUSTOMER_SK,

        CONTRACT_SK,

        CONTRACT_ID,

        ----------------------------------------------------------------------
        -- Clés calendrier
        ----------------------------------------------------------------------

        CONTRACT_START_DATE_SK,

        CONTRACT_END_DATE_SK,

        CONTRACT_CREATED_DATE_SK,

        CONTRACT_UPDATED_DATE_SK,

        ----------------------------------------------------------------------
        -- Informations contrat
        ----------------------------------------------------------------------

        CONTRACT_TYPE,

        ENERGY_TYPE,

        TARIFF_NAME,

        SUPPLIER_NAME,

        CONTRACT_STATUS,

        CONTRACT_START_DATE,

        CONTRACT_END_DATE,

        MONTHLY_FEE,

        ESTIMATED_ANNUAL_CONSUMPTION,

        RENEWABLE_ENERGY,

        PAYMENT_FREQUENCY,

        PAYMENT_METHOD,

        CONTRACT_COUNTRY,

        ----------------------------------------------------------------------
        -- Audit
        ----------------------------------------------------------------------

        CONTRACT_CREATED_AT,

        CONTRACT_UPDATED_AT

    FROM contracts_ranked

    WHERE RN = 1
      AND CONTRACT_ID IS NOT NULL

)

SELECT *

FROM final