{{
  config(
    materialized = 'incremental',
    unique_key = 'order_id',
    incremental_strategy = 'merge',
    on_schema_change = 'fail'
  )
}}

select
  -- Native Fields --
  id as order_id,
  user_id as customer_id,
  order_date,
  status,

  -- Derived Fields --
  status like '%pending%' as is_status_pending,

  case
    when status like '%return%' then 'returned'
    when status like '%pending%' then 'placed'
    else status
  end as status_cleaned,

  date_diff('day', order_date::date, {{ dbt.current_timestamp() }}::date) as days_since_ordered
  
from {{ source('jaffle_shop', 'orders') }}

-- {% if is_incremental() %}
--   where order_date >= (select max(order_date) from {{ this }})
-- {% endif %}
