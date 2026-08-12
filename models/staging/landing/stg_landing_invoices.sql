{{ config(materialized='view') }}

/*
==============================================================================
MODEL : stg_landing_invoices

DESCRIPTION :
Nettoyage et standardisation des factures provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données de facturation pour les modèles Silver.

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

    FROM {{ source('landing', 'INVOICES') }}

),

deduplicated AS (

    ----------------------------------------------------------------------------
    -- Aucune déduplication nécessaire.
    -- INVOICE_ID est unique dans la source.
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

        invoice_sk,

        {{ clean_text('invoice_id') }} AS invoice_id,

        {{ clean_text('contract_id') }} AS contract_id,

        {{ clean_text('meter_id') }} AS meter_id,

        ------------------------------------------------------------------------
        -- Dates de facturation
        ------------------------------------------------------------------------

        {{ to_date('invoice_date') }},

        {{ to_date('billing_period_start') }},

        {{ to_date('billing_period_end') }},

        {{ to_date('due_date') }},

        {{ to_date('payment_date') }},

        ------------------------------------------------------------------------
        -- Informations de facturation
        ------------------------------------------------------------------------

        {{ clean_numeric('total_kwh') }},

        {{ clean_numeric('energy_amount') }},

        {{ clean_numeric('fixed_charge') }},

        {{ clean_numeric('tax_amount') }},

        {{ clean_numeric('total_amount') }},

        ------------------------------------------------------------------------
        -- Statut de la facture
        ------------------------------------------------------------------------

        {{ clean_upper('invoice_status') }} AS invoice_status,

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
        -- Statut de paiement
        ------------------------------------------------------------------------

        {{ invoice_flags('invoice_status') }},

        ------------------------------------------------------------------------
        -- Délai de paiement
        ------------------------------------------------------------------------

        {{ payment_terms(
            'invoice_date',
            'due_date'
        ) }} AS payment_terms_days,

        ------------------------------------------------------------------------
        -- Retard de paiement
        ------------------------------------------------------------------------

        {{ calculate_delay(
            'payment_date',
            'due_date'
        ) }} AS payment_delay_days,

        ------------------------------------------------------------------------
        -- Audit dbt
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