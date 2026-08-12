{{ config(
    materialized='table'
) }}

/*
==============================================================================
MODEL : dim_meters

DESCRIPTION :
Dimension des compteurs.

BUSINESS PURPOSE :
Construire la dimension des compteurs utilisée par les tables de faits
et les tableaux de bord.

LAYER :
GOLD

GRANULARITY :
1 ligne = 1 compteur

SOURCE :
- stg_landing_meters
- dim_contracts
- dim_date

AUTHOR :
Ouattara Seydou
==============================================================================
*/

with source as (

    ----------------------------------------------------------------------------
    -- Informations des compteurs
    ----------------------------------------------------------------------------

    select

        meter_sk,
        meter_id,
        contract_id,

        serial_number,

        meter_type,
        manufacturer,

        installation_date,
        last_calibration_date,

        meter_status,

        voltage,
        phase,
        max_power_kw,

        communication_type,

        country,

        latitude,
        longitude,

        created_at,
        updated_at

    from {{ ref('stg_landing_meters') }}

),

contracts as (

    ----------------------------------------------------------------------------
    -- Clés des contrats
    ----------------------------------------------------------------------------

    select

        contract_sk,
        contract_id

    from {{ ref('dim_contracts') }}

),

installation_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

calibration_dates as (

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

updated_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

meters_ranked as (

    ----------------------------------------------------------------------------
    -- Association avec les dimensions Contrat et Date
    ----------------------------------------------------------------------------

    select

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        s.meter_sk,
        s.meter_id,

        c.contract_sk,
        s.contract_id,

        ------------------------------------------------------------------------
        -- Clés calendrier
        ------------------------------------------------------------------------

        id.date_sk as installation_date_sk,

        lcd.date_sk as last_calibration_date_sk,

        cd.date_sk as meter_created_date_sk,

        ud.date_sk as meter_updated_date_sk,

        ------------------------------------------------------------------------
        -- Informations compteur
        ------------------------------------------------------------------------

        s.serial_number,

        s.meter_type,

        s.manufacturer,

        s.installation_date,

        s.last_calibration_date,

        s.meter_status,

        s.voltage,

        s.phase,

        s.max_power_kw,

        s.communication_type,

        s.country,

        s.latitude,

        s.longitude,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        s.created_at as meter_created_at,

        s.updated_at as meter_updated_at,

        ------------------------------------------------------------------------
        -- Déduplication
        ------------------------------------------------------------------------

        row_number() over (

            partition by s.meter_id

            order by s.updated_at desc

        ) as rn

    from source as s

    left join contracts as c
        on s.contract_id = c.contract_id

    left join installation_dates as id
        on s.installation_date = id.full_date

    left join calibration_dates as lcd
        on s.last_calibration_date = lcd.full_date

    left join created_dates as cd
        on cast(s.created_at as date) = cd.full_date

    left join updated_dates as ud
        on cast(s.updated_at as date) = ud.full_date

),

final as (

    ----------------------------------------------------------------------------
    -- Dimension Compteur
    ----------------------------------------------------------------------------

    select

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        meter_sk,

        meter_id,

        contract_sk,

        contract_id,

        ------------------------------------------------------------------------
        -- Clés calendrier
        ------------------------------------------------------------------------

        installation_date_sk,

        last_calibration_date_sk,

        meter_created_date_sk,

        meter_updated_date_sk,

        ------------------------------------------------------------------------
        -- Informations compteur
        ------------------------------------------------------------------------

        serial_number,

        meter_type,

        manufacturer,

        installation_date,

        last_calibration_date,

        meter_status,

        voltage,

        phase,

        max_power_kw,

        communication_type,

        country,

        latitude,

        longitude,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        meter_created_at,

        meter_updated_at

    from meters_ranked

    where rn = 1

)

select *

from final