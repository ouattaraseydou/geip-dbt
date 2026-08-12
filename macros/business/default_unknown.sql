/*
==============================================================================
MACRO : default_unknown

DESCRIPTION :
Remplace les valeurs NULL
par une valeur par défaut.

BUSINESS PURPOSE :
Éviter les NULL
dans les dimensions.

PARAMETERS :
- column
- default_value

RETURNS :
COALESCE()

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro default_unknown(column_name, default_value="'UNKNOWN'") %}

COALESCE(
{{ column_name }},
{{ default_value }}
)

{% endmacro %}