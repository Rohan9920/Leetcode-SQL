
-- Table: Candidate

-- +-----+---------+
-- | id  | Name    |
-- +-----+---------+
-- | 1   | A       |
-- | 2   | B       |
-- | 3   | C       |
-- | 4   | D       |
-- | 5   | E       |
-- +-----+---------+  
-- Table: Vote

-- +-----+--------------+
-- | id  | CandidateId  |
-- +-----+--------------+
-- | 1   |     2        |
-- | 2   |     4        |
-- | 3   |     3        |
-- | 4   |     2        |
-- | 5   |     5        |
-- +-----+--------------+
-- id is the auto-increment primary key,
-- CandidateId is the id appeared in Candidate table.
-- Write a sql to find the name of the winning candidate, the above example will return the winner B.

-- +------+
-- | Name |
-- +------+
-- | B    |
-- +------+
-- Notes:

-- You may assume there is no tie, in other words there will be only one winning candidate

CREATE TABLE Candidate
    (id int, Name varchar2(1))
;

INSERT ALL 
    INTO Candidate (id, Name)
         VALUES (1, 'A')
    INTO Candidate (id, Name)
         VALUES (2, 'B')
    INTO Candidate (id, Name)
         VALUES (3, 'C')
    INTO Candidate (id, Name)
         VALUES (4, 'D')
    INTO Candidate (id, Name)
         VALUES (5, 'E')
SELECT * FROM dual
;

CREATE TABLE Vote
    (id int, CandidateId int)
;

INSERT ALL 
    INTO Vote (id, CandidateId)
         VALUES (1, 2)
    INTO Vote (id, CandidateId)
         VALUES (2, 4)
    INTO Vote (id, CandidateId)
         VALUES (3, 3)
    INTO Vote (id, CandidateId)
         VALUES (4, 2)
    INTO Vote (id, CandidateId)
         VALUES (5, 5)
SELECT * FROM dual
;

--Solution 1:

with temp as
(select a.name, count(b.id) as votes from candidate a join vote b on a.id = b.CandidateId
group by a.name)
select name from (select * from temp order by 2 desc) where rownum = 1;

-- Solution 2:
select "Name" from 
(select a.*, rank() over (order by b.votes desc) as rnk from candidate a join
(select "CandidateId", count(*) as votes from Vote group by "CandidateId")b on
a."id" = b."CandidateId") where rnk = 1;
