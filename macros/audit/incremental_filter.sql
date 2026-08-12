/*
==============================================================================
MACRO : incremental_filter

DESCRIPTION :
Génère automatiquement le filtre utilisé dans les modèles
matérialisés en mode incremental.

BUSINESS PURPOSE :
Ne charger que les nouvelles données ou les données modifiées
depuis le dernier chargement.

Cette macro évite de répéter le même bloc SQL dans tous
les modèles incrémentaux.

PARAMETERS :
- source_column : Colonne de la source utilisée pour filtrer.
- target_column : Colonne correspondante dans la table cible.

RETURNS :
Bloc WHERE exécuté uniquement lors d'un chargement incrémental.

EXAMPLE :

{{ incremental_filter('CREATED_AT', 'INVOICE_CREATED_AT') }}

Compile en :

{% raw %}
{% if is_incremental() %}

WHERE CREATED_AT >

(
    SELECT COALESCE(MAX(INVOICE_CREATED_AT), '1900-01-01')
    FROM {{ this }}
)

{% endif %}
{% endraw %}

AUTHOR :
Ouattara Seydou
==============================================================================
*/

{% macro incremental_filter(source_column, target_column) %}

{% if is_incremental() %}

WHERE {{ source_column }} >

(

    SELECT COALESCE(MAX({{ target_column }}), '1900-01-01')

    FROM {{ this }}

)

{% endif %}

{% endmacro %}