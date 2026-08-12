/*
==============================================================================
TEST : test_paid_invoice_has_payment_date

OBJECTIF :
Vérifier qu'une facture payée possède une date de paiement.

RÈGLE MÉTIER :
Toute facture ayant le statut "payée" doit être associée
à une date de paiement.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *
FROM {{ ref('int_invoice_payments') }}
WHERE IS_PAID = TRUE
  AND PAYMENT_DATE IS NULL