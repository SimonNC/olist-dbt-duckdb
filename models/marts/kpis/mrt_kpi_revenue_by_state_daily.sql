with fct as (
    select
        order_id,
        customer_id,
        order_purchase_ts,
        payment_value_total
    from {{ ref('fct_orders') }}
),

cust as (
    select
        customer_id,
        customer_state
    from {{ ref('dim_customers') }}
),

joined as (
    select
        cast(f.order_purchase_ts as date) as order_date,
        c.customer_state,
        f.order_id,
        f.payment_value_total
    from fct f
    left join cust c
        using (customer_id)
    where f.order_purchase_ts is not null
)

select
    order_date,
    customer_state,
    count(distinct order_id) as orders_count,
    sum(payment_value_total) as revenue_total
from joined
group by 1, 2
order by order_date, customer_state
