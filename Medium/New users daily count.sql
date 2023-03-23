-- Table: Traffic

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | activity      | enum    |
-- | activity_date | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
 

-- Write an SQL query that reports for every date within at most 90 days from today, 
-- the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

-- The query result format is in the following example:

-- Traffic table:
-- +---------+----------+---------------+
-- | user_id | activity | activity_date |
-- +---------+----------+---------------+
-- | 1       | login    | 2019-05-01    |
-- | 1       | homepage | 2019-05-01    |
-- | 1       | logout   | 2019-05-01    |
-- | 2       | login    | 2019-06-21    |
-- | 2       | logout   | 2019-06-21    |
-- | 3       | login    | 2019-01-01    |
-- | 3       | jobs     | 2019-01-01    |
-- | 3       | logout   | 2019-01-01    |
-- | 4       | login    | 2019-06-21    |
-- | 4       | groups   | 2019-06-21    |
-- | 4       | logout   | 2019-06-21    |
-- | 5       | login    | 2019-03-01    |
-- | 5       | logout   | 2019-03-01    |
-- | 5       | login    | 2019-06-21    |
-- | 5       | logout   | 2019-06-21    |
-- +---------+----------+---------------+

-- Result table:
-- +------------+-------------+
-- | login_date | user_count  |
-- +------------+-------------+
-- | 2019-05-01 | 1           |
-- | 2019-06-21 | 2           |
-- +------------+-------------+
-- Note that we only care about dates with non zero user count.
-- The user with id 5 first logged in on 2019-03-01 so he's not counted on 2019-06-21.

-- DDL Scripts:

CREATE TABLE traffic
    (user_id int, activity varchar2(8), activity_date date)
;

INSERT ALL 
    INTO traffic (user_id, activity, activity_date)
         VALUES (1, 'login', '2019-05-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (1, 'homepage', '2019-05-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (1, 'logout', '2019-05-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (2, 'login', '2019-06-21')
    INTO traffic (user_id, activity, activity_date)
         VALUES (2, 'logout', '2019-06-21')
    INTO traffic (user_id, activity, activity_date)
         VALUES (3, 'login', '2019-01-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (3, 'jobs', '2019-01-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (3, 'logout', '2019-01-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (4, 'login', '2019-06-21')
    INTO traffic (user_id, activity, activity_date)
         VALUES (4, 'groups', '2019-06-21')
    INTO traffic (user_id, activity, activity_date)
         VALUES (4, 'logout', '2019-06-21')
    INTO traffic (user_id, activity, activity_date)
         VALUES (5, 'login', '2019-03-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (5, 'logout', '2019-03-01')
    INTO traffic (user_id, activity, activity_date)
         VALUES (5, 'login', '2019-06-21')
    INTO traffic (user_id, activity, activity_date)
         VALUES (5, 'logout', '2019-06-21')
SELECT * FROM dual
;

-- Solution 1:

with temp as
(select user_id, activity_date, row_number() over (partition by user_id order by activity_date)as rn from traffic where activity  = 'login')
select activity_date, count(distinct user_id) as user_count from temp
where rn=1 and TO_DATE('2019-06-30','YYYY-MM-DD')-activity_date   < 90
group by activity_date;

-- Solution 2:

with t1 as
(
    select user_id, min(activity_date) as login_date
    from Traffic
    where activity = 'login'
    group by user_id
)

select login_date, count(distinct user_id) as user_count
from t1
where login_date between '2019-04-01' and '2019-06-30'
group by login_date;
