/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : CUSTOMERS
    SCRIPT        : 01_customers_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.CUSTOMERS
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


/*==============================================================================
    1. STRUCTURE DE LA TABLE
==============================================================================*/
USE DATABASE GEIP_PROD;
USE SCHEMA LANDING;
DESC TABLE LANDING.CUSTOMERS;



/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES

    Objectif :
    Vérifier le volume de données présent dans la table.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES

FROM LANDING.CUSTOMERS;



/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE

    CUSTOMER_SK doit être unique.

    Si :

        NB_LIGNES = NB_CUSTOMER_SK

    alors la clé technique est valide.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT CUSTOMER_SK) AS NB_CUSTOMER_SK

FROM LANDING.CUSTOMERS;



/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER

    CUSTOMER_ID doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT CUSTOMER_ID) AS NB_CUSTOMER_ID

FROM LANDING.CUSTOMERS;



/*==============================================================================
    5. RECHERCHE DES VALEURS NULL

    Objectif :

    Identifier les colonnes obligatoires qui devront recevoir
    un test NOT NULL dans dbt.
==============================================================================*/

SELECT

    COUNT_IF(CUSTOMER_ID IS NULL)      AS CUSTOMER_ID_NULL,

    COUNT_IF(FIRST_NAME IS NULL)       AS FIRST_NAME_NULL,

    COUNT_IF(LAST_NAME IS NULL)        AS LAST_NAME_NULL,

    COUNT_IF(EMAIL IS NULL)            AS EMAIL_NULL,

    COUNT_IF(MOBILE_PHONE IS NULL)            AS PHONE_NULL,

    COUNT_IF(CREATED_AT IS NULL)       AS CREATED_AT_NULL

FROM LANDING.CUSTOMERS;



/*==============================================================================
    6. RECHERCHE DES DOUBLONS

    Vérifier qu'il n'existe aucun doublon sur CUSTOMER_ID.
==============================================================================*/

SELECT

    CUSTOMER_ID,

    COUNT(*) AS NB

FROM LANDING.CUSTOMERS

GROUP BY CUSTOMER_ID

HAVING COUNT(*) > 1;



/*==============================================================================
    7. RECHERCHE DES ESPACES

    Vérifier si CUSTOMER_ID contient des espaces inutiles.

    Si des lignes sont retournées,
    TRIM() devra être appliqué dans dbt.
==============================================================================*/

SELECT *

FROM LANDING.CUSTOMERS

WHERE CUSTOMER_ID <> TRIM(CUSTOMER_ID);



/*==============================================================================
    8. ANALYSE DES TYPES DE CLIENTS

    Objectif :

    Identifier les valeurs possibles afin de préparer
    le test accepted_values.
==============================================================================*/

SELECT

    CUSTOMER_TYPE,

    COUNT(*) AS NB

FROM LANDING.CUSTOMERS

GROUP BY CUSTOMER_TYPE

ORDER BY NB DESC;



/*==============================================================================
    9. ANALYSE DES DATES

    Identifier la période couverte par les données.
==============================================================================*/

SELECT

    MIN(CREATED_AT) AS PREMIERE_DATE,

    MAX(CREATED_AT) AS DERNIERE_DATE

FROM LANDING.CUSTOMERS;



/*==============================================================================
    10. APERÇU DES DONNÉES

    Vérification visuelle.
==============================================================================*/

SELECT *

FROM LANDING.CUSTOMERS

LIMIT 10;



/*==============================================================================
    11. CONCLUSION

    A compléter après l'analyse.

    □ Clé technique valide

    □ Clé métier valide

    □ Doublons

    □ Valeurs NULL

    □ Espaces à supprimer

    □ Tests NOT NULL

    □ Tests UNIQUE

    □ Tests ACCEPTED_VALUES

    □ Colonnes à nettoyer

    □ Colonnes métier à créer dans le modèle STAGING

==============================================================================*/