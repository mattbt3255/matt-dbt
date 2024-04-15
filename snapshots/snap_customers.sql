{% snapshot snap_customers %}

{{
  config(
    target_database = 'analytics',
    target_schema = 'snapshots',
    unique_key = 'id',
    strategy = 'timestamp',
    updated_at = 'updated_at'
  )
}}

select * from {{ source('jaffle_shop', 'customers') }}

{% endsnapshot %}
