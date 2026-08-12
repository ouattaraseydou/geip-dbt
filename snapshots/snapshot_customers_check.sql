{% snapshot snapshot_customers_check %}

{{
    config(

        target_schema='SNAPSHOTS',

        unique_key='CUSTOMER_ID',

        strategy='check',

        check_cols=[

            'CUSTOMER_SEGMENT',
            'STATUS',
            'LOYALTY_LEVEL'

        ]

    )
}}

SELECT *

FROM {{ ref('stg_landing_customers') }}

{% endsnapshot %}