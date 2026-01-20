with fct as (
    select
        order_id,
        order_purchase_ts,
        order_status
    from {{ ref('fct_orders') }}
),

daily as (
    select
        cast(order_purchase_ts as date) as order_date,
        order_status,
        count(distinct order_id) as orders_count
    from fct
    where order_purchase_ts is not null
    group by 1, 2
),

with_totals as (
    select
        order_date,
        order_status,
        orders_count,
        sum(orders_count) over (partition by order_date) as orders_total_day
    from daily
)

select
    order_date,
    order_status,
    orders_count,
    orders_total_day,
    round(orders_count * 1.0 / nullif(orders_total_day, 0), 4) as orders_share
from with_totals
order by order_date, order_status
