-- ==========================================================
-- Projet : GEIP (Global Energy Intelligence Platform)
-- Script : 01_create_roles.sql
-- Auteur : Seydou Ouattara
-- Description : Création des rôles métier
-- ==========================================================
USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS DATA_ENGINEER;
CREATE ROLE IF NOT EXISTS BI_ANALYST;
CREATE ROLE IF NOT EXISTS DATA_SCIENTIST;
CREATE ROLE IF NOT EXISTS DBT_ROLE;


SHOW ROLES;

SHOW ROLES LIKE '%DATA%';

