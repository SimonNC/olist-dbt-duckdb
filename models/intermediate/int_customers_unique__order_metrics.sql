with fct as (
    select
        customer_id,
        order_id,
        order_purchase_ts,
        payment_value_total
    from {{ ref('fct_orders') }}
),

bridge as (
    select
        customer_id,
        customer_unique_id
    from {{ ref('dim_customer_ids') }}
),

joined as (
    select
        b.customer_unique_id,
        f.order_id,
        f.order_purchase_ts,
        f.payment_value_total
    from fct f
    left join bridge b
        using (customer_id)
)

select
    customer_unique_id,
    count(distinct order_id) as orders_count,
    min(order_purchase_ts) as first_order_ts,
    max(order_purchase_ts) as last_order_ts,
    sum(payment_value_total) as revenue_total
from joined
group by customer_unique_id
