/*
==============================================================================
MACRO : payment_flags

DESCRIPTION :
Construit automatiquement les indicateurs
de statut de paiement.

BUSINESS PURPOSE :
Éviter de répéter les CASE WHEN
dans tous les modèles.

PARAMETERS :
- column_name : colonne contenant le statut.

RETURNS :
Trois colonnes :

- IS_SUCCESSFUL_PAYMENT
- IS_PENDING_PAYMENT
- IS_FAILED_PAYMENT

EXAMPLE :

{{ payment_flags('payment_status') }}

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro payment_flags(column_name) %}

CASE
    WHEN {{ column_name }} = 'SUCCESS'
    THEN TRUE
    ELSE FALSE
END AS IS_SUCCESSFUL_PAYMENT,

CASE
    WHEN {{ column_name }} = 'PENDING'
    THEN TRUE
    ELSE FALSE
END AS IS_PENDING_PAYMENT,

CASE
    WHEN {{ column_name }} = 'FAILED'
    THEN TRUE
    ELSE FALSE
END AS IS_FAILED_PAYMENT

{% endmacro %}