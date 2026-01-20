with payments as (
  select
    order_id,
    payment_type,
    payment_installments,
    payment_value
  from {{ ref('stg_olist__payments') }}
),

aggregated as (
  select
    order_id,
    sum(payment_value) as payment_value_total,
    max(payment_installments) as payment_installments_max
  from payments
  group by order_id
),

payment_type_ranked as (
  select
    order_id,
    payment_type,
    sum(payment_value) as payment_value_by_type,
    row_number() over (
      partition by order_id
      order by sum(payment_value) desc
    ) as rn
  from payments
  group by order_id, payment_type
),

primary_payment_type as (
  select
    order_id,
    payment_type as payment_type_primary
  from payment_type_ranked
  where rn = 1
)

select
  a.order_id,
  a.payment_value_total,
  a.payment_installments_max,
  p.payment_type_primary
from aggregated a
left join primary_payment_type p
  using (order_id)
