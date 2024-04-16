with orders as (
  select * from {{ ref('fct_orders')}}
)

select
  order_date,
  count(*) as order_count

from orders

group by 1

order by 1 desc
