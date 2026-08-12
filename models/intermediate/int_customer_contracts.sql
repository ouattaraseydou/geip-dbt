{{ config(materialized='view') }}

/*
==============================================================================
    MODEL      : int_customer_contracts
    LAYER      : SILVER

    DESCRIPTION
    -----------
    Associer les informations des clients avec leurs contrats.

    BUSINESS PURPOSE
    ----------------
    Cette table constitue la couche d'intégration entre les entités
    Customer et Contract. Elle alimente principalement les dimensions GOLD
    (dim_customers, dim_contracts) ainsi que plusieurs tables de faits.

    GRANULARITÉ
    -----------
    1 ligne = 1 Client × 1 Contrat

    SOURCES
    -------
    - stg_landing_customers
    - stg_landing_contracts

    RÈGLES MÉTIER
    -------------
    - Un client peut posséder zéro, un ou plusieurs contrats.
    - Les clients sans contrat sont conservés (LEFT JOIN).
    - Les attributs techniques inutiles pour l'analyse sont exclus.

    AUTHOR
    ------
    Ouattara Seydou
==============================================================================
*/

WITH customers AS (

    ----------------------------------------------------------------------------
    -- Informations clients
    ----------------------------------------------------------------------------

    SELECT

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        customer_sk,
        customer_id,
        customer_code,

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
        -- Coordonnées
        ------------------------------------------------------------------------

        email AS customer_email,
        mobile_phone AS customer_mobile_phone,

        ------------------------------------------------------------------------
        -- Localisation
        ------------------------------------------------------------------------

        city AS customer_city,
        region AS customer_region,
        country AS customer_country,

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

        registration_date AS customer_registration_date,
        status AS customer_status,

        risk_score,
        acquisition_channel,
        customer_lifetime_value,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        created_at AS customer_created_at

    FROM {{ ref('stg_landing_customers') }}

),

contracts AS (

    ----------------------------------------------------------------------------
    -- Informations contrats
    ----------------------------------------------------------------------------

    SELECT

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        contract_sk,
        contract_id,
        customer_id,

        ------------------------------------------------------------------------
        -- Informations contrat
        ------------------------------------------------------------------------

        contract_type,
        energy_type,
        tariff_name,
        contract_status,

        start_date AS contract_start_date,
        end_date AS contract_end_date,

        monthly_fee,
        estimated_annual_consumption,

        renewable_energy,

        payment_frequency,
        payment_method,

        supplier_name,
        country AS contract_country,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        created_at AS contract_created_at,
        updated_at AS contract_updated_at

    FROM {{ ref('stg_landing_contracts') }}

),

final AS (

    ----------------------------------------------------------------------------
    -- Association Client ↔ Contrat
    ----------------------------------------------------------------------------

    SELECT

        ------------------------------------------------------------------------
        -- Informations Client
        ------------------------------------------------------------------------

        c.customer_sk,
        c.customer_id,
        c.customer_code,

        c.civility,
        c.first_name,
        c.middle_name,
        c.last_name,

        c.gender,
        c.birth_date,
        c.nationality,
        c.marital_status,

        c.customer_email,
        c.customer_mobile_phone,

        c.customer_city,
        c.customer_region,
        c.customer_country,

        c.customer_type,
        c.customer_segment,
        c.loyalty_level,

        c.annual_income,
        c.occupation,

        c.customer_registration_date,
        c.customer_status,

        c.risk_score,
        c.acquisition_channel,
        c.customer_lifetime_value,

        c.customer_created_at,

        ------------------------------------------------------------------------
        -- Informations Contrat
        ------------------------------------------------------------------------

        ct.contract_sk,
        ct.contract_id,

        ct.contract_type,
        ct.energy_type,
        ct.tariff_name,
        ct.contract_status,

        ct.contract_start_date,
        ct.contract_end_date,

        ct.monthly_fee,
        ct.estimated_annual_consumption,

        ct.renewable_energy,

        ct.payment_frequency,
        ct.payment_method,

        ct.supplier_name,
        ct.contract_country,

        ct.contract_created_at,
        ct.contract_updated_at,

        ------------------------------------------------------------------------
        -- KPI métier
        ------------------------------------------------------------------------

        DATEDIFF(
            DAY,
            ct.contract_start_date,
            COALESCE(
                ct.contract_end_date,
                CURRENT_DATE()
            )
        ) AS contract_duration_days

    FROM customers AS c

    LEFT JOIN contracts AS ct
        ON c.customer_id = ct.customer_id

)

SELECT *

FROM final