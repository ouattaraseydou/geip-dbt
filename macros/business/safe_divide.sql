/*
==============================================================================
MACRO : safe_divide

DESCRIPTION :
Effectue une division sécurisée.

BUSINESS PURPOSE :
Éviter les erreurs de division par zéro.

PARAMETERS :
- numerator
- denominator

RETURNS :
NULL si le dénominateur vaut 0.

EXAMPLE :

{{ safe_divide(
'total_paid',
'total_amount'
) }}

Compile en :

CASE
    WHEN total_amount = 0 THEN NULL
    ELSE total_paid / total_amount
END

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro safe_divide(numerator, denominator) %}

CASE

    WHEN {{ denominator }} = 0 THEN NULL

    ELSE {{ numerator }} / {{ denominator }}

END

{% endmacro %}