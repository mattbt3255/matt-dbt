select
  id as payment_id,
  order_id,
  payment_method,
  {{ cents_to_dollars('amount') }} as amount -- amount is stored in cents, convert it to dollars

from {{ source('stripe', 'payments') }}
