with geo as (
    select
        customer_unique_id,
        customer_state,
        customer_city,
        customer_zip_code_prefix,
        count(*) as cnt
    from {{ ref('dim_customer_ids') }}
    group by 1,2,3,4
),

geo_ranked as (
    select
        *,
        row_number() over (
            partition by customer_unique_id
            order by cnt desc
        ) as rn
    from geo
),

geo_primary as (
    select
        customer_unique_id,
        customer_zip_code_prefix as primary_zip_code_prefix,
        customer_city as primary_city,
        customer_state as primary_state
    from geo_ranked
    where rn = 1
),

metrics as (
    select
        customer_unique_id,
        orders_count,
        first_order_ts,
        last_order_ts,
        revenue_total
    from {{ ref('int_customers_unique__order_metrics') }}
)

select
    m.customer_unique_id,
    g.primary_zip_code_prefix,
    g.primary_city,
    g.primary_state,

    coalesce(m.orders_count, 0) as orders_count,
    m.first_order_ts,
    m.last_order_ts,
    coalesce(m.revenue_total, 0) as revenue_total,

    case
        when coalesce(m.orders_count, 0) = 0 then 'no_orders'
        when m.orders_count = 1 then 'one_time'
        else 'repeat'
    end as customer_segment

from metrics m
left join geo_primary g
    using (customer_unique_id)
