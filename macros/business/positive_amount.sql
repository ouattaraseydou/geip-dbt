/*
==============================================================================
MACRO : positive_amount

DESCRIPTION :
Retourne un montant positif.

BUSINESS PURPOSE :
Éviter les valeurs négatives
dans les montants financiers.

PARAMETERS :
- column_name : colonne du montant.

RETURNS :
ABS(colonne)

EXAMPLE :

{{ positive_amount('AMOUNT_PAID') }}

Compile en :

ABS(AMOUNT_PAID)

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro positive_amount(column_name) %}

ABS({{ column_name }})

{% endmacro %}