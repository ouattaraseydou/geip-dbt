/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : CUSTOMER_SERVICE
    SCRIPT        : 07_customer_service_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.CUSTOMER_SERVICE
    avant la création du modèle dbt STAGING.

    Cette analyse permet de :

    - Comprendre la structure de la table
    - Identifier les clés techniques et métiers
    - Vérifier la qualité des données
    - Détecter les valeurs NULL
    - Détecter les doublons
    - Identifier les colonnes à nettoyer
    - Vérifier les règles métier
    - Préparer les tests dbt
==============================================================================*/

USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;


/*==============================================================================
    1. STRUCTURE DE LA TABLE
==============================================================================*/

DESC TABLE CUSTOMER_SERVICE;


/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES
==============================================================================*/

SELECT COUNT(*) AS NB_LIGNES
FROM CUSTOMER_SERVICE;


/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT TICKET_SK) AS NB_TICKET_SK

FROM CUSTOMER_SERVICE;


/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT TICKET_ID) AS NB_TICKET_ID

FROM CUSTOMER_SERVICE;


/*==============================================================================
    5. RECHERCHE DES VALEURS NULL
==============================================================================*/

SELECT

    COUNT_IF(TICKET_ID IS NULL) AS TICKET_ID_NULL,

    COUNT_IF(CUSTOMER_ID IS NULL) AS CUSTOMER_ID_NULL,

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(TICKET_DATE IS NULL) AS TICKET_DATE_NULL,

    COUNT_IF(TICKET_TYPE IS NULL) AS TICKET_TYPE_NULL,

    COUNT_IF(PRIORITY IS NULL) AS PRIORITY_NULL,

    COUNT_IF(STATUS IS NULL) AS STATUS_NULL,

    COUNT_IF(CREATED_AT IS NULL) AS CREATED_AT_NULL

FROM CUSTOMER_SERVICE;


/*==============================================================================
    6. RECHERCHE DES DOUBLONS
==============================================================================*/

SELECT

    TICKET_ID,

    COUNT(*) AS NB

FROM CUSTOMER_SERVICE

GROUP BY TICKET_ID

HAVING COUNT(*) > 1;


/*==============================================================================
    7. RECHERCHE DES ESPACES
==============================================================================*/

SELECT *

FROM CUSTOMER_SERVICE

WHERE

       TICKET_ID <> TRIM(TICKET_ID)

    OR CUSTOMER_ID <> TRIM(CUSTOMER_ID)

    OR CONTRACT_ID <> TRIM(CONTRACT_ID)

    OR TICKET_TYPE <> TRIM(TICKET_TYPE)

    OR PRIORITY <> TRIM(PRIORITY)

    OR STATUS <> TRIM(STATUS)

    OR CHANNEL <> TRIM(CHANNEL)

    OR ASSIGNED_TEAM <> TRIM(ASSIGNED_TEAM)

    OR RESULT <> TRIM(RESULT);


/*==============================================================================
    8. ANALYSE DES TYPES DE TICKET
==============================================================================*/

SELECT

    TICKET_TYPE,

    COUNT(*) AS NB

FROM CUSTOMER_SERVICE

GROUP BY TICKET_TYPE

ORDER BY NB DESC;


/*==============================================================================
    9. ANALYSE DES PRIORITÉS
==============================================================================*/

SELECT

    PRIORITY,

    COUNT(*) AS NB

FROM CUSTOMER_SERVICE

GROUP BY PRIORITY

ORDER BY NB DESC;


/*==============================================================================
    10. ANALYSE DES STATUTS
==============================================================================*/

SELECT

    STATUS,

    COUNT(*) AS NB

FROM CUSTOMER_SERVICE

GROUP BY STATUS

ORDER BY NB DESC;


/*==============================================================================
    11. ANALYSE DES CANAUX
==============================================================================*/

SELECT

    CHANNEL,

    COUNT(*) AS NB

FROM CUSTOMER_SERVICE

GROUP BY CHANNEL

ORDER BY NB DESC;


/*==============================================================================
    12. ANALYSE DES DATES
==============================================================================*/

SELECT

    MIN(TICKET_DATE) AS PREMIER_TICKET,

    MAX(TICKET_DATE) AS DERNIER_TICKET

FROM CUSTOMER_SERVICE;


/*==============================================================================
    13. ANALYSE DES TEMPS DE RÉSOLUTION
==============================================================================*/

SELECT

    MIN(RESOLUTION_TIME_HOURS) AS MIN_RESOLUTION,

    MAX(RESOLUTION_TIME_HOURS) AS MAX_RESOLUTION,

    AVG(RESOLUTION_TIME_HOURS) AS MOYENNE_RESOLUTION

FROM CUSTOMER_SERVICE;


/*==============================================================================
    14. ANALYSE DE LA SATISFACTION CLIENT
==============================================================================*/

SELECT

    MIN(SATISFACTION_SCORE) AS MIN_SCORE,

    MAX(SATISFACTION_SCORE) AS MAX_SCORE,

    AVG(SATISFACTION_SCORE) AS SCORE_MOYEN

FROM CUSTOMER_SERVICE;


/*==============================================================================
    15. RÈGLE MÉTIER

    Un ticket "Resolved" doit posséder
    un temps de résolution.
==============================================================================*/

SELECT *

FROM CUSTOMER_SERVICE

WHERE

    STATUS = 'Resolved'

AND

    RESOLUTION_TIME_HOURS IS NULL;


/*==============================================================================
    16. RÈGLE MÉTIER

    Vérifier que le score de satisfaction
    est compris entre 1 et 5.
==============================================================================*/

SELECT *

FROM CUSTOMER_SERVICE

WHERE

    SATISFACTION_SCORE < 1

OR

    SATISFACTION_SCORE > 5;


/*==============================================================================
    17. RÈGLE MÉTIER

    Vérifier que le temps de résolution
    est positif.
==============================================================================*/

SELECT *

FROM CUSTOMER_SERVICE

WHERE RESOLUTION_TIME_HOURS < 0;


/*==============================================================================
    18. VÉRIFICATION DE LA RELATION AVEC CUSTOMERS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM CUSTOMER_SERVICE cs

LEFT JOIN CUSTOMERS c

ON cs.CUSTOMER_ID = c.CUSTOMER_ID

WHERE c.CUSTOMER_ID IS NULL;


/*==============================================================================
    19. VÉRIFICATION DE LA RELATION AVEC CONTRACTS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM CUSTOMER_SERVICE cs

LEFT JOIN CONTRACTS c

ON cs.CONTRACT_ID = c.CONTRACT_ID

WHERE c.CONTRACT_ID IS NULL;


/*==============================================================================
    20. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM CUSTOMER_SERVICE

LIMIT 10;


/*==============================================================================
    21. CONCLUSION

    □ Clé technique valide

    □ Clé métier valide

    □ Doublons

    □ Valeurs NULL

    □ Espaces à supprimer

    □ Règles métier validées

    □ Tests NOT NULL

    □ Tests UNIQUE

    □ Tests RELATIONSHIPS

    □ Tests ACCEPTED_VALUES

    □ Colonnes à nettoyer

    □ Colonnes métier à créer dans STAGING

==============================================================================*/