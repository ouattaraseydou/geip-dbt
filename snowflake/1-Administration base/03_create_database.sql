-- =====================================================================
-- Projet      : GEIP (Global Energy Intelligence Platform)
-- Fichier     : 03_create_database.sql
-- Auteur      : Seydou Ouattara
-- Description : Création de la base de données principale
--
-- Objectif :
-- Centraliser toutes les données du projet GEIP.
--
-- Bonnes pratiques :
-- - Utiliser SYSADMIN pour créer les objets.
-- - Utiliser IF NOT EXISTS afin que le script soit réexécutable.
-- =====================================================================

-- ==========================================================
-- Utilisation du rôle SYSADMIN
-- ==========================================================

USE ROLE SYSADMIN;

-- ==========================================================
-- Création de la base de données
--
-- Cette base contiendra tous les schémas du projet :
-- LANDING
-- BRONZE
-- SILVER
-- GOLD
-- MONITORING
-- SANDBOX
-- ==========================================================

CREATE DATABASE IF NOT EXISTS GEIP_PROD
COMMENT = 'Base de données principale de la plateforme Global Energy Intelligence Platform';

-- ==========================================================
-- Vérification
-- ==========================================================

SHOW DATABASES LIKE 'GEIP_PROD';