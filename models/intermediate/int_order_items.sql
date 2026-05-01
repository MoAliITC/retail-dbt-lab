-- int_order_items.sql
-- Joins flattened orders with product details
-- One row per order line item, enriched with price and line total

with orders as (

    select * from {{ ref('stg_orders') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

joined as (

    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.product_id,
        o.quantity,
        p.product_name,
        p.category,
        p.price,
        (o.quantity * p.price)              as line_total

    from orders o
    left join products p
        on o.product_id = p.product_id

)

select * from joined
