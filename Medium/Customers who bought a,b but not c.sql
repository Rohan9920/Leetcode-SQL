-- Table: Customers

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | customer_id         | int     |
-- | customer_name       | varchar |
-- +---------------------+---------+
-- customer_id is the primary key for this table.
-- customer_name is the name of the customer.
 

-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- customer_id is the id of the customer who bought the product "product_name".
 

-- Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.

-- Return the result table ordered by customer_id.

-- The query result format is in the following example.

 

-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Diana         |
-- | 3           | Elizabeth     |
-- | 4           | Jhon          |
-- +-------------+---------------+

-- Orders table:
-- +------------+--------------+---------------+
-- | order_id   | customer_id  | product_name  |
-- +------------+--------------+---------------+
-- | 10         |     1        |     A         |
-- | 20         |     1        |     B         |
-- | 30         |     1        |     D         |
-- | 40         |     1        |     C         |
-- | 50         |     2        |     A         |
-- | 60         |     3        |     A         |
-- | 70         |     3        |     B         |
-- | 80         |     3        |     D         |
-- | 90         |     4        |     C         |
-- +------------+--------------+---------------+

-- Result table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 3           | Elizabeth     |
-- +-------------+---------------+
-- Only the customer_id with id 3 bought the product A and B but not the product C.

--DDL Scripts:

CREATE TABLE Customers
    (customer_id int, customer_name varchar2(9))
;

INSERT ALL 
    INTO Customers (customer_id, customer_name)
         VALUES (1, 'Daniel')
    INTO Customers (customer_id, customer_name)
         VALUES (2, 'Diana')
    INTO Customers (customer_id, customer_name)
         VALUES (3, 'Elizabeth')
    INTO Customers (customer_id, customer_name)
         VALUES (4, 'Jhon')
SELECT * FROM dual
;

CREATE TABLE Orders
    (order_id int, customer_id int, product_name varchar2(1))
;

INSERT ALL 
    INTO Orders (order_id, customer_id, product_name)
         VALUES (10, 1, 'A')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (20, 1, 'B')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (30, 1, 'D')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (40, 1, 'C')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (50, 2, 'A')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (60, 3, 'A')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (70, 3, 'B')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (80, 3, 'D')
    INTO Orders (order_id, customer_id, product_name)
         VALUES (90, 4, 'C')
SELECT * FROM dual
;

-- Solution 1:

with temp as
(select distinct customer_id from orders
where product_name ='C')
select c.customer_id, c.customer_name from orders o1 join orders o2 on o1.customer_id = o2.customer_id
join customers c on o1.customer_id = c.customer_id
where o1.customer_id not in (select * from temp) and o1.product_name='A' and o2.product_name = 'B';

-- Solution 2:

with temp as 
(select  a.customer_id from orders a, orders b 
 where a.product_name = 'A' and b.product_name = 'B' and a.customer_id =
b.customer_id)
select a.customer_id,b.customer_name from temp a join customers b
on a.customer_id = b.customer_id and a.customer_id not in  (select customer_id
from orders where product_name = 'C') ;


