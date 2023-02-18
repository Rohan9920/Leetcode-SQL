
-- DDL Scripts:

CREATE TABLE Sales
    (sale_date timestamp, fruit varchar2(7), sold_num int)
;

INSERT ALL 
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('01-May-2020 12:00:00 AM', 'apples', 10)
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('01-May-2020 12:00:00 AM', 'oranges', 8)
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('02-May-2020 12:00:00 AM', 'apples', 15)
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('02-May-2020 12:00:00 AM', 'oranges', 15)
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('03-May-2020 12:00:00 AM', 'apples', 20)
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('03-May-2020 12:00:00 AM', 'oranges', 0)
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('04-May-2020 12:00:00 AM', 'apples', 15)
    INTO Sales (sale_date, fruit, sold_num)
         VALUES ('04-May-2020 12:00:00 AM', 'oranges', 16)
SELECT * FROM dual
;

-- Solution 1: (Using partition)

with temp as
(select sale_date, sold_num - lead(sold_num,1,0) over (partition by sale_date
order by fruit) as diff, row_number() over (partition by sale_date
order by fruit) as rn from sales)
select sale_date,diff from temp where rn=1
order by sale_date;

-- Solution 2: (Using join)

select a.sale_date, a.sold_num - b.sold_num as diff from sales a join sales b
on a.sale_date = b.sale_date and a.fruit='apples' and b.fruit='oranges'
order by sale_date;