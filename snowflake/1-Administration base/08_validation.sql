-- =======================================================================
-- Projet      : GEIP (Global Energy Intelligence Platform)
-- Fichier     : 08_validation.sql
-- Auteur      : Seydou Ouattara
-- Description : Validation de l'environnement Snowflake
--
-- Objectif :
-- Vérifier que tous les objets de la plateforme ont été créés
-- correctement et que les permissions sont bien attribuées.
-- =======================================================================

USE ROLE ACCOUNTADMIN;

-- ==========================================================
-- 1. Vérification des bases de données
-- ==========================================================

SHOW DATABASES;

-- ==========================================================
-- 2. Vérification des schémas
-- ==========================================================

SHOW SCHEMAS IN DATABASE GEIP_PROD;

-- ==========================================================
-- 3. Vérification des rôles
-- ==========================================================

SHOW ROLES;

-- ==========================================================
-- 4. Vérification des Warehouses
-- ==========================================================

SHOW WAREHOUSES;

-- ==========================================================
-- 5. Vérification des utilisateurs
-- ==========================================================

SHOW USERS;

-- ==========================================================
-- 6. Vérification des privilèges des rôles
-- ==========================================================

SHOW GRANTS TO ROLE DATA_ENGINEER;

SHOW GRANTS TO ROLE DBT_ROLE;

SHOW GRANTS TO ROLE BI_ANALYST;

SHOW GRANTS TO ROLE DATA_SCIENTIST;

-- ==========================================================
-- 7. Vérification des privilèges sur la base de données
-- ==========================================================

SHOW GRANTS ON DATABASE GEIP_PROD;

-- ==========================================================
-- 8. Vérification des privilèges sur les schémas
-- ==========================================================

SHOW GRANTS ON SCHEMA GEIP_PROD.LANDING;

SHOW GRANTS ON SCHEMA GEIP_PROD.BRONZE;

SHOW GRANTS ON SCHEMA GEIP_PROD.SILVER;

SHOW GRANTS ON SCHEMA GEIP_PROD.GOLD;

SHOW GRANTS ON SCHEMA GEIP_PROD.SANDBOX;

SHOW GRANTS ON SCHEMA GEIP_PROD.MONITORING;