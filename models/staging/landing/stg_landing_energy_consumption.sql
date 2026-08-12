{{ config(materialized='view') }}

/*
==============================================================================
MODEL : stg_landing_energy_consumption

DESCRIPTION :
Nettoyage, déduplication et standardisation
des relevés de consommation provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données de consommation
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

    FROM {{ source('landing', 'ENERGY_CONSUMPTION') }}

),

deduplicated AS (

    ----------------------------------------------------------------------------
    -- Conservation de la dernière version
    -- d'un relevé de consommation.
    ----------------------------------------------------------------------------

    SELECT *

    FROM source

    QUALIFY ROW_NUMBER() OVER (

        PARTITION BY
            TRIM(meter_id),
            reading_datetime

        ORDER BY
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

        consumption_sk,

        {{ clean_column('meter_id') }},

        {{ clean_column('contract_id') }},

        ------------------------------------------------------------------------
        -- Date de lecture
        ------------------------------------------------------------------------

        {{ to_timestamp('reading_datetime') }},

        {{ clean_numeric('reading_year') }},

        {{ clean_numeric('reading_month') }},

        {{ clean_numeric('reading_day') }},

        {{ clean_numeric('reading_hour') }},

        {{ clean_upper_column('season') }},

        ------------------------------------------------------------------------
        -- Mesures de consommation
        ------------------------------------------------------------------------

        {{ clean_numeric('energy_consumed_kwh') }},

        {{ clean_numeric('peak_kwh') }},

        {{ clean_numeric('off_peak_kwh') }},

        {{ clean_numeric('reactive_energy_kvarh') }},

        ------------------------------------------------------------------------
        -- Mesures électriques
        ------------------------------------------------------------------------

        {{ clean_numeric('voltage') }},

        {{ clean_numeric('electric_current') }},

        {{ clean_numeric('power_factor') }},

        {{ clean_numeric('temperature') }},

        {{ clean_numeric('co2_emission_kg') }},

        {{ to_boolean('estimated_reading') }},

        {{ clean_numeric('outage_minutes') }},

        {{ clean_upper_column('quality_flag') }},

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
        -- Type de lecture
        ------------------------------------------------------------------------

        CASE
            WHEN estimated_reading THEN 'ESTIMATED'
            ELSE 'ACTUAL'
        END AS reading_type,

        ------------------------------------------------------------------------
        -- Présence d'une consommation
        ------------------------------------------------------------------------

        CASE
            WHEN energy_consumed_kwh > 0 THEN TRUE
            ELSE FALSE
        END AS has_consumption,

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