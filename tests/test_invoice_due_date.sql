/*
==============================================================================
TEST : test_invoice_due_date

OBJECTIF :
Contrôler la cohérence des dates de facturation.

RÈGLE MÉTIER :
La date d'échéance d'une facture doit être postérieure
à sa date d'émission.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('fact_invoices') }}

WHERE DUE_DATE < INVOICE_DATE