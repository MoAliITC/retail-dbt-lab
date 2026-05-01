-- top_products_by_category.sql
-- Top 3 products per category ranked by total revenue
-- Uses ROW_NUMBER() window function partitioned by category

{{ config(materialized='table') }}

with product_sales as (

    select
        category,
        product_id,
        product_name,
        sum(quantity)                       as total_units_sold,
        sum(line_total)                     as total_revenue

    from {{ ref('fct_orders') }}
    group by category, product_id, product_name

),

ranked as (

    select
        *,
        row_number() over (
            partition by category
            order by total_revenue desc
        )                                   as rank_in_category

    from product_sales

)

select
    category,
    rank_in_category,
    product_id,
    product_name,
    total_units_sold,
    total_revenue

from ranked
where rank_in_category <= 3
order by category, rank_in_category
