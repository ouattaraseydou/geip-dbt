/*
==============================================================================
MACRO : clean_upper_column

DESCRIPTION :
Nettoie une colonne texte,
la convertit en majuscules
et conserve son nom.

BUSINESS PURPOSE :
Éviter de répéter :

UPPER(TRIM(colonne)) AS colonne

PARAMETERS :
- column_name

RETURNS :
UPPER(TRIM(colonne)) AS colonne

EXAMPLE :

{{ clean_upper_column('invoice_status') }}

Compile en :

UPPER(TRIM(invoice_status))
AS invoice_status

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro clean_upper_column(column_name) %}

UPPER(TRIM({{ column_name }}))
AS {{ column_name }}

{% endmacro %}