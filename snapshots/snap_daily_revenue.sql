{% snapshot snap_daily_revenue %}

{{
  config(
    target_database = 'analytics',
    target_schema = 'snapshots',
    unique_key = 'order_date',
    strategy = 'check',
    check_cols = ['daily_revenue']
  )
}}

select
  order_date,
  sum(amount) as daily_revenue

from {{ ref('fct_orders') }}

group by 1

order by 1

{% endsnapshot %}
