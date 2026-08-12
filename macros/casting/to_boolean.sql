/*
==============================================================================
MACRO : to_boolean

DESCRIPTION :
Convertit une colonne en BOOLEAN.

UTILISATION :
{{ to_boolean('is_active') }}

RESULTAT :
CAST(is_active AS BOOLEAN)
==============================================================================
*/

{% macro to_boolean(column_name) %}

CAST({{ column_name }} AS BOOLEAN) AS {{ column_name }}

{% endmacro %}