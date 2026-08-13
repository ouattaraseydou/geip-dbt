-- =====================================================================
-- Projet      : GEIP (Global Energy Intelligence Platform)
-- Fichier     : 04_create_schemas.sql
-- Auteur      : Seydou Ouattara
-- Description : Création des schémas de la plateforme
--
-- Objectif :
-- Organiser les données selon l'architecture Medallion.
--
-- Schémas :
-- LANDING     : Zone d'arrivée des fichiers
-- BRONZE      : Données brutes
-- SILVER      : Données nettoyées
-- GOLD        : Données métier
-- SANDBOX     : Zone de travail des développeurs
-- MONITORING  : Logs, audit et supervision
-- =====================================================================

-- ==========================================================
-- Utilisation du rôle SYSADMIN
-- ==========================================================

USE ROLE SYSADMIN;

-- ==========================================================
-- Sélection de la base de données
-- ==========================================================

USE DATABASE GEIP_PROD;

-- ==========================================================
-- Création des schémas
-- ==========================================================

CREATE SCHEMA IF NOT EXISTS LANDING
COMMENT='Zone d''arrivée des données sources';

CREATE SCHEMA IF NOT EXISTS BRONZE
COMMENT='Données brutes importées';

CREATE SCHEMA IF NOT EXISTS SILVER
COMMENT='Données nettoyées et enrichies';

CREATE SCHEMA IF NOT EXISTS GOLD
COMMENT='Données métier prêtes pour la BI';

CREATE SCHEMA IF NOT EXISTS SANDBOX
COMMENT='Zone de développement et de tests';

CREATE SCHEMA IF NOT EXISTS MONITORING
COMMENT='Logs, supervision et audit';

-- ==========================================================
-- Vérification
-- ==========================================================

SHOW SCHEMAS;