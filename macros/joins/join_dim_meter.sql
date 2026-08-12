/*
==============================================================================
MACRO : join_dim_meter

DESCRIPTION :
Construit automatiquement la jointure entre une table métier
et la dimension des compteurs.

BUSINESS PURPOSE :
Centraliser les jointures vers DIM_METERS.

PARAMETERS :
- table_alias
- meter_column

RETURNS :
LEFT JOIN sur DIM_METERS.

EXAMPLE :

{{ join_dim_meter(
    'i',
    'METER_ID'
) }}

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro join_dim_meter(table_alias, meter_column) %}

LEFT JOIN {{ ref('dim_meters') }} m
       ON {{ table_alias }}.{{ meter_column }} = m.METER_ID

{% endmacro %}