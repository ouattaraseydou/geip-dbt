{{ config(materialized='view') }}

/*
==============================================================================
MODEL : stg_landing_customers

DESCRIPTION :
Nettoyage, déduplication et standardisation
des clients provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données clients
pour les modèles Silver.

LAYER :
BRONZE

AUTHOR :
Ouattara Seydou
==============================================================================
*/

WITH source AS (

    ----------------------------------------------------------------------------
    -- Lecture de la table source
    ----------------------------------------------------------------------------

    SELECT *

    FROM {{ source('landing', 'CUSTOMERS') }}

),

deduplicated AS (

    ----------------------------------------------------------------------------
    -- Conservation de la version la plus récente
    -- de chaque client (clé métier).
    ----------------------------------------------------------------------------

    SELECT *

    FROM source

    QUALIFY ROW_NUMBER() OVER (

        PARTITION BY customer_id

        ORDER BY
            updated_at DESC,
            load_date DESC

    ) = 1

),

cleaned AS (

    ----------------------------------------------------------------------------
    -- Nettoyage et standardisation
    ----------------------------------------------------------------------------

    SELECT

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        customer_sk,

        {{ clean_column('customer_id') }},

        {{ clean_column('customer_code') }},

        ------------------------------------------------------------------------
        -- Informations personnelles
        ------------------------------------------------------------------------

        {{ clean_upper_column('civility') }},

        {{ clean_column('first_name') }},

        {{ clean_column('middle_name') }},

        {{ clean_column('last_name') }},

        {{ clean_upper_column('gender') }},

        {{ to_date('birth_date') }},

        {{ clean_upper_column('nationality') }},

        {{ clean_upper_column('marital_status') }},

        ------------------------------------------------------------------------
        -- Contacts
        ------------------------------------------------------------------------

        {{ clean_email('email') }} AS email,

        {{ clean_email('secondary_email') }} AS secondary_email,

        {{ clean_column('mobile_phone') }},

        {{ clean_column('home_phone') }},

        {{ clean_column('work_phone') }},

        {{ clean_upper_column('preferred_contact_method') }},

        {{ clean_upper_column('preferred_language') }},

        {{ clean_column('website') }},

        {{ clean_column('linkedin_profile') }},

        {{ to_boolean('communication_opt_in') }},

        ------------------------------------------------------------------------
        -- Adresse
        ------------------------------------------------------------------------

        {{ clean_column('address_line1') }},

        {{ clean_column('address_line2') }},

        {{ clean_column('postal_code') }},

        {{ clean_column('city') }},

        {{ clean_column('region') }},

        {{ clean_upper_column('country') }},

        {{ clean_upper_column('country_code') }},

        {{ clean_numeric('latitude') }},

        {{ clean_numeric('longitude') }},

        {{ clean_column('timezone') }},

        ------------------------------------------------------------------------
        -- Informations client
        ------------------------------------------------------------------------

        {{ clean_upper_column('customer_type') }},

        {{ clean_upper_column('customer_segment') }},

        {{ clean_upper_column('loyalty_level') }},

        {{ clean_numeric('annual_income') }},

        {{ clean_column('occupation') }},

        {{ clean_column('employer') }},

        {{ to_date('registration_date') }},

        {{ clean_upper_column('status') }},

        {{ clean_numeric('risk_score') }},

        {{ clean_upper_column('acquisition_channel') }},

        {{ clean_column('campaign_name') }},

        {{ clean_column('referral_source') }},

        {{ clean_numeric('marketing_score') }},

        {{ clean_numeric('customer_lifetime_value') }},

        ------------------------------------------------------------------------
        -- Consentements
        ------------------------------------------------------------------------

        {{ to_boolean('consent_email') }},

        {{ to_boolean('consent_sms') }},

        {{ to_boolean('consent_phone') }},

        {{ to_date('consent_date') }},

        {{ clean_column('privacy_version') }},

        ------------------------------------------------------------------------
        -- Historisation
        ------------------------------------------------------------------------

        {{ to_date('effective_start_date') }},

        {{ to_date('effective_end_date') }},

        {{ to_boolean('is_current') }},

        {{ clean_numeric('version_number') }},

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        {{ clean_upper_column('source_system') }},

        {{ clean_column('source_file') }},

        {{ clean_column('batch_id') }},

        {{ to_timestamp('created_at') }},

        {{ clean_column('created_by') }},

        {{ to_timestamp('updated_at') }},

        {{ clean_column('updated_by') }},

        {{ to_timestamp('load_date') }},

        {{ current_load_timestamp() }} AS dbt_loaded_at

    FROM deduplicated

),

final AS (

    ----------------------------------------------------------------------------
    -- Jeu de données final
    ----------------------------------------------------------------------------

    SELECT *

    FROM cleaned

)

SELECT *

FROM final