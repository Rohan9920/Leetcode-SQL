-- Table Accounts:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- the id is the primary key for this table.
-- This table contains the account id and the user name of each account.
 

-- Table Logins:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | login_date    | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

-- Write an SQL query to find the id and the name of active users.

-- Active users are those who logged in to their accounts for 5 or more consecutive days.

-- Return the result table ordered by the id.

-- The query result format is in the following example:

-- Accounts table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 1  | Winston  |
-- | 7  | Jonathan |
-- +----+----------+

-- Logins table:
-- +----+------------+
-- | id | login_date |
-- +----+------------+
-- | 7  | 2020-05-30 |
-- | 1  | 2020-05-30 |
-- | 7  | 2020-05-31 |
-- | 7  | 2020-06-01 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-03 |
-- | 1  | 2020-06-07 |
-- | 7  | 2020-06-10 |
-- +----+------------+

-- Result table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 7  | Jonathan |
-- +----+----------+
-- User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
-- User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.

-- DDL scripts:

CREATE TABLE Logins (
  id NUMBER,
  login_date DATE
);

CREATE TABLE Accounts (
  id NUMBER,
  name VARCHAR(50)
);

INSERT into accounts values(1,'Winston');
INSERT into accounts values(7,'Jonathon');

INSERT into logins values (7,'2020-05-30');
INSERT into logins values (1,'2020-05-30');
INSERT into logins values (7,'2020-05-31');
INSERT into logins values (7,'2020-06-01');
INSERT into logins values (7,'2020-06-02');
INSERT into logins values (7,'2020-06-02');
INSERT into logins values (7,'2020-06-03');
INSERT into logins values (7,'2020-06-03');
INSERT into logins values (7,'2020-06-04');
INSERT into logins values (1,'2020-06-07');
INSERT into logins values (7,'2020-06-10');

-- Solution 1:

with temp1 as
(select distinct * from logins),
temp2 as
(select a.id, a.name, l.login_date- dense_rank() over (partition by a.name order by l.login_date) as dt from temp1 l, accounts a where l.id = a.id)
select id,name from 
(select id, name, dt from temp2 group by id,name,dt having count(id)>=5);

-- Solution 2: (Using lead function)

with t1 as (
select id,login_date,
lead(login_date,4) over(partition by id order by login_date) date_5
from (select distinct * from Logins) b
)

select distinct a.id, a.name from t1
inner join accounts a 
on t1.id = a.id
where t1.date_5 - login_date = 4
order by id;
