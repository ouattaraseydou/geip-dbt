
-- ============================================================
-- Vérification du rôle de sécurité actif
-- ============================================================
-- SECURITYADMIN est le rôle Snowflake dédié à la gestion des
-- rôles, des privilèges et des politiques de sécurité.
--
-- CURRENT_ROLE() permet de vérifier que la session utilise bien
-- le rôle attendu avant d'effectuer des opérations de sécurité.
-- Cette vérification permet d'éviter d'exécuter une commande
-- avec un rôle inapproprié.
-- ============================================================

USE ROLE SECURITYADMIN;

SELECT CURRENT_ROLE();
