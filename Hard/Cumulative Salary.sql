-- The Employee table holds the salary information in a year.

-- Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.

-- The result should be displayed by 'Id' ascending, and then by 'Month' descending.

-- Example
-- Input

-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 1  | 2     | 30     |
-- | 2  | 2     | 30     |
-- | 3  | 2     | 40     |
-- | 1  | 3     | 40     |
-- | 3  | 3     | 60     |
-- | 1  | 4     | 60     |
-- | 3  | 4     | 70     |
-- Output

-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 3     | 90     |
-- | 1  | 2     | 50     |
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 3  | 3     | 100    |
-- | 3  | 2     | 40     |
 

-- Explanation
-- Employee '1' has 3 salary records for the following 3 months except the most recent month '4': salary 40 for month '3', 30 for month '2' and 20 for month '1'
-- So the cumulative sum of salary of this employee over 3 months is 90(40+30+20), 50(30+20) and 20 respectively.

-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 3     | 90     |
-- | 1  | 2     | 50     |
-- | 1  | 1     | 20     |
-- Employee '2' only has one salary record (month '1') except its most recent month '2'.
-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 2  | 1     | 20     |
 

-- Employ '3' has two salary records except its most recent pay month '4': month '3' with 60 and month '2' with 40. So the cumulative salary is as following.
-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 3  | 3     | 100    |
-- | 3  | 2     | 40     |

-- DDL Scripts

CREATE TABLE employee (
  id NUMBER,
  month NUMBER,
  salary NUMBER);

INSERT INTO employee VALUES (1,1,20);
INSERT INTO employee VALUES (2,1,20);
INSERT INTO employee VALUES (1,2,30);
INSERT INTO employee VALUES (2,2,30);
INSERT INTO employee VALUES (3,2,40);
INSERT INTO employee VALUES (1,3,40);
INSERT INTO employee VALUES (3,3,60);
INSERT INTO employee VALUES (1,4,60);
INSERT INTO employee VALUES (3,4,70);

--Solution 1:

select id, month, salary from 
(select id,month, row_number() over (partition by id order by month desc) rn, sum(salary) over(partition by id order by month) as salary from employee) 
where rn!=1
order by id, month desc;

-- Solution 2: (Using lead and lag functions)

select id, month, salary+lag(lg,1,0) over (partition by id order by month) as salary  from
(select id,month,salary, lead(salary,1) over (partition by id order by month) as ld,salary + lag(salary,1,0) over (partition by id order by month) as lg
from employee)
where ld is not null
order by id, month desc;