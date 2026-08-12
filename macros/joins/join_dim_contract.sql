/*
==============================================================================
MACRO : join_dim_contract

DESCRIPTION :
Construit automatiquement la jointure entre une table métier
et la dimension des contrats.

BUSINESS PURPOSE :
Éviter de répéter les LEFT JOIN vers DIM_CONTRACTS
dans les modèles GOLD.

PARAMETERS :
- table_alias : alias de la table source
- contract_column : colonne contenant le CONTRACT_ID

RETURNS :
LEFT JOIN sur DIM_CONTRACTS.

EXAMPLE :

{{ join_dim_contract(
    'i',
    'CONTRACT_ID'
) }}

Compile en :

LEFT JOIN dim_contracts c
ON i.CONTRACT_ID = c.CONTRACT_ID

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro join_dim_contract(table_alias, contract_column) %}

LEFT JOIN {{ ref('dim_contracts') }} c
       ON {{ table_alias }}.{{ contract_column }} = c.CONTRACT_ID

{% endmacro %}