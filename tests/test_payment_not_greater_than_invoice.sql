-- ============================================================================
-- TEST : test_payment_not_greater_than_invoice
--
-- OBJECTIF
-- --------
-- Vérifier qu'un paiement n'est jamais supérieur au montant de la facture.
--
-- RESULTAT ATTENDU
-- ----------------
-- Le test doit retourner 0 ligne.
-- ============================================================================

WITH payments AS (

    SELECT
        INVOICE_SK,
        PAYMENT_ID,
        AMOUNT_PAID
    FROM {{ ref('fact_payments') }}

),

invoices AS (

    SELECT
        INVOICE_SK,
        TOTAL_AMOUNT
    FROM {{ ref('fact_invoices') }}

)

SELECT

    p.PAYMENT_ID,
    p.AMOUNT_PAID,
    i.TOTAL_AMOUNT

FROM payments p

INNER JOIN invoices i
    ON p.INVOICE_SK = i.INVOICE_SK

WHERE p.AMOUNT_PAID > i.TOTAL_AMOUNT