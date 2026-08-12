{{ config(
    materialized='incremental',
    unique_key='invoice_sk',
    incremental_strategy='merge'
) }}

/*
==============================================================================
MODEL : fact_invoices

DESCRIPTION :
Table de faits des factures.

BUSINESS PURPOSE :
Centraliser les données de facturation afin d'alimenter les analyses
financières, les indicateurs de paiement et les tableaux de bord.

LAYER :
GOLD

GRANULARITY :
1 ligne = 1 facture

SOURCE :
- stg_landing_invoices
- dim_contracts
- dim_meters
- dim_date

AUTHOR :
Ouattara Seydou
==============================================================================
*/

with invoices as (

    ----------------------------------------------------------------------------
    -- Factures
    ----------------------------------------------------------------------------

    select *

    from {{ ref('stg_landing_invoices') }}

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

meters as (

    ----------------------------------------------------------------------------
    -- Dimension Compteur
    ----------------------------------------------------------------------------

    select

        meter_sk,
        meter_id

    from {{ ref('dim_meters') }}

),

invoice_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

billing_start_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

billing_end_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

due_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

payment_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

created_dates as (

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

        i.invoice_sk,

        i.invoice_id,

        c.customer_sk,

        c.contract_sk,

        m.meter_sk,

        ------------------------------------------------------------------------
        -- Clés calendrier
        ------------------------------------------------------------------------

        id.date_sk as invoice_date_sk,

        bsd.date_sk as billing_start_date_sk,

        bed.date_sk as billing_end_date_sk,

        dd.date_sk as due_date_sk,

        pd.date_sk as payment_date_sk,

        cd.date_sk as created_date_sk,

        ------------------------------------------------------------------------
        -- Dates métier
        ------------------------------------------------------------------------

        i.invoice_date,

        i.billing_period_start,

        i.billing_period_end,

        i.due_date,

        i.payment_date,

        ------------------------------------------------------------------------
        -- Mesures
        ------------------------------------------------------------------------

        i.total_kwh,

        i.energy_amount,

        i.fixed_charge,

        i.tax_amount,

        i.total_amount,

        ------------------------------------------------------------------------
        -- Indicateurs métier
        ------------------------------------------------------------------------

        i.invoice_status,

        i.is_paid,

        i.payment_terms_days,

        i.payment_delay_days,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        i.created_at as invoice_created_at

    from invoices as i

    left join contracts as c
        on i.contract_id = c.contract_id

    left join meters as m
        on i.meter_id = m.meter_id

    left join invoice_dates as id
        on i.invoice_date = id.full_date

    left join billing_start_dates as bsd
        on i.billing_period_start = bsd.full_date

    left join billing_end_dates as bed
        on i.billing_period_end = bed.full_date

    left join due_dates as dd
        on i.due_date = dd.full_date

    left join payment_dates as pd
        on i.payment_date = pd.full_date

    left join created_dates as cd
        on cast(i.created_at as date) = cd.full_date

    {% if is_incremental() %}

        where i.created_at >

        (

            select coalesce(

                max(invoice_created_at),
                cast('1900-01-01' as timestamp)

            )

            from {{ this }}

        )

    {% endif %}

)

select *

from final