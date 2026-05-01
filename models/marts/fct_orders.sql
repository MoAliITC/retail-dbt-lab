-- fct_orders.sql
-- Central fact table: orders enriched with customer and product details
-- Materialized as a TABLE for query performance

{{ config(materialized='table') }}

with order_items as (

    select * from {{ ref('int_order_items') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

fact as (

    select
        oi.order_id,
        oi.order_date,
        oi.customer_id,
        c.customer_name,
        c.city                              as customer_city,
        oi.product_id,
        oi.product_name,
        oi.category,
        oi.quantity,
        oi.price                            as unit_price,
        oi.line_total

    from order_items oi
    left join customers c
        on oi.customer_id = c.customer_id

)

select * from fact
