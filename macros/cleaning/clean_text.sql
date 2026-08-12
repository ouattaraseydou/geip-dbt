/*
==============================================================================
MACRO : clean_text

DESCRIPTION :
Nettoie une colonne texte en supprimant les espaces en début et en fin.

OBJECTIF :
Standardiser les colonnes texte dans les modèles Bronze, Silver et Gold.

PARAMÈTRE :
column_name : nom de la colonne à nettoyer.

RETOUR :
trim(column_name)

EXEMPLE :

{{ clean_text('customer_id') }}

Compile en :

trim(customer_id)

AUTEUR :
Ouattara Seydou
==============================================================================
*/

{% macro clean_text(column_name) %}

    trim({{ column_name }})

{% endmacro %}