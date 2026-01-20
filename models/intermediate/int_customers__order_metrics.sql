with fct as (
    select
        customer_id,
        order_id,
        order_purchase_ts,
        payment_value_total
    from {{ ref('fct_orders') }}
),

agg as (
    select
        customer_id,
        count(distinct order_id) as orders_count,
        min(order_purchase_ts) as first_order_ts,
        max(order_purchase_ts) as last_order_ts,
        sum(payment_value_total) as revenue_total
    from fct
    group by customer_id
)

select * from agg
