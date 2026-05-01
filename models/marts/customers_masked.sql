-- customers_masked.sql
-- Customer view with email addresses masked using the mask_email macro
-- Safe to share with analysts who should not see full email addresses
-- e.g.  amelia.williams@gmail.com  →  am***@gmail.com

{{ config(materialized='view') }}

select
    customer_id,
    customer_name,
    {{ mask_email('email') }}               as email,
    city,
    signup_date,
    total_orders,
    total_spent

from {{ ref('dim_customers') }}
