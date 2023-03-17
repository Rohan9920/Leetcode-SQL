-- The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

-- +------+----------+-----------+----------+
-- |Id    |Name 	  |Department |ManagerId |
-- +------+----------+-----------+----------+
-- |101   |John 	  |A 	      |null      |
-- |102   |Dan 	  |A 	      |101       |
-- |103   |James 	  |A 	      |101       |
-- |104   |Amy 	  |A 	      |101       |
-- |105   |Anne 	  |A 	      |101       |
-- |106   |Ron 	  |B 	      |101       |
-- +------+----------+-----------+----------+
-- Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

-- +-------+
-- | Name  |
-- +-------+
-- | John  |
-- +-------+
-- Note:
-- No one would report to himself.

-- DDL Scripts:

CREATE TABLE Employee
    (Id int, Name varchar2(5), Department varchar2(1), ManagerId varchar2(4))
;

INSERT ALL 
    INTO Employee (Id, Name, Department, ManagerId)
         VALUES (101, 'John', 'A', NULL)
    INTO Employee (Id, Name, Department, ManagerId)
         VALUES (102, 'Dan', 'A', '101')
    INTO Employee (Id, Name, Department, ManagerId)
         VALUES (103, 'James', 'A', '101')
    INTO Employee (Id, Name, Department, ManagerId)
         VALUES (104, 'Amy', 'A', '101')
    INTO Employee (Id, Name, Department, ManagerId)
         VALUES (105, 'Anne', 'A', '101')
    INTO Employee (Id, Name, Department, ManagerId)
         VALUES (106, 'Ron', 'B', '101')
SELECT * FROM dual
;

-- Solution:

with temp as
(select managerid, count(id) as cnt from employee group by managerid having count(id) >4)
select name from employee e join temp t on e.id = t.managerid;
