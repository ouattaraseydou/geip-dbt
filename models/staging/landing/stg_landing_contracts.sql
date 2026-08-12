{{ config(materialized='view') }}

 /*
==============================================================================
MODEL : stg_landing_contracts

DESCRIPTION :
Nettoyage, déduplication et standardisation
des contrats provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données des contrats
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

    FROM {{ source('landing', 'CONTRACTS') }}

),

deduplicated AS (

    --------------------------------------------------------------------------
    -- Conservation de la dernière version du contrat
    --------------------------------------------------------------------------

    SELECT *

    FROM source

    QUALIFY ROW_NUMBER() OVER (

        PARTITION BY contract_id

        ORDER BY
            updated_at DESC,
            created_at DESC

    ) = 1

),

cleaned AS (

    --------------------------------------------------------------------------
    -- Nettoyage et standardisation
    --------------------------------------------------------------------------

    SELECT

        ----------------------------------------------------------------------
        -- Clés
        ----------------------------------------------------------------------

        contract_sk,

        {{ clean_column('contract_id') }},

        {{ clean_column('customer_id') }},

        ----------------------------------------------------------------------
        -- Informations contrat
        ----------------------------------------------------------------------

        {{ clean_upper_column('contract_type') }},

        {{ clean_upper_column('energy_type') }},

        {{ clean_column('tariff_name') }},

        {{ clean_upper_column('contract_status') }},

        ----------------------------------------------------------------------
        -- Dates
        ----------------------------------------------------------------------

        {{ to_date('start_date') }},

        {{ to_date('end_date') }},

        ----------------------------------------------------------------------
        -- Informations financières
        ----------------------------------------------------------------------

        {{ clean_numeric('monthly_fee') }},

        {{ clean_numeric('estimated_annual_consumption') }},

        ----------------------------------------------------------------------
        -- Options
        ----------------------------------------------------------------------

        {{ to_boolean('renewable_energy') }},

        {{ clean_upper_column('payment_frequency') }},

        {{ clean_upper_column('payment_method') }},

        ----------------------------------------------------------------------
        -- Fournisseur
        ----------------------------------------------------------------------

        {{ clean_column('supplier_name') }},

        {{ clean_upper_column('country') }},

        ----------------------------------------------------------------------
        -- Audit
        ----------------------------------------------------------------------

        {{ to_timestamp('created_at') }},

        {{ to_timestamp('updated_at') }},

        {{ current_load_timestamp() }} AS dbt_loaded_at

    FROM deduplicated

),

final AS (

    --------------------------------------------------------------------------
    -- Jeu de données final
    --------------------------------------------------------------------------

    SELECT *

    FROM cleaned

)

SELECT *

FROM final