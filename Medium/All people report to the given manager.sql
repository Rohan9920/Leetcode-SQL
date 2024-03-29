-- Table: Employees

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | employee_id   | int     |
-- | employee_name | varchar |
-- | manager_id    | int     |
-- +---------------+---------+
-- employee_id is the primary key for this table.
-- Each row of this table indicates that the employee with ID employee_id and name employee_name reports his
-- work to his/her direct manager with manager_id
-- The head of the company is the employee with employee_id = 1.
 

-- Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

-- The indirect relation between managers will not exceed 3 managers as the company is small.

-- Return result table in any order without duplicates.

-- The query result format is in the following example:

-- Employees table:
-- +-------------+---------------+------------+
-- | employee_id | employee_name | manager_id |
-- +-------------+---------------+------------+
-- | 1           | Boss          | 1          |
-- | 3           | Alice         | 3          |
-- | 2           | Bob           | 1          |
-- | 4           | Daniel        | 2          |
-- | 7           | Luis          | 4          |
-- | 8           | Jhon          | 3          |
-- | 9           | Angela        | 8          |
-- | 77          | Robert        | 1          |
-- +-------------+---------------+------------+

-- Result table:
-- +-------------+
-- | employee_id |
-- +-------------+
-- | 2           |
-- | 77          |
-- | 4           |
-- | 7           |
-- +-------------+

-- The head of the company is the employee with employee_id 1.
-- The employees with employee_id 2 and 77 report their work directly to the head of the company.
-- The employee with employee_id 4 report his work indirectly to the head of the company 4 --> 2 --> 1. 
-- The employee with employee_id 7 report his work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
-- The employees with employee_id 3, 8 and 9 don't report their work to head of company directly or indirectly.

-- DDL Scripts:

CREATE TABLE Employees
    (employee_id int, employee_name varchar2(6), manager_id int)
;

INSERT ALL 
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (1, 'Boss', 1)
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (3, 'Alice', 3)
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (2, 'Bob', 1)
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (4, 'Daniel', 2)
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (7, 'Luis', 4)
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (8, 'Jhon', 3)
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (9, 'Angela', 8)
    INTO Employees (employee_id, employee_name, manager_id)
         VALUES (77, 'Robert', 1)
SELECT * FROM dual
;  


-- Solution:

select a.employee_id from employees a, employees b, employees c 
where a.manager_id = b.employee_id and b.manager_id = c.employee_id and 
a.employee_id!=1 and c.manager_id = 1;