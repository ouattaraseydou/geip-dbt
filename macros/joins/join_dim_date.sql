/*
==============================================================================
MACRO : join_dim_date

DESCRIPTION :
Construit automatiquement une jointure
entre une date métier et la dimension DIM_DATE.

BUSINESS PURPOSE :
Éviter de répéter les LEFT JOIN sur DIM_DATE
dans tous les modèles.

PARAMETERS :
- table_alias : alias de la table source
- column_name : colonne date de la table source
- alias_name : alias de la dimension

RETURNS :
LEFT JOIN DIM_DATE

EXAMPLE :

{{ join_dim_date(
    'i',
    'INVOICE_DATE',
    'invoice_date'
) }}

Compile en :

LEFT JOIN dim_date invoice_date
ON TO_DATE(i.INVOICE_DATE)=invoice_date.FULL_DATE

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro join_dim_date(table_alias, column_name, alias_name) %}

LEFT JOIN {{ ref('dim_date') }} {{ alias_name }}

       ON TO_DATE({{ table_alias }}.{{ column_name }})
       = {{ alias_name }}.FULL_DATE

{% endmacro %}