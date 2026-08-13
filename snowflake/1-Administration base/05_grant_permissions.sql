-- =======================================================================
-- Projet      : GEIP (Global Energy Intelligence Platform)
-- Fichier     : 05_grant_permissions.sql
-- Auteur      : Seydou Ouattara
-- Description : Attribution des permissions aux rôles
--
-- Objectif :
-- Appliquer le principe du moindre privilège (Least Privilege).
-- Chaque rôle reçoit uniquement les droits nécessaires à son travail.
-- =====================================================================

-- ==========================================================
-- Utilisation du rôle SECURITYADMIN
-- SECURITYADMIN est responsable de l'attribution des privilèges.
-- ==========================================================

USE ROLE SECURITYADMIN;

-- ==========================================================
-- Permissions du rôle BI_ANALYST
-- ==========================================================

-- Autoriser l'accès à la base de données
GRANT USAGE
ON DATABASE GEIP_PROD
TO ROLE BI_ANALYST;

-- Autoriser l'accès au schéma GOLD
GRANT USAGE
ON SCHEMA GEIP_PROD.GOLD
TO ROLE BI_ANALYST;

-- Autoriser la lecture de toutes les tables existantes
GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE BI_ANALYST;

-- Autoriser automatiquement la lecture des futures tables
GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE BI_ANALYST;

---==================================================================================================================
---================================================================================================================

USE ROLE SECURITYADMIN;

-- ==========================================================
-- ==========================================================
-- Permissions du rôle DATA_ENGINEER
-- ==========================================================

-- Accès à la base
GRANT USAGE
ON DATABASE GEIP_PROD
TO ROLE DATA_ENGINEER;

-- Accès aux schémas
GRANT USAGE ON SCHEMA GEIP_PROD.LANDING TO ROLE DATA_ENGINEER;
GRANT USAGE ON SCHEMA GEIP_PROD.BRONZE  TO ROLE DATA_ENGINEER;
GRANT USAGE ON SCHEMA GEIP_PROD.SILVER  TO ROLE DATA_ENGINEER;
GRANT USAGE ON SCHEMA GEIP_PROD.GOLD    TO ROLE DATA_ENGINEER;

-- Création des tables uniquement dans LANDING
GRANT CREATE TABLE
ON SCHEMA GEIP_PROD.LANDING
TO ROLE DATA_ENGINEER;

-- Lecture des données
GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.LANDING
TO ROLE DATA_ENGINEER;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.LANDING
TO ROLE DATA_ENGINEER;

GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.BRONZE
TO ROLE DATA_ENGINEER;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.BRONZE
TO ROLE DATA_ENGINEER;

GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.SILVER
TO ROLE DATA_ENGINEER;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.SILVER
TO ROLE DATA_ENGINEER;

GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE DATA_ENGINEER;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE DATA_ENGINEER;

-- Chargement des données dans LANDING
GRANT INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA GEIP_PROD.LANDING
TO ROLE DATA_ENGINEER;

GRANT INSERT, UPDATE, DELETE
ON FUTURE TABLES IN SCHEMA GEIP_PROD.LANDING
TO ROLE DATA_ENGINEER;

-- Utilisation du warehouse d'ingestion
GRANT USAGE
ON WAREHOUSE INGEST_WH
TO ROLE DATA_ENGINEER;



--==============================================================================

-- ==========================================================
-- Permissions du rôle DBT_ROLE
-- ==========================================================

-- ----------------------------------------------------------
-- Accès à la base de données
-- ----------------------------------------------------------

GRANT USAGE
ON DATABASE GEIP_PROD
TO ROLE DBT_ROLE;

-- ----------------------------------------------------------
-- Accès aux schémas
-- ----------------------------------------------------------

GRANT USAGE
ON SCHEMA GEIP_PROD.LANDING
TO ROLE DBT_ROLE;

GRANT USAGE
ON SCHEMA GEIP_PROD.BRONZE
TO ROLE DBT_ROLE;

GRANT USAGE
ON SCHEMA GEIP_PROD.SILVER
TO ROLE DBT_ROLE;

GRANT USAGE
ON SCHEMA GEIP_PROD.GOLD
TO ROLE DBT_ROLE;

-- ----------------------------------------------------------
-- Lecture des données de LANDING
-- ----------------------------------------------------------

GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.LANDING
TO ROLE DBT_ROLE;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.LANDING
TO ROLE DBT_ROLE;

-- ----------------------------------------------------------
-- Gestion des objets dans BRONZE
-- ----------------------------------------------------------

GRANT CREATE TABLE
ON SCHEMA GEIP_PROD.BRONZE
TO ROLE DBT_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA GEIP_PROD.BRONZE
TO ROLE DBT_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON FUTURE TABLES IN SCHEMA GEIP_PROD.BRONZE
TO ROLE DBT_ROLE;

-- ----------------------------------------------------------
-- Gestion des objets dans SILVER
-- ----------------------------------------------------------

GRANT CREATE TABLE
ON SCHEMA GEIP_PROD.SILVER
TO ROLE DBT_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA GEIP_PROD.SILVER
TO ROLE DBT_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON FUTURE TABLES IN SCHEMA GEIP_PROD.SILVER
TO ROLE DBT_ROLE;

-- ----------------------------------------------------------
-- Gestion des objets dans GOLD
-- ----------------------------------------------------------

GRANT CREATE TABLE
ON SCHEMA GEIP_PROD.GOLD
TO ROLE DBT_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE DBT_ROLE;

GRANT SELECT, INSERT, UPDATE, DELETE
ON FUTURE TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE DBT_ROLE;

-- ----------------------------------------------------------
-- Utilisation du Warehouse dbt
-- ----------------------------------------------------------

GRANT USAGE
ON WAREHOUSE DBT_WH
TO ROLE DBT_ROLE;


--=================================================================================

-- ==========================================================
-- Permissions du rôle DATA_SCIENTIST
-- ==========================================================

-- ----------------------------------------------------------
-- Accès à la base de données
-- ----------------------------------------------------------

GRANT USAGE
ON DATABASE GEIP_PROD
TO ROLE DATA_SCIENTIST;

-- ----------------------------------------------------------
-- Accès aux schémas
-- ----------------------------------------------------------

GRANT USAGE
ON SCHEMA GEIP_PROD.BRONZE
TO ROLE DATA_SCIENTIST;

GRANT USAGE
ON SCHEMA GEIP_PROD.SILVER
TO ROLE DATA_SCIENTIST;

GRANT USAGE
ON SCHEMA GEIP_PROD.GOLD
TO ROLE DATA_SCIENTIST;

GRANT USAGE
ON SCHEMA GEIP_PROD.SANDBOX
TO ROLE DATA_SCIENTIST;

-- ----------------------------------------------------------
-- Lecture des données
-- ----------------------------------------------------------

GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.BRONZE
TO ROLE DATA_SCIENTIST;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.BRONZE
TO ROLE DATA_SCIENTIST;

GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.SILVER
TO ROLE DATA_SCIENTIST;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.SILVER
TO ROLE DATA_SCIENTIST;

GRANT SELECT
ON ALL TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE DATA_SCIENTIST;

GRANT SELECT
ON FUTURE TABLES IN SCHEMA GEIP_PROD.GOLD
TO ROLE DATA_SCIENTIST;

-- ----------------------------------------------------------
-- Création d'objets dans SANDBOX
-- ----------------------------------------------------------

GRANT CREATE TABLE
ON SCHEMA GEIP_PROD.SANDBOX
TO ROLE DATA_SCIENTIST;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA GEIP_PROD.SANDBOX
TO ROLE DATA_SCIENTIST;

GRANT SELECT, INSERT, UPDATE, DELETE
ON FUTURE TABLES IN SCHEMA GEIP_PROD.SANDBOX
TO ROLE DATA_SCIENTIST;

-- ----------------------------------------------------------
-- Utilisation du Warehouse Machine Learning
-- ----------------------------------------------------------

GRANT USAGE
ON WAREHOUSE ML_WH
TO ROLE DATA_SCIENTIST;