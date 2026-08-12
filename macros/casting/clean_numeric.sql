/*
==============================================================================
MACRO : clean_numeric

DESCRIPTION :
Convertit une colonne en NUMBER avec une précision et une échelle (decimales)
paramétrables. Gère aussi le nettoyage basique (espaces, virgule -> point,
valeurs vides -> NULL) si clean=true.

PARAMETRES :
- column_name : nom de la colonne (ou expression SQL) à convertir
- precision   : précision totale (défaut 18)
- scale       : nombre de décimales (défaut 2)
- clean       : si true, nettoie la valeur avant le cast (défaut false)
- alias       : nom de l'alias en sortie (défaut = column_name)

UTILISATION :
{{ clean_numeric('amount') }}
{{ clean_numeric('amount', precision=10, scale=4) }}
{{ clean_numeric('raw_amount', clean=true, alias='amount') }}

RESULTAT :
CAST(amount AS NUMBER(18,2)) AS amount
==============================================================================
*/

{% macro clean_numeric(
    column_name,
    precision=18,
    scale=2,
    clean=false,
    alias=none
) %}

{% set output_alias = alias if alias is not none else column_name %}

{% if clean %}

TRY_TO_DECIMAL(
    NULLIF(
        TRIM(
            REPLACE({{ column_name }}, ',', '.')
        ),
        ''
    ),
    {{ precision }},
    {{ scale }}
) AS {{ output_alias }}

{% else %}

CAST(
    {{ column_name }}
    AS NUMBER({{ precision }}, {{ scale }})
) AS {{ output_alias }}

{% endif %}

{% endmacro %}