-- Table: Events

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | business_id   | int     |
-- | event_type    | varchar |
-- | occurences    | int     | 
-- +---------------+---------+
-- (business_id, event_type) is the primary key of this table.
-- Each row in the table logs the info that an event of some type occured at some business for a number of times.
 

-- Write an SQL query to find all active businesses.

-- An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

-- The query result format is in the following example:

-- Events table:
-- +-------------+------------+------------+
-- | business_id | event_type | occurences |
-- +-------------+------------+------------+
-- | 1           | reviews    | 7          |
-- | 3           | reviews    | 3          |
-- | 1           | ads        | 11         |
-- | 2           | ads        | 7          |
-- | 3           | ads        | 6          |
-- | 1           | page views | 3          |
-- | 2           | page views | 12         |
-- +-------------+------------+------------+

-- Result table:
-- +-------------+
-- | business_id |
-- +-------------+
-- | 1           |
-- +-------------+ 
-- Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
-- Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.

-- DDL Scripts:

CREATE TABLE Events (
  business_id NUMBER,
  event_type VARCHAR(50),
  occurences NUMBER);

INSERT INTO Events VALUES (1,'reviews',7);
INSERT INTO Events VALUES (3,'reviews',3);
INSERT INTO Events VALUES (1,'ads',11);
INSERT INTO Events VALUES (2,'ads',7);
INSERT INTO Events VALUES (3,'ads',6);
INSERT INTO Events VALUES (1,'page views',3);
INSERT INTO Events VALUES (2,'page views',12);

-- Solution 1:

with temp as 
(
select business_id, event_type, occurences, avg(occurences) over (partition by event_type) as avg from events)
select business_id from
(select business_id, sum(case when occurences>avg then 1 else 0 end) as sm from temp
group by business_id)
where sm>1;

-- Solution 2: (Using joins)

with temp as 
(select  event_type ,sum(occurences)/count(event_type) as calc from events group by event_type)
select business_id from events a join temp b on a.event_type = b.event_type and a.occurences > b.calc group by business_id having count(business_id)>1;
