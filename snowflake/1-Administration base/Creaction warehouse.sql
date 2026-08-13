-- ============================================================
-- Création du Warehouse d'ingestion
-- ============================================================
-- Ce Warehouse est dédié aux opérations d'ingestion et de
-- chargement des données sources dans Snowflake.
--
-- MEDIUM       : capacité de calcul adaptée aux traitements
--                d'ingestion du projet GEIP.
-- AUTO_SUSPEND : suspension automatique après 60 secondes
--                d'inactivité afin de limiter les coûts.
-- AUTO_RESUME  : redémarrage automatique dès qu'une requête
--                nécessite le Warehouse.
-- INITIALLY_SUSPENDED :
--                le Warehouse est créé à l'état suspendu.
-- ============================================================

USE ROLE SYSADMIN;

CREATE WAREHOUSE IF NOT EXISTS INGEST_WH
WITH
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;