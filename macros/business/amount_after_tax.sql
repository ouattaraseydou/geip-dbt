/*
==============================================================================
MACRO : amount_after_tax

DESCRIPTION :
Calcule le montant TTC.

BUSINESS PURPOSE :
Centraliser le calcul financier
des montants.

PARAMETERS :
- amount
- tax

RETURNS :
amount + tax

EXAMPLE :

{{ amount_after_tax(
'energy_amount',
'tax_amount'
) }}

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro amount_after_tax(amount, tax) %}

({{ amount }} + {{ tax }})

{% endmacro %}