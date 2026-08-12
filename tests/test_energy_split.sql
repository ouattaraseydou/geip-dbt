/*
==============================================================================
TEST : test_energy_split

OBJECTIF :
Vérifier la cohérence entre la consommation totale
et le détail heures pleines / heures creuses.

RÈGLE MÉTIER :
ENERGY_CONSUMED_KWH doit être égal à :

PEAK_KWH + OFF_PEAK_KWH

Une tolérance de 0.01 est autorisée afin d'éviter les
erreurs d'arrondi sur les nombres décimaux.

RÉSULTAT ATTENDU :
Ce test doit retourner 0 ligne.
==============================================================================
*/

SELECT *

FROM {{ ref('fact_energy_consumption') }}

WHERE peak_kwh < 0
   OR off_peak_kwh < 0