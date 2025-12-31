select
  -- Native Fields --
  id as order_id,
  user_id as customer_id,
  order_date,
  status,

  -- Derived Fields --
  status like '%pending%' as is_status_pending,

  case
    when status like '%pending%' then 'placed'
    when status like '%return%' then 'returned'
    else status
  end as status_cleaned
  
from {{ source('jaffle_shop', 'orders') }}
