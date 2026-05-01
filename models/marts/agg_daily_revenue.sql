-- agg_daily_revenue.sql
-- Daily revenue with a running cumulative total using a window function
-- Replaces the materialized view from the Snowflake lab

{{ config(materialized='table') }}

with fact as (

    select * from {{ ref('fct_orders') }}

)

select
    order_date,
    count(distinct order_id)                as num_orders,
    count(distinct customer_id)             as unique_customers,
    sum(line_total)                         as daily_revenue,
    avg(line_total)                         as avg_line_value,

    -- Running cumulative revenue (window function)
    sum(sum(line_total)) over (
        order by order_date
        rows between unbounded preceding and current row
    )                                       as cumulative_revenue

from fact
group by order_date
order by order_date
