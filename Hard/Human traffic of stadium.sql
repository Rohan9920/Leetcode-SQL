-- Table: Stadium

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | visit_date    | date    |
-- | people        | int     |
-- +---------------+---------+
-- visit_date is the primary key for this table.
-- Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
-- No two rows will have the same visit_date, and as the id increases, the dates increase as well.
 

-- Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

-- Return the result table ordered by visit_date in ascending order.

-- The query result format is in the following example.

 

-- Example 1:

-- Input: 
-- Stadium table:
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 1    | 2017-01-01 | 10        |
-- | 2    | 2017-01-02 | 109       |
-- | 3    | 2017-01-03 | 150       |
-- | 4    | 2017-01-04 | 99        |
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-09 | 188       |
-- +------+------------+-----------+
-- Output: 
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-09 | 188       |
-- +------+------------+-----------+
-- Explanation: 
-- The four rows with ids 5, 6, 7, and 8 have consecutive ids and each of them has >= 100 people attended. Note that row 8 was included even though the visit_date was not the next day after row 7.
-- The rows with ids 2 and 3 are not included because we need at least three consecutive ids.



-- Solution 1: (Using UNION)

with temp as
(select a.id as id_1, a.visit_date as visit_date_1, a.people as people_1,b.id id_2, b.visit_date as visit_date_2, b.people as people_2,
c.id as id_3, c.visit_date as visit_date_3, c.people as people_3 from stadium a, stadium b, stadium c
where b.id - a.id = 1 and c.id-b.id = 1 and a.people >= 100 and b.people >= 100
and c.people >= 100)
select  distinct id_1, visit_date_1, people_1 from temp
UNION ALL
select  id_2, visit_date_2, people_2 from temp
UNION ALL
select  id_3, visit_date_3, people_3 from temp;

-- Solution 2: (Using Lead/Lag)


select id, to_char(visit_date,'YYYY-MM-DD') as visit_date, people from (
with temp as 
(select id,visit_date, people, 
case when lead(people,1,0) over (order by id)>=100 and people >=100 then 1 else 0 end as ld,
case when lag(people,1,0) over (order by id)>=100 and people>=100 then 1 else 0 end as lg
from stadium 
)
select id,visit_date,people,ld, lg,
case when lead(ld,1,0) over (order by id) =1 and lead(lg,1,0) over (order by id) =1 then 1 else 0 end as after, case when lag(ld,1,0) over (order by id) =1 and lag(lg,1,0) over (order by id) =1 then 1 else 0 end as before from temp) where (ld=1 and lg=1) or before =1 or after =1 ;

-- Solution 3: (Using row_number())

with temp as
(select id, visit_date, id - row_number() over (order by id)  as rn, people  from 
stadium where people >= 100)
select id, visit_date, people from temp
join 
(select rn from temp group by rn having count(id) > 2) a 
on temp.rn = a.rn ;


