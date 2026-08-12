{{ config(
    materialized='incremental',
    unique_key='consumption_sk',
    incremental_strategy='merge'
) }}

/*
==============================================================================
MODEL : fact_energy_consumption

DESCRIPTION :
Table de faits des consommations énergétiques.

BUSINESS PURPOSE :
Centraliser les relevés de consommation afin d'alimenter les analyses
de consommation, les tableaux de bord et les indicateurs métier.

LAYER :
GOLD

GRANULARITY :
1 ligne = 1 relevé de consommation

SOURCE :
- int_meter_consumption
- dim_contracts
- dim_date

AUTHOR :
Ouattara Seydou
==============================================================================
*/

with consumption as (

    ----------------------------------------------------------------------------
    -- Relevés de consommation
    ----------------------------------------------------------------------------

    select *

    from {{ ref('int_meter_consumption') }}

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

dates as (

    ----------------------------------------------------------------------------
    -- Dimension Date
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

        c.consumption_sk,

        ct.customer_sk,

        ct.contract_sk,

        c.meter_sk,

        ------------------------------------------------------------------------
        -- Clé calendrier
        ------------------------------------------------------------------------

        d.date_sk as reading_date_sk,

        ------------------------------------------------------------------------
        -- Date de lecture
        ------------------------------------------------------------------------

        c.reading_datetime,

        c.reading_year,

        c.reading_month,

        c.reading_day,

        c.reading_hour,

        c.season,

        ------------------------------------------------------------------------
        -- Mesures
        ------------------------------------------------------------------------

        c.energy_consumed_kwh,

        c.peak_kwh,

        c.off_peak_kwh,

        c.reactive_energy_kvarh,

        c.temperature,

        c.co2_emission_kg,

        c.outage_minutes,

        ------------------------------------------------------------------------
        -- Attributs métier
        ------------------------------------------------------------------------

        c.estimated_reading,

        c.quality_flag,

        c.reading_type,

        c.has_consumption,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        c.consumption_created_at

    from consumption as c

    left join contracts as ct
        on c.contract_id = ct.contract_id

    left join dates as d
        on cast(c.reading_datetime as date) = d.full_date

    {% if is_incremental() %}

        where c.consumption_created_at >

        (

            select coalesce(

                max(consumption_created_at),
                cast('1900-01-01' as timestamp)

            )

            from {{ this }}

        )

    {% endif %}

)

select *

from final