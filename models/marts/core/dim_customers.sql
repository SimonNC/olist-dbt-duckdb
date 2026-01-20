with customers as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    from {{ ref('stg_olist__customers') }}
),

metrics as (
    select
        customer_id,
        orders_count,
        first_order_ts,
        last_order_ts,
        revenue_total
    from {{ ref('int_customers__order_metrics') }}
)

select
    c.customer_id,
    c.customer_unique_id,

    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,

    coalesce(m.orders_count, 0) as orders_count,
    m.first_order_ts,
    m.last_order_ts,
    coalesce(m.revenue_total, 0) as revenue_total,

    case
        when coalesce(m.orders_count, 0) = 0 then 'no_orders'
        when m.orders_count = 1 then 'one_time'
        else 'repeat'
    end as customer_segment

from customers c
left join metrics m
    using (customer_id)
