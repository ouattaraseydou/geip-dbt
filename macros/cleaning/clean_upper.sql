/*
==============================================================================
MACRO : clean_upper

DESCRIPTION :
Nettoie une colonne texte et la convertit en majuscules.

OBJECTIF :
Uniformiser les valeurs textuelles avant les traitements.

PARAMÈTRE :
column_name : nom de la colonne.

RETOUR :
upper(trim(column_name))

EXEMPLE :

{{ clean_upper('invoice_status') }}

Compile en :

upper(trim(invoice_status))

AUTEUR :
Ouattara Seydou
==============================================================================
*/

{% macro clean_upper(column_name) %}

    upper(trim({{ column_name }}))

{% endmacro %}