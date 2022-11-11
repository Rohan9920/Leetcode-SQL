-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | order_date    | date    | 
-- | item_id       | varchar |
-- | quantity      | int     |
-- +---------------+---------+
-- (ordered_id, item_id) is the primary key for this table.
-- This table contains information of the orders placed.
-- order_date is the date when item_id was ordered by the customer with id customer_id.
 

-- Table: Items

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | item_id             | varchar |
-- | item_name           | varchar |
-- | item_category       | varchar |
-- +---------------------+---------+
-- item_id is the primary key for this table.
-- item_name is the name of the item.
-- item_category is the category of the item.
 

-- You are the business owner and would like to obtain a sales report for category items and day of the week.

-- Write an SQL query to report how many units in each category have been ordered on each day of the week.

-- Return the result table ordered by category.

-- The query result format is in the following example:

 

-- Orders table:
-- +------------+--------------+-------------+--------------+-------------+
-- | order_id   | customer_id  | order_date  | item_id      | quantity    |
-- +------------+--------------+-------------+--------------+-------------+
-- | 1          | 1            | 2020-06-01  | 1            | 10          |
-- | 2          | 1            | 2020-06-08  | 2            | 10          |
-- | 3          | 2            | 2020-06-02  | 1            | 5           |
-- | 4          | 3            | 2020-06-03  | 3            | 5           |
-- | 5          | 4            | 2020-06-04  | 4            | 1           |
-- | 6          | 4            | 2020-06-05  | 5            | 5           |
-- | 7          | 5            | 2020-06-05  | 1            | 10          |
-- | 8          | 5            | 2020-06-14  | 4            | 5           |
-- | 9          | 5            | 2020-06-21  | 3            | 5           |
-- +------------+--------------+-------------+--------------+-------------+

-- Items table:
-- +------------+----------------+---------------+
-- | item_id    | item_name      | item_category |
-- +------------+----------------+---------------+
-- | 1          | LC Alg. Book   | Book          |
-- | 2          | LC DB. Book    | Book          |
-- | 3          | LC SmarthPhone | Phone         |
-- | 4          | LC Phone 2020  | Phone         |
-- | 5          | LC SmartGlass  | Glasses       |
-- | 6          | LC T-Shirt XL  | T-Shirt       |
-- +------------+----------------+---------------+

-- Result table:
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- | Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- | Book       | 20        | 5         | 0         | 0         | 10        | 0         | 0         |
-- | Glasses    | 0         | 0         | 0         | 0         | 5         | 0         | 0         |
-- | Phone      | 0         | 0         | 5         | 1         | 0         | 0         | 10        |
-- | T-Shirt    | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- On Monday (2020-06-01, 2020-06-08) were sold a total of 20 units (10 + 10) in the category Book (ids: 1, 2).
-- On Tuesday (2020-06-02) were sold a total of 5 units  in the category Book (ids: 1, 2).
-- On Wednesday (2020-06-03) were sold a total of 5 units in the category Phone (ids: 3, 4).
-- On Thursday (2020-06-04) were sold a total of 1 unit in the category Phone (ids: 3, 4).
-- On Friday (2020-06-05) were sold 10 units in the category Book (ids: 1, 2) and 5 units in Glasses (ids: 5).
-- On Saturday there are no items sold.
-- On Sunday (2020-06-14, 2020-06-21) were sold a total of 10 units (5 +5) in the category Phone (ids: 3, 4).
-- There are no sales of T-Shirt.

-- DDL Scripts:

CREATE TABLE Orders
    (order_id int, customer_id int, order_date timestamp, item_id int, quantity int)
;

INSERT ALL 
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (1, 1, '01-Jun-2020 12:00:00 AM', 1, 10)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (2, 1, '08-Jun-2020 12:00:00 AM', 2, 10)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (3, 2, '02-Jun-2020 12:00:00 AM', 1, 5)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (4, 3, '03-Jun-2020 12:00:00 AM', 3, 5)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (5, 4, '04-Jun-2020 12:00:00 AM', 4, 1)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (6, 4, '05-Jun-2020 12:00:00 AM', 5, 5)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (7, 5, '05-Jun-2020 12:00:00 AM', 1, 10)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (8, 5, '14-Jun-2020 12:00:00 AM', 4, 5)
    INTO Orders (order_id, customer_id, order_date, item_id, quantity)
         VALUES (9, 5, '21-Jun-2020 12:00:00 AM', 3, 5)
SELECT * FROM dual
;

CREATE TABLE Items
    (item_id int, item_name varchar2(14), item_category varchar2(7))
;

INSERT ALL 
    INTO Items (item_id, item_name, item_category)
         VALUES (1, 'LC Alg. Book', 'Book')
    INTO Items (item_id, item_name, item_category)
         VALUES (2, 'LC DB. Book', 'Book')
    INTO Items (item_id, item_name, item_category)
         VALUES (3, 'LC SmarthPhone', 'Phone')
    INTO Items (item_id, item_name, item_category)
         VALUES (4, 'LC Phone 2020', 'Phone')
    INTO Items (item_id, item_name, item_category)
         VALUES (5, 'LC SmartGlass', 'Glasses')
    INTO Items (item_id, item_name, item_category)
         VALUES (6, 'LC T-Shirt XL', 'T-Shirt')
SELECT * FROM dual
;   

--Solution 1: (Using group by)

with temp as
(select TO_CHAR(o.order_date, 'D') as Day,i.item_category,o.quantity from orders o, items i where o.item_id
= i.item_id),
dist_items as
(select distinct item_category from items order by 1)
select item_category,
(select NVL(sum(quantity),0) from temp where day=2 and item_category=
d.item_category) as MONDAY, 
(select NVL(sum(quantity),0) from temp where day=3 and item_category=
d.item_category) as TUESDAY, 
(select NVL(sum(quantity),0) from temp where day=4 and item_category=
d.item_category) as WEDNESDAY, 
(select NVL(sum(quantity),0) from temp where day=5 and item_category=
d.item_category) as THURSDAY, 
(select NVL(sum(quantity),0) from temp where day=6 and item_category=
d.item_category) as FRIDAY, 
(select NVL(sum(quantity),0) from temp where day=7 and item_category=
d.item_category) as SATURDAY ,
(select NVL(sum(quantity),0) from temp where day=1 and item_category=
d.item_category) as SUNDAY 
from dist_items d;

-- Solution 2: (Using partition)

with temp as 
(select distinct i.item_category,
case when TO_CHAR(o.order_date, 'D')=2 then sum(o.quantity) over (partition by item_category, TO_CHAR(o.order_date, 'D')) else 0 end as MONDAY,
case when TO_CHAR(o.order_date, 'D')=3 then sum(o.quantity) over (partition by item_category, TO_CHAR(o.order_date, 'D')) else 0 end as TUESDAY,
case when TO_CHAR(o.order_date, 'D')=4 then sum(o.quantity) over (partition by item_category, TO_CHAR(o.order_date, 'D')) else 0 end as WEDNESDAY,
case when TO_CHAR(o.order_date, 'D')=5 then sum(o.quantity) over (partition by item_category, TO_CHAR(o.order_date, 'D')) else 0 end as THURSDAY,
case when TO_CHAR(o.order_date, 'D')=6 then sum(o.quantity) over (partition by item_category, TO_CHAR(o.order_date, 'D')) else 0 end as FRIDAY,
case when TO_CHAR(o.order_date, 'D')=7 then sum(o.quantity) over (partition by item_category, TO_CHAR(o.order_date, 'D')) else 0 end as SATURDAY,
case when TO_CHAR(o.order_date, 'D')=1 then sum(o.quantity) over (partition by item_category, TO_CHAR(o.order_date, 'D')) else 0 end as SUNDAY
from items i left join orders o
on i.item_id = o.item_id)
select item_category, sum(MONDAY) as MONDAY,sum(TUESDAY) as TUESDAY,
sum(WEDNESDAY) as WEDNESDAY,sum(THURSDAY) as THURSDAY,sum(FRIDAY) as FRIDAY,
sum(SATURDAY) as SATURDAY,sum(SUNDAY) as SUNDAY
from temp
group by item_category
order by 1;
