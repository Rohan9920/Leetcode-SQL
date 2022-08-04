Table: Spending

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | spend_date  | date    |
-- | platform    | enum    | 
-- | amount      | int     |
-- +-------------+---------+
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
-- (user_id, spend_date, platform) is the primary key of this table.
-- The platform column is an ENUM type of ('desktop', 'mobile').
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

-- The query result format is in the following example:

-- Spending table:
-- +---------+------------+----------+--------+
-- | user_id | spend_date | platform | amount |
-- +---------+------------+----------+--------+
-- | 1       | 2019-07-01 | mobile   | 100    |
-- | 1       | 2019-07-01 | desktop  | 100    |
-- | 2       | 2019-07-01 | mobile   | 100    |
-- | 2       | 2019-07-02 | mobile   | 100    |
-- | 3       | 2019-07-01 | desktop  | 100    |
-- | 3       | 2019-07-02 | desktop  | 100    |
-- +---------+------------+----------+--------+

-- Result table:
-- +------------+----------+--------------+-------------+
-- | spend_date | platform | total_amount | total_users |
-- +------------+----------+--------------+-------------+
-- | 2019-07-01 | desktop  | 100          | 1           |
-- | 2019-07-01 | mobile   | 100          | 1           |
-- | 2019-07-01 | both     | 200          | 1           |
-- | 2019-07-02 | desktop  | 100          | 1           |
-- | 2019-07-02 | mobile   | 100          | 1           |
-- | 2019-07-02 | both     | 0            | 0           |
-- +------------+----------+--------------+-------------+ 
-- On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
-- On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.

-- DDL Scripts:

CREATE TABLE Spending
    (user_id int, spend_date date, platform varchar2(7), amount int)
;

INSERT ALL 
    INTO Spending (user_id, spend_date, platform, amount)
         VALUES (1, '2019-07-01', 'mobile', 100)
    INTO Spending (user_id, spend_date, platform, amount)
         VALUES (1, '2019-Jul-01', 'desktop', 100)
    INTO Spending (user_id, spend_date, platform, amount)
         VALUES (2, '2019-07-01', 'mobile', 100)
    INTO Spending (user_id, spend_date, platform, amount)
         VALUES (2, '2019-07-02', 'mobile', 100)
    INTO Spending (user_id, spend_date, platform, amount)
         VALUES (3, '2019-07-01', 'desktop', 100)
    INTO Spending (user_id, spend_date, platform, amount)
         VALUES (3, '2019-07-02', 'desktop', 100)
SELECT * FROM dual
;

-- Solution 1 (Lengthy solution with repetitions)

with temp as
(select user_id, spend_date from spending 
group by user_id, spend_date
having count(*)>1),
dist_dates as
(select distinct spend_date from spending)
select temp.spend_date, 'mobile' as platform, (select NVL(sum(amount),0) from spending where platform = 'mobile' and spend_date = temp.spend_date and user_id not in (select user_id from temp where spend_date = temp.spend_date)), (select count(user_id) from spending where platform = 'mobile' and spend_date = temp.spend_date and user_id not in (select user_id from temp where spend_date = temp.spend_date))  from (select * from dist_dates)temp
UNION ALL
select temp.spend_date, 'desktop' as platform, (select NVL(sum(amount),0) from spending where platform = 'desktop' and spend_date = temp.spend_date and user_id not in (select user_id from temp where spend_date = temp.spend_date)), (select count(user_id) from spending where platform = 'desktop' and spend_date = temp.spend_date and user_id not in (select user_id from temp where spend_date = temp.spend_date))  from (select * from dist_dates)temp
UNION ALL
select temp.spend_date, 'both' as platform, (select NVL(sum(amount),0) from spending where spend_date = temp.spend_date and user_id  in (select user_id from temp where spend_date = temp.spend_date)), (select count( distinct user_id) from spending where spend_date = temp.spend_date and user_id in (select user_id from temp where spend_date = temp.spend_date)) from (select * from dist_dates)temp;

-- Solution 2 (Better than the first solution but still has repetitons)

with temp as 
( select distinct spend_date, 'mobile' as platform from spending
  UNION
 (select distinct spend_date, 'desktop' as platform from spending)
 UNION
 (select distinct spend_date, 'both' as platform from spending)
)
select spend_date, platform, NVL(amt, 0), NVL(num_ppl,0)
from
(select a.spend_date, a.platform, 
CASE WHEN a. platform != 'both' THEN (select sum(amount) from spending where spend_date = a.spend_date and platform = a.platform and user_id in (select user_id from spending where spend_date = a.spend_date group by user_id having count(user_id)=1))
ELSE
(select sum(amount) from spending where spend_date = a.spend_date and user_id in (select user_id from spending where spend_date = a.spend_date group by user_id having count(user_id)>1)) END as amt,
CASE WHEN  a. platform != 'both' THEN (select count(user_id) from spending where 
spend_date = a.spend_date and platform = a.platform and user_id in (select user_id from spending where spend_date = a.spend_date group by user_id having count(user_id)=1))
ELSE
(select count(user_id) from spending where 
spend_date = a.spend_date and user_id in (select user_id from spending where spend_date = a.spend_date group by user_id having count(user_id)>1)) END as num_ppl
from temp a);

-- Solution 3 (Best solution with left joins - would only work if ONLY_FULL_GROUP_BY is disabled)

select temp.spend_date, temp.platform, NVL(sum(amount),0), NVL(count(distinct user_id),0) from
(
(select distinct spend_date,  'desktop' as platform from spending
UNION
select distinct spend_date,  'mobile' as platform from spending
UNION
select distinct spend_date,  'both' as platform from spending)temp
LEFT JOIN (select user_id, spend_date, sum(amount) as amount, (case when count(*)>1 then 'both' else platform end) as platform from spending group by spend_date, user_id)a ON temp.spend_date = a.spend_date and temp.platform = a.platform)
group by temp.spend_date, temp.platform;

