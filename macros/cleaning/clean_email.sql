/*
==============================================================================
MACRO : clean_email

DESCRIPTION :
Nettoie une adresse e-mail en supprimant les espaces
et en la convertissant en minuscules.

BUSINESS PURPOSE :
Garantit un format uniforme des adresses e-mail
pour les recherches, les jointures et les contrôles qualité.

PARAMETERS :
- column_name : Nom de la colonne contenant l'adresse e-mail.

RETURNS :
lower(trim(column_name))

EXAMPLE :

{{ clean_email('customer_email') }}

Compile en :

lower(trim(customer_email))

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro clean_email(column_name) %}

    lower(trim({{ column_name }}))

{% endmacro %}