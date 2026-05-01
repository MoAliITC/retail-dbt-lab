-- fct_orders_incremental.sql
-- Incremental version of fct_orders
-- First run: full load. Subsequent runs: only new orders by order_date.
-- Force full rebuild: dbt run --full-refresh --select fct_orders_incremental

{{
    config(
        materialized='incremental',
        unique_key="order_id || '-' || product_id::string",
        on_schema_change='sync_all_columns'
    )
}}

with order_items as (

    select * from {{ ref('int_order_items') }}

    {% if is_incremental() %}
        -- on incremental runs, only pick up orders newer than the latest already loaded
        where order_date > (select max(order_date) from {{ this }})
    {% endif %}

),

customers as (

    select * from {{ ref('stg_customers') }}

)

select
    oi.order_id,
    oi.order_date,
    oi.customer_id,
    c.customer_name,
    c.city                                  as customer_city,
    oi.product_id,
    oi.product_name,
    oi.category,
    oi.quantity,
    oi.price                                as unit_price,
    oi.line_total

from order_items oi
left join customers c
    on oi.customer_id = c.customer_id
