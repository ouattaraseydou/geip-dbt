{{ config(
    materialized='table'
) }}

/*
==============================================================================
MODEL : dim_customers

DESCRIPTION :
Dimension des clients.

BUSINESS PURPOSE :
Construire la dimension Client utilisée par les tables de faits
et les tableaux de bord.

LAYER :
GOLD

GRANULARITY :
1 ligne = 1 client

SOURCE :
- int_customer_contracts
- dim_date

AUTHOR :
Ouattara Seydou
==============================================================================
*/

with source as (

    ----------------------------------------------------------------------------
    -- Informations clients
    ----------------------------------------------------------------------------

    select

        customer_sk,
        customer_id,
        customer_code,

        civility,
        first_name,
        middle_name,
        last_name,

        gender,
        birth_date,
        nationality,
        marital_status,

        customer_email,
        customer_mobile_phone,

        customer_city,
        customer_region,
        customer_country,

        customer_type,
        customer_segment,
        loyalty_level,

        annual_income,
        occupation,

        customer_registration_date,
        customer_status,

        risk_score,
        acquisition_channel,
        customer_lifetime_value,

        customer_created_at

    from {{ ref('int_customer_contracts') }}

),

birth_dates as (

    select

        date_sk,
        full_date

    from {{ ref('dim_date') }}

),

registration_dates as (

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

customers_ranked as (

    ----------------------------------------------------------------------------
    -- Association avec la dimension Date
    ----------------------------------------------------------------------------

    select

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        s.customer_sk,
        s.customer_id,
        s.customer_code,

        ------------------------------------------------------------------------
        -- Clés calendrier
        ------------------------------------------------------------------------

        bd.date_sk as customer_birth_date_sk,

        rd.date_sk as customer_registration_date_sk,

        cd.date_sk as customer_created_date_sk,

        ------------------------------------------------------------------------
        -- Informations personnelles
        ------------------------------------------------------------------------

        s.civility,
        s.first_name,
        s.middle_name,
        s.last_name,

        s.gender,
        s.birth_date,
        s.nationality,
        s.marital_status,

        ------------------------------------------------------------------------
        -- Contacts
        ------------------------------------------------------------------------

        s.customer_email,
        s.customer_mobile_phone,

        ------------------------------------------------------------------------
        -- Localisation
        ------------------------------------------------------------------------

        s.customer_city,
        s.customer_region,
        s.customer_country,

        ------------------------------------------------------------------------
        -- Profil client
        ------------------------------------------------------------------------

        s.customer_type,
        s.customer_segment,
        s.loyalty_level,

        ------------------------------------------------------------------------
        -- Informations métier
        ------------------------------------------------------------------------

        s.annual_income,
        s.occupation,

        s.customer_registration_date,
        s.customer_status,

        s.risk_score,
        s.acquisition_channel,
        s.customer_lifetime_value,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        s.customer_created_at,

        ------------------------------------------------------------------------
        -- Déduplication
        ------------------------------------------------------------------------

        row_number() over (

            partition by s.customer_id

            order by s.customer_created_at desc

        ) as rn

    from source as s

    left join birth_dates as bd
        on s.birth_date = bd.full_date

    left join registration_dates as rd
        on s.customer_registration_date = rd.full_date

    left join created_dates as cd
        on cast(s.customer_created_at as date) = cd.full_date

),

final as (

    ----------------------------------------------------------------------------
    -- Dimension Client
    ----------------------------------------------------------------------------

    select

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        customer_sk,
        customer_id,
        customer_code,

        ------------------------------------------------------------------------
        -- Clés calendrier
        ------------------------------------------------------------------------

        customer_birth_date_sk,
        customer_registration_date_sk,
        customer_created_date_sk,

        ------------------------------------------------------------------------
        -- Informations personnelles
        ------------------------------------------------------------------------

        civility,
        first_name,
        middle_name,
        last_name,

        gender,
        birth_date,
        nationality,
        marital_status,

        ------------------------------------------------------------------------
        -- Contacts
        ------------------------------------------------------------------------

        customer_email,
        customer_mobile_phone,

        ------------------------------------------------------------------------
        -- Localisation
        ------------------------------------------------------------------------

        customer_city,
        customer_region,
        customer_country,

        ------------------------------------------------------------------------
        -- Profil client
        ------------------------------------------------------------------------

        customer_type,
        customer_segment,
        loyalty_level,

        ------------------------------------------------------------------------
        -- Informations métier
        ------------------------------------------------------------------------

        annual_income,
        occupation,

        customer_registration_date,
        customer_status,

        risk_score,
        acquisition_channel,
        customer_lifetime_value,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        customer_created_at

    from customers_ranked

    where rn = 1

)

select *

from final