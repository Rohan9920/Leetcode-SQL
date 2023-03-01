-- The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 70000  | 1            |
-- | 2  | Jim   | 90000  | 1            |
-- | 3  | Henry | 80000  | 2            |
-- | 4  | Sam   | 60000  | 2            |
-- | 5  | Max   | 90000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+
-- Write a SQL query to find employees who have the highest salary in each of the departments. 
-- For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Jim      | 90000  |
-- | Sales      | Henry    | 80000  |
-- +------------+----------+--------+
-- Explanation:

-- Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.

-- DDL Scripts:

CREATE TABLE Employee
    (Id int, Name varchar2(5), Salary int, DepartmentId int)
;

INSERT ALL 
    INTO Employee (Id, Name, Salary, DepartmentId)
         VALUES (1, 'Joe', 70000, 1)
    INTO Employee (Id, Name, Salary, DepartmentId)
         VALUES (2, 'Jim', 90000, 1)
    INTO Employee (Id, Name, Salary, DepartmentId)
         VALUES (3, 'Henry', 80000, 2)
    INTO Employee (Id, Name, Salary, DepartmentId)
         VALUES (4, 'Sam', 60000, 2)
    INTO Employee (Id, Name, Salary, DepartmentId)
         VALUES (5, 'Max', 90000, 1)
SELECT * FROM dual
;

CREATE TABLE Department
    (Id int, Name varchar2(5))
;

INSERT ALL 
    INTO Department (Id, Name)
         VALUES (1, 'IT')
    INTO Department (Id, Name)
         VALUES (2, 'Sales')
SELECT * FROM dual
;

-- Solution:

select department, employee, salary from 
(select d.name as department,e.name as employee,e.salary,rank() over (partition by d.name order by e.salary desc)as rn 
from department d, employee e where d.id = e.departmentid)
where rn=1;