{{ config(
    materialized='incremental',
    unique_key='PAYMENT_SK',
    incremental_strategy='merge'
) }}

-- ============================================================================
-- MODEL       : fact_payments
-- LAYER       : GOLD
--
-- OBJECTIF
-- --------
-- Construire la table de faits des paiements.
--
-- GRANULARITE
-- -----------
-- 1 ligne = 1 paiement.
--
-- SOURCES
-- -------
-- stg_landing_payments
-- dim_contracts
-- fact_invoices
-- dim_date
--
-- DESCRIPTION
-- -----------
-- Cette table centralise tous les paiements effectués par les clients.
-- Elle est reliée aux dimensions Contrat, Facture et Calendrier afin de
-- faciliter les analyses financières dans Power BI, Tableau et Superset.
-- ============================================================================

WITH payments AS (

    --------------------------------------------------------------------------
    -- Source des paiements
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ ref('stg_landing_payments') }}

),

contracts AS (

    --------------------------------------------------------------------------
    -- Dimension Contrat
    --------------------------------------------------------------------------

    SELECT

        CUSTOMER_SK,
        CONTRACT_SK,
        CONTRACT_ID

    FROM {{ ref('dim_contracts') }}

),

invoices AS (

    --------------------------------------------------------------------------
    -- Factures
    --------------------------------------------------------------------------

    SELECT

        INVOICE_SK,
        INVOICE_ID,
        TOTAL_AMOUNT

    FROM {{ ref('fact_invoices') }}

),

payment_dates AS (

    --------------------------------------------------------------------------
    -- Calendrier des dates de paiement
    --------------------------------------------------------------------------

    SELECT

        DATE_SK,
        FULL_DATE

    FROM {{ ref('dim_date') }}

),

created_dates AS (

    --------------------------------------------------------------------------
    -- Calendrier des dates de création
    --------------------------------------------------------------------------

    SELECT

        DATE_SK,
        FULL_DATE

    FROM {{ ref('dim_date') }}

)

SELECT

    --------------------------------------------------------------------------
    -- Clés techniques
    --------------------------------------------------------------------------

    p.PAYMENT_SK,

    p.PAYMENT_ID,

    i.INVOICE_SK,

    p.INVOICE_ID,

    c.CUSTOMER_SK,

    c.CONTRACT_SK,

    c.CONTRACT_ID,

    payment_date.DATE_SK      AS PAYMENT_DATE_SK,

    created_date.DATE_SK      AS CREATED_DATE_SK,

    --------------------------------------------------------------------------
    -- Dates métier
    --------------------------------------------------------------------------

    p.PAYMENT_DATE,

    p.CREATED_AT              AS PAYMENT_CREATED_AT,

    --------------------------------------------------------------------------
    -- Mesures financières
    --------------------------------------------------------------------------

    p.AMOUNT_PAID,

    i.TOTAL_AMOUNT,

    --------------------------------------------------------------------------
    -- Informations de paiement
    --------------------------------------------------------------------------

    p.PAYMENT_METHOD,

    p.PAYMENT_STATUS,

    p.TRANSACTION_REFERENCE,

    p.BANK_NAME,

    p.CURRENCY,

    --------------------------------------------------------------------------
    -- Indicateurs métier
    --------------------------------------------------------------------------

    p.IS_SUCCESSFUL_PAYMENT,

    p.IS_PENDING_PAYMENT,

    p.IS_FAILED_PAYMENT

FROM payments p

LEFT JOIN contracts c

       ON p.CONTRACT_ID = c.CONTRACT_ID

LEFT JOIN invoices i

       ON p.INVOICE_ID = i.INVOICE_ID

LEFT JOIN payment_dates payment_date

       ON TO_DATE(p.PAYMENT_DATE) = payment_date.FULL_DATE

LEFT JOIN created_dates created_date

       ON TO_DATE(p.CREATED_AT) = created_date.FULL_DATE

{% if is_incremental() %}

WHERE p.CREATED_AT >

(

    SELECT COALESCE(

        MAX(PAYMENT_CREATED_AT),

        '1900-01-01'

    )

    FROM {{ this }}

)

{% endif %}