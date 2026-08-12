/*
==============================================================================
TEST : test_customer_birth_date

OBJECTIF :
Vérifier que les dates de naissance sont cohérentes.

RÈGLE MÉTIER :
Un client ne peut pas être né dans le futur.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('dim_customers') }}

WHERE BIRTH_DATE > CURRENT_DATE()