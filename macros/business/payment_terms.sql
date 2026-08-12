/*
==============================================================================
MACRO : payment_terms

DESCRIPTION :
Calcule le nombre de jours accordés au client
pour payer sa facture.

BUSINESS PURPOSE :
Centraliser le calcul du délai de paiement
dans tous les modèles.

PARAMETERS :
- invoice_date : date de facturation
- due_date : date d'échéance

RETURNS :
Nombre de jours entre la facture et l'échéance.

EXAMPLE :

{{ payment_terms(
    'invoice_date',
    'due_date'
) }}

Compile en :

DATEDIFF(
    day,
    invoice_date,
    due_date
)

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro payment_terms(invoice_date, due_date) %}

DATEDIFF(

    day,

    {{ invoice_date }},

    {{ due_date }}

)

{% endmacro %}