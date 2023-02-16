-- Table: Friends

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- | activity      | varchar |
-- +---------------+---------+
-- id is the id of the friend and primary key for this table.
-- name is the name of the friend.
-- activity is the name of the activity which the friend takes part in.
-- Table: Activities

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- id is the primary key for this table.
-- name is the name of the activity.
 

-- Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

-- Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

-- The query result format is in the following example:

-- Friends table:
-- +------+--------------+---------------+
-- | id   | name         | activity      |
-- +------+--------------+---------------+
-- | 1    | Jonathan D.  | Eating        |
-- | 2    | Jade W.      | Singing       |
-- | 3    | Victor J.    | Singing       |
-- | 4    | Elvis Q.     | Eating        |
-- | 5    | Daniel A.    | Eating        |
-- | 6    | Bob B.       | Horse Riding  |
-- +------+--------------+---------------+

-- Activities table:
-- +------+--------------+
-- | id   | name         |
-- +------+--------------+
-- | 1    | Eating       |
-- | 2    | Singing      |
-- | 3    | Horse Riding |
-- +------+--------------+

-- Result table:
-- +--------------+
-- | activity     |
-- +--------------+
-- | Singing      |
-- +--------------+

-- Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
-- Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
-- Singing is performed by 2 friends (Victor J. and Jade W.)

-- DDL Scripts:

CREATE TABLE Friends
    (id int, name varchar2(11), activity varchar2(12))
;

INSERT ALL 
    INTO Friends (id, name, activity)
         VALUES (1, 'Jonathan D.', 'Eating')
    INTO Friends (id, name, activity)
         VALUES (2, 'Jade W.', 'Singing')
    INTO Friends (id, name, activity)
         VALUES (3, 'Victor J.', 'Singing')
    INTO Friends (id, name, activity)
         VALUES (4, 'Elvis Q.', 'Eating')
    INTO Friends (id, name, activity)
         VALUES (5, 'Daniel A.', 'Eating')
    INTO Friends (id, name, activity)
         VALUES (6, 'Bob B.', 'Horse Riding')
SELECT * FROM dual
;

CREATE TABLE Activities
    (id int, name varchar2(12))
;

INSERT ALL 
    INTO Activities (id, name)
         VALUES (1, 'Eating')
    INTO Activities (id, name)
         VALUES (2, 'Singing')
    INTO Activities (id, name)
         VALUES (3, 'Horse Riding')
SELECT * FROM dual
;

-- Solution 1: (Using max and min)

with temp as
(select activity, count(id) as cnt from friends group by activity )
select activity from   
(select activity, cnt, max(cnt) over () as mx, min(cnt) over () as mn from temp)
where cnt != mx and cnt!= mn;

-- Solution 2: (Using rank)

select activity from
(select activity, rank() over (order by cnt desc) as highest, rank() over (order by cnt)
as lowest from
(select activity, count(activity) as cnt from friends group by activity)) where highest!=1 and lowest!=1 ; 
