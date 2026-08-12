/*
==============================================================================
MACRO : to_timestamp

DESCRIPTION :
Convertit une colonne en TIMESTAMP.

UTILISATION :
{{ to_timestamp('created_at') }}

RESULTAT :
TO_TIMESTAMP(created_at)
==============================================================================
*/


{% macro to_timestamp(column_name) %}

TO_TIMESTAMP({{ column_name }}) AS {{ column_name }}

{% endmacro %}