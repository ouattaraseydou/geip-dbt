/*
==============================================================================
MACRO : clean_lower

DESCRIPTION :
Supprime les espaces et convertit le texte en minuscules.

BUSINESS PURPOSE :
Uniformise les colonnes contenant des adresses e-mail,
des identifiants ou d'autres champs insensibles à la casse.

PARAMETERS :
- column_name : Nom de la colonne.

RETURNS :
lower(trim(column_name))

EXAMPLE :

{{ clean_lower('email') }}

Compile en :

lower(trim(email))

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro clean_lower(column_name) %}

    lower(trim({{ column_name }}))

{% endmacro %}