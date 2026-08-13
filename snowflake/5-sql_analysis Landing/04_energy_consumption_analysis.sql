/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : ENERGY_CONSUMPTION
    SCRIPT        : 04_energy_consumption_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.ENERGY_CONSUMPTION
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

DESC TABLE ENERGY_CONSUMPTION;


/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES

FROM ENERGY_CONSUMPTION;


/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE

    CONSUMPTION_SK doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT CONSUMPTION_SK) AS NB_CONSUMPTION_SK

FROM ENERGY_CONSUMPTION;


/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER

    Dans cette table il n'existe pas d'identifiant métier unique.

    La clé métier est :

        METER_ID + READING_DATETIME
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT
        CONCAT(
            TRIM(METER_ID),
            '|',
            TO_VARCHAR(READING_DATETIME)
        )
    ) AS NB_METER_DATETIME

FROM ENERGY_CONSUMPTION;


/*==============================================================================
    5. RECHERCHE DES VALEURS NULL
==============================================================================*/

SELECT

    COUNT_IF(METER_ID IS NULL) AS METER_ID_NULL,

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(READING_DATETIME IS NULL) AS READING_DATETIME_NULL,

    COUNT_IF(ENERGY_CONSUMED_KWH IS NULL) AS ENERGY_NULL,

    COUNT_IF(QUALITY_FLAG IS NULL) AS QUALITY_NULL,

    COUNT_IF(CREATED_AT IS NULL) AS CREATED_AT_NULL

FROM ENERGY_CONSUMPTION;


/*==============================================================================
    6. RECHERCHE DES DOUBLONS

    Vérification de la clé métier.
==============================================================================*/

SELECT

    METER_ID,

    READING_DATETIME,

    COUNT(*) AS NB

FROM ENERGY_CONSUMPTION

GROUP BY

    METER_ID,

    READING_DATETIME

HAVING COUNT(*) > 1;


/*==============================================================================
    7. RECHERCHE DES ESPACES
==============================================================================*/

SELECT *

FROM ENERGY_CONSUMPTION

WHERE

    METER_ID <> TRIM(METER_ID)

OR

    CONTRACT_ID <> TRIM(CONTRACT_ID);


/*==============================================================================
    8. ANALYSE DES SAISONS
==============================================================================*/

SELECT

    SEASON,

    COUNT(*) AS NB

FROM ENERGY_CONSUMPTION

GROUP BY SEASON

ORDER BY NB DESC;


/*==============================================================================
    9. ANALYSE DE LA QUALITÉ DES DONNÉES
==============================================================================*/

SELECT

    QUALITY_FLAG,

    COUNT(*) AS NB

FROM ENERGY_CONSUMPTION

GROUP BY QUALITY_FLAG

ORDER BY NB DESC;


/*==============================================================================
    10. ANALYSE DES DATES
==============================================================================*/

SELECT

    MIN(READING_DATETIME) AS PREMIERE_LECTURE,

    MAX(READING_DATETIME) AS DERNIERE_LECTURE

FROM ENERGY_CONSUMPTION;


/*==============================================================================
    11. ANALYSE DES VALEURS NUMÉRIQUES
==============================================================================*/

SELECT

    MIN(ENERGY_CONSUMED_KWH) AS MIN_KWH,

    MAX(ENERGY_CONSUMED_KWH) AS MAX_KWH,

    MIN(PEAK_KWH) AS MIN_PEAK,

    MAX(PEAK_KWH) AS MAX_PEAK,

    MIN(OFF_PEAK_KWH) AS MIN_OFF_PEAK,

    MAX(OFF_PEAK_KWH) AS MAX_OFF_PEAK

FROM ENERGY_CONSUMPTION;


/*==============================================================================
    12. RÈGLES MÉTIER

    Vérifier qu'il n'existe aucune consommation négative.
==============================================================================*/

SELECT *

FROM ENERGY_CONSUMPTION

WHERE ENERGY_CONSUMED_KWH < 0;


/*==============================================================================
    13. RÈGLES MÉTIER

    Vérifier que :

    PEAK_KWH + OFF_PEAK_KWH = ENERGY_CONSUMED_KWH
==============================================================================*/

SELECT *

FROM ENERGY_CONSUMPTION

WHERE ABS((PEAK_KWH + OFF_PEAK_KWH) - ENERGY_CONSUMED_KWH) > 0.01;


/*==============================================================================
    14. RÈGLES MÉTIER

    Vérifier la cohérence entre READING_DATETIME
    et les colonnes YEAR / MONTH / DAY / HOUR.
==============================================================================*/

SELECT *

FROM ENERGY_CONSUMPTION

WHERE

    YEAR(READING_DATETIME) <> READING_YEAR

OR

    MONTH(READING_DATETIME) <> READING_MONTH

OR

    DAY(READING_DATETIME) <> READING_DAY

OR

    HOUR(READING_DATETIME) <> READING_HOUR;


/*==============================================================================
    15. VÉRIFICATION DE LA RELATION AVEC METERS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM ENERGY_CONSUMPTION ec

LEFT JOIN METERS m

ON ec.METER_ID = m.METER_ID

WHERE m.METER_ID IS NULL;


/*==============================================================================
    16. VÉRIFICATION DE LA RELATION AVEC CONTRACTS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM ENERGY_CONSUMPTION ec

LEFT JOIN CONTRACTS c

ON ec.CONTRACT_ID = c.CONTRACT_ID

WHERE c.CONTRACT_ID IS NULL;


/*==============================================================================
    17. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM ENERGY_CONSUMPTION

LIMIT 10;


/*==============================================================================
    18. CONCLUSION

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