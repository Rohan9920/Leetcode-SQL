-- Question 50
-- Write a SQL query to get the nth highest salary from the Employee table.

-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+
-- For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

-- +------------------------+
-- | getNthHighestSalary(2) |
-- +------------------------+
-- | 200                    |
-- +------------------------+

-- DDL Scripts:



CREATE TABLE Employee
    (Id int, Salary int)
;

INSERT ALL 
    INTO Employee (Id, Salary)
         VALUES (1, 100)
    INTO Employee (Id, Salary)
         VALUES (2, 200)
    INTO Employee (Id, Salary)
         VALUES (3, 300)
SELECT * FROM dual
;

-- Solution:

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN
    select distinct salary from
    (select salary, dense_rank() over (order by salary desc) as rk from employee)
    where rk = 1;
END
