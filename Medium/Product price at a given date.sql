-- Table: Products

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.
 

-- Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

-- The query result format is in the following example:

-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+

-- Result table:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+


-- DDL scripts:

CREATE TABLE Products
    (product_id int, new_price int, change_date date)
;

INSERT ALL 
    INTO Products (product_id, new_price, change_date)
         VALUES (1, 20, '2019-08-14')
    INTO Products (product_id, new_price, change_date)
         VALUES (2, 50, '2019-08-14')
    INTO Products (product_id, new_price, change_date)
         VALUES (1, 30, '2019-08-15')
    INTO Products (product_id, new_price, change_date)
         VALUES (1, 35, '2019-08-16')
    INTO Products (product_id, new_price, change_date)
         VALUES (2, 65, '2019-08-17')
    INTO Products (product_id, new_price, change_date)
         VALUES (3, 20, '2019-08-18')
SELECT * FROM dual
;

-- Solution:

with temp as
(select product_id, new_price, rank() over (partition by product_id order by change_date desc) as rnk from products where change_date < = '2019-08-16')
select distinct p.product_id as product_id, NVL(t.new_price,10) as price from products p left join temp t
on p.product_id = t.product_id and t.rnk = 1
order by p.product_id;