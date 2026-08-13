/*==============================================================================
    PROJET        : GEIP - Energy Data Platform
    COUCHE        : LANDING
    TABLE         : INVOICES
    SCRIPT        : 05_invoices_analysis.sql

    OBJECTIF
    --------
    Analyser la qualité des données de la table LANDING.INVOICES
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

DESC TABLE INVOICES;


/*==============================================================================
    2. NOMBRE TOTAL DE LIGNES
==============================================================================*/

SELECT
    COUNT(*) AS NB_LIGNES
FROM INVOICES;


/*==============================================================================
    3. VÉRIFICATION DE LA CLÉ TECHNIQUE

    INVOICE_SK doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT INVOICE_SK) AS NB_INVOICE_SK

FROM INVOICES;


/*==============================================================================
    4. VÉRIFICATION DE LA CLÉ MÉTIER

    INVOICE_ID doit être unique.
==============================================================================*/

SELECT

    COUNT(*) AS NB_LIGNES,

    COUNT(DISTINCT INVOICE_ID) AS NB_INVOICE_ID

FROM INVOICES;


/*==============================================================================
    5. RECHERCHE DES VALEURS NULL
==============================================================================*/

SELECT

    COUNT_IF(INVOICE_ID IS NULL) AS INVOICE_ID_NULL,

    COUNT_IF(CONTRACT_ID IS NULL) AS CONTRACT_ID_NULL,

    COUNT_IF(METER_ID IS NULL) AS METER_ID_NULL,

    COUNT_IF(INVOICE_DATE IS NULL) AS INVOICE_DATE_NULL,

    COUNT_IF(TOTAL_AMOUNT IS NULL) AS TOTAL_AMOUNT_NULL,

    COUNT_IF(INVOICE_STATUS IS NULL) AS STATUS_NULL,

    COUNT_IF(CREATED_AT IS NULL) AS CREATED_AT_NULL

FROM INVOICES;


/*==============================================================================
    6. RECHERCHE DES DOUBLONS
==============================================================================*/

SELECT

    INVOICE_ID,

    COUNT(*) AS NB

FROM INVOICES

GROUP BY INVOICE_ID

HAVING COUNT(*) > 1;


/*==============================================================================
    7. RECHERCHE DES ESPACES
==============================================================================*/

SELECT *

FROM INVOICES

WHERE

    INVOICE_ID <> TRIM(INVOICE_ID)

OR

    CONTRACT_ID <> TRIM(CONTRACT_ID)

OR

    METER_ID <> TRIM(METER_ID);


/*==============================================================================
    8. ANALYSE DU STATUT DES FACTURES
==============================================================================*/

SELECT

    INVOICE_STATUS,

    COUNT(*) AS NB

FROM INVOICES

GROUP BY INVOICE_STATUS

ORDER BY NB DESC;


/*==============================================================================
    9. ANALYSE DES DATES
==============================================================================*/

SELECT

    MIN(INVOICE_DATE) AS PREMIERE_FACTURE,

    MAX(INVOICE_DATE) AS DERNIERE_FACTURE,

    MIN(DUE_DATE) AS PREMIERE_ECHEANCE,

    MAX(DUE_DATE) AS DERNIERE_ECHEANCE

FROM INVOICES;


/*==============================================================================
    10. ANALYSE DES MONTANTS
==============================================================================*/

SELECT

    MIN(TOTAL_AMOUNT) AS MIN_TOTAL,

    MAX(TOTAL_AMOUNT) AS MAX_TOTAL,

    MIN(TOTAL_KWH) AS MIN_KWH,

    MAX(TOTAL_KWH) AS MAX_KWH

FROM INVOICES;


/*==============================================================================
    11. RÈGLE MÉTIER

    Vérifier que

    TOTAL_AMOUNT =
    ENERGY_AMOUNT +
    FIXED_CHARGE +
    TAX_AMOUNT
==============================================================================*/

SELECT *

FROM INVOICES

WHERE ABS(

    TOTAL_AMOUNT -

    (ENERGY_AMOUNT + FIXED_CHARGE + TAX_AMOUNT)

) > 0.01;


/*==============================================================================
    12. RÈGLE MÉTIER

    Une facture payée doit posséder une PAYMENT_DATE.
==============================================================================*/

SELECT *

FROM INVOICES

WHERE

    INVOICE_STATUS = 'PAID'

AND

    PAYMENT_DATE IS NULL;


/*==============================================================================
    13. RÈGLE MÉTIER

    La date d'échéance doit être supérieure
    ou égale à la date de facture.
==============================================================================*/

SELECT *

FROM INVOICES

WHERE DUE_DATE < INVOICE_DATE;


/*==============================================================================
    14. RÈGLE MÉTIER

    La fin de période doit être postérieure
    au début de période.
==============================================================================*/

SELECT *

FROM INVOICES

WHERE BILLING_PERIOD_END < BILLING_PERIOD_START;


/*==============================================================================
    15. RÈGLE MÉTIER

    Les montants ne doivent pas être négatifs.
==============================================================================*/

SELECT *

FROM INVOICES

WHERE

    TOTAL_AMOUNT < 0

OR

    ENERGY_AMOUNT < 0

OR

    FIXED_CHARGE < 0

OR

    TAX_AMOUNT < 0;


/*==============================================================================
    16. VÉRIFICATION DE LA RELATION AVEC CONTRACTS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM INVOICES i

LEFT JOIN CONTRACTS c

ON i.CONTRACT_ID = c.CONTRACT_ID

WHERE c.CONTRACT_ID IS NULL;


/*==============================================================================
    17. VÉRIFICATION DE LA RELATION AVEC METERS
==============================================================================*/

SELECT

    COUNT(*) AS NB_ORPHELINS

FROM INVOICES i

LEFT JOIN METERS m

ON i.METER_ID = m.METER_ID

WHERE m.METER_ID IS NULL;


/*==============================================================================
    18. APERÇU DES DONNÉES
==============================================================================*/

SELECT *

FROM INVOICES

LIMIT 10;


/*==============================================================================
    19. CONCLUSION

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