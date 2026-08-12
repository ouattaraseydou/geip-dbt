/*
==============================================================================
TEST : test_contract_end_after_start

OBJECTIF :
Contrôler la cohérence des dates des contrats.

RÈGLE MÉTIER :
La date de fin d'un contrat doit toujours être postérieure
à sa date de début.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('dim_contracts') }}

WHERE CONTRACT_END_DATE < CONTRACT_START_DATE