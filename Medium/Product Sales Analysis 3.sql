-- Table: Sales

-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | sale_id     | int   |
-- | product_id  | int   |
-- | year        | int   |
-- | quantity    | int   |
-- | price       | int   |
-- +-------------+-------+
-- sale_id is the primary key of this table.
-- product_id is a foreign key to Product table.
-- Note that the price is per unit.
-- Table: Product

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | product_id   | int     |
-- | product_name | varchar |
-- +--------------+---------+
-- product_id is the primary key of this table.
 

-- Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

-- The query result format is in the following example:

-- Sales table:
-- +---------+------------+------+----------+-------+
-- | sale_id | product_id | year | quantity | price |
-- +---------+------------+------+----------+-------+ 
-- | 1       | 100        | 2008 | 10       | 5000  |
-- | 2       | 100        | 2009 | 12       | 5000  |
-- | 7       | 200        | 2011 | 15       | 9000  |
-- +---------+------------+------+----------+-------+

-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 100        | Nokia        |
-- | 200        | Apple        |
-- | 300        | Samsung      |
-- +------------+--------------+

-- Result table:
-- +------------+------------+----------+-------+
-- | product_id | first_year | quantity | price |
-- +------------+------------+----------+-------+ 
-- | 100        | 2008       | 10       | 5000  |
-- | 200        | 2011       | 15       | 9000  |
-- +------------+------------+----------+-------+

-- DDL Scripts:

CREATE TABLE Sales
    (sale_id int, product_id int, year int, quantity int, price int)
;

INSERT ALL 
    INTO Sales (sale_id, product_id, year, quantity, price)
         VALUES (1, 100, 2008, 10, 5000)
    INTO Sales (sale_id, product_id, year, quantity, price)
         VALUES (2, 100, 2009, 12, 5000)
    INTO Sales (sale_id, product_id, year, quantity, price)
         VALUES (7, 200, 2011, 15, 9000)
SELECT * FROM dual
;



CREATE TABLE Product
    (product_id int, product_name varchar2(7))
;

INSERT ALL 
    INTO Product (product_id, product_name)
         VALUES (100, 'Nokia')
    INTO Product (product_id, product_name)
         VALUES (200, 'Apple')
    INTO Product (product_id, product_name)
         VALUES (300, 'Samsung')
SELECT * FROM dual
;

-- Solution: (order by sale_id to avoid cases with duplicate year)

select product_id, first_year, quantity,price from
(select product_id,year as first_year, quantity ,price, row_number() over (partition by
product_id order by sale_id) as rn from sales)
where rn=1;
