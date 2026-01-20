with orders as (

    select
        order_id,
        customer_id,
        order_status,

        order_purchase_ts,
        order_approved_ts,
        order_delivered_carrier_ts,
        order_delivered_customer_ts,
        order_estimated_delivery_ts

    from {{ ref('stg_olist__orders') }}

),

order_items as (

    select
        order_id,
        items_count,
        items_gmv,
        freight_total

    from {{ ref('int_order_items__order_level') }}

),

payments as (

    select
        order_id,
        payment_value_total,
        payment_installments_max,
        payment_type_primary

    from {{ ref('int_payments__order_level') }}

)

select
    -- identifiers
    o.order_id,
    o.customer_id,

    -- order status
    o.order_status,

    -- timestamps
    o.order_purchase_ts,
    o.order_approved_ts,
    o.order_delivered_carrier_ts,
    o.order_delivered_customer_ts,
    o.order_estimated_delivery_ts,

    -- item metrics (order level)
    coalesce(oi.items_count, 0)       as items_count,
    coalesce(oi.items_gmv, 0)         as items_gmv,
    coalesce(oi.freight_total, 0)     as freight_total,

    -- payment metrics (order level)
    coalesce(p.payment_value_total, 0) as payment_value_total,
    p.payment_installments_max,
    p.payment_type_primary

from orders o
left join order_items oi
    using (order_id)
left join payments p
    using (order_id)
