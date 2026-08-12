{{ config(
    materialized='view'
) }}

-- ============================================================================
-- MODEL       : rpt_finance_dashboard
-- LAYER       : REPORTING
--
-- OBJECTIF
-- --------
-- Construire une vue de synthèse financière permettant de suivre
-- la facturation, les paiements et les impayés des clients.
--
-- BUSINESS PURPOSE
-- ----------------
-- Cette vue est destinée aux tableaux de bord Power BI, Tableau,
-- Apache Superset et Snowflake.
--
-- GRANULARITE
-- -----------
-- 1 ligne = 1 client.
--
-- SOURCES
-- -------
-- dim_customers
-- fact_invoices
-- fact_payments
-- dim_date
-- ============================================================================

WITH customers AS (

    --------------------------------------------------------------------------
    -- Dimension Client
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ ref('dim_customers') }}

),

invoice_dates AS (

    --------------------------------------------------------------------------
    -- Dimension calendrier utilisée pour les factures
    --------------------------------------------------------------------------

    SELECT

        DATE_SK,
        FULL_DATE,
        YEAR,
        QUARTER,
        MONTH,
        MONTH_NAME,
        WEEK_OF_YEAR,
        DAY_NAME,
        SEASON,
        IS_WEEKEND

    FROM {{ ref('dim_date') }}

),

payment_dates AS (

    --------------------------------------------------------------------------
    -- Dimension calendrier utilisée pour les paiements
    --------------------------------------------------------------------------

    SELECT

        DATE_SK,
        FULL_DATE,
        YEAR,
        QUARTER,
        MONTH,
        MONTH_NAME,
        WEEK_OF_YEAR,
        DAY_NAME,
        SEASON,
        IS_WEEKEND

    FROM {{ ref('dim_date') }}

),

invoices AS (

    --------------------------------------------------------------------------
    -- Agrégation des factures par client
    --------------------------------------------------------------------------

    SELECT

        i.CUSTOMER_SK,

        MAX(i.INVOICE_DATE_SK)                      AS LAST_INVOICE_DATE_SK,

        COUNT(i.INVOICE_SK)                 AS NB_INVOICES,

        SUM(i.TOTAL_AMOUNT)                 AS TOTAL_BILLED,

        AVG(i.TOTAL_AMOUNT)                 AS AVG_INVOICE_AMOUNT,

        MAX(i.TOTAL_AMOUNT)                 AS MAX_INVOICE_AMOUNT,

        MIN(i.TOTAL_AMOUNT)                 AS MIN_INVOICE_AMOUNT,

        AVG(i.PAYMENT_DELAY_DAYS)           AS AVG_PAYMENT_DELAY_DAYS,

        MAX(i.INVOICE_DATE)                 AS LAST_INVOICE_DATE,

        MAX(

            CASE

                WHEN i.IS_PAID = FALSE

                THEN 1

                ELSE 0

            END

        ) AS HAS_UNPAID_INVOICE

    FROM {{ ref('fact_invoices') }} i

    GROUP BY i.CUSTOMER_SK

),

payments AS (

    --------------------------------------------------------------------------
    -- Agrégation des paiements
    --------------------------------------------------------------------------

   SELECT

    p.CUSTOMER_SK,

    MAX(p.PAYMENT_DATE_SK) AS LAST_PAYMENT_DATE_SK,

    COUNT(p.PAYMENT_SK) AS NB_PAYMENTS,

    SUM(p.AMOUNT_PAID) AS TOTAL_PAID,

    AVG(p.AMOUNT_PAID) AS AVG_PAYMENT_AMOUNT,

    MAX(p.PAYMENT_DATE) AS LAST_PAYMENT_DATE

FROM {{ ref('fact_payments') }} p

GROUP BY p.CUSTOMER_SK

)

SELECT

    --------------------------------------------------------------------------
    -- Informations Client
    --------------------------------------------------------------------------

    c.CUSTOMER_SK,

    c.CUSTOMER_ID,

    c.FIRST_NAME,

    c.LAST_NAME,

    c.CUSTOMER_SEGMENT,

    c.CUSTOMER_COUNTRY,

    c.CUSTOMER_STATUS,

    --------------------------------------------------------------------------
    -- Calendrier de la dernière facture
    --------------------------------------------------------------------------

    i.LAST_INVOICE_DATE_SK,

    di.YEAR              AS INVOICE_YEAR,

    di.QUARTER           AS INVOICE_QUARTER,

    di.MONTH             AS INVOICE_MONTH,

    di.MONTH_NAME        AS INVOICE_MONTH_NAME,

    di.WEEK_OF_YEAR      AS INVOICE_WEEK,
    --------------------------------------------------------------------------
    -- KPI Paiements
    --------------------------------------------------------------------------

    COALESCE(p.NB_PAYMENTS,0)         AS NB_PAYMENTS,

    COALESCE(p.TOTAL_PAID,0)       AS TOTAL_PAID,

    ROUND(
        COALESCE(p.AVG_PAYMENT_AMOUNT,0),
        2
    ) AS AVG_PAYMENT_AMOUNT,

    p.LAST_PAYMENT_DATE,

    --------------------------------------------------------------------------
    -- Solde restant
    --------------------------------------------------------------------------

    ROUND(

        COALESCE(i.TOTAL_BILLED,0)
        -
        COALESCE(p.TOTAL_PAID,0)

    ,2) AS OUTSTANDING_BALANCE,

    --------------------------------------------------------------------------
    -- Taux de paiement
    --------------------------------------------------------------------------

    CASE

        WHEN COALESCE(i.TOTAL_BILLED,0) = 0

            THEN 0

        ELSE ROUND(

            (
                COALESCE(p.TOTAL_PAID,0)
                /
                COALESCE(i.TOTAL_BILLED,1)
            ) * 100

        ,2)

    END AS PAYMENT_RATE_PERCENT,

    --------------------------------------------------------------------------
    -- Retard moyen de paiement
    --------------------------------------------------------------------------

    ROUND(

        COALESCE(i.AVG_PAYMENT_DELAY_DAYS,0)

    ,2) AS AVG_PAYMENT_DELAY_DAYS,

    --------------------------------------------------------------------------
    -- Présence d'au moins une facture impayée
    --------------------------------------------------------------------------

    COALESCE(i.HAS_UNPAID_INVOICE,0)
        AS HAS_UNPAID_INVOICE,

    --------------------------------------------------------------------------
    -- Catégorie de paiement
    --------------------------------------------------------------------------

    CASE

        WHEN COALESCE(i.TOTAL_BILLED,0)=0

            THEN 'NO INVOICE'

        WHEN
            (
                COALESCE(p.TOTAL_PAID,0)
                /
                COALESCE(i.TOTAL_BILLED,1)
            ) >= 0.95

            THEN 'EXCELLENT'

        WHEN
            (
                COALESCE(p.TOTAL_PAID,0)
                /
                COALESCE(i.TOTAL_BILLED,1)
            ) >= 0.80

            THEN 'GOOD'

        WHEN
            (
                COALESCE(p.TOTAL_PAID,0)
                /
                COALESCE(i.TOTAL_BILLED,1)
            ) >= 0.50

            THEN 'AVERAGE'

        ELSE 'POOR'

    END AS PAYMENT_CATEGORY,

    --------------------------------------------------------------------------
    -- Catégorie de dette
    --------------------------------------------------------------------------

    CASE

        WHEN
            COALESCE(i.TOTAL_BILLED,0)
            -
            COALESCE(p.TOTAL_PAID,0) = 0

            THEN 'NO DEBT'

        WHEN
            COALESCE(i.TOTAL_BILLED,0)
            -
            COALESCE(p.TOTAL_PAID,0) < 500

            THEN 'LOW DEBT'

        WHEN
            COALESCE(i.TOTAL_BILLED,0)
            -
            COALESCE(p.TOTAL_PAID,0) < 2000

            THEN 'MEDIUM DEBT'

        ELSE 'HIGH DEBT'

    END AS DEBT_CATEGORY,

    --------------------------------------------------------------------------
    -- Indicateur Bon Payeur
    --------------------------------------------------------------------------

    CASE

        WHEN
            COALESCE(p.TOTAL_PAID,0)
            >=
            COALESCE(i.TOTAL_BILLED,0)

            THEN TRUE

        ELSE FALSE

    END AS IS_GOOD_PAYER,

    --------------------------------------------------------------------------
    -- Indicateur Mauvais Payeur
    --------------------------------------------------------------------------

    CASE

        WHEN
            COALESCE(i.TOTAL_BILLED,0)
            -
            COALESCE(p.TOTAL_PAID,0)
            > 1000

            THEN TRUE

        ELSE FALSE

    END AS IS_BAD_PAYER

FROM customers c

LEFT JOIN invoices i

       ON c.CUSTOMER_SK = i.CUSTOMER_SK

LEFT JOIN payments p

       ON c.CUSTOMER_SK = p.CUSTOMER_SK

LEFT JOIN invoice_dates di

       ON i.LAST_INVOICE_DATE_SK = di.DATE_SK

LEFT JOIN payment_dates dp

       ON p.LAST_PAYMENT_DATE_SK = dp.DATE_SK