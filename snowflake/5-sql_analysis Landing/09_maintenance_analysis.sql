/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : MAINTENANCE
    SCRIPT        : 09_maintenance_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.MAINTENANCE
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

DESC TABLE MAINTENANCE;


/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES

FROM MAINTENANCE;


/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE

    MAINTENANCE_SK doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT MAINTENANCE_SK) AS NB_MAINTENANCE_SK

FROM MAINTENANCE;


/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER

    MAINTENANCE_ID doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT MAINTENANCE_ID) AS NB_MAINTENANCE_ID

FROM MAINTENANCE;


/*==============================================================================
    5. RECHERCHE DES VALEURS NULL
==============================================================================*/

SELECT

    COUNT_IF(MAINTENANCE_ID IS NULL) AS MAINTENANCE_ID_NULL,

    COUNT_IF(METER_ID IS NULL) AS METER_ID_NULL,

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(MAINTENANCE_DATE IS NULL) AS MAINTENANCE_DATE_NULL,

    COUNT_IF(MAINTENANCE_TYPE IS NULL) AS MAINTENANCE_TYPE_NULL,

    COUNT_IF(TECHNICIAN IS NULL) AS TECHNICIAN_NULL,

    COUNT_IF(PRIORITY IS NULL) AS PRIORITY_NULL,

    COUNT_IF(STATUS IS NULL) AS STATUS_NULL,

    COUNT_IF(MAINTENANCE_COST IS NULL) AS MAINTENANCE_COST_NULL,

    COUNT_IF(RESULT IS NULL) AS RESULT_NULL,

    COUNT_IF(CREATED_AT IS NULL) AS CREATED_AT_NULL

FROM MAINTENANCE;


/*==============================================================================
    6. RECHERCHE DES DOUBLONS
==============================================================================*/

SELECT

    MAINTENANCE_ID,

    COUNT(*) AS NB

FROM MAINTENANCE

GROUP BY MAINTENANCE_ID

HAVING COUNT(*) > 1;


/*==============================================================================
    7. RECHERCHE DES ESPACES
==============================================================================*/

SELECT *

FROM MAINTENANCE

WHERE

       MAINTENANCE_ID <> TRIM(MAINTENANCE_ID)

    OR METER_ID <> TRIM(METER_ID)

    OR CONTRACT_ID <> TRIM(CONTRACT_ID)

    OR MAINTENANCE_TYPE <> TRIM(MAINTENANCE_TYPE)

    OR TECHNICIAN <> TRIM(TECHNICIAN)

    OR PRIORITY <> TRIM(PRIORITY)

    OR STATUS <> TRIM(STATUS)

    OR RESULT <> TRIM(RESULT);


/*==============================================================================
    8. ANALYSE DES TYPES DE MAINTENANCE
==============================================================================*/

SELECT

    MAINTENANCE_TYPE,

    COUNT(*) AS NB

FROM MAINTENANCE

GROUP BY MAINTENANCE_TYPE

ORDER BY NB DESC;


/*==============================================================================
    9. ANALYSE DES PRIORITÉS
==============================================================================*/

SELECT

    PRIORITY,

    COUNT(*) AS NB

FROM MAINTENANCE

GROUP BY PRIORITY

ORDER BY NB DESC;


/*==============================================================================
    10. ANALYSE DES STATUTS
==============================================================================*/

SELECT

    STATUS,

    COUNT(*) AS NB

FROM MAINTENANCE

GROUP BY STATUS

ORDER BY NB DESC;


/*==============================================================================
    11. ANALYSE DES RÉSULTATS
==============================================================================*/

SELECT

    RESULT,

    COUNT(*) AS NB

FROM MAINTENANCE

GROUP BY RESULT

ORDER BY NB DESC;


/*==============================================================================
    12. ANALYSE DES DURÉES ET DES COÛTS
==============================================================================*/

SELECT

    MIN(DURATION_HOURS) AS MIN_DURATION,

    MAX(DURATION_HOURS) AS MAX_DURATION,

    AVG(DURATION_HOURS) AS DUREE_MOYENNE,

    MIN(MAINTENANCE_COST) AS MIN_COST,

    MAX(MAINTENANCE_COST) AS MAX_COST,

    AVG(MAINTENANCE_COST) AS COUT_MOYEN

FROM MAINTENANCE;


/*==============================================================================
    13. ANALYSE DES DATES
==============================================================================*/

SELECT

    MIN(MAINTENANCE_DATE) AS PREMIERE_MAINTENANCE,

    MAX(MAINTENANCE_DATE) AS DERNIERE_MAINTENANCE

FROM MAINTENANCE;


/*==============================================================================
    14. RÈGLE MÉTIER

    Une maintenance terminée doit posséder un résultat.
==============================================================================*/

SELECT *

FROM MAINTENANCE

WHERE

    STATUS='Completed'

AND

    RESULT IS NULL;


/*==============================================================================
    15. RÈGLE MÉTIER

    La durée d'intervention doit être positive.
==============================================================================*/

SELECT *

FROM MAINTENANCE

WHERE DURATION_HOURS <= 0;


/*==============================================================================
    16. RÈGLE MÉTIER

    Le coût de maintenance doit être positif.
==============================================================================*/

SELECT *

FROM MAINTENANCE

WHERE MAINTENANCE_COST < 0;


/*==============================================================================
    17. VÉRIFICATION DE LA RELATION AVEC METERS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM MAINTENANCE mt

LEFT JOIN METERS m

ON mt.METER_ID = m.METER_ID

WHERE m.METER_ID IS NULL;


/*==============================================================================
    18. VÉRIFICATION DE LA RELATION AVEC CONTRACTS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM MAINTENANCE mt

LEFT JOIN CONTRACTS c

ON mt.CONTRACT_ID = c.CONTRACT_ID

WHERE c.CONTRACT_ID IS NULL;


/*==============================================================================
    19. ANALYSE MÉTIER

    Coût moyen par type de maintenance.
==============================================================================*/

SELECT

    MAINTENANCE_TYPE,

    ROUND(AVG(MAINTENANCE_COST),2) AS COUT_MOYEN

FROM MAINTENANCE

GROUP BY MAINTENANCE_TYPE

ORDER BY COUT_MOYEN DESC;


/*==============================================================================
    20. ANALYSE MÉTIER

    Durée moyenne par type de maintenance.
==============================================================================*/

SELECT

    MAINTENANCE_TYPE,

    ROUND(AVG(DURATION_HOURS),2) AS DUREE_MOYENNE

FROM MAINTENANCE

GROUP BY MAINTENANCE_TYPE

ORDER BY DUREE_MOYENNE DESC;


/*==============================================================================
    21. ANALYSE MÉTIER

    Coût moyen par priorité.
==============================================================================*/

SELECT

    PRIORITY,

    ROUND(AVG(MAINTENANCE_COST),2) AS COUT_MOYEN

FROM MAINTENANCE

GROUP BY PRIORITY

ORDER BY COUT_MOYEN DESC;


/*==============================================================================
    22. ANALYSE MÉTIER

    Top 10 des techniciens ayant réalisé le plus
    d'interventions.
==============================================================================*/

SELECT

    TECHNICIAN,

    COUNT(*) AS NB_INTERVENTIONS

FROM MAINTENANCE

GROUP BY TECHNICIAN

ORDER BY NB_INTERVENTIONS DESC

LIMIT 10;


/*==============================================================================
    23. ANALYSE MÉTIER

    Top 10 des interventions les plus coûteuses.
==============================================================================*/

SELECT

    MAINTENANCE_ID,

    TECHNICIAN,

    MAINTENANCE_TYPE,

    MAINTENANCE_COST

FROM MAINTENANCE

ORDER BY MAINTENANCE_COST DESC

LIMIT 10;


/*==============================================================================
    24. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM MAINTENANCE

LIMIT 10;


/*==============================================================================
    25. CONCLUSION

    □ Clé technique validée

    □ Clé métier validée

    □ Valeurs NULL analysées

    □ Doublons vérifiés

    □ Espaces détectés

    □ Relations vérifiées

    □ Règles métier validées

    □ Tests dbt identifiés

    □ Colonnes à nettoyer

    □ Colonnes métier à créer

==============================================================================*/