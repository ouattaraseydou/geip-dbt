/*
==============================================================================
MACRO : date_key

DESCRIPTION :
Retourne la clé de substitution (DATE_SK)
correspondant à une date métier.

BUSINESS PURPOSE :
Uniformiser la récupération des clés
de la dimension temporelle.

PARAMETERS :
- alias_name : alias de la dimension date.

RETURNS :
DATE_SK

EXAMPLE :

{{ date_key('invoice_date') }}

Compile en :

invoice_date.DATE_SK

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro date_key(alias_name) %}

{{ alias_name }}.DATE_SK

{% endmacro %}