/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : CONTRACTS
    SCRIPT        : 02_contracts_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.CONTRACTS
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
DESC TABLE LANDING.CONTRACTS;



/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES

    Objectif :
    Vérifier le volume de données.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES

FROM LANDING.CONTRACTS;



/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE

    CONTRACT_SK doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT CONTRACT_SK) AS NB_CONTRACT_SK

FROM LANDING.CONTRACTS;



/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER

    CONTRACT_ID doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT CONTRACT_ID) AS NB_CONTRACT_ID

FROM LANDING.CONTRACTS;



/*==============================================================================
    5. RECHERCHE DES VALEURS NULL

    Objectif :

    Identifier les colonnes qui devront recevoir
    un test NOT NULL.
==============================================================================*/

SELECT

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(CUSTOMER_ID IS NULL) AS CUSTOMER_ID_NULL,

    COUNT_IF(CONTRACT_TYPE IS NULL) AS CONTRACT_TYPE_NULL,

    COUNT_IF(CONTRACT_STATUS IS NULL) AS CONTRACT_STATUS_NULL,

    COUNT_IF(ENERGY_TYPE IS NULL) AS ENERGY_TYPE_NULL,

    COUNT_IF(PAYMENT_FREQUENCY IS NULL) AS PAYMENT_FREQUENCY_NULL,

    COUNT_IF(CREATED_AT IS NULL) AS CREATED_AT_NULL

FROM LANDING.CONTRACTS;



/*==============================================================================
    6. RECHERCHE DES DOUBLONS

    Vérifier qu'il n'existe aucun doublon
    sur CONTRACT_ID.
==============================================================================*/

SELECT

    CONTRACT_ID,

    COUNT(*) AS NB

FROM LANDING.CONTRACTS

GROUP BY CONTRACT_ID

HAVING COUNT(*) > 1;



/*==============================================================================
    7. RECHERCHE DES ESPACES

    Vérifier si CONTRACT_ID contient
    des espaces inutiles.
==============================================================================*/

SELECT *

FROM LANDING.CONTRACTS

WHERE CONTRACT_ID <> TRIM(CONTRACT_ID);



/*==============================================================================
    8. ANALYSE DES TYPES DE CONTRAT

    Préparer le test accepted_values.
==============================================================================*/

SELECT

    CONTRACT_TYPE,

    COUNT(*) AS NB

FROM LANDING.CONTRACTS

GROUP BY CONTRACT_TYPE

ORDER BY NB DESC;



/*==============================================================================
    9. ANALYSE DU STATUT DES CONTRATS

    Préparer le test accepted_values.
==============================================================================*/

SELECT

    CONTRACT_STATUS,

    COUNT(*) AS NB

FROM LANDING.CONTRACTS

GROUP BY CONTRACT_STATUS

ORDER BY NB DESC;



/*==============================================================================
    10. ANALYSE DU TYPE D'ÉNERGIE
==============================================================================*/

SELECT

    ENERGY_TYPE,

    COUNT(*) AS NB

FROM LANDING.CONTRACTS

GROUP BY ENERGY_TYPE

ORDER BY NB DESC;



/*==============================================================================
    11. ANALYSE DE LA FRÉQUENCE DE PAIEMENT
==============================================================================*/

SELECT

    PAYMENT_FREQUENCY,

    COUNT(*) AS NB

FROM LANDING.CONTRACTS

GROUP BY PAYMENT_FREQUENCY

ORDER BY NB DESC;



/*==============================================================================
    12. ANALYSE DES DATES

    Vérifier la période couverte.
==============================================================================*/

SELECT

    MIN(CONTRACT_START_DATE) AS PREMIER_CONTRAT,

    MAX(CONTRACT_START_DATE) AS DERNIER_CONTRAT,

    MIN(CONTRACT_END_DATE) AS PREMIERE_FIN,

    MAX(CONTRACT_END_DATE) AS DERNIERE_FIN

FROM LANDING.CONTRACTS;



/*==============================================================================
    13. VÉRIFICATION DE LA RELATION AVEC CUSTOMERS

    Vérifier que tous les CUSTOMER_ID existent.
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM LANDING.CONTRACTS c

LEFT JOIN LANDING.CUSTOMERS cu

ON c.CUSTOMER_ID = cu.CUSTOMER_ID

WHERE cu.CUSTOMER_ID IS NULL;



/*==============================================================================
    14. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM LANDING.CONTRACTS

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