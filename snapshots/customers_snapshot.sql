-- customers_snapshot.sql
-- SCD Type 2 for the customers dimension
-- dbt tracks changes to city and email automatically
-- Adds: dbt_valid_from, dbt_valid_to, dbt_scd_id columns
--
-- Run with:  dbt snapshot --profiles-dir .
-- View history: SELECT * FROM RETAIL_LAB.SNAPSHOTS.CUSTOMERS_SNAPSHOT WHERE customer_id = 1;

{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['city', 'email']
    )
}}

select * from {{ ref('stg_customers') }}

{% endsnapshot %}
