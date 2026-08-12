{{ config(materialized='view') }}

/*
==============================================================================
MODEL : stg_landing_meters

DESCRIPTION :
Nettoyage, déduplication et standardisation
des compteurs provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données des compteurs
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

    FROM {{ source('landing', 'METERS') }}

),

deduplicated AS (

    ----------------------------------------------------------------------------
    -- Conservation de la version la plus récente
    -- de chaque compteur.
    ----------------------------------------------------------------------------

    SELECT *

    FROM source

    QUALIFY ROW_NUMBER() OVER (

        PARTITION BY meter_id

        ORDER BY
            updated_at DESC,
            created_at DESC

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

        meter_sk,

        {{ clean_text('meter_id') }} AS meter_id,

        {{ clean_text('contract_id') }} AS contract_id,

        ------------------------------------------------------------------------
        -- Informations compteur
        ------------------------------------------------------------------------

        {{ clean_text('serial_number') }} AS serial_number,

        {{ clean_upper('meter_type') }} AS meter_type,

        {{ clean_text('manufacturer') }} AS manufacturer,

        {{ to_date('installation_date') }},

        {{ to_date('last_calibration_date') }},

        {{ clean_upper('meter_status') }} AS meter_status,

        {{ clean_text('voltage') }} AS voltage,

        {{ clean_text('phase') }} AS phase,

        {{ clean_numeric('max_power_kw') }},

        {{ clean_upper('communication_type') }} AS communication_type,

        {{ clean_upper('country') }} AS country,

        {{ clean_numeric('latitude') }},

        {{ clean_numeric('longitude') }},

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        {{ to_timestamp('created_at') }},

        {{ to_timestamp('updated_at') }}

    FROM deduplicated

),

enriched AS (

    ----------------------------------------------------------------------------
    -- Création des indicateurs métier
    ----------------------------------------------------------------------------

    SELECT

        *,

        ------------------------------------------------------------------------
        -- Compteur actif
        ------------------------------------------------------------------------

        CASE
            WHEN meter_status = 'ACTIVE' THEN TRUE
            ELSE FALSE
        END AS is_active,

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