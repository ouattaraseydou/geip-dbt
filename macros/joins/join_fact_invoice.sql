/*
==============================================================================
MACRO : join_fact_invoice

DESCRIPTION :
Jointure entre les paiements
et la table des factures.

BUSINESS PURPOSE :
Récupérer les informations de facture
à partir de FACT_INVOICES.

PARAMETERS :
- table_alias
- invoice_column

RETURNS :
LEFT JOIN FACT_INVOICES.

EXAMPLE :

{{ join_fact_invoice(
    'p',
    'INVOICE_ID'
) }}

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro join_fact_invoice(table_alias, invoice_column) %}

LEFT JOIN {{ ref('fact_invoices') }} i
       ON {{ table_alias }}.{{ invoice_column }} = i.INVOICE_ID

{% endmacro %}