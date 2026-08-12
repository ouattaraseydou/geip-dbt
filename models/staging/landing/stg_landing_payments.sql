/*
==============================================================================
MODEL : stg_landing_payments

DESCRIPTION :
Nettoyage et standardisation des paiements provenant de la couche Landing.

BUSINESS PURPOSE :
Préparer les données de paiement pour les modèles Silver.

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

    FROM {{ source('landing', 'PAYMENTS') }}

),

deduplicated AS (

    ----------------------------------------------------------------------------
    -- Aucune déduplication nécessaire.
    -- PAYMENT_ID est unique dans la source.
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

        payment_sk,

        {{ clean_text('payment_id') }}          AS payment_id,

        {{ clean_text('invoice_id') }}          AS invoice_id,

        {{ clean_text('contract_id') }}         AS contract_id,

        ------------------------------------------------------------------------
        -- Informations de paiement
        ------------------------------------------------------------------------

        payment_date,

        amount_paid,

        {{ clean_text('payment_method') }}      AS payment_method,

        {{ clean_upper('payment_status') }}     AS payment_status,

        {{ clean_text('transaction_reference') }} AS transaction_reference,

        {{ clean_text('bank_name') }}           AS bank_name,

        {{ clean_upper('currency') }}           AS currency,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        created_at

    FROM deduplicated

),

enriched AS (

    ----------------------------------------------------------------------------
    -- Création des indicateurs métier
    ----------------------------------------------------------------------------

    SELECT

        *,

        ------------------------------------------------------------------------
        -- Statuts de paiement
        ------------------------------------------------------------------------

        {{ payment_flags('payment_status') }},

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