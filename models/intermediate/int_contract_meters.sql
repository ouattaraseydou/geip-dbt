{{ config(materialized='view') }}

/*
==============================================================================
MODEL : int_contract_meters

DESCRIPTION :
Association des contrats avec leurs compteurs.

BUSINESS PURPOSE :
Fournir une vue consolidée permettant d'analyser
les compteurs rattachés à chaque contrat.

LAYER :
SILVER

AUTHOR :
Ouattara Seydou
==============================================================================
*/

WITH contracts AS (

    ----------------------------------------------------------------------------
    -- Contrats
    ----------------------------------------------------------------------------

    SELECT

        contract_sk,
        contract_id,
        customer_id,
        contract_type,
        energy_type,
        contract_status,
        start_date,
        end_date,
        created_at

    FROM {{ ref('stg_landing_contracts') }}

),

meters AS (

    ----------------------------------------------------------------------------
    -- Compteurs
    ----------------------------------------------------------------------------

    SELECT

        meter_sk,
        meter_id,
        contract_id,
        serial_number,
        meter_type,
        manufacturer,
        installation_date,
        last_calibration_date,
        meter_status,
        voltage,
        phase,
        max_power_kw,
        communication_type,
        country,
        latitude,
        longitude,
        created_at

    FROM {{ ref('stg_landing_meters') }}

),

final AS (

    ----------------------------------------------------------------------------
    -- Association Contrat ↔ Compteur
    ----------------------------------------------------------------------------

    SELECT

        ------------------------------------------------------------------------
        -- Contrat
        ------------------------------------------------------------------------

        ct.contract_sk,
        ct.contract_id,
        ct.customer_id,
        ct.contract_type,
        ct.energy_type,
        ct.contract_status,
        ct.start_date,
        ct.end_date,

        ------------------------------------------------------------------------
        -- Compteur
        ------------------------------------------------------------------------

        m.meter_sk,
        m.meter_id,
        m.serial_number,
        m.meter_type,
        m.manufacturer,
        m.installation_date,
        m.last_calibration_date,
        m.meter_status,
        m.voltage,
        m.phase,
        m.max_power_kw,
        m.communication_type,
        m.country,
        m.latitude,
        m.longitude,

        ------------------------------------------------------------------------
        -- Audit
        ------------------------------------------------------------------------

        ct.created_at AS contract_created_at,
        m.created_at AS meter_created_at

    FROM contracts AS ct

    LEFT JOIN meters AS m
        ON ct.contract_id = m.contract_id

)

SELECT *

FROM final