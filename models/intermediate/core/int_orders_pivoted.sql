with payments as (
  select * from {{ ref('stg_payments') }}
),

pivoted_manual as (
  select
    order_id,
    sum(case when payment_method = 'bank_transfer' then amount else 0 end) as bank_transfer_amount,
    sum(case when payment_method = 'coupon' then amount else 0 end) as coupon_amount,
    sum(case when payment_method = 'credit_card' then amount else 0 end) as credit_card_amount,
    sum(case when payment_method = 'gift_card' then amount else 0 end) as gift_card_amount

  from payments

  group by 1
),

pivoted_jinja as (
  select
    order_id,
    {% set payment_methods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] %}

    {% for method in payment_methods %}
      sum(case when payment_method = '{{ method }}' then amount else 0 end) as {{ method }}_amount,
    {% endfor %}

  from payments

  group by 1
)

select * from pivoted_jinja
