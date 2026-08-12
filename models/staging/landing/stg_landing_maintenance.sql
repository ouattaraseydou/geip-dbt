{{ config(materialized='view') }}

/*
==============================================================================
MODEL : stg_landing_maintenance

DESCRIPTION :
Nettoyage, standardisation et enrichissement
des opérations de maintenance provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données de maintenance
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

    FROM {{ source('landing', 'MAINTENANCE') }}

),

deduplicated AS (

    ----------------------------------------------------------------------------
    -- Aucune déduplication nécessaire.
    -- MAINTENANCE_ID est unique dans la source.
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

        maintenance_sk,

        {{ clean_text('maintenance_id') }} AS maintenance_id,

        {{ clean_text('meter_id') }} AS meter_id,

        {{ clean_text('contract_id') }} AS contract_id,

        ------------------------------------------------------------------------
        -- Informations maintenance
        ------------------------------------------------------------------------

        {{ to_date('maintenance_date') }},

        {{ clean_upper('maintenance_type') }} AS maintenance_type,

        {{ clean_text('technician') }} AS technician,

        {{ clean_upper('priority') }} AS priority,

        {{ clean_upper('status') }} AS status,

        {{ clean_numeric('duration_hours') }},

        {{ clean_numeric('maintenance_cost') }},

        {{ clean_upper('result') }} AS result,

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

        ------------------------------------------------------------------------
        -- Maintenance terminée
        ------------------------------------------------------------------------

        CASE
            WHEN status = 'COMPLETED'
                THEN TRUE
            ELSE FALSE
        END AS is_completed,

        ------------------------------------------------------------------------
        -- Maintenance prioritaire
        ------------------------------------------------------------------------

        CASE
            WHEN priority IN ('HIGH', 'CRITICAL')
                THEN TRUE
            ELSE FALSE
        END AS is_high_priority,

        ------------------------------------------------------------------------
        -- Maintenance longue
        ------------------------------------------------------------------------

        CASE
            WHEN duration_hours >= 4
                THEN TRUE
            ELSE FALSE
        END AS is_long_maintenance,

        ------------------------------------------------------------------------
        -- Maintenance coûteuse
        ------------------------------------------------------------------------

        CASE
            WHEN maintenance_cost >= 500
                THEN TRUE
            ELSE FALSE
        END AS is_high_cost,

        ------------------------------------------------------------------------
        -- Date de chargement dbt
        ------------------------------------------------------------------------

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