-- In social network like Facebook or Twitter, people send friend requests and accept others' requests as well.

-- Table request_accepted

-- +--------------+-------------+------------+
-- | requester_id | accepter_id | accept_date|
-- |--------------|-------------|------------|
-- | 1            | 2           | 2016_06-03 |
-- | 1            | 3           | 2016-06-08 |
-- | 2            | 3           | 2016-06-08 |
-- | 3            | 4           | 2016-06-09 |
-- +--------------+-------------+------------+
-- This table holds the data of friend acceptance, while requester_id and accepter_id both are the id of a person.
 

-- Write a query to find the the people who has most friends and the most friends number under the following rules:

-- It is guaranteed there is only 1 people having the most friends.
-- The friend request could only been accepted once, which mean there is no multiple records with the same requester_id and accepter_id value.
-- For the sample data above, the result is:

-- Result table:
-- +------+------+
-- | id   | num  |
-- |------|------|
-- | 3    | 3    |
-- +------+------+
-- The person with id '3' is a friend of people '1', '2' and '4', so he has 3 friends in total, which is the most number than any others.

-- DDL scripts:

CREATE TABLE request_accepted (
  requester_id NUMBER,
  accepter_id NUMBER,
  accept_date DATE);

INSERT INTO request_accepted VALUES (1,2,'2016-06-03');
INSERT INTO request_accepted VALUES (1,3,'2016-06-08');
INSERT INTO request_accepted VALUES (2,3,'2016-06-08');
INSERT INTO request_accepted VALUES (3,4,'2016-06-09');

-- Solution 1:

select * from (select requester_id,count(requester_id) as cnt from
(select requester_id from request_accepted UNION ALL select accepter_id from request_accepted ) group by requester_id order by cnt desc) where rownum =1;

-- Solution 2:

with temp as
( select requester_id from request_accepted UNION ALL (select accepter_id from request_accepted)), temp2 as
(select requester_id, count(requester_id) as cnt
from temp group by requester_id)
select requester_id, cnt from temp2
where cnt = (select max(cnt) from temp2)
;
