-- Table: UserActivity

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | username      | varchar |
-- | activity      | varchar |
-- | startDate     | Date    |
-- | endDate       | Date    |
-- +---------------+---------+
-- This table does not contain primary key.
-- This table contain information about the activity performed of each user in a period of time.
-- A person with username performed a activity from startDate to endDate.

-- Write an SQL query to show the second most recent activity of each user.

-- If the user only has one activity, return that one. 

-- A user can't perform more than one activity at the same time. Return the result table in any order.

-- The query result format is in the following example:

-- UserActivity table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Travel       | 2020-02-12  | 2020-02-20  |
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Alice      | Travel       | 2020-02-24  | 2020-02-28  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- Result table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+

-- The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
-- Bob only has one record, we just take that one.

-- DDL Scripts:

CREATE TABLE UserActivity
    (username varchar2(5), activity varchar2(7), startDate date, endDate date)
;

INSERT ALL 
    INTO UserActivity (username, activity, startDate, endDate)
         VALUES ('Alice', 'Travel', '2020-02-12', '2020-02-20')
    INTO UserActivity (username, activity, startDate, endDate)
         VALUES ('Alice', 'Dancing', '2020-02-21', '2020-02-23')
    INTO UserActivity (username, activity, startDate, endDate)
         VALUES ('Alice', 'Travel', '2020-02-24', '2020-02-28')
    INTO UserActivity (username, activity, startDate, endDate)
         VALUES ('Bob', 'Travel', '2020-02-11', '2020-02-18')
SELECT * FROM dual
;

-- Solution 1:

with temp as
(select username, activity, startDate, row_number() over(partition by username order by startDate) as rn, max(startDate) over (partition by username) as mx from UserActivity)
select username, activity from temp
where rn=2 or (startDate=mx and rn=1);

-- Solution 2:

with temp as
(select username, activity, startDate, row_number() over(partition by username order by startDate) as rn, count(*) over (partition by username) as cnt from UserActivity)
select username, activity from temp
where rn=2 or (cnt=1);
