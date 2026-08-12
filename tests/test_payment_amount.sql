/*
==============================================================================
TEST : test_payment_amount

OBJECTIF :
Contrôler que les montants des paiements sont positifs.

RÈGLE MÉTIER :
Un paiement ne peut jamais être négatif.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('fact_payments') }}

WHERE AMOUNT_PAID < 0