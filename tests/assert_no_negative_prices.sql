-- assert_no_negative_prices.sql
-- Custom test: fails if any product has a negative price
-- A passing test returns ZERO rows. Any rows returned = test failure.

select *
from {{ ref('stg_products') }}
where price < 0
