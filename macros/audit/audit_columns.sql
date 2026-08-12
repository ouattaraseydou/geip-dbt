/*
==============================================================================
MACRO : audit_columns

DESCRIPTION :
Ajoute les colonnes d'audit communes à tous les modèles dbt.

BUSINESS PURPOSE :
Permet de tracer automatiquement la date et l'heure de chargement
des données dans le modèle.

Cette macro garantit que tous les modèles utilisent le même
standard d'audit.

PARAMETERS :
Aucun.

RETURNS :
- DBT_LOADED_AT : Date et heure de chargement du modèle.

EXAMPLE :

SELECT

    CUSTOMER_ID,

    {{ audit_columns() }}

FROM customers

Compile en :

SELECT

    CUSTOMER_ID,

    CURRENT_TIMESTAMP() AS DBT_LOADED_AT

FROM customers

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro audit_columns() %}

    CURRENT_TIMESTAMP() AS DBT_LOADED_AT

{% endmacro %}