-- Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

-- The column id is continuous increment.
 

-- Mary wants to change seats for the adjacent students.
 

-- Can you write a SQL query to output the result for Mary?
 

-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Abbot   |
-- |    2    | Doris   |
-- |    3    | Emerson |
-- |    4    | Green   |
-- |    5    | Jeames  |
-- +---------+---------+
-- For the sample input, the output is:
 

-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Doris   |
-- |    2    | Abbot   |
-- |    3    | Green   |
-- |    4    | Emerson |
-- |    5    | Jeames  |
-- +---------+---------+

-- DDL Scripts:



CREATE TABLE seat
    (id int, student varchar2(7))
;

INSERT ALL 
    INTO seat (id, student)
         VALUES (1, 'Abbot')
    INTO seat (id, student)
         VALUES (2, 'Doris')
    INTO seat (id, student)
         VALUES (3, 'Emerson')
    INTO seat (id, student)
         VALUES (4, 'Green')
    INTO seat (id, student)
         VALUES (5, 'Jeames')
SELECT * FROM dual
;


-- Solution 1 (Using lead / lag):

select id, 
case when mod(id,2)!=0 then Lead(student,1,student) over (order by id)
ElSE Lag(student,1,0) over (order by id)
End as Student from seat;

-- Solution 2 (Using joins):

with temp as
(select id, student, case when mod(id,2)=0 then id-1 else id+1 end as id2 from seat)
select t.id, NVL(s.student,t.student) as student from temp t left join seat s on t.id2 = s.id
order by id;

-- Solution 3: (Using subquery):

select id, 
case when mod(id,2)!=0 and id+1 not in (select id from seat) then id
when mod(id,2)!=0 then (id+1)
else (id-1)
End as new_ids
from seat a ;