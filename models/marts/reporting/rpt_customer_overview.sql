{{ config(
    materialized='view'
) }}

-- ============================================================================
-- MODEL       : rpt_customer_overview
-- LAYER       : REPORTING
--
-- OBJECTIF
-- --------
-- Construire une vue de synthèse des clients destinée aux outils BI
-- (Power BI, Tableau, Apache Superset...).
--
-- BUSINESS PURPOSE
-- ----------------
-- Cette vue fournit les principaux indicateurs métier par client :
--
-- • Nombre de contrats
-- • Nombre de compteurs
-- • Consommation totale
-- • Energie de pointe
-- • Energie heures creuses
-- • Energie réactive
-- • Emissions CO2
-- • Temps total de coupure
-- • Nombre de factures
-- • Montant facturé
-- • Nombre de paiements
-- • Montant payé
-- • Solde restant
-- • Taux de paiement
--
-- GRANULARITE
-- -----------
-- 1 ligne = 1 client
--
-- SOURCES
-- -------
-- dim_customers
-- dim_contracts
-- dim_meters
-- fact_energy_consumption
-- fact_invoices
-- fact_payments
-- ============================================================================

WITH customers AS (

    --------------------------------------------------------------------------
    -- Dimension Client
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ ref('dim_customers') }}

),

contracts_count AS (

    --------------------------------------------------------------------------
    -- Nombre de contrats
    --------------------------------------------------------------------------

    SELECT

        CUSTOMER_SK,

        COUNT(DISTINCT CONTRACT_SK) AS NB_CONTRACTS

    FROM {{ ref('dim_contracts') }}

    GROUP BY CUSTOMER_SK

),

meters_count AS (

    --------------------------------------------------------------------------
    -- Nombre de compteurs
    --------------------------------------------------------------------------

    SELECT

        dc.CUSTOMER_SK,

        COUNT(DISTINCT dm.METER_SK) AS NB_METERS

    FROM {{ ref('dim_meters') }} dm

    INNER JOIN {{ ref('dim_contracts') }} dc
        ON dm.CONTRACT_SK = dc.CONTRACT_SK

    GROUP BY dc.CUSTOMER_SK

),

energy AS (

    --------------------------------------------------------------------------
    -- Consommation énergétique
    --------------------------------------------------------------------------

    SELECT

        CUSTOMER_SK,

        SUM(ENERGY_CONSUMED_KWH)          AS TOTAL_KWH,

        SUM(PEAK_KWH)                     AS TOTAL_PEAK_KWH,

        SUM(OFF_PEAK_KWH)                 AS TOTAL_OFF_PEAK_KWH,

        SUM(REACTIVE_ENERGY_KVARH)        AS TOTAL_REACTIVE_KVARH,

        SUM(CO2_EMISSION_KG)              AS TOTAL_CO2_EMISSION,

        SUM(OUTAGE_MINUTES)               AS TOTAL_OUTAGE_MINUTES

    FROM {{ ref('fact_energy_consumption') }}

    GROUP BY CUSTOMER_SK

),

invoices AS (

    --------------------------------------------------------------------------
    -- Facturation
    --------------------------------------------------------------------------

    SELECT

        CUSTOMER_SK,

        COUNT(INVOICE_SK)      AS NB_INVOICES,

        SUM(TOTAL_AMOUNT)      AS TOTAL_BILLED,

        MAX(INVOICE_DATE)      AS LAST_INVOICE_DATE

    FROM {{ ref('fact_invoices') }}

    GROUP BY CUSTOMER_SK

),

payments AS (

    --------------------------------------------------------------------------
    -- Paiements
    --------------------------------------------------------------------------

    SELECT

        CUSTOMER_SK,

        COUNT(PAYMENT_SK)      AS NB_PAYMENTS,

        SUM(AMOUNT_PAID)       AS TOTAL_PAID,

        MAX(PAYMENT_DATE)      AS LAST_PAYMENT_DATE

    FROM {{ ref('fact_payments') }}

    GROUP BY CUSTOMER_SK

)

SELECT

    --------------------------------------------------------------------------
    -- Informations Client
    --------------------------------------------------------------------------

    c.CUSTOMER_SK,

    c.CUSTOMER_ID,

    c.CUSTOMER_CODE,

    c.CIVILITY,

    c.FIRST_NAME,

    c.MIDDLE_NAME,

    c.LAST_NAME,

    c.GENDER,

    c.BIRTH_DATE,

    c.NATIONALITY,

    c.MARITAL_STATUS,

    c.CUSTOMER_EMAIL,

    c.CUSTOMER_MOBILE_PHONE,

    c.CUSTOMER_CITY,

    c.CUSTOMER_REGION,

    c.CUSTOMER_COUNTRY,

    c.CUSTOMER_TYPE,

    c.CUSTOMER_SEGMENT,

    c.LOYALTY_LEVEL,

    c.ANNUAL_INCOME,

    c.OCCUPATION,

    c.CUSTOMER_REGISTRATION_DATE,

    c.CUSTOMER_STATUS,

    c.RISK_SCORE,

    c.ACQUISITION_CHANNEL,

    c.CUSTOMER_LIFETIME_VALUE,

    c.CUSTOMER_CREATED_AT,

    --------------------------------------------------------------------------
    -- KPI Contrats
    --------------------------------------------------------------------------

    COALESCE(cc.NB_CONTRACTS,0)           AS NB_CONTRACTS,

    --------------------------------------------------------------------------
    -- KPI Compteurs
    --------------------------------------------------------------------------

    COALESCE(mc.NB_METERS,0)              AS NB_METERS,

    --------------------------------------------------------------------------
    -- KPI Consommation
    --------------------------------------------------------------------------

    COALESCE(e.TOTAL_KWH,0)               AS TOTAL_KWH,

    COALESCE(e.TOTAL_PEAK_KWH,0)          AS TOTAL_PEAK_KWH,

    COALESCE(e.TOTAL_OFF_PEAK_KWH,0)      AS TOTAL_OFF_PEAK_KWH,

    COALESCE(e.TOTAL_REACTIVE_KVARH,0)    AS TOTAL_REACTIVE_KVARH,

    COALESCE(e.TOTAL_CO2_EMISSION,0)      AS TOTAL_CO2_EMISSION,

    COALESCE(e.TOTAL_OUTAGE_MINUTES,0)    AS TOTAL_OUTAGE_MINUTES,

    --------------------------------------------------------------------------
    -- KPI Facturation
    --------------------------------------------------------------------------

    COALESCE(i.NB_INVOICES,0)             AS NB_INVOICES,

    COALESCE(i.TOTAL_BILLED,0)            AS TOTAL_BILLED,

    i.LAST_INVOICE_DATE,

    --------------------------------------------------------------------------
    -- KPI Paiements
    --------------------------------------------------------------------------

    COALESCE(p.NB_PAYMENTS,0)             AS NB_PAYMENTS,

    COALESCE(p.TOTAL_PAID,0)              AS TOTAL_PAID,

    p.LAST_PAYMENT_DATE,

    --------------------------------------------------------------------------
    -- Solde restant
    --------------------------------------------------------------------------

    COALESCE(i.TOTAL_BILLED,0)
    -
    COALESCE(p.TOTAL_PAID,0)

    AS OUTSTANDING_BALANCE,

    --------------------------------------------------------------------------
    -- Taux de paiement
    --------------------------------------------------------------------------

    CASE

        WHEN COALESCE(i.TOTAL_BILLED,0)=0

        THEN 0

        ELSE ROUND(

            COALESCE(p.TOTAL_PAID,0)
            /
            i.TOTAL_BILLED
            *100,

            2

        )

    END AS PAYMENT_RATE_PERCENT

FROM customers c

LEFT JOIN contracts_count cc

ON c.CUSTOMER_SK = cc.CUSTOMER_SK

LEFT JOIN meters_count mc

ON c.CUSTOMER_SK = mc.CUSTOMER_SK

LEFT JOIN energy e

ON c.CUSTOMER_SK = e.CUSTOMER_SK

LEFT JOIN invoices i

ON c.CUSTOMER_SK = i.CUSTOMER_SK

LEFT JOIN payments p

ON c.CUSTOMER_SK = p.CUSTOMER_SK