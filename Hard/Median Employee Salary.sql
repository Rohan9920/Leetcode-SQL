-- The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |1    | A          | 2341   |
-- |2    | A          | 341    |
-- |3    | A          | 15     |
-- |4    | A          | 15314  |
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |7    | B          | 15     |
-- |8    | B          | 13     |
-- |9    | B          | 1154   |
-- |10   | B          | 1345   |
-- |11   | B          | 1221   |
-- |12   | B          | 234    |
-- |13   | C          | 2345   |
-- |14   | C          | 2645   |
-- |15   | C          | 2645   |
-- |16   | C          | 2652   |
-- |17   | C          | 65     |
-- +-----+------------+--------+
-- Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |12   | B          | 234    |
-- |9    | B          | 1154   |
-- |14   | C          | 2645   |
-- +-----+------------+--------+

--DDL scripts

CREATE TABLE Employee
    (Id int, Company varchar2(1), Salary int)
;

INSERT ALL 
    INTO Employee (Id, Company, Salary)
         VALUES (1, 'A', 2341)
    INTO Employee (Id, Company, Salary)
         VALUES (2, 'A', 341)
    INTO Employee (Id, Company, Salary)
         VALUES (3, 'A', 15)
    INTO Employee (Id, Company, Salary)
         VALUES (4, 'A', 15314)
    INTO Employee (Id, Company, Salary)
         VALUES (5, 'A', 451)
    INTO Employee (Id, Company, Salary)
         VALUES (6, 'A', 513)
    INTO Employee (Id, Company, Salary)
         VALUES (7, 'B', 15)
    INTO Employee (Id, Company, Salary)
         VALUES (8, 'B', 13)
    INTO Employee (Id, Company, Salary)
         VALUES (9, 'B', 1154)
    INTO Employee (Id, Company, Salary)
         VALUES (10, 'B', 1345)
    INTO Employee (Id, Company, Salary)
         VALUES (11, 'B', 1221)
    INTO Employee (Id, Company, Salary)
         VALUES (12, 'B', 234)
    INTO Employee (Id, Company, Salary)
         VALUES (13, 'C', 2345)
    INTO Employee (Id, Company, Salary)
         VALUES (14, 'C', 2645)
    INTO Employee (Id, Company, Salary)
         VALUES (15, 'C', 2645)
    INTO Employee (Id, Company, Salary)
         VALUES (16, 'C', 2652)
    INTO Employee (Id, Company, Salary)
         VALUES (17, 'C', 65)
SELECT * FROM dual
;

-- Solution 1: (Best solution)

with temp as
(select id, company,salary, row_number() over (partition by company order by salary) as rn,
count(id) over (partition by company) as cnt from employee)
select  id, company, salary from temp                                         
where rn between cnt/2 and ((cnt/2)+1);

-- Solution 2: (Using floor and ceil)

with temp as
(select id, company,salary, row_number() over (partition by company order by salary) as rn,
count(id) over (partition by company) as cnt from employee)
select  id, company, salary from temp
where rn = floor((cnt+1)/2) or rn = ceil((cnt+1)/2;


-- Solution 3: (Using formula)

with temp as
(select id, company, salary, row_number() over (partition by company order by
salary) as rn, count(*) over (partition by company) as mx from employee)
select id, company, salary from temp where( (mod(mx,2)=0 and 
(rn=mx/2 or rn = (mx/2+1) )) or (mod(mx,2)!=0 and (rn = (mx+1)/2)));

