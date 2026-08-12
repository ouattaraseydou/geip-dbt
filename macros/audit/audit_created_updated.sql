/*
==============================================================================
MACRO : audit_created_updated

DESCRIPTION :
Ajoute automatiquement
les colonnes d'audit.

BUSINESS PURPOSE :
Uniformiser les colonnes
techniques dans tous les modèles.

RETURNS :
CREATED_AT
DBT_LOADED_AT

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro audit_created_updated(created_column) %}

{{ created_column }} as CREATED_AT,

CURRENT_TIMESTAMP() as DBT_LOADED_AT

{% endmacro %}