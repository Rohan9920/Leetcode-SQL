-- Question 24
-- Table my_numbers contains many numbers in column num including duplicated ones.
-- Can you write a SQL query to find the biggest number, which only appears once.

-- +---+
-- |num|
-- +---+
-- | 8 |
-- | 8 |
-- | 3 |
-- | 3 |
-- | 1 |
-- | 4 |
-- | 5 |
-- | 6 | 
-- For the sample data above, your query should return the following result:
-- +---+
-- |num|
-- +---+
-- | 6 |
-- Note:
-- If there is no such number, just output null.


CREATE TABLE my_numbers
    (num int)
;

INSERT ALL 
    INTO my_numbers (num)
         VALUES (8)
    INTO my_numbers (num)
         VALUES (8)
    INTO my_numbers (num)
         VALUES (3)
    INTO my_numbers (num)
         VALUES (3)
    INTO my_numbers (num)
         VALUES (1)
    INTO my_numbers (num)
         VALUES (4)
    INTO my_numbers (num)
         VALUES (5)
    INTO my_numbers (num)
         VALUES (6)
SELECT * FROM dual
;

-- Solution:

with temp as
(select num from my_numbers group by num having count(*)=1)
select max(num) as num from temp;

