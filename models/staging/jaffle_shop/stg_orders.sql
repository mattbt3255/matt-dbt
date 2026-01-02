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
