/*
==============================================================================
TEST : test_positive_energy_consumption

OBJECTIF :
Vérifier qu'aucune consommation d'énergie n'est négative.

RÈGLE MÉTIER :
Une consommation électrique ne peut jamais être inférieure à zéro.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('fact_energy_consumption') }}

WHERE ENERGY_CONSUMED_KWH < 0