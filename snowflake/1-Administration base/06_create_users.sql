-- ==========================================================
-- Création des utilisateurs
-- ==========================================================

USE ROLE USERADMIN;

-- ----------------------------------------------------------
-- Utilisateur Data Engineer
-- ----------------------------------------------------------

CREATE USER SEYDOU
PASSWORD = 'Password123!'
DEFAULT_ROLE = DATA_ENGINEER
DEFAULT_WAREHOUSE = INGEST_WH
MUST_CHANGE_PASSWORD = TRUE;

-- ----------------------------------------------------------
-- Utilisateur BI Analyst
-- ----------------------------------------------------------

CREATE USER ALICE
PASSWORD = 'Password456!'
DEFAULT_ROLE = BI_ANALYST
DEFAULT_WAREHOUSE = BI_WH
MUST_CHANGE_PASSWORD = TRUE;

-- ----------------------------------------------------------
-- Utilisateur Data Scientist
-- ----------------------------------------------------------

CREATE USER BOB
PASSWORD = 'Password789!'
DEFAULT_ROLE = DATA_SCIENTIST
DEFAULT_WAREHOUSE = ML_WH
MUST_CHANGE_PASSWORD = TRUE;


- ----------------------------------------------------------
-- Utilisateur DBT_SERVICE
-- ----------------------------------------------------------


CREATE USER DBT_SERVICE
PASSWORD = 'TempPass987!'
DEFAULT_ROLE = DBT_ROLE
DEFAULT_WAREHOUSE = DBT_WH
MUST_CHANGE_PASSWORD = TRUE;