-- stg_customers.sql
-- Source: seeds/customers.csv
-- Cleans types, trims whitespace, standardises casing

with source as (

    select * from {{ ref('customers') }}

),

cleaned as (

    select
        customer_id::int                    as customer_id,
        initcap(trim(name))                 as customer_name,
        lower(trim(email))                  as email,
        initcap(trim(city))                 as city,
        signup_date::date                   as signup_date,
        current_timestamp()                 as _loaded_at

    from source
    where customer_id is not null

)

select * from cleaned
