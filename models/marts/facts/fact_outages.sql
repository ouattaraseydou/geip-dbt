{{ config(
    materialized='incremental',
    unique_key='outage_sk',
    incremental_strategy='merge'
) }}

/*
==============================================================================
MODEL : fact_outages

DESCRIPTION :
Table de faits des coupures réseau.

BUSINESS PURPOSE :
Centraliser les événements de coupure afin d'analyser la qualité du réseau,
les impacts clients et les performances opérationnelles.

LAYER :
GOLD

GRANULARITY :
1 ligne = 1 coupure réseau

SOURCE :
- int_outages
- dim_date

AUTHOR :
Ouattara Seydou
==============================================================================
*/

with outages as (

    ----------------------------------------------------------------------------
    -- Coupures réseau
    ----------------------------------------------------------------------------

    select *

    from {{ ref('int_outages') }}

),

start_dates as (

    ----------------------------------------------------------------------------
    -- Date de début
    ----------------------------------------------------------------------------

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

end_dates as (

    ----------------------------------------------------------------------------
    -- Date de fin
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

        o.outage_sk,

        o.outage_id,

        o.contract_sk,

        o.contract_id,

        o.meter_sk,

        o.meter_id,

        ------------------------------------------------------------------------
        -- Clés calendrier
        ------------------------------------------------------------------------

        sd.date_sk as outage_start_date_sk,

        ed.date_sk as outage_end_date_sk,

        cd.date_sk as created_date_sk,

        ------------------------------------------------------------------------
        -- Dates métier
        ------------------------------------------------------------------------

        o.outage_start,

        o.outage_end,

        o.outage_created_at,

        ------------------------------------------------------------------------
        -- Informations coupure
        ------------------------------------------------------------------------

        o.cause,

        o.severity,

        o.status,

        ------------------------------------------------------------------------
        -- Informations contrat
        ------------------------------------------------------------------------

        o.contract_type,

        o.energy_type,

        o.contract_status,

        o.country,

        ------------------------------------------------------------------------
        -- Informations compteur
        ------------------------------------------------------------------------

        o.serial_number,

        o.meter_type,

        o.manufacturer,

        o.meter_status,

        o.max_power_kw,

        o.communication_type,

        ------------------------------------------------------------------------
        -- Mesures
        ------------------------------------------------------------------------

        o.duration_minutes,

        o.duration_hours,

        o.affected_customers,

        ------------------------------------------------------------------------
        -- Indicateurs
        ------------------------------------------------------------------------

        o.is_resolved,

        o.is_major_outage,

        o.is_large_outage,

        ------------------------------------------------------------------------
        -- KPI calculés
        ------------------------------------------------------------------------

        case
            when o.status = 'RESOLVED'
                then true
            else false
        end as is_resolved_status,

        case
            when o.severity = 'CRITICAL'
                then true
            else false
        end as is_critical,

        case
            when o.duration_hours < 1 then 'Very Short'
            when o.duration_hours < 4 then 'Short'
            when o.duration_hours < 8 then 'Medium'
            when o.duration_hours < 12 then 'Long'
            else 'Very Long'
        end as duration_category,

        case
            when o.affected_customers < 50 then 'Low Impact'
            when o.affected_customers < 200 then 'Medium Impact'
            when o.affected_customers < 500 then 'High Impact'
            else 'Critical Impact'
        end as impact_category,

        case
            when o.manufacturer in (

                'Landis+Gyr',
                'Siemens',
                'Schneider Electric'

            )
                then 'Premium'
            else 'Standard'
        end as manufacturer_category,

        case
            when o.max_power_kw <= 6 then 'Small'
            when o.max_power_kw <= 18 then 'Medium'
            when o.max_power_kw <= 36 then 'Large'
            else 'Industrial'
        end as power_category,

        ------------------------------------------------------------------------
        -- Ancienneté
        ------------------------------------------------------------------------

        datediff(

            day,

            cast(o.contract_created_at as date),

            current_date()

        ) as contract_age_days,

        datediff(

            day,

            cast(o.meter_created_at as date),

            current_date()

        ) as meter_age_days,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        o.contract_created_at,

        o.meter_created_at

    from outages as o

    left join start_dates as sd
        on cast(o.outage_start as date) = sd.full_date

    left join end_dates as ed
        on cast(o.outage_end as date) = ed.full_date

    left join created_dates as cd
        on cast(o.outage_created_at as date) = cd.full_date

    {% if is_incremental() %}

        where o.outage_created_at >

        (

            select coalesce(

                max(outage_created_at),
                cast('1900-01-01' as timestamp)

            )

            from {{ this }}

        )

    {% endif %}

)

select *

from final