-- =====================================================================
-- Projet      : GEIP (Global Energy Intelligence Platform)
-- Fichier     : 02_create_warehouses.sql
-- Auteur      : Seydou Ouattara
-- Description : Création des Warehouses Snowflake
--
-- Objectif :
-- Créer les moteurs de calcul (Compute) utilisés par les différents
-- composants de la plateforme.
--
-- Bonnes pratiques :
-- - Utiliser SYSADMIN pour créer les objets.
-- - Utiliser IF NOT EXISTS afin que le script soit réexécutable.
-- - Activer AUTO_RESUME pour un démarrage automatique.
-- - Activer AUTO_SUSPEND pour réduire les coûts.
-- =====================================================================

-- ==========================================================
-- Utilisation du rôle administrateur des objets
-- ==========================================================

USE ROLE SYSADMIN;

-- ==========================================================
-- INGEST_WH
-- Warehouse dédié à l'ingestion des données
--
-- Utilisé par :
-- - Snowpipe
-- - COPY INTO
-- - Chargement de fichiers CSV, JSON, Parquet...
-- ==========================================================

CREATE WAREHOUSE IF NOT EXISTS INGEST_WH
WITH
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- ==========================================================
-- DBT_WH
-- Warehouse dédié aux transformations dbt
--
-- Utilisé par :
-- - dbt Core
-- - dbt Cloud
-- - Création des modèles Bronze -> Silver -> Gold
-- ==========================================================

CREATE WAREHOUSE IF NOT EXISTS DBT_WH
WITH
    WAREHOUSE_SIZE = 'LARGE'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- ==========================================================
-- BI_WH
-- Warehouse dédié aux outils de Business Intelligence
--
-- Utilisé par :
-- - Power BI
-- - Tableau
-- - Looker
-- - Dashboards
-- ==========================================================

CREATE WAREHOUSE IF NOT EXISTS BI_WH
WITH
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- ==========================================================
-- ML_WH
-- Warehouse dédié au Machine Learning
--
-- Utilisé par :
-- - Snowpark
-- - Python
-- - Data Science
-- - Entraînement des modèles IA
-- ==========================================================

CREATE WAREHOUSE IF NOT EXISTS ML_WH
WITH
    WAREHOUSE_SIZE = 'LARGE'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

-- ==========================================================
-- Vérification
-- Affiche tous les Warehouses créés pour le projet GEIP
-- ==========================================================

SHOW WAREHOUSES;