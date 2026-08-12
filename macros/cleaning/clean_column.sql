/*
==============================================================================
MACRO : clean_column

DESCRIPTION :
Nettoie une colonne texte en supprimant
les espaces inutiles et conserve son nom.

BUSINESS PURPOSE :
Éviter de répéter :

trim(colonne) AS colonne

dans tous les modèles.

PARAMETERS :
- column_name : nom de la colonne.

RETURNS :
trim(colonne) AS colonne

EXAMPLE :

{{ clean_column('customer_id') }}

Compile en :

trim(customer_id) AS customer_id

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro clean_column(column_name) %}

TRIM({{ column_name }}) AS {{ column_name }}

{% endmacro %}