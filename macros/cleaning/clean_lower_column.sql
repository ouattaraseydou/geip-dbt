/*
==============================================================================
MACRO : clean_lower_column

DESCRIPTION :
Nettoie une colonne texte,
la convertit en minuscules
et conserve son nom.

BUSINESS PURPOSE :
Éviter de répéter :

LOWER(TRIM(colonne)) AS colonne

PARAMETERS :
- column_name

RETURNS :
LOWER(TRIM(colonne)) AS colonne

EXAMPLE :

{{ clean_lower_column('email') }}

Compile en :

LOWER(TRIM(email))
AS email

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro clean_lower_column(column_name) %}

LOWER(TRIM({{ column_name }}))
AS {{ column_name }}

{% endmacro %}