-- customer_spending_ranked.sql
-- All customers ranked by total spend
-- Includes % of grand total and cumulative spend using window functions

{{ config(materialized='table') }}

with customer_spending as (

    select
        customer_id,
        customer_name,
        customer_city,
        count(distinct order_id)            as total_orders,
        sum(line_total)                     as total_spent

    from {{ ref('fct_orders') }}
    group by customer_id, customer_name, customer_city

),

ranked as (

    select
        *,
        rank() over (
            order by total_spent desc
        )                                   as spending_rank,

        round(
            total_spent / sum(total_spent) over () * 100,
            2
        )                                   as pct_of_grand_total,

        sum(total_spent) over (
            order by total_spent desc
            rows between unbounded preceding and current row
        )                                   as cumulative_spent

    from customer_spending

)

select * from ranked
order by spending_rank
