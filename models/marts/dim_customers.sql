-- dim_customers.sql
-- Customer dimension enriched with order statistics
-- Customers with no orders still appear (LEFT JOIN) with 0 values

{{ config(materialized='table') }}

with customers as (

    select * from {{ ref('stg_customers') }}

),

order_stats as (

    select
        customer_id,
        count(distinct order_id)            as total_orders,
        sum(line_total)                     as total_spent,
        min(order_date)                     as first_order_date,
        max(order_date)                     as last_order_date

    from {{ ref('int_order_items') }}
    group by customer_id

)

select
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    c.signup_date,
    coalesce(o.total_orders, 0)             as total_orders,
    coalesce(o.total_spent, 0)              as total_spent,
    o.first_order_date,
    o.last_order_date

from customers c
left join order_stats o
    on c.customer_id = o.customer_id
