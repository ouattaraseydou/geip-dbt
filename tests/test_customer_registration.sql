/*
==============================================================================
TEST : test_customer_registration

OBJECTIF :
Vérifier la cohérence des dates d'inscription.

RÈGLE MÉTIER :
La date d'inscription d'un client ne peut pas être située
dans le futur.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('dim_customers') }}

WHERE CUSTOMER_REGISTRATION_DATE > CURRENT_DATE()