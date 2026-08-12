/*
==============================================================================
MACRO : surrogate_key

DESCRIPTION :
Construit une clé technique (Surrogate Key)
à partir d'une ou plusieurs colonnes.

BUSINESS PURPOSE :
Créer des identifiants uniques indépendants
des clés métier.

Cette macro repose sur dbt_utils.generate_surrogate_key().

PARAMETERS :
- columns : liste des colonnes composant la clé.

RETURNS :
Hash MD5 stable.

EXAMPLE :

{{ surrogate_key([
    'CUSTOMER_ID',
    'CONTRACT_ID'
]) }}

Compile en :

dbt_utils.generate_surrogate_key(
    ['CUSTOMER_ID','CONTRACT_ID']
)

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro surrogate_key(columns) %}

{{ dbt_utils.generate_surrogate_key(columns) }}

{% endmacro %}