{{ config(
    materialized='incremental',
    unique_key='payment_sk',
    incremental_strategy='merge'
) }}

/*
==============================================================================
MODEL : fact_payments

DESCRIPTION :
Table de faits des paiements.

BUSINESS PURPOSE :
Centraliser les paiements afin d'analyser les encaissements,
les moyens de paiement, les statuts des transactions
et les performances financières.

LAYER :
GOLD

GRANULARITY :
1 ligne = 1 paiement

SOURCE :
- stg_landing_payments
- dim_contracts
- fact_invoices
- dim_date

AUTHOR :
Ouattara Seydou
==============================================================================
*/

with payments as (

    ----------------------------------------------------------------------------
    -- Paiements
    ----------------------------------------------------------------------------

    select *

    from {{ ref('stg_landing_payments') }}

),

contracts as (

    ----------------------------------------------------------------------------
    -- Dimension Contrat
    ----------------------------------------------------------------------------

    select

        customer_sk,
        contract_sk,
        contract_id

    from {{ ref('dim_contracts') }}

),

invoices as (

    ----------------------------------------------------------------------------
    -- Factures
    ----------------------------------------------------------------------------

    select

        invoice_sk,
        invoice_id,
        total_amount

    from {{ ref('fact_invoices') }}

),

payment_dates as (

    ----------------------------------------------------------------------------
    -- Date du paiement
    ----------------------------------------------------------------------------

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

created_dates as (

    ----------------------------------------------------------------------------
    -- Date de création
    ----------------------------------------------------------------------------

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

final as (

    select

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        p.payment_sk,

        p.payment_id,

        i.invoice_sk,

        p.invoice_id,

        c.customer_sk,

        c.contract_sk,

        ------------------------------------------------------------------------
        -- Clés calendrier
        ------------------------------------------------------------------------

        pd.date_sk as payment_date_sk,

        cd.date_sk as created_date_sk,

        ------------------------------------------------------------------------
        -- Dates métier
        ------------------------------------------------------------------------

        p.payment_date,

        p.created_at as payment_created_at,

        ------------------------------------------------------------------------
        -- Mesures
        ------------------------------------------------------------------------

        p.amount_paid,

        i.total_amount,

        ------------------------------------------------------------------------
        -- Informations paiement
        ------------------------------------------------------------------------

        p.payment_method,

        p.payment_status,

        p.transaction_reference,

        p.bank_name,

        p.currency,

        ------------------------------------------------------------------------
        -- Indicateurs métier
        ------------------------------------------------------------------------

        p.is_successful_payment,

        p.is_pending_payment,

        p.is_failed_payment

    from payments as p

    left join contracts as c
        on p.contract_id = c.contract_id

    left join invoices as i
        on p.invoice_id = i.invoice_id

    left join payment_dates as pd
        on p.payment_date = pd.full_date

    left join created_dates as cd
        on cast(p.created_at as date) = cd.full_date

    {% if is_incremental() %}

        where p.created_at >

        (

            select coalesce(

                max(payment_created_at),
                cast('1900-01-01' as timestamp)

            )

            from {{ this }}

        )

    {% endif %}

)

select *

from final