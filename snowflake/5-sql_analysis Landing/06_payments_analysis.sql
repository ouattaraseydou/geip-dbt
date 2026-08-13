/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : PAYMENTS
    SCRIPT        : 06_payments_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.PAYMENTS
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

DESC TABLE PAYMENTS;


/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES

FROM PAYMENTS;


/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE

    PAYMENT_SK doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT PAYMENT_SK) AS NB_PAYMENT_SK

FROM PAYMENTS;


/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER

    PAYMENT_ID doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT PAYMENT_ID) AS NB_PAYMENT_ID

FROM PAYMENTS;


/*==============================================================================
    5. RECHERCHE DES VALEURS NULL
==============================================================================*/

SELECT

    COUNT_IF(PAYMENT_ID IS NULL) AS PAYMENT_ID_NULL,

    COUNT_IF(INVOICE_ID IS NULL) AS INVOICE_ID_NULL,

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(PAYMENT_DATE IS NULL) AS PAYMENT_DATE_NULL,

    COUNT_IF(AMOUNT_PAID IS NULL) AS AMOUNT_PAID_NULL,

    COUNT_IF(PAYMENT_METHOD IS NULL) AS PAYMENT_METHOD_NULL,

    COUNT_IF(PAYMENT_STATUS IS NULL) AS PAYMENT_STATUS_NULL,

    COUNT_IF(CURRENCY IS NULL) AS CURRENCY_NULL,

    COUNT_IF(CREATED_AT IS NULL) AS CREATED_AT_NULL

FROM PAYMENTS;


/*==============================================================================
    6. RECHERCHE DES DOUBLONS
==============================================================================*/

SELECT

    PAYMENT_ID,

    COUNT(*) AS NB

FROM PAYMENTS

GROUP BY PAYMENT_ID

HAVING COUNT(*) > 1;


/*==============================================================================
    7. RECHERCHE DES ESPACES
==============================================================================*/

SELECT *

FROM PAYMENTS

WHERE

       PAYMENT_ID <> TRIM(PAYMENT_ID)

    OR INVOICE_ID <> TRIM(INVOICE_ID)

    OR CONTRACT_ID <> TRIM(CONTRACT_ID)

    OR TRANSACTION_REFERENCE <> TRIM(TRANSACTION_REFERENCE)

    OR BANK_NAME <> TRIM(BANK_NAME);


/*==============================================================================
    8. ANALYSE DU MODE DE PAIEMENT
==============================================================================*/

SELECT

    PAYMENT_METHOD,

    COUNT(*) AS NB

FROM PAYMENTS

GROUP BY PAYMENT_METHOD

ORDER BY NB DESC;


/*==============================================================================
    9. ANALYSE DU STATUT DE PAIEMENT
==============================================================================*/

SELECT

    PAYMENT_STATUS,

    COUNT(*) AS NB

FROM PAYMENTS

GROUP BY PAYMENT_STATUS

ORDER BY NB DESC;


/*==============================================================================
    10. ANALYSE DES DEVISES
==============================================================================*/

SELECT

    CURRENCY,

    COUNT(*) AS NB

FROM PAYMENTS

GROUP BY CURRENCY

ORDER BY NB DESC;


/*==============================================================================
    11. ANALYSE DES MONTANTS
==============================================================================*/

SELECT

    MIN(AMOUNT_PAID) AS MIN_AMOUNT,

    MAX(AMOUNT_PAID) AS MAX_AMOUNT

FROM PAYMENTS;


/*==============================================================================
    12. ANALYSE DES DATES
==============================================================================*/

SELECT

    MIN(PAYMENT_DATE) AS PREMIER_PAIEMENT,

    MAX(PAYMENT_DATE) AS DERNIER_PAIEMENT

FROM PAYMENTS;


/*==============================================================================
    13. RÈGLE MÉTIER

    Le montant payé ne doit pas être négatif.
==============================================================================*/

SELECT *

FROM PAYMENTS

WHERE AMOUNT_PAID < 0;


/*==============================================================================
    14. RÈGLE MÉTIER

    Un paiement SUCCESS doit avoir une date de paiement.
==============================================================================*/

SELECT *

FROM PAYMENTS

WHERE

    PAYMENT_STATUS = 'SUCCESS'

AND

    PAYMENT_DATE IS NULL;


/*==============================================================================
    15. RÈGLE MÉTIER

    Vérifier que le montant payé ne dépasse pas
    le montant de la facture.
==============================================================================*/

SELECT

    p.PAYMENT_ID,

    p.AMOUNT_PAID,

    i.TOTAL_AMOUNT

FROM PAYMENTS p

INNER JOIN INVOICES i

ON p.INVOICE_ID = i.INVOICE_ID

WHERE p.AMOUNT_PAID > i.TOTAL_AMOUNT;


/*==============================================================================
    16. RÈGLE MÉTIER

    Vérifier que le paiement n'a pas été effectué
    avant la date de la facture.
==============================================================================*/

SELECT

    p.PAYMENT_ID,

    p.PAYMENT_DATE,

    i.INVOICE_DATE

FROM PAYMENTS p

INNER JOIN INVOICES i

ON p.INVOICE_ID = i.INVOICE_ID

WHERE p.PAYMENT_DATE < i.INVOICE_DATE;


/*==============================================================================
    17. VÉRIFICATION DE LA RELATION AVEC INVOICES
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM PAYMENTS p

LEFT JOIN INVOICES i

ON p.INVOICE_ID = i.INVOICE_ID

WHERE i.INVOICE_ID IS NULL;


/*==============================================================================
    18. VÉRIFICATION DE LA RELATION AVEC CONTRACTS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM PAYMENTS p

LEFT JOIN CONTRACTS c

ON p.CONTRACT_ID = c.CONTRACT_ID

WHERE c.CONTRACT_ID IS NULL;


/*==============================================================================
    19. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM PAYMENTS

LIMIT 10;


/*==============================================================================
    20. CONCLUSION

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