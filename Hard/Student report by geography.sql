-- A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.
 

-- | name   | continent |
-- |--------|-----------|
-- | Jack   | America   |
-- | Pascal | Europe    |
-- | Xi     | Asia      |
-- | Jane   | America   |
 

-- Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
 

-- For the sample input, the output is:
 

-- | America | Asia | Europe |
-- |---------|------|--------|
-- | Jack    | Xi   | Pascal |
-- | Jane    |      |        |


-- DDL scripts:

CREATE TABLE Students
    (name varchar2(6), continent varchar2(7))
;

INSERT ALL 
    INTO Students (name, continent)
         VALUES ('Jack', 'America')
    INTO Students (name, continent)
         VALUES ('Pascal', 'Europe')
    INTO Students (name, continent)
         VALUES ('Xi', 'Asia')
    INTO Students (name, continent)
         VALUES ('Jane', 'America')
SELECT * FROM dual
;


-- Solution 1: Using outer join

with temp as
(select name, continent, row_number() over (partition by continent order by name) as rn
from students)
select America, Asia, Europe from 
(
(select name as America, rn from temp where continent='America')t1 FULL JOIN (select name as Asia,rn from temp where continent='Asia')t2
 ON t1.rn=t2.rn FULL JOIN (select name as Europe, rn from temp where continent='Europe')t3
 ON t2.rn=t3.rn 
);

-- Solution 2: Using group by
with temp as
(select name, continent, row_number() over (partition by continent order by name) as rn
from students)
select min(case when continent='America' then name end) as America,
min(case when continent='Asia' then name end) as Asia,
min(case when continent='Europe' then name end) as Europe
from temp
group by rn;