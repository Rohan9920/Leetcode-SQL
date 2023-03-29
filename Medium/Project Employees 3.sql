-- Table: Project

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- (project_id, employee_id) is the primary key of this table.
-- employee_id is a foreign key to Employee table.
-- Table: Employee

-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | experience_years | int     |
-- +------------------+---------+
-- employee_id is the primary key of this table.
 

-- Write an SQL query that reports the most experienced employees in each project. 
-- In case of a tie, report all employees with the maximum number of experience years.

-- The query result format is in the following example:

-- Project table:
-- +-------------+-------------+
-- | project_id  | employee_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- | 1           | 2           |
-- | 1           | 3           |
-- | 2           | 1           |
-- | 2           | 4           |
-- +-------------+-------------+

-- Employee table:
-- +-------------+--------+------------------+
-- | employee_id | name   | experience_years |
-- +-------------+--------+------------------+
-- | 1           | Khaled | 3                |
-- | 2           | Ali    | 2                |
-- | 3           | John   | 3                |
-- | 4           | Doe    | 2                |
-- +-------------+--------+------------------+

-- Result table:
-- +-------------+---------------+
-- | project_id  | employee_id   |
-- +-------------+---------------+
-- | 1           | 1             |
-- | 1           | 3             |
-- | 2           | 1             |
-- +-------------+---------------+
-- Both employees with id 1 and 3 have the 
-- most experience among the employees of the first project. For the second project, the employee with id 1 has the most experience.


-- DDL Scripts:

CREATE TABLE Project
    (project_id int, employee_id int)
;

INSERT ALL 
    INTO Project (project_id, employee_id)
         VALUES (1, 1)
    INTO Project (project_id, employee_id)
         VALUES (1, 2)
    INTO Project (project_id, employee_id)
         VALUES (1, 3)
    INTO Project (project_id, employee_id)
         VALUES (2, 1)
    INTO Project (project_id, employee_id)
         VALUES (2, 4)
SELECT * FROM dual
;

CREATE TABLE Employee
    (employee_id int, name varchar2(6), experience_years int)
;

INSERT ALL 
    INTO Employee (employee_id, name, experience_years)
         VALUES (1, 'Khaled', 3)
    INTO Employee (employee_id, name, experience_years)
         VALUES (2, 'Ali', 2)
    INTO Employee (employee_id, name, experience_years)
         VALUES (3, 'John', 3)
    INTO Employee (employee_id, name, experience_years)
         VALUES (4, 'Doe', 2)
SELECT * FROM dual
;

-- Solution:

with temp as
(select p.project_id, e.employee_id, rank() over (partition by p.project_id order
by e.experience_years desc) as rn from project p join employee e on p.employee_id
= e.employee_id)
select project_id, employee_id from temp where rn=1
order by 1;