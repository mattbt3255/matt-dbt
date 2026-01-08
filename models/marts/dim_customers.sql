with customers as (
  select * from {{ ref('stg_customers') }}
),

employees as (
  select * from {{ ref('employees' ) }}
),

final as (
  select
    customers.*,
    employees.employee_id is not null as is_employee
  
  from customers
  left join employees on employees.customer_id = customers.customer_id
)

select * from final
