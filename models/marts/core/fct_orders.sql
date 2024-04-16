with orders as (
  select * from {{ref('stg_orders')}}
),

payments as (
  select * from {{ref('stg_payments')}}
),

order_payments as (
  select
    order_id,
    sum(case when status = 'success' then amount end) as amount

  from payments
  group by 1
),

final as (
  select
    {{ dbt_utils.generate_surrogate_key(['orders.order_id']) }} as id,
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    order_payments.amount

  from orders
  left join order_payments using (order_id)
  )

select * from final
