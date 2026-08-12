/*
==============================================================================
MACRO : percentage

DESCRIPTION :
Calcule un pourcentage sécurisé.

BUSINESS PURPOSE :
Calculer les KPI sans erreur.

PARAMETERS :
- numerator
- denominator

RETURNS :
Pourcentage

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro percentage(numerator, denominator) %}

CASE

WHEN {{ denominator }}=0 THEN NULL

ELSE ROUND(
100*{{ numerator }}/{{ denominator }},
2)

END

{% endmacro %}