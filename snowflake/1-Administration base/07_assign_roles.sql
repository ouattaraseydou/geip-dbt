-- ==========================================================
-- Attribution des rôles aux utilisateurs
-- ==========================================================

USE ROLE SECURITYADMIN;

GRANT ROLE DATA_ENGINEER
TO USER SEYDOU;

GRANT ROLE BI_ANALYST
TO USER ALICE;

GRANT ROLE DATA_SCIENTIST
TO USER BOB;

GRANT ROLE DBT_ROLE
TO USER DBT_SERVICE;