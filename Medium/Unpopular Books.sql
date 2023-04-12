-- Table: Books

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | book_id        | int     |
-- | name           | varchar |
-- | available_from | date    |
-- +----------------+---------+
-- book_id is the primary key of this table.
-- Table: Orders

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | order_id       | int     |
-- | book_id        | int     |
-- | quantity       | int     |
-- | dispatch_date  | date    |
-- +----------------+---------+
-- order_id is the primary key of this table.
-- book_id is a foreign key to the Books table.
 

-- Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.

-- The query result format is in the following example:

-- Books table:
-- +---------+--------------------+----------------+
-- | book_id | name               | available_from |
-- +---------+--------------------+----------------+
-- | 1       | "Kalila And Demna" | 2010-01-01     |
-- | 2       | "28 Letters"       | 2012-05-12     |
-- | 3       | "The Hobbit"       | 2019-06-10     |
-- | 4       | "13 Reasons Why"   | 2019-06-01     |
-- | 5       | "The Hunger Games" | 2008-09-21     |
-- +---------+--------------------+----------------+

-- Orders table:
-- +----------+---------+----------+---------------+
-- | order_id | book_id | quantity | dispatch_date |
-- +----------+---------+----------+---------------+
-- | 1        | 1       | 2        | 2018-07-26    |
-- | 2        | 1       | 1        | 2018-11-05    |
-- | 3        | 3       | 8        | 2019-06-11    |
-- | 4        | 4       | 6        | 2019-06-05    |
-- | 5        | 4       | 5        | 2019-06-20    |
-- | 6        | 5       | 9        | 2009-02-02    |
-- | 7        | 5       | 8        | 2010-04-13    |
-- +----------+---------+----------+---------------+

-- Result table:
-- +-----------+--------------------+
-- | book_id   | name               |
-- +-----------+--------------------+
-- | 1         | "Kalila And Demna" |
-- | 2         | "28 Letters"       |
-- | 5         | "The Hunger Games" |
-- +-----------+--------------------+

-- DDL Scripts:

CREATE TABLE Books
    (book_id int, name varchar2(18), available_from date)
;

INSERT ALL 
    INTO Books (book_id, name, available_from)
         VALUES (1, 'Kalila And Demna', '2010-01-01')
    INTO Books (book_id, name, available_from)
         VALUES (2, '28 Letters', '2012-05-12')
    INTO Books (book_id, name, available_from)
         VALUES (3, 'The Hobbit', '2019-06-10')
    INTO Books (book_id, name, available_from)
         VALUES (4, '13 Reasons Why', '2019-06-01')
    INTO Books (book_id, name, available_from)
         VALUES (5, 'The Hunger Games', '2008-09-21')
SELECT * FROM dual
;

CREATE TABLE Orders
    (order_id int, book_id int, quantity int, dispatch_date date)
;

INSERT ALL 
    INTO Orders (order_id, book_id, quantity, dispatch_date)
         VALUES (1, 1, 2, '2018-07-26')
    INTO Orders (order_id, book_id, quantity, dispatch_date)
         VALUES (2, 1, 1, '2018-11-05')
    INTO Orders (order_id, book_id, quantity, dispatch_date)
         VALUES (3, 3, 8, '2019-06-11')
    INTO Orders (order_id, book_id, quantity, dispatch_date)
         VALUES (4, 4, 6, '2019-06-05')
    INTO Orders (order_id, book_id, quantity, dispatch_date)
         VALUES (5, 4, 5, '2019-06-20')
    INTO Orders (order_id, book_id, quantity, dispatch_date)
         VALUES (6, 5, 9, '2009-02-02')
    INTO Orders (order_id, book_id, quantity, dispatch_date)
         VALUES (7, 5, 8, '2010-04-13')
SELECT * FROM dual
;

-- Solution 1:


with temp1 as
(select book_id, name from books where TO_DATE('2019-06-23','YYYY-MM-DD')-available_from > 30),
temp2 as
(select book_id,quantity from orders where extract(year from dispatch_date)=2018)
select t1.book_id, t1.name from temp1 t1 left join temp2 t2 on t1.book_id = t2.book_id
group by t1.book_id, t1.name
having NVL(sum(t2.quantity),0) < 10;

-- Solution 2:

select b.book_id, name
from
(select *
from books
where available_from < '2019-05-23') b
left join
(select *
from orders 
where dispatch_date > '2018-06-23') a
on a.book_id = b.book_id
group by b.book_id, name
having coalesce(sum(quantity),0)<10
