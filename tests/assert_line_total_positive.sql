-- assert_line_total_positive.sql
-- Custom test: fails if any order line has a zero or negative total
-- This catches bad quantity * price calculations

select *
from {{ ref('fct_orders') }}
where line_total <= 0
