CREATE TABLE Customer
    (customer_id int, name varchar2(7), visited_on date, amount int)
;

INSERT ALL 
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (1, 'Jhon', '2019-01-01', 100)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (2, 'Daniel', '2019-01-02', 110)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (3, 'Jade', '2019-01-03', 120)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (4, 'Khaled', '2019-01-04', 130)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (5, 'Winston', '2019-01-05', 110)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (6, 'Elvis', '2019-01-06', 140)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (7, 'Anna', '2019-01-07', 150)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (8, 'Maria', '2019-01-08', 80)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (9, 'Jaze', '2019-01-09', 110)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (1, 'Jhon', '2019-01-10', 130)
    INTO Customer (customer_id, name, visited_on, amount)
         VALUES (3, 'Jade', '2019-01-10', 150)
SELECT * FROM dual
;

-- Solution 1: (Using OFFSET. Available after oracle 12c)

with temp as
(select visited_on, sum(amount) as amount from customer group by visited_on order by visited_on)
select visited_on ,sum(amount) over (order by visited_on rows 6 preceding) as amount,
round(avg(amount) over (order by visited_on rows 6 preceding),2) as average_amount
order by visited_on OFFSET 6 rows;

-- Solution 2: (Using rownum)

with temp as
(select visited_on, sum(amount) as amount from customer group by visited_on)
select visited_on, amount, average_amount from
(select visited_on ,sum(amount) over (order by visited_on rows 6 preceding) as amount,
round(avg(amount) over (order by visited_on rows 6 preceding),2) as average_amount, row_number() over (order by visited_on) as rn from temp) where rn > 6;

-- Solution 3: (Using joins)

with temp as
(select visited_on, sum(amount) as amount from customer group by visited_on),
temp1 as
(select visited_on, amount, row_number() over (order by visited_on) as rn from temp)
select a.visited_on, sum(b.amount) as amount, round(avg(b.amount),2) as average_amount from temp1 a join temp1 b on a.visited_on - b.visited_on BETWEEN 0 and 6 and a.rn>6
group by a.visited_on;


