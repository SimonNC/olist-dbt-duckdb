with fct as (
    select
        order_id,
        order_purchase_ts,
        items_gmv,
        freight_total,
        payment_value_total
    from {{ ref('fct_orders') }}
),

daily as (
    select
        cast(order_purchase_ts as date) as order_date,
        count(distinct order_id) as orders_count,
        sum(items_gmv) as items_gmv_total,
        sum(freight_total) as freight_total,
        sum(payment_value_total) as revenue_total
    from fct
    where order_purchase_ts is not null
    group by 1
)

select * from daily
order by order_date
