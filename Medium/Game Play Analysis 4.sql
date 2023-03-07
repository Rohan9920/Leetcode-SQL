-- Table: Activity

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key of this table.
-- This table shows the activity of players of some game.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) 
-- before logging out on some day using some device.
 

-- Write an SQL query that reports the fraction of players that logged in again 
-- on the day after the day they first logged in, rounded to 2 decimal places. 
-- In other words, you need to count the number of players that logged in for at least two consecutive 
-- days starting from their first login date, then divide that number by the total number of players.

-- The query result format is in the following example:

-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-02 | 0            |
-- | 3         | 4         | 2018-07-03 | 5            |
-- +-----------+-----------+------------+--------------+

-- Result table:
-- +-----------+
-- | fraction  |
-- +-----------+
-- | 0.33      |
-- +-----------+
-- Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

-- DDL scripts:

CREATE TABLE Activity
    (player_id int, device_id int, event_date date, games_played int)
;

INSERT ALL 
    INTO Activity (player_id, device_id, event_date, games_played)
         VALUES (1, 2, '2016-03-01', 5)
    INTO Activity (player_id, device_id, event_date, games_played)
         VALUES (1, 2, '2016-03-02', 6)
    INTO Activity (player_id, device_id, event_date, games_played)
         VALUES (2, 3, '2017-06-25', 1)
    INTO Activity (player_id, device_id, event_date, games_played)
         VALUES (3, 1, '2016-03-02', 0)
    INTO Activity (player_id, device_id, event_date, games_played)
         VALUES (3, 4, '2018-07-03', 5)
SELECT * FROM dual
;


-- Solution 1:

with temp as
(select player_id, row_number() over (partition by player_id order by event_date) as dt, lead(event_date,1,event_date)over (partition by player_id order by event_date) -event_date as ld from activity)
(select sum(case when dt=1 and ld=1 then 1 else 0 end)/count(distinct player_id) as sm from temp );

-- Solution 2:

with temp as
(select player_id, min(event_date) over(partition by player_id order by event_date), CASE WHEN event_date - min(event_date) over(partition by player_id order by event_date) = 1 THEN 1 else 0 END as consecutive from activity)
select sum(consecutive)/ count(distinct player_id) from temp;


