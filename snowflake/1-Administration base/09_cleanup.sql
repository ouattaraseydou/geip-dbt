-- =======================================================================
-- Projet      : GEIP (Global Energy Intelligence Platform)
-- Fichier     : 09_cleanup.sql
-- Auteur      : Seydou Ouattara
-- Description : Suppression de l'environnement GEIP
--
-- Objectif :
-- Supprimer les objets créés pour reconstruire
-- entièrement la plateforme.
--
-- ATTENTION :
-- Ce script supprime définitivement les objets.
-- À utiliser uniquement en environnement de développement.
-- =======================================================================

USE ROLE ACCOUNTADMIN;

-- ==========================================================
-- 1. Suppression des utilisateurs
-- ==========================================================

DROP USER IF EXISTS SEYDOU;
DROP USER IF EXISTS ALICE;
DROP USER IF EXISTS BOB;
DROP USER IF EXISTS DBT_SERVICE;

-- ==========================================================
-- 2. Suppression des rôles
-- ==========================================================

DROP ROLE IF EXISTS DATA_ENGINEER;
DROP ROLE IF EXISTS BI_ANALYST;
DROP ROLE IF EXISTS DATA_SCIENTIST;
DROP ROLE IF EXISTS DBT_ROLE;

-- ==========================================================
-- 3. Suppression des Warehouses
-- ==========================================================

DROP WAREHOUSE IF EXISTS INGEST_WH;
DROP WAREHOUSE IF EXISTS DBT_WH;
DROP WAREHOUSE IF EXISTS BI_WH;
DROP WAREHOUSE IF EXISTS ML_WH;

-- ==========================================================
-- 4. Suppression de la base de données
-- ==========================================================

DROP DATABASE IF EXISTS GEIP_PROD;