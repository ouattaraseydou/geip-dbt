/*
==============================================================================
MACRO : invoice_flags

DESCRIPTION :
Construit automatiquement
l'indicateur IS_PAID.

BUSINESS PURPOSE :
Uniformiser la logique métier
des factures.

PARAMETERS :
- column_name : statut de facture.

RETURNS :
IS_PAID

EXAMPLE :

{{ invoice_flags('invoice_status') }}

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro invoice_flags(column_name) %}

CASE

    WHEN {{ column_name }} = 'PAID'

    THEN TRUE

    ELSE FALSE

END AS IS_PAID

{% endmacro %}