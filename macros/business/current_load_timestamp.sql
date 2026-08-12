/*
==============================================================================
MACRO : current_load_timestamp

DESCRIPTION :
Retourne la date et l'heure du chargement dbt.

BUSINESS PURPOSE :
Uniformiser la colonne de chargement
(DBT_LOADED_AT) dans tous les modèles.

RETURNS :
CURRENT_TIMESTAMP()

EXAMPLE :

{{ current_load_timestamp() }}

Compile en :

CURRENT_TIMESTAMP()

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro current_load_timestamp() %}

CURRENT_TIMESTAMP()

{% endmacro %}