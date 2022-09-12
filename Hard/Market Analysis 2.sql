-- Table: Users

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | user_id        | int     |
-- | join_date      | date    |
-- | favorite_brand | varchar |
-- +----------------+---------+
-- user_id is the primary key of this table.
-- This table has the info of the users of an online shopping website where users can sell and buy items.
-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | item_id       | int     |
-- | buyer_id      | int     |
-- | seller_id     | int     |
-- +---------------+---------+
-- order_id is the primary key of this table.
-- item_id is a foreign key to the Items table.
-- buyer_id and seller_id are foreign keys to the Users table.
-- Table: Items

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | item_id       | int     |
-- | item_brand    | varchar |
-- +---------------+---------+
-- item_id is the primary key of this table.
 

-- Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

-- It is guaranteed that no seller sold more than one item on a day.

-- The query result format is in the following example:

-- Users table:
-- +---------+------------+----------------+
-- | user_id | join_date  | favorite_brand |
-- +---------+------------+----------------+
-- | 1       | 2019-01-01 | Lenovo         |
-- | 2       | 2019-02-09 | Samsung        |
-- | 3       | 2019-01-19 | LG             |
-- | 4       | 2019-05-21 | HP             |
-- +---------+------------+----------------+

-- Orders table:
-- +----------+------------+---------+----------+-----------+
-- | order_id | order_date | item_id | buyer_id | seller_id |
-- +----------+------------+---------+----------+-----------+
-- | 1        | 2019-08-01 | 4       | 1        | 2         |
-- | 2        | 2019-08-02 | 2       | 1        | 3         |
-- | 3        | 2019-08-03 | 3       | 2        | 3         |
-- | 4        | 2019-08-04 | 1       | 4        | 2         |
-- | 5        | 2019-08-04 | 1       | 3        | 4         |
-- | 6        | 2019-08-05 | 2       | 2        | 4         |
-- +----------+------------+---------+----------+-----------+

-- Items table:
-- +---------+------------+
-- | item_id | item_brand |
-- +---------+------------+
-- | 1       | Samsung    |
-- | 2       | Lenovo     |
-- | 3       | LG         |
-- | 4       | HP         |
-- +---------+------------+

-- Result table:
-- +-----------+--------------------+
-- | seller_id | 2nd_item_fav_brand |
-- +-----------+--------------------+
-- | 1         | no                 |
-- | 2         | yes                |
-- | 3         | yes                |
-- | 4         | no                 |
-- +-----------+--------------------+

-- The answer for the user with id 1 is no because they sold nothing.
-- The answer for the users with id 2 and 3 is yes because the brands of their second sold items are their favorite brands.
-- The answer for the user with id 4 is no because the brand of their second sold item is not their favorite brand.

-- DDL statement:

CREATE TABLE Users
    (user_id int, join_date timestamp, favorite_brand varchar2(7))
;

INSERT ALL 
    INTO Users (user_id, join_date, favorite_brand)
         VALUES (1, '01-Jan-2019 12:00:00 AM', 'Lenovo')
    INTO Users (user_id, join_date, favorite_brand)
         VALUES (2, '09-Feb-2019 12:00:00 AM', 'Samsung')
    INTO Users (user_id, join_date, favorite_brand)
         VALUES (3, '19-Jan-2019 12:00:00 AM', 'LG')
    INTO Users (user_id, join_date, favorite_brand)
         VALUES (4, '21-May-2019 12:00:00 AM', 'HP')
SELECT * FROM dual
;

CREATE TABLE Orders
    (order_id int, order_date timestamp, item_id int, buyer_id int, seller_id int)
;

INSERT ALL 
    INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
         VALUES (1, '01-Aug-2019 12:00:00 AM', 4, 1, 2)
    INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
         VALUES (2, '02-Aug-2019 12:00:00 AM', 2, 1, 3)
    INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
         VALUES (3, '03-Aug-2019 12:00:00 AM', 3, 2, 3)
    INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
         VALUES (4, '04-Aug-2019 12:00:00 AM', 1, 4, 2)
    INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
         VALUES (5, '04-Aug-2019 12:00:00 AM', 1, 3, 4)
    INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
         VALUES (6, '05-Aug-2019 12:00:00 AM', 2, 2, 4)
SELECT * FROM dual
;


CREATE TABLE Items
    (item_id int, item_brand varchar2(7))
;

INSERT ALL 
    INTO Items (item_id, item_brand)
         VALUES (1, 'Samsung')
    INTO Items (item_id, item_brand)
         VALUES (2, 'Lenovo')
    INTO Items (item_id, item_brand)
         VALUES (3, 'LG')
    INTO Items (item_id, item_brand)
         VALUES (4, 'HP')
SELECT * FROM dual
;

--Solution:

with temp as
(select seller_id, item_id from
(select seller_id, item_id, row_number() over (partition by seller_id order by order_date) as rn
from orders) where rn = 2),
favs as 
(select u.user_id, i.item_id from users u, items i where u.favorite_brand = i.item_brand)
select f.user_id, case when f.item_id = t.item_id then 'yes' else 'no' end as "2nd_item_fav_brand"
from favs f left join temp t on f.user_id = t.seller_id
order by f.user_id;


