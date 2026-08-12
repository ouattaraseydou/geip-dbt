/*
==============================================================================
MACRO : calculate_delay

DESCRIPTION :
Calcule le nombre de jours entre deux dates.

BUSINESS PURPOSE :
Standardiser tous les calculs de délai
(retard de paiement, délai d'intervention,
ancienneté client, etc.).

PARAMETERS :
- start_date : date de début.
- end_date : date de fin.

RETURNS :
Nombre de jours entre les deux dates.

EXAMPLE :

{{ calculate_delay('DUE_DATE','PAYMENT_DATE') }}

Compile en :

DATEDIFF(
    day,
    DUE_DATE,
    PAYMENT_DATE
)

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro calculate_delay(payment_date, due_date) %}

CASE

    WHEN {{ payment_date }} IS NULL THEN NULL

    WHEN {{ payment_date }} <= {{ due_date }} THEN 0

    ELSE DATEDIFF(
            day,
            {{ due_date }},
            {{ payment_date }}
         )

END

{% endmacro %}