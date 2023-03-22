-- Table: NPV

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | year          | int     |
-- | npv           | int     |
-- +---------------+---------+
-- (id, year) is the primary key of this table.
-- The table has information about the id and the year of each inventory and the corresponding net present value.
 

-- Table: Queries

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | year          | int     |
-- +---------------+---------+
-- (id, year) is the primary key of this table.
-- The table has information about the id and the year of each inventory query.
 

-- Write an SQL query to find the npv of all each query of queries table.

-- Return the result table in any order.

-- The query result format is in the following example:

-- NPV table:
-- +------+--------+--------+
-- | id   | year   | npv    |
-- +------+--------+--------+
-- | 1    | 2018   | 100    |
-- | 7    | 2020   | 30     |
-- | 13   | 2019   | 40     |
-- | 1    | 2019   | 113    |
-- | 2    | 2008   | 121    |
-- | 3    | 2009   | 12     |
-- | 11   | 2020   | 99     |
-- | 7    | 2019   | 0      |
-- +------+--------+--------+

-- Queries table:
-- +------+--------+
-- | id   | year   |
-- +------+--------+
-- | 1    | 2019   |
-- | 2    | 2008   |
-- | 3    | 2009   |
-- | 7    | 2018   |
-- | 7    | 2019   |
-- | 7    | 2020   |
-- | 13   | 2019   |
-- +------+--------+

-- Result table:
-- +------+--------+--------+
-- | id   | year   | npv    |
-- +------+--------+--------+
-- | 1    | 2019   | 113    |
-- | 2    | 2008   | 121    |
-- | 3    | 2009   | 12     |
-- | 7    | 2018   | 0      |
-- | 7    | 2019   | 0      |
-- | 7    | 2020   | 30     |
-- | 13   | 2019   | 40     |
-- +------+--------+--------+

-- The npv value of (7, 2018) is not present in the NPV table, we consider it 0.
-- The npv values of all other queries can be found in the NPV table.

-- DDL Scripts:



CREATE TABLE NPV
    (id int, year int, npv int)
;

INSERT ALL 
    INTO NPV (id, year, npv)
         VALUES (1, 2018, 100)
    INTO NPV (id, year, npv)
         VALUES (7, 2020, 30)
    INTO NPV (id, year, npv)
         VALUES (13, 2019, 40)
    INTO NPV (id, year, npv)
         VALUES (1, 2019, 113)
    INTO NPV (id, year, npv)
         VALUES (2, 2008, 121)
    INTO NPV (id, year, npv)
         VALUES (3, 2009, 12)
    INTO NPV (id, year, npv)
         VALUES (11, 2020, 99)
    INTO NPV (id, year, npv)
         VALUES (7, 2019, 0)
SELECT * FROM dual
;

CREATE TABLE Queries
    (id int, year int)
;

INSERT ALL 
    INTO Queries (id, year)
         VALUES (1, 2019)
    INTO Queries (id, year)
         VALUES (2, 2008)
    INTO Queries (id, year)
         VALUES (3, 2009)
    INTO Queries (id, year)
         VALUES (7, 2018)
    INTO Queries (id, year)
         VALUES (7, 2019)
    INTO Queries (id, year)
         VALUES (7, 2020)
    INTO Queries (id, year)
         VALUES (13, 2019)
SELECT * FROM dual
;


-- Solution:

select q.id,q.year,NVL(n.npv,0) as npv
from queries q left join npv n
on q.id = n.id and q.year = n.year;

