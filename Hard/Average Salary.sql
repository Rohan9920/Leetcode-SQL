-- Given two tables as below, write a query to display the comparison result (higher/lower/same) of the 
-- average salary of employees in a department to the company's average salary.
 

-- Table: salary
-- | id | employee_id | amount | pay_date   |
-- |----|-------------|--------|------------|
-- | 1  | 1           | 9000   | 2017-03-31 |
-- | 2  | 2           | 6000   | 2017-03-31 |
-- | 3  | 3           | 10000  | 2017-03-31 |
-- | 4  | 1           | 7000   | 2017-02-28 |
-- | 5  | 2           | 6000   | 2017-02-28 |
-- | 6  | 3           | 8000   | 2017-02-28 |
 

-- The employee_id column refers to the employee_id in the following table employee.
 

-- | employee_id | department_id |
-- |-------------|---------------|
-- | 1           | 1             |
-- | 2           | 2             |
-- | 3           | 2             |
 

-- So for the sample data above, the result is:
 

-- | pay_month | department_id | comparison  |
-- |-----------|---------------|-------------|
-- | 2017-03   | 1             | higher      |
-- | 2017-03   | 2             | lower       |
-- | 2017-02   | 1             | same        |
-- | 2017-02   | 2             | same        |
 

-- Explanation
 

-- In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
 

-- The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
 

-- The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.
 

-- With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.

-- DDL Scripts:

CREATE TABLE salary (
  id NUMBER,
  employee_id NUMBER,
  amount NUMBER,
  pay_date DATE  
);

CREATE TABLE employee (
  employee_id NUMBER,
  department_id NUMBER
);


INSERT INTO salary VALUES (1,1,9000,'2017-03-31');
INSERT INTO salary VALUES (2,2,6000,'2017-03-31');
INSERT INTO salary VALUES (3,3,10000,'2017-03-31');
INSERT INTO salary VALUES (4,1,7000,'2017-02-28');
INSERT INTO salary VALUES (5,2,6000,'2017-02-28');
INSERT INTO salary VALUES (6,3,8000,'2017-02-28');


INSERT INTO employee VALUES (1,1);
INSERT INTO employee VALUES (2,2);
INSERT INTO employee VALUES (3,2);

-- Solution:

with temp as
(select b.department_id, a.amount, a.pay_date, avg(amount) over (partition by pay_date) as total_sal, avg(amount) over (partition by a.pay_date, b.department_id) as dept_sal from salary a join employee b on a.employee_id = b.employee_id)
select distinct TO_CHAR(pay_date,'YYYY-MM') as pay_month, department_id, 
case when dept_sal>total_sal then 'higher'
when dept_sal<total_sal then 'lower'
else 'same'
end as comparison from temp
order by pay_month desc;