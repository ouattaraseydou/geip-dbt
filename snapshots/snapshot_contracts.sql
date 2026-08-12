{% snapshot snapshot_contracts %}

{{
    config(

        target_schema='SNAPSHOTS',

        unique_key='CONTRACT_ID',

        strategy='timestamp',

        updated_at='UPDATED_AT',

        invalidate_hard_deletes=True

    )
}}

SELECT *

FROM {{ ref('stg_landing_contracts') }}

{% endsnapshot %}