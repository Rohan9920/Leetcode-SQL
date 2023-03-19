-- Table: Transactions

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | id             | int     |
-- | country        | varchar |
-- | state          | enum    |
-- | amount         | int     |
-- | trans_date     | date    |
-- +----------------+---------+
-- id is the primary key of this table.
-- The table has information about incoming transactions.
-- The state column is an enum of type ["approved", "declined"].
-- Table: Chargebacks

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | trans_id       | int     |
-- | charge_date    | date    |
-- +----------------+---------+
-- Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
-- trans_id is a foreign key to the id column of Transactions table.
-- Each chargeback corresponds to a transaction made previously even if they were not approved.
 

-- Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.

-- Note: In your query, given the month and country, ignore rows with all zeros.

-- The query result format is in the following example:

-- Transactions table:
-- +------+---------+----------+--------+------------+
-- | id   | country | state    | amount | trans_date |
-- +------+---------+----------+--------+------------+
-- | 101  | US      | approved | 1000   | 2019-05-18 |
-- | 102  | US      | declined | 2000   | 2019-05-19 |
-- | 103  | US      | approved | 3000   | 2019-06-10 |
-- | 104  | US      | approved | 4000   | 2019-06-13 |
-- | 105  | US      | approved | 5000   | 2019-06-15 |
-- +------+---------+----------+--------+------------+

-- Chargebacks table:
-- +------------+------------+
-- | trans_id   | trans_date |
-- +------------+------------+
-- | 102        | 2019-05-29 |
-- | 101        | 2019-06-30 |
-- | 105        | 2019-09-18 |
-- +------------+------------+

-- Result table:
-- +----------+---------+----------------+-----------------+-------------------+--------------------+
-- | month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
-- +----------+---------+----------------+-----------------+-------------------+--------------------+
-- | 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
-- | 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
-- | 2019-09  | US      | 0              | 0               | 1                 | 5000               |
-- +----------+---------+----------------+-----------------+-------------------+--------------------+

-- DDL Scripts:

CREATE TABLE Transactions
    (id int, country varchar2(2), state varchar2(8), amount int, trans_date date)
;

INSERT ALL 
    INTO Transactions (id, country, state, amount, trans_date)
         VALUES (101, 'US', 'approved', 1000, '2019-05-18')
    INTO Transactions (id, country, state, amount, trans_date)
         VALUES (102, 'US', 'declined', 2000, '2019-05-19')
    INTO Transactions (id, country, state, amount, trans_date)
         VALUES (103, 'US', 'approved', 3000, '2019-06-10')
    INTO Transactions (id, country, state, amount, trans_date)
         VALUES (104, 'US', 'approved', 4000, '2019-06-13')
    INTO Transactions (id, country, state, amount, trans_date)
         VALUES (105, 'US', 'approved', 5000, '2019-06-15')
SELECT * FROM dual
;


CREATE TABLE Chargebacks
    (trans_id int, trans_date date)
;

INSERT ALL 
    INTO Chargebacks (trans_id, trans_date)
         VALUES (102, '2019-05-29')
    INTO Chargebacks (trans_id, trans_date)
         VALUES (101, '2019-06-30')
    INTO Chargebacks (trans_id, trans_date)
         VALUES (105, '2019-09-18')
SELECT * FROM dual
;

Solution:

with temp as
(select to_char(trans_date,'YYYY-MM') as trans_date, country, sum(amount) as approved_amount, count(id) as approved_count from transactions
where state = 'approved' group by to_char(trans_date,'YYYY-MM'), country),
temp2 as
(select to_char(c.trans_date,'YYYY-MM') as trans_date, t.country, count(c.trans_id) as chargeback_count, sum(t.amount) as chargeback_amount from chargebacks c join transactions t on c.trans_id = t.id
group by to_char(c.trans_date,'YYYY-MM'),t.country )
select * from
(select t1.trans_date as month,t1.country as country,NVL(t1.approved_count,0) as approved_count,NVL(t1.approved_amount,0) as approved_amount,NVL(t2.chargeback_count,0) as chargeback_count,NVL(t2.chargeback_amount,0) as chargeback_amount
from temp t1 left join temp2 t2 on t1.trans_date = t2.trans_date and t1.country = t2.country UNION (select t2.trans_date as month,t2.country as country,NVL(t1.approved_count,0),NVL(t1.approved_amount,0),NVL(t2.chargeback_count,0),NVL(t2.chargeback_amount,0)
from temp t1 right join temp2 t2 on t1.trans_date = t2.trans_date and t1.country = t2.country))
where approved_count+approved_amount+chargeback_count+chargeback_amount>0;