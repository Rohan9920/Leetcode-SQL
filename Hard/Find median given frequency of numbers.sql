-- DDL scripts

CREATE TABLE numbers (
  NUMBERS NUMBER,
  FREQUENCY NUMBER
);

INSERT into numbers values (0,7);
INSERT into numbers values (1,1);
INSERT into numbers values (2,3);
INSERT into numbers values (3,1);

-- Solution 1: Using between function:

with t1 as(
select *,
sum(frequency) over(order by number) as cum_sum, (sum(frequency) over())/2 as middle
from numbers)

select avg(number) as median
from t1
where middle between (cum_sum - frequency) and cum_sum

-- Solution 2: Using floor and ceil:

with temp as
(select numbers, sum(frequency) over(order by numbers) as sm, sum(frequency) over () as mx from numbers)
select avg(ns) from
(select min(numbers) as ns from temp where sm >= ceil(mx/2)
 UNION ALL (select min(numbers) from temp where sm >= floor((mx/2) + 1)));

 -- Solution 3: Using LEVEL

 with levels as
(
select level as lv1 from dual connect by level <= (select max(frequency) from numbers)
)
select median(numbers) from numbers a, levels b where a.frequency >= b.lv1 order by numbers;