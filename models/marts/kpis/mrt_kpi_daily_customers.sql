with fct as (
    select
        customer_id,
        cast(order_purchase_ts as date) as order_date
    from {{ ref('fct_orders') }}
    where order_purchase_ts is not null
),

bridge as (
    select
        customer_id,
        customer_unique_id
    from {{ ref('dim_customer_ids') }}
),

fct_unique as (
    select
        b.customer_unique_id,
        f.order_date
    from fct f
    left join bridge b
        using (customer_id)
    where b.customer_unique_id is not null
),

first_orders as (
    select
        customer_unique_id,
        min(order_date) as first_order_date
    from fct_unique
    group by customer_unique_id
),

daily as (
    select
        fu.order_date,
        count(distinct fu.customer_unique_id) as customers_total,
        count(distinct case
            when fu.order_date = fo.first_order_date
            then fu.customer_unique_id
        end) as new_customers,
        count(distinct case
            when fu.order_date > fo.first_order_date
            then fu.customer_unique_id
        end) as repeat_customers
    from fct_unique fu
    left join first_orders fo
        using (customer_unique_id)
    group by fu.order_date
)

select
    order_date,
    customers_total,
    new_customers,
    repeat_customers,
    round(repeat_customers * 1.0 / nullif(customers_total, 0), 4) as repeat_rate
from daily
order by order_date
