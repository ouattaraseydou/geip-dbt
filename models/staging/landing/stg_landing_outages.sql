{{ config(materialized='view') }}

 /*
==============================================================================
MODEL : stg_landing_outages

DESCRIPTION :
Nettoyage, standardisation et enrichissement
des pannes provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données des interruptions
pour les modèles Silver.

LAYER :
BRONZE

AUTHOR :
Ouattara Seydou
==============================================================================
*/

WITH source AS (

    --------------------------------------------------------------------------
    -- Lecture de la table source
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ source('landing', 'OUTAGES') }}

),

deduplicated AS (

    --------------------------------------------------------------------------
    -- Aucune déduplication nécessaire
    --------------------------------------------------------------------------

    SELECT *

    FROM source

),

cleaned AS (

    --------------------------------------------------------------------------
    -- Nettoyage et standardisation
    --------------------------------------------------------------------------

    SELECT

        ----------------------------------------------------------------------
        -- Clés
        ----------------------------------------------------------------------

        outage_sk,

        {{ clean_column('outage_id') }},

        {{ clean_column('meter_id') }},

        {{ clean_column('contract_id') }},

        ----------------------------------------------------------------------
        -- Informations sur la panne
        ----------------------------------------------------------------------

        {{ to_timestamp('outage_start') }},

        {{ to_timestamp('outage_end') }},

        {{ clean_numeric('duration_minutes') }},

        {{ clean_upper_column('cause') }},

        {{ clean_upper_column('severity') }},

        {{ clean_upper_column('status') }},

        {{ clean_numeric('affected_customers') }},

        ----------------------------------------------------------------------
        -- Audit
        ----------------------------------------------------------------------

        {{ to_timestamp('created_at') }}

    FROM deduplicated

),

enriched AS (

    --------------------------------------------------------------------------
    -- Création des indicateurs métier
    --------------------------------------------------------------------------

    SELECT

        *,

        ----------------------------------------------------------------------
        -- Panne résolue
        ----------------------------------------------------------------------

        CASE
            WHEN status = 'RESOLVED'
                THEN TRUE
            ELSE FALSE
        END AS is_resolved,

        ----------------------------------------------------------------------
        -- Panne majeure
        ----------------------------------------------------------------------

        CASE
            WHEN severity IN ('HIGH', 'CRITICAL')
                THEN TRUE
            ELSE FALSE
        END AS is_major_outage,

        ----------------------------------------------------------------------
        -- Durée de la panne (heures)
        ----------------------------------------------------------------------

        ROUND(duration_minutes / 60.0, 2) AS duration_hours,

        ----------------------------------------------------------------------
        -- Panne de grande ampleur
        ----------------------------------------------------------------------

        CASE
            WHEN affected_customers >= 100
                THEN TRUE
            ELSE FALSE
        END AS is_large_outage,

        ----------------------------------------------------------------------
        -- Audit dbt
        ----------------------------------------------------------------------

        {{ current_load_timestamp() }} AS dbt_loaded_at

    FROM cleaned

),

final AS (

    --------------------------------------------------------------------------
    -- Jeu de données final
    --------------------------------------------------------------------------

    SELECT *

    FROM enriched

)

SELECT *

FROM final