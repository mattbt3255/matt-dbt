with orders as (
  select * from {{ ref('stg_orders') }}
),

payments as (
  select * from {{ ref('stg_payments') }}
),

orders_pivoted as (
  select * from {{ ref('int_orders_pivoted') }}
),

order_payments as (
  select
    order_id,
    sum(amount) as amount

  from payments
  group by 1
),

final as (
  select
    {{ dbt_utils.generate_surrogate_key(['orders.order_id']) }} as id,
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    order_payments.amount,
    orders_pivoted.credit_card_amount,
    orders_pivoted.gift_card_amount,

  from orders
  left join order_payments on order_payments.order_id = orders.order_id
  left join orders_pivoted on orders_pivoted.order_id = orders.order_id
)

select * from final
