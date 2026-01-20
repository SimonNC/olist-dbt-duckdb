with items as (
  select
    order_id,
    price,
    freight_value
  from {{ ref('stg_olist__order_items') }}
),

aggregated as (
  select
    order_id,
    count(*) as items_count,
    sum(price) as items_gmv,
    sum(freight_value) as freight_total
  from items
  group by order_id
)

select * from aggregated
