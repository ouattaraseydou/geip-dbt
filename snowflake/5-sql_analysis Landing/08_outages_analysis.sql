/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : OUTAGES
    SCRIPT        : 08_outages_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.OUTAGES
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

DESC TABLE OUTAGES;


/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES
==============================================================================*/

SELECT COUNT(*) AS NB_LIGNES
FROM OUTAGES;


/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT OUTAGE_SK) AS NB_OUTAGE_SK

FROM OUTAGES;


/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT OUTAGE_ID) AS NB_OUTAGE_ID

FROM OUTAGES;


/*==============================================================================
    5. RECHERCHE DES VALEURS NULL
==============================================================================*/

SELECT

    COUNT_IF(OUTAGE_ID IS NULL) AS OUTAGE_ID_NULL,

    COUNT_IF(METER_ID IS NULL) AS METER_ID_NULL,

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(OUTAGE_START IS NULL) AS OUTAGE_START_NULL,

    COUNT_IF(OUTAGE_END IS NULL) AS OUTAGE_END_NULL,

    COUNT_IF(CAUSE IS NULL) AS CAUSE_NULL,

    COUNT_IF(SEVERITY IS NULL) AS SEVERITY_NULL,

    COUNT_IF(STATUS IS NULL) AS STATUS_NULL

FROM OUTAGES;


/*==============================================================================
    6. RECHERCHE DES DOUBLONS
==============================================================================*/

SELECT

    OUTAGE_ID,

    COUNT(*) AS NB

FROM OUTAGES

GROUP BY OUTAGE_ID

HAVING COUNT(*) > 1;


/*==============================================================================
    7. RECHERCHE DES ESPACES
==============================================================================*/

SELECT *

FROM OUTAGES

WHERE

       OUTAGE_ID <> TRIM(OUTAGE_ID)

    OR METER_ID <> TRIM(METER_ID)

    OR CONTRACT_ID <> TRIM(CONTRACT_ID)

    OR CAUSE <> TRIM(CAUSE)

    OR SEVERITY <> TRIM(SEVERITY)

    OR STATUS <> TRIM(STATUS);


/*==============================================================================
    8. ANALYSE DES CAUSES
==============================================================================*/

SELECT

    CAUSE,

    COUNT(*) AS NB

FROM OUTAGES

GROUP BY CAUSE

ORDER BY NB DESC;


/*==============================================================================
    9. ANALYSE DE LA SÉVÉRITÉ
==============================================================================*/

SELECT

    SEVERITY,

    COUNT(*) AS NB

FROM OUTAGES

GROUP BY SEVERITY

ORDER BY NB DESC;


/*==============================================================================
    10. ANALYSE DES STATUTS
==============================================================================*/

SELECT

    STATUS,

    COUNT(*) AS NB

FROM OUTAGES

GROUP BY STATUS

ORDER BY NB DESC;


/*==============================================================================
    11. ANALYSE DES DURÉES
==============================================================================*/

SELECT

    MIN(DURATION_MINUTES) AS MIN_DURATION,

    MAX(DURATION_MINUTES) AS MAX_DURATION,

    AVG(DURATION_MINUTES) AS MOYENNE_DURATION

FROM OUTAGES;


/*==============================================================================
    12. ANALYSE DU NOMBRE DE CLIENTS IMPACTÉS
==============================================================================*/

SELECT

    MIN(AFFECTED_CUSTOMERS) AS MIN_CLIENTS,

    MAX(AFFECTED_CUSTOMERS) AS MAX_CLIENTS,

    AVG(AFFECTED_CUSTOMERS) AS MOYENNE_CLIENTS

FROM OUTAGES;


/*==============================================================================
    13. RÈGLE MÉTIER

    Une panne doit se terminer après son début.
==============================================================================*/

SELECT *

FROM OUTAGES

WHERE OUTAGE_END < OUTAGE_START;


/*==============================================================================
    14. RÈGLE MÉTIER

    Vérifier la cohérence de DURATION_MINUTES.
==============================================================================*/

SELECT *

FROM OUTAGES

WHERE

DATEDIFF(
    minute,
    OUTAGE_START,
    OUTAGE_END
)

<> DURATION_MINUTES;


/*==============================================================================
    15. RÈGLE MÉTIER

    Une panne résolue doit posséder une date de fin.
==============================================================================*/

SELECT *

FROM OUTAGES

WHERE

    STATUS='Resolved'

AND

    OUTAGE_END IS NULL;


/*==============================================================================
    16. RÈGLE MÉTIER

    Le nombre de clients impactés doit être positif.
==============================================================================*/

SELECT *

FROM OUTAGES

WHERE AFFECTED_CUSTOMERS < 0;


/*==============================================================================
    17. VÉRIFICATION DE LA RELATION AVEC METERS
==============================================================================*/

SELECT

COUNT(*) AS NB_ORPHELINS

FROM OUTAGES o

LEFT JOIN METERS m

ON o.METER_ID=m.METER_ID

WHERE m.METER_ID IS NULL;


/*==============================================================================
    18. VÉRIFICATION DE LA RELATION AVEC CONTRACTS
==============================================================================*/

SELECT

COUNT(*) AS NB_ORPHELINS

FROM OUTAGES o

LEFT JOIN CONTRACTS c

ON o.CONTRACT_ID=c.CONTRACT_ID

WHERE c.CONTRACT_ID IS NULL;


/*==============================================================================
    19. ANALYSE MÉTIER

    Durée moyenne par cause
==============================================================================*/

SELECT

    CAUSE,

    ROUND(AVG(DURATION_MINUTES),2) AS DUREE_MOYENNE_MIN

FROM OUTAGES

GROUP BY CAUSE

ORDER BY DUREE_MOYENNE_MIN DESC;


/*==============================================================================
    20. ANALYSE MÉTIER

    Nombre moyen de clients impactés par cause
==============================================================================*/

SELECT

    CAUSE,

    ROUND(AVG(AFFECTED_CUSTOMERS),0) AS CLIENTS_MOYENS

FROM OUTAGES

GROUP BY CAUSE

ORDER BY CLIENTS_MOYENS DESC;


/*==============================================================================
    21. ANALYSE MÉTIER

    Durée moyenne par niveau de sévérité
==============================================================================*/

SELECT

    SEVERITY,

    ROUND(AVG(DURATION_MINUTES),2) AS DUREE_MOYENNE

FROM OUTAGES

GROUP BY SEVERITY

ORDER BY DUREE_MOYENNE DESC;


/*==============================================================================
    22. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM OUTAGES

LIMIT 10;


/*==============================================================================
    23. CONCLUSION

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