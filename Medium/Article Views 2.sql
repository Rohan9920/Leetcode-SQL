-- Table: Views

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | article_id    | int     |
-- | author_id     | int     |
-- | viewer_id     | int     |
-- | view_date     | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
-- Note that equal author_id and viewer_id indicate the same person.
 

-- Write an SQL query to find all the people who viewed more than one article on the same date, sorted in ascending order by their id.

-- The query result format is in the following example:

-- Views table:
-- +------------+-----------+-----------+------------+
-- | article_id | author_id | viewer_id | view_date  |
-- +------------+-----------+-----------+------------+
-- | 1          | 3         | 5         | 2019-08-01 |
-- | 3          | 4         | 5         | 2019-08-01 |
-- | 1          | 3         | 6         | 2019-08-02 |
-- | 2          | 7         | 7         | 2019-08-01 |
-- | 2          | 7         | 6         | 2019-08-02 |
-- | 4          | 7         | 1         | 2019-07-22 |
-- | 3          | 4         | 4         | 2019-07-21 |
-- | 3          | 4         | 4         | 2019-07-21 |
-- +------------+-----------+-----------+------------+

-- Result table:
-- +------+
-- | id   |
-- +------+
-- | 5    |
-- | 6    |
-- +------+

-- DDL Scripts:



CREATE TABLE Views
    (article_id int, author_id int, viewer_id int, view_date timestamp)
;

INSERT ALL 
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (1, 3, 5, '01-Aug-2019 12:00:00 AM')
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (3, 4, 5, '01-Aug-2019 12:00:00 AM')
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (1, 3, 6, '02-Aug-2019 12:00:00 AM')
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (2, 7, 7, '01-Aug-2019 12:00:00 AM')
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (2, 7, 6, '02-Aug-2019 12:00:00 AM')
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (4, 7, 1, '22-Jul-2019 12:00:00 AM')
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (3, 4, 4, '21-Jul-2019 12:00:00 AM')
    INTO Views (article_id, author_id, viewer_id, view_date)
         VALUES (3, 4, 4, '21-Jul-2019 12:00:00 AM')
SELECT * FROM dual
;


-- Solution:

Select viewer_id as id from
(select viewer_id,view_date from Views
group by viewer_id,view_date having count(distinct article_id)>1)
order by id;