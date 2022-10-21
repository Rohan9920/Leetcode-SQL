-- Table: Failed

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | fail_date    | date    |
-- +--------------+---------+
-- Primary key for this table is fail_date.
-- Failed table contains the days of failed tasks.
-- Table: Succeeded

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | success_date | date    |
-- +--------------+---------+
-- Primary key for this table is success_date.
-- Succeeded table contains the days of succeeded tasks.
 

-- A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

-- Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

-- period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

-- Order result by start_date.

-- The query result format is in the following example:

-- Failed table:
-- +-------------------+
-- | fail_date         |
-- +-------------------+
-- | 2018-12-28        |
-- | 2018-12-29        |
-- | 2019-01-04        |
-- | 2019-01-05        |
-- +-------------------+

-- Succeeded table:
-- +-------------------+
-- | success_date      |
-- +-------------------+
-- | 2018-12-30        |
-- | 2018-12-31        |
-- | 2019-01-01        |
-- | 2019-01-02        |
-- | 2019-01-03        |
-- | 2019-01-06        |
-- +-------------------+


-- Result table:
-- +--------------+--------------+--------------+
-- | period_state | start_date   | end_date     |
-- +--------------+--------------+--------------+
-- | succeeded    | 2019-01-01   | 2019-01-03   |
-- | failed       | 2019-01-04   | 2019-01-05   |
-- | succeeded    | 2019-01-06   | 2019-01-06   |
-- +--------------+--------------+--------------+

-- The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
-- From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
-- From 2019-01-04 to 2019-01-05 all tasks failed and system state was "failed".
-- From 2019-01-06 to 2019-01-06 all tasks succeeded and system state was "succeeded".

-- DDL Scripts:

CREATE TABLE Failed
    (fail_date DATE)
;

INSERT ALL 
    INTO Failed (fail_date)
         VALUES ('28-Dec-2018')
    INTO Failed (fail_date)
         VALUES ('29-Dec-2018')
    INTO Failed (fail_date)
         VALUES ('04-Jan-2019')
    INTO Failed (fail_date)
         VALUES ('05-Jan-2019')
SELECT * FROM dual
;

CREATE TABLE Succeeded
    (success_date DATE)
;

INSERT ALL 
    INTO Succeeded (success_date)
         VALUES ('30-Dec-2018')
    INTO Succeeded (success_date)
         VALUES ('31-Dec-2018')
    INTO Succeeded (success_date)
         VALUES ('01-Jan-2019')
    INTO Succeeded (success_date)
         VALUES ('02-Jan-2019')
    INTO Succeeded (success_date)
         VALUES ('03-Jan-2019')
    INTO Succeeded (success_date)
         VALUES ('06-Jan-2019')
SELECT * FROM dual
;

-- Solution 1:

with temp as
(
select 'failed' as period_state, fail_date from failed
where EXTRACT(year from fail_date)=2019 UNION ALL
(select 'succeeded' as period_state, success_date from succeeded
where EXTRACT(year from success_date)=2019)
), filtered as
(select period_state, fail_date, fail_date - row_number () over (partition by period_state
order by fail_date) as prev_date from temp)
select period_state, start_date, end_date from
(select prev_date, period_state, min(fail_date) as start_date, max(fail_date) as end_date
from filtered group by prev_date, period_state)
order by start_date;

-- Solution 2:

WITH temp_one as
(select min(fail_date) as start_date, max(fail_date) as end_date,'failed' as status from
(select fail_date, fail_date -  row_number() over (order by fail_date) diff  from failed where fail_date between '2019-01-01' and '2019-12-31')
group by diff),
temp_two as (select min(success_date) start_date, max(success_date) end_date,'succeeded' as status from
(select success_date, success_date -  row_number() over (order by success_date) diff  from succeeded where success_date between '2019-01-01' and '2019-12-31')
group by diff)
select * from
(select status, start_date, end_date from temp_one
UNION ALL
(select status, start_date, end_date from temp_two)) order by 2;
