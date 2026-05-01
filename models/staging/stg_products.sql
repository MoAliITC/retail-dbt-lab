-- stg_products.sql
-- Source: seeds/products.csv
-- Cleans types and filters invalid rows

with source as (

    select * from {{ ref('products') }}

),

cleaned as (

    select
        product_id::int                     as product_id,
        trim(product_name)                  as product_name,
        initcap(trim(category))             as category,
        price::decimal(10, 2)               as price

    from source
    where product_id is not null
      and price > 0

)

select * from cleaned
