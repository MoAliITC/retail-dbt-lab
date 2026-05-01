-- assert_no_orphan_orders.sql
-- Custom test: fails if an order references a customer_id that does not exist
-- An orphan order means a data integrity problem in the source

select o.*
from {{ ref('stg_orders') }} o
left join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id
where c.customer_id is null
