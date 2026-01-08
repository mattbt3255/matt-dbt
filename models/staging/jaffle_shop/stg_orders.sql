{{
  config(
    materialized = 'incremental',
    unique_key = 'order_id',
    incremental_strategy = 'merge',
    on_schema_change = 'sync_all_columns'
  )
}}

select
  -- Native Fields --
  id as order_id,
  user_id as customer_id,
  order_date,
  status,
  warehouse_id,

  -- Derived Fields --
  status like '%pending%' as is_status_pending,

  case
    when status like '%return%' then 'returned'
    when status like '%pending%' then 'placed'
    else status
  end as status_cleaned,

  date_diff('day', order_date::date, {{ dbt.current_timestamp() }}::date) as days_since_ordered
  
from {{ source('jaffle_shop', 'orders') }}

{% macro limit_data_in_dev(column_name, days_of_data = 3) %}

{% if target.name == 'dev' %}

where {{ column_name }} >= current_timestamp - interval {{ days_of_data }} day

{% endif %}

{% endmacro %}


-- {% if is_incremental() %}
--   where order_date >= (select max(order_date) from {{ this }})
-- {% endif %}
