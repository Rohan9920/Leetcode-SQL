-- Table Salaries:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | company_id    | int     |
-- | employee_id   | int     |
-- | employee_name | varchar |
-- | salary        | int     |
-- +---------------+---------+
-- (company_id, employee_id) is the primary key for this table.
-- This table contains the company id, the id, the name and the salary for an employee.
 

-- Write an SQL query to find the salaries of the employees after applying taxes.

-- The tax rate is calculated for each company based on the following criteria:

-- 0% If the max salary of any employee in the company is less than 1000$.
-- 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
-- 49% If the max salary of any employee in the company is greater than 10000$.
-- Return the result table in any order. Round the salary to the nearest integer.

-- The query result format is in the following example:

-- Salaries table:
-- +------------+-------------+---------------+--------+
-- | company_id | employee_id | employee_name | salary |
-- +------------+-------------+---------------+--------+
-- | 1          | 1           | Tony          | 2000   |
-- | 1          | 2           | Pronub        | 21300  |
-- | 1          | 3           | Tyrrox        | 10800  |
-- | 2          | 1           | Pam           | 300    |
-- | 2          | 7           | Bassem        | 450    |
-- | 2          | 9           | Hermione      | 700    |
-- | 3          | 7           | Bocaben       | 100    |
-- | 3          | 2           | Ognjen        | 2200   |
-- | 3          | 13          | Nyancat       | 3300   |
-- | 3          | 15          | Morninngcat   | 1866   |
-- +------------+-------------+---------------+--------+

-- Result table:
-- +------------+-------------+---------------+--------+
-- | company_id | employee_id | employee_name | salary |
-- +------------+-------------+---------------+--------+
-- | 1          | 1           | Tony          | 1020   |
-- | 1          | 2           | Pronub        | 10863  |
-- | 1          | 3           | Tyrrox        | 5508   |
-- | 2          | 1           | Pam           | 300    |
-- | 2          | 7           | Bassem        | 450    |
-- | 2          | 9           | Hermione      | 700    |
-- | 3          | 7           | Bocaben       | 76     |
-- | 3          | 2           | Ognjen        | 1672   |
-- | 3          | 13          | Nyancat       | 2508   |
-- | 3          | 15          | Morninngcat   | 5911   |
-- +------------+-------------+---------------+--------+
-- For company 1, Max salary is 21300. Employees in company 1 have taxes = 49%
-- For company 2, Max salary is 700. Employees in company 2 have taxes = 0%
-- For company 3, Max salary is 7777. Employees in company 3 have taxes = 24%
-- The salary after taxes = salary - (taxes percentage / 100) * salary
-- For example, Salary for Morninngcat (3, 15) after taxes = 7777 - 7777 * (24 / 100) = 7777 - 1866.48 = 5910.52, which is rounded to 5911.

-- DDL Scripts:

CREATE TABLE Salaries
    (company_id int, employee_id int, employee_name varchar2(11), salary int)
;

INSERT ALL 
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (1, 1, 'Tony', 2000)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (1, 2, 'Pronub', 21300)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (1, 3, 'Tyrrox', 10800)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (2, 1, 'Pam', 300)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (2, 7, 'Bassem', 450)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (2, 9, 'Hermione', 700)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (3, 7, 'Bocaben', 100)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (3, 2, 'Ognjen', 2200)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (3, 13, 'Nyancat', 3300)
    INTO Salaries (company_id, employee_id, employee_name, salary)
         VALUES (3, 15, 'Morninngcat', 7777)
SELECT * FROM dual;


-- Solution:

with temp as
(select s.*,max(salary) over (partition by company_id) as mx
from salaries s)
select company_id, employee_id, employee_name,
case when mx < 1000 then salary
when mx between 1000 and 10000 then round(0.76*salary)
else round(0.51*salary)
end as salary
from temp;