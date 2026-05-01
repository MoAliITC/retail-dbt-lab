-- stg_orders.sql
-- Source: RETAIL_LAB.RAW.ORDERS_RAW (VARIANT column loaded in Snowflake lab)
-- Parses JSON and flattens the items array → one row per order line item
--
-- NOTE: If your raw column is not called "raw_data", update the reference below.
-- To check:  SELECT * FROM RETAIL_LAB.RAW.ORDERS_RAW LIMIT 1;

with source as (

    select raw_data from {{ source('raw', 'orders_raw') }}

),

flattened as (

    select
        src.raw_data:order_id::int          as order_id,
        src.raw_data:customer_id::int       as customer_id,
        src.raw_data:order_date::date       as order_date,
        item.value:product_id::int          as product_id,
        item.value:quantity::int            as quantity

    from source as src,
    lateral flatten(input => src.raw_data:items) as item

)

select * from flattened
