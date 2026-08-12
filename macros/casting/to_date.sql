/*
==============================================================================
MACRO : to_date

DESCRIPTION :
Convertit une colonne en DATE.

UTILISATION :
{{ to_date('invoice_date') }}

RESULTAT :
TO_DATE(invoice_date)
==============================================================================
*/
{% macro to_date(column_name) %}

TO_DATE({{ column_name }}) AS {{ column_name }}

{% endmacro %}