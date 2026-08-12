/*
==============================================================================
MACRO : bool_from_status

DESCRIPTION :
Transforme une valeur de statut en indicateur booléen.

BUSINESS PURPOSE :
Standardiser la création des indicateurs métier
(IS_SUCCESSFUL_PAYMENT, IS_PENDING_PAYMENT,
IS_FAILED_PAYMENT, IS_ACTIVE, etc.).

PARAMETERS :
- column_name : colonne contenant le statut.
- expected_value : valeur attendue.

RETURNS :
TRUE si la valeur correspond.
FALSE sinon.

EXAMPLE :

{{ bool_from_status('PAYMENT_STATUS', 'SUCCESS') }}
    AS IS_SUCCESSFUL_PAYMENT

Compile en :

CASE
    WHEN PAYMENT_STATUS = 'SUCCESS'
        THEN TRUE
    ELSE FALSE
END

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro bool_from_status(column_name, expected_value) %}

CASE

    WHEN {{ column_name }} = '{{ expected_value }}'
        THEN TRUE

    ELSE FALSE

END

{% endmacro %}