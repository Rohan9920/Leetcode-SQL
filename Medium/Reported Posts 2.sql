-- Table: Actions

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | post_id       | int     |
-- | action_date   | date    |
-- | action        | enum    |
-- | extra         | varchar |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
-- The extra column has optional information about the action such as a reason for report or a type of reaction. 
-- Table: Removals

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | post_id       | int     |
-- | remove_date   | date    | 
-- +---------------+---------+
-- post_id is the primary key of this table.
-- Each row in this table indicates that some post was removed as a result of being reported or as a result of an admin review.
 

-- Write an SQL query to find the average for daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

-- The query result format is in the following example:

-- Actions table:
-- +---------+---------+-------------+--------+--------+
-- | user_id | post_id | action_date | action | extra  |
-- +---------+---------+-------------+--------+--------+
-- | 1       | 1       | 2019-07-01  | view   | null   |
-- | 1       | 1       | 2019-07-01  | like   | null   |
-- | 1       | 1       | 2019-07-01  | share  | null   |
-- | 2       | 2       | 2019-07-04  | view   | null   |
-- | 2       | 2       | 2019-07-04  | report | spam   |
-- | 3       | 4       | 2019-07-04  | view   | null   |
-- | 3       | 4       | 2019-07-04  | report | spam   |
-- | 4       | 3       | 2019-07-02  | view   | null   |
-- | 4       | 3       | 2019-07-02  | report | spam   |
-- | 5       | 2       | 2019-07-03  | view   | null   |
-- | 5       | 2       | 2019-07-03  | report | racism |
-- | 5       | 5       | 2019-07-03  | view   | null   |
-- | 5       | 5       | 2019-07-03  | report | racism |
-- +---------+---------+-------------+--------+--------+

-- Removals table:
-- +---------+-------------+
-- | post_id | remove_date |
-- +---------+-------------+
-- | 2       | 2019-07-20  |
-- | 3       | 2019-07-18  |
-- +---------+-------------+

-- Result table:
-- +-----------------------+
-- | average_daily_percent |
-- +-----------------------+
-- | 75.00                 |
-- +-----------------------+
-- The percentage for 2019-07-04 is 50% because only one post of two spam reported posts was removed.
-- The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
-- The other days had no spam reports so the average is (50 + 100) / 2 = 75%
-- Note that the output is only one number and that we do not care about the remove dates.


-- DDL Scripts:

CREATE TABLE Actions
    (user_id int, post_id int, action_date date, action varchar2(6), extra varchar2(6))
;

INSERT ALL 
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (1, 1, '2019-07-01', 'view', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (1, 1, '2019-07-01', 'like', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (1, 1, '2019-07-01', 'share', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (2, 2, '2019-07-04', 'view', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (2, 2, '2019-07-04', 'report', 'spam')
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (3, 4, '2019-07-04', 'view', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (3, 4, '2019-07-04', 'report', 'spam')
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (4, 3, '2019-07-02', 'view', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (4, 3, '2019-07-02', 'report', 'spam')
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (5, 2, '2019-07-03', 'view', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (5, 2, '2019-07-03', 'report', 'racism')
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (5, 5, '2019-07-03', 'view', NULL)
    INTO Actions (user_id, post_id, action_date, action, extra)
         VALUES (5, 5, '2019-07-03', 'report', 'racism')
SELECT * FROM dual
;


CREATE TABLE Removals
    (post_id int, remove_date date)
;

INSERT ALL 
    INTO Removals (post_id, remove_date)
         VALUES (2, '2019-07-20')
    INTO Removals (post_id, remove_date)
         VALUES (3, '2019-07-18')
SELECT * FROM dual
;

-- Solution:

select round(avg((remove/spam)*100),2) from
(select a.action_date, count(distinct a.post_id) as spam, count(distinct b.post_id) as remove from actions a left join removals b on a.post_id = b.post_id
where action = 'report' and extra = 'spam'
group by a.action_date);
