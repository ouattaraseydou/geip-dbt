{% snapshot snapshot_customers %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='CUSTOMER_ID',
        strategy='timestamp',
        updated_at='UPDATED_AT',
        invalidate_hard_deletes=True
    )
}}

SELECT *
FROM {{ ref('stg_landing_customers') }}

{% endsnapshot %}