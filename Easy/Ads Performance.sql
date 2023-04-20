-- Table: Ads

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | ad_id         | int     |
-- | user_id       | int     |
-- | action        | enum    |
-- +---------------+---------+
-- (ad_id, user_id) is the primary key for this table.
-- Each row of this table contains the ID of an Ad, the ID of a user and the action taken by this user regarding this Ad.
-- The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').
 

-- A company is running Ads and wants to calculate the performance of each Ad.

-- Performance of the Ad is measured using Click-Through Rate (CTR) where:



-- Write an SQL query to find the ctr of each Ad.

-- Round ctr to 2 decimal points. Order the result table by ctr in descending order and by ad_id in ascending order in case of a tie.

-- The query result format is in the following example:

-- Ads table:
-- +-------+---------+---------+
-- | ad_id | user_id | action  |
-- +-------+---------+---------+
-- | 1     | 1       | Clicked |
-- | 2     | 2       | Clicked |
-- | 3     | 3       | Viewed  |
-- | 5     | 5       | Ignored |
-- | 1     | 7       | Ignored |
-- | 2     | 7       | Viewed  |
-- | 3     | 5       | Clicked |
-- | 1     | 4       | Viewed  |
-- | 2     | 11      | Viewed  |
-- | 1     | 2       | Clicked |
-- +-------+---------+---------+
-- Result table:
-- +-------+-------+
-- | ad_id | ctr   |
-- +-------+-------+
-- | 1     | 66.67 |
-- | 3     | 50.00 |
-- | 2     | 33.33 |
-- | 5     | 0.00  |
-- +-------+-------+
-- for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
-- for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
-- for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
-- for ad_id = 5, ctr = 0.00, Note that ad_id = 5 has no clicks or views.
-- Note that we don't care about Ignored Ads.
-- Result table is ordered by the ctr. in case of a tie we order them by ad_id


-- DDL Scripts:

CREATE TABLE Ads (
  ad_id NUMBER,
  user_id NUMBER,
  action VARCHAR(50)
);

INSERT into ads values(1,1,'Clicked');
INSERT into ads values(2,2,'Clicked');
INSERT into ads values(3,3,'Viewed');
INSERT into ads values(5,5,'Ignored');
INSERT into ads values(1,7,'Ignored');
INSERT into ads values(2,7,'Viewed');
INSERT into ads values(3,5,'Clicked');
INSERT into ads values(1,4,'Viewed');
INSERT into ads values(2,11,'Viewed');
INSERT into ads values(1,2,'Clicked');

-- Solution 1:

with temp1 as
(select ad_id, count(distinct user_id) as clicks from ads
where action = 'Clicked'
group by ad_id),
temp2 as 
(select ad_id, count(distinct user_id) as views from ads
 where action != 'Ignored'
 group by ad_id)
select distinct a.ad_id, round(NVL( ((b.clicks/c.views)*100) ,0),2) as ctr
from ads a LEFT JOIN temp1 b  ON a.ad_id = b.ad_id
LEFT JOIN temp2 c ON a.ad_id = c.ad_id
order by 2 desc,1;

-- Solution 2:

with temp1 as
(select ad_id, case when action = 'Clicked' then 1 else 0 end as clicks,
case when action = 'Viewed' then 1 else 0 end as views
from ads)
select ad_id,
CASE WHEN sum(clicks)+sum(views) = 0 then 0 else
round(coalesce(((sum(clicks)/(sum(clicks) +sum(views)))*100),0),2) end as ctr
from temp1
group by ad_id;

--Solution 3:

select ad_id, round(coalesce((clk/(clk+view_cnt))*100,0),2) as ctr from 
(select ad_id, (select count(*) from ads where action = 'Clicked' and ad_id = a.ad_id group by  ad_id) clk,(select count(*) from ads where action = 'Viewed' and ad_id = a.ad_id group by  ad_id) view_cnt from
(select ad_id from ads group by ad_id)a)
order by ctr desc, ad_id;
