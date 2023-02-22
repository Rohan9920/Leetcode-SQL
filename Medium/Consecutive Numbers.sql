
-- Write a SQL query to find all numbers that appear at least three times consecutively.

-- +----+-----+
-- | Id | Num |
-- +----+-----+
-- | 1  |  1  |
-- | 2  |  1  |
-- | 3  |  1  |
-- | 4  |  2  |
-- | 5  |  1  |
-- | 6  |  2  |
-- | 7  |  2  |
-- +----+-----+
-- For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+


-- DDL Scripts
CREATE TABLE Logs
    (Id int, Num int)
;

INSERT ALL 
    INTO Logs (Id, Num)
         VALUES (1, 1)
    INTO Logs (Id, Num)
         VALUES (2, 1)
    INTO Logs (Id, Num)
         VALUES (3, 1)
    INTO Logs (Id, Num)
         VALUES (4, 2)
    INTO Logs (Id, Num)
         VALUES (5, 1)
    INTO Logs (Id, Num)
         VALUES (6, 2)
    INTO Logs (Id, Num)
         VALUES (7, 2)
SELECT * FROM dual
;

-- Solution 1: (using lead lag)

with temp as
(select num, lead(id,1,0) over (partition by num order by id) - id as ld, id - lag(num,1,0) over (partition by num order by id) as lg
from Logs)
select distinct num from temp where ld = 1 and lg=1;

-- Solution 2 (Using join)

select distinct a.num from Logs a, Logs b, Logs c
where b.id - a.id = 1 and c.id-b.id=1 and a.num= b.num and b.num=c.num
