/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : METERS
    SCRIPT        : 03_meters_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.METERS
    avant la création du modèle dbt STAGING.

    Cette analyse permet de :

    - Comprendre la structure de la table
    - Identifier les clés techniques et métiers
    - Vérifier la qualité des données
    - Détecter les valeurs NULL
    - Détecter les doublons
    - Identifier les colonnes à nettoyer
    - Préparer les tests dbt
==============================================================================*/

USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;


/*==============================================================================
    1. STRUCTURE DE LA TABLE
==============================================================================*/

DESC TABLE METERS;



/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES

FROM METERS;



/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE

    METER_SK doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT METER_SK) AS NB_METER_SK

FROM METERS;



/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER

    METER_ID doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT METER_ID) AS NB_METER_ID

FROM METERS;



/*==============================================================================
    5. RECHERCHE DES VALEURS NULL
==============================================================================*/

SELECT

    COUNT_IF(METER_ID IS NULL) AS METER_ID_NULL,

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(SERIAL_NUMBER IS NULL) AS SERIAL_NUMBER_NULL,

    COUNT_IF(METER_TYPE IS NULL) AS METER_TYPE_NULL,

    COUNT_IF(MANUFACTURER IS NULL) AS MANUFACTURER_NULL,

    COUNT_IF(INSTALLATION_DATE IS NULL) AS INSTALLATION_DATE_NULL,

    COUNT_IF(METER_STATUS IS NULL) AS METER_STATUS_NULL,

    COUNT_IF(CREATED_AT IS NULL) AS CREATED_AT_NULL

FROM METERS;



/*==============================================================================
    6. RECHERCHE DES DOUBLONS
==============================================================================*/

SELECT

    METER_ID,

    COUNT(*) AS NB

FROM METERS

GROUP BY METER_ID

HAVING COUNT(*) > 1;



/*==============================================================================
    7. RECHERCHE DES ESPACES
==============================================================================*/

SELECT *

FROM METERS

WHERE METER_ID <> TRIM(METER_ID);



/*==============================================================================
    8. ANALYSE DES TYPES DE COMPTEURS
==============================================================================*/

SELECT

    METER_TYPE,

    COUNT(*) AS NB

FROM METERS

GROUP BY METER_TYPE

ORDER BY NB DESC;



/*==============================================================================
    9. ANALYSE DU STATUT DES COMPTEURS
==============================================================================*/

SELECT

    METER_STATUS,

    COUNT(*) AS NB

FROM METERS

GROUP BY METER_STATUS

ORDER BY NB DESC;



/*==============================================================================
    10. ANALYSE DU TYPE DE COMMUNICATION
==============================================================================*/

SELECT

    COMMUNICATION_TYPE,

    COUNT(*) AS NB

FROM METERS

GROUP BY COMMUNICATION_TYPE

ORDER BY NB DESC;



/*==============================================================================
    11. ANALYSE DES DATES
==============================================================================*/

SELECT

    MIN(INSTALLATION_DATE) AS PREMIERE_INSTALLATION,

    MAX(INSTALLATION_DATE) AS DERNIERE_INSTALLATION,

    MIN(LAST_CALIBRATION_DATE) AS PREMIERE_CALIBRATION,

    MAX(LAST_CALIBRATION_DATE) AS DERNIERE_CALIBRATION

FROM METERS;



/*==============================================================================
    12. ANALYSE DES VALEURS NUMÉRIQUES
==============================================================================*/

SELECT

    MIN(MAX_POWER_KW) AS MIN_POWER,

    MAX(MAX_POWER_KW) AS MAX_POWER,

    MIN(LATITUDE) AS MIN_LATITUDE,

    MAX(LATITUDE) AS MAX_LATITUDE,

    MIN(LONGITUDE) AS MIN_LONGITUDE,

    MAX(LONGITUDE) AS MAX_LONGITUDE

FROM METERS;



/*==============================================================================
    13. VÉRIFICATION DE LA RELATION AVEC CONTRACTS

    Vérifier que tous les CONTRACT_ID existent.
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM METERS m

LEFT JOIN CONTRACTS c

ON m.CONTRACT_ID = c.CONTRACT_ID

WHERE c.CONTRACT_ID IS NULL;



/*==============================================================================
    14. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM METERS

LIMIT 10;



/*==============================================================================
    15. CONCLUSION

    □ Clé technique valide

    □ Clé métier valide

    □ Doublons

    □ Valeurs NULL

    □ Espaces à supprimer

    □ Tests NOT NULL

    □ Tests UNIQUE

    □ Tests RELATIONSHIPS

    □ Tests ACCEPTED_VALUES

    □ Colonnes à nettoyer

    □ Colonnes métier à créer dans STAGING

==============================================================================*/