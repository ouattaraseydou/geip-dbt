{{ config(
    materialized='view'
) }}

-- ============================================================================
-- MODEL       : rpt_contract_dashboard
-- LAYER       : REPORTING (GOLD)
--
-- OBJECTIF
-- --------
-- Construire une vue de synthèse des contrats destinée aux outils de
-- reporting (Power BI, Tableau, Apache Superset...).
--
-- BUSINESS PURPOSE
-- ----------------
-- Cette vue permet d'analyser :
--   • le nombre de contrats
--   • les revenus estimés
--   • les fournisseurs
--   • les types d'énergie
--   • les tarifs
--   • les modes de paiement
--   • les contrats actifs / suspendus / résiliés
--   • l'ancienneté des contrats
--   • la répartition temporelle grâce à la dimension calendrier
--
-- GRANULARITE
-- -----------
-- 1 ligne = 1 contrat
--
-- SOURCES
-- -------
-- dim_contracts
-- dim_date
--
-- DESIGN
-- ------
-- Toutes les informations calendaires proviennent exclusivement de dim_date.
-- Aucun YEAR(), MONTH() ou DATEPART() n'est calculé directement dans cette vue.
-- ============================================================================

WITH contracts AS (

    --------------------------------------------------------------------------
    -- Dimension Contrats
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ ref('dim_contracts') }}

),

calendar AS (

    --------------------------------------------------------------------------
    -- Dimension Calendrier
    --------------------------------------------------------------------------

    SELECT *

    FROM {{ ref('dim_date') }}

)

SELECT

    --------------------------------------------------------------------------
    -- Clés techniques
    --------------------------------------------------------------------------

    c.CUSTOMER_SK,

    c.CONTRACT_SK,

    c.CONTRACT_ID,

    --------------------------------------------------------------------------
    -- Clés vers la dimension Date
    --------------------------------------------------------------------------

    c.CONTRACT_START_DATE_SK,

    c.CONTRACT_END_DATE_SK,

    c.CONTRACT_CREATED_DATE_SK,

    c.CONTRACT_UPDATED_DATE_SK,

    --------------------------------------------------------------------------
    -- Informations contrat
    --------------------------------------------------------------------------

    c.CONTRACT_TYPE,

    c.ENERGY_TYPE,

    c.TARIFF_NAME,

    c.SUPPLIER_NAME,

    c.CONTRACT_STATUS,

    --------------------------------------------------------------------------
    -- Dates métier
    --------------------------------------------------------------------------

    c.CONTRACT_START_DATE,

    c.CONTRACT_END_DATE,

    c.CONTRACT_CREATED_AT,

    c.CONTRACT_UPDATED_AT,

    --------------------------------------------------------------------------
    -- Informations Calendrier
    -- Toutes ces colonnes proviennent de dim_date
    --------------------------------------------------------------------------

    d.YEAR,

    d.SEMESTER,

    d.QUARTER,

    d.MONTH,

    d.MONTH_NAME,

    d.MONTH_SHORT,

    d.WEEK_OF_YEAR,

    d.DAY,

    d.DAY_NAME,

    d.DAY_OF_WEEK,

    d.DAY_OF_YEAR,

    d.SEASON,

    d.IS_WEEKEND,

    d.IS_MONTH_START,

    d.IS_MONTH_END,

    d.IS_QUARTER_START,

    d.IS_QUARTER_END,

    d.IS_YEAR_START,

    d.IS_YEAR_END,

    --------------------------------------------------------------------------
    -- Informations financières
    --------------------------------------------------------------------------

    c.MONTHLY_FEE,

    c.ESTIMATED_ANNUAL_CONSUMPTION,

    --------------------------------------------------------------------------
    -- Informations de paiement
    --------------------------------------------------------------------------

    c.PAYMENT_METHOD,

    c.PAYMENT_FREQUENCY,

    --------------------------------------------------------------------------
    -- Localisation
    --------------------------------------------------------------------------

    c.CONTRACT_COUNTRY,

    --------------------------------------------------------------------------
    -- Energie renouvelable
    --------------------------------------------------------------------------

    c.RENEWABLE_ENERGY,

    --------------------------------------------------------------------------
    -- KPI : Revenu annuel théorique
    --------------------------------------------------------------------------

    ROUND(

        c.MONTHLY_FEE * 12,

        2

    ) AS ESTIMATED_ANNUAL_REVENUE,

    --------------------------------------------------------------------------
    -- KPI : Durée du contrat
    --------------------------------------------------------------------------

    DATEDIFF(

        DAY,

        c.CONTRACT_START_DATE,

        COALESCE(

            c.CONTRACT_END_DATE,

            CURRENT_DATE()

        )

    ) AS CONTRACT_DURATION_DAYS,

    --------------------------------------------------------------------------
    -- KPI : Ancienneté du contrat
    --------------------------------------------------------------------------

    DATEDIFF(

        DAY,

        c.CONTRACT_CREATED_AT,

        CURRENT_DATE()

    ) AS CONTRACT_AGE_DAYS,

    --------------------------------------------------------------------------
    -- KPI : Contrat actif
    --------------------------------------------------------------------------

    CASE

        WHEN c.CONTRACT_STATUS = 'ACTIVE'

        THEN TRUE

        ELSE FALSE

    END AS IS_ACTIVE,

    --------------------------------------------------------------------------
    -- KPI : Contrat suspendu
    --------------------------------------------------------------------------

    CASE

        WHEN c.CONTRACT_STATUS = 'SUSPENDED'

        THEN TRUE

        ELSE FALSE

    END AS IS_SUSPENDED,

    --------------------------------------------------------------------------
    -- KPI : Contrat résilié
    --------------------------------------------------------------------------

    CASE

        WHEN c.CONTRACT_STATUS = 'TERMINATED'

        THEN TRUE

        ELSE FALSE

    END AS IS_TERMINATED,

    --------------------------------------------------------------------------
    -- KPI : Contrat toujours valide
    --------------------------------------------------------------------------

    CASE

        WHEN c.CONTRACT_END_DATE IS NULL

             OR c.CONTRACT_END_DATE >= CURRENT_DATE()

        THEN TRUE

        ELSE FALSE

    END AS IS_VALID_CONTRACT,

    --------------------------------------------------------------------------
    -- KPI : Catégorie d'énergie
    --------------------------------------------------------------------------

    CASE

        WHEN c.RENEWABLE_ENERGY

        THEN 'Renewable'

        ELSE 'Standard'

    END AS ENERGY_CATEGORY

FROM contracts c

---------------------------------------------------------------------------
-- Jointure avec la dimension Calendrier
-- Utilisation de la date de début du contrat comme référence temporelle
---------------------------------------------------------------------------

LEFT JOIN calendar d

       ON c.CONTRACT_START_DATE_SK = d.DATE_SK