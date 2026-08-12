{{ config(materialized='view') }}

/*
==============================================================================
MODEL : stg_landing_customer_service

DESCRIPTION :
Nettoyage, standardisation et enrichissement
des tickets du service client.

BUSINESS PURPOSE :
Préparer les données du service client
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

    FROM {{ source('landing', 'CUSTOMER_SERVICE') }}

),

deduplicated AS (

    ----------------------------------------------------------------------------
    -- Aucune déduplication nécessaire
    ----------------------------------------------------------------------------

    SELECT *

    FROM source

),

cleaned AS (

    ----------------------------------------------------------------------------
    -- Nettoyage et standardisation
    ----------------------------------------------------------------------------

    SELECT

        ------------------------------------------------------------------------
        -- Clés
        ------------------------------------------------------------------------

        ticket_sk,

        {{ clean_column('ticket_id') }},

        {{ clean_column('customer_id') }},

        {{ clean_column('contract_id') }},

        ------------------------------------------------------------------------
        -- Informations du ticket
        ------------------------------------------------------------------------

        {{ to_date('ticket_date') }},

        {{ clean_upper_column('ticket_type') }},

        {{ clean_upper_column('priority') }},

        {{ clean_upper_column('channel') }},

        {{ clean_upper_column('status') }},

        {{ clean_column('assigned_team') }},

        ------------------------------------------------------------------------
        -- Mesures
        ------------------------------------------------------------------------

        {{ clean_numeric('resolution_time_hours') }},

        {{ clean_numeric('satisfaction_score') }},

        {{ to_boolean('first_call_resolution') }},

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        {{ to_timestamp('created_at') }}

    FROM deduplicated

),

enriched AS (

    ----------------------------------------------------------------------------
    -- Création des indicateurs métier
    ----------------------------------------------------------------------------

    SELECT

        *,

        CASE
            WHEN status = 'RESOLVED' THEN TRUE
            ELSE FALSE
        END AS is_resolved,

        CASE
            WHEN status = 'OPEN' THEN TRUE
            ELSE FALSE
        END AS is_open,

        CASE
            WHEN status = 'IN PROGRESS' THEN TRUE
            ELSE FALSE
        END AS is_in_progress,

        CASE
            WHEN priority IN ('HIGH', 'CRITICAL') THEN TRUE
            ELSE FALSE
        END AS is_high_priority,

        CASE
            WHEN resolution_time_hours IS NULL THEN NULL
            WHEN resolution_time_hours <= 24 THEN TRUE
            ELSE FALSE
        END AS resolved_within_24h,

        {{ current_load_timestamp() }} AS dbt_loaded_at

    FROM cleaned

),

final AS (

    ----------------------------------------------------------------------------
    -- Jeu de données final
    ----------------------------------------------------------------------------

    SELECT *

    FROM enriched

)

SELECT *

FROM final