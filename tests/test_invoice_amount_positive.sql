/*
==============================================================================
TEST : test_invoice_amount_positive

OBJECTIF :
Contrôler que le montant total d'une facture est strictement positif.

RÈGLE MÉTIER :
Une facture ne peut pas avoir un montant nul ou négatif.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('fact_invoices') }}

WHERE TOTAL_AMOUNT <= 0