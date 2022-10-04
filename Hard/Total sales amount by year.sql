-- Table: Product

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- product_name is the name of the product.
 

-- Table: Sales

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | product_id          | int     |
-- | period_start        | varchar |
-- | period_end          | date    |
-- | average_daily_sales | int     |
-- +---------------------+---------+
-- product_id is the primary key for this table. 
-- period_start and period_end indicates the start and end date for sales period, both dates are inclusive.
-- The average_daily_sales column holds the average daily sales amount of the items for the period.

-- Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name and report_year.

-- Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.

-- The query result format is in the following example:


-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 1          | LC Phone     |
-- | 2          | LC T-Shirt   |
-- | 3          | LC Keychain  |
-- +------------+--------------+

-- Sales table:
-- +------------+--------------+-------------+---------------------+
-- | product_id | period_start | period_end  | average_daily_sales |
-- +------------+--------------+-------------+---------------------+
-- | 1          | 2019-01-25   | 2019-02-28  | 100                 |
-- | 2          | 2018-12-01   | 2020-01-01  | 10                  |
-- | 3          | 2019-12-01   | 2020-01-31  | 1                   |
-- +------------+--------------+-------------+---------------------+

-- Result table:
-- +------------+--------------+-------------+--------------+
-- | product_id | product_name | report_year | total_amount |
-- +------------+--------------+-------------+--------------+
-- | 1          | LC Phone     |    2019     | 3500         |
-- | 2          | LC T-Shirt   |    2018     | 310          |
-- | 2          | LC T-Shirt   |    2019     | 3650         |
-- | 2          | LC T-Shirt   |    2020     | 10           |
-- | 3          | LC Keychain  |    2019     | 31           |
-- | 3          | LC Keychain  |    2020     | 31           |
-- +------------+--------------+-------------+--------------+
-- LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
-- LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
-- LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.

-- DDL scripts

CREATE TABLE Product
    (product_id int, product_name varchar2(11))
;

INSERT ALL 
    INTO Product (product_id, product_name)
         VALUES (1, 'LC Phone')
    INTO Product (product_id, product_name)
         VALUES (2, 'LC T-Shirt')
    INTO Product (product_id, product_name)
         VALUES (3, 'LC Keychain')
SELECT * FROM dual
;

CREATE TABLE Sales
    (product_id int, period_start date, period_end date, average_daily_sales int)
;
INSERT ALL 
    INTO Sales (product_id, period_start, period_end, average_daily_sales)
         VALUES (1, '2019-01-25', '2019-02-28', 100)
    INTO Sales (product_id, period_start, period_end, average_daily_sales)
         VALUES (2, '2018-12-01', '2020-01-01', 10)
    INTO Sales (product_id, period_start, period_end, average_daily_sales)
         VALUES (3, '2019-12-01', '2020-01-31', 1)
SELECT * FROM dual
;

-- Solution 1: (Using level function to build years table)

with temp as 
(select level + 2017 as years from dual connect by level <=3)
select a.product_id, b.product_name, a.years as report_year, a.no_of_days * a.average_daily_sales as total_amount from 
(select a.product_id, b.years, a.period_start, a.period_end, a.average_daily_sales,
CASE WHEN EXTRACT(year from a.period_start) = EXTRACT(year from a.period_end) THEN (period_end - period_start) + 1
WHEN EXTRACT(year from a.period_start) = b.years THEN (TO_DATE(CONCAT(EXTRACT(year from period_start),'-12-31'), 'YYYY-MM-DD') - a.period_start) + 1
WHEN EXTRACT(year from a.period_end) = b.years THEN (a.period_end - TO_DATE(CONCAT(EXTRACT(year from period_end),'-01-01'), 'YYYY-MM-DD') ) + 1
ELSE 365 END as no_of_days
from sales a join temp b
on b.years between EXTRACT(year from a.period_start) and EXTRACT(year from a.period_end))a, product b where
a.product_id = b.product_id
order by a.product_id, report_year;

-- Solution 2: (Using table unions to build years table)

select * from
(select b.product_id, b.product_name, b.yr,
CASE 
WHEN EXTRACT(year from a.period_start) = EXTRACT(year from a.period_end) and EXTRACT(year from a.period_start) = b.yr THEN (a.period_end - a.period_start) + 1
WHEN EXTRACT(year from a.period_start) = b.yr THEN (TO_DATE(CONCAT(EXTRACT(YEAR from period_start),'-12-31'),'YYYY-MM-DD')- a.period_start) + 1
WHEN EXTRACT(year from a.period_end) = b.yr THEN TO_NUMBER(TO_CHAR(a.period_end,'DDD'))
WHEN EXTRACT(year from a.period_start) < b.yr and EXTRACT(year from a.period_end) > b.yr THEN 365 
ELSE 0 END * average_daily_sales as cnt
from
(select product_id, product_name, '2018' as yr from product UNION
(select product_id, product_name, '2019' as yr from product) UNION
(select product_id, product_name, '2020' as yr from product))b join sales a on
a.product_id = b.product_id)
where  cnt!= 0
order by product_id, yr;

-- Notes:

-- TO_NUMBER(TO_CHAR(a.period_end,'DDD') returns day of the year. For eg 1st February would return 
-- 32. (31 days of Jan + 1st day of Feb.)