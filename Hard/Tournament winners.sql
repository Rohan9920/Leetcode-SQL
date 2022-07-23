-- Table: Players

-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | player_id   | int   |
-- | group_id    | int   |
-- +-------------+-------+
-- player_id is the primary key of this table.
-- Each row of this table indicates the group of each player.
-- Table: Matches

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | match_id      | int     |
-- | first_player  | int     |
-- | second_player | int     | 
-- | first_score   | int     |
-- | second_score  | int     |
-- +---------------+---------+
-- match_id is the primary key of this table.
-- Each row is a record of a match, first_player and second_player contain the player_id of each match.
-- first_score and second_score contain the number of points of the first_player and second_player respectively.
-- You may assume that, in each match, players belongs to the same group.
 

-- The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, 
-- the lowest player_id wins.

-- Write an SQL query to find the winner in each group.

-- The query result format is in the following example:

-- Players table:
-- +-----------+------------+
-- | player_id | group_id   |
-- +-----------+------------+
-- | 15        | 1          |
-- | 25        | 1          |
-- | 30        | 1          |
-- | 45        | 1          |
-- | 10        | 2          |
-- | 35        | 2          |
-- | 50        | 2          |
-- | 20        | 3          |
-- | 40        | 3          |
-- +-----------+------------+

-- Matches table:
-- +------------+--------------+---------------+-------------+--------------+
-- | match_id   | first_player | second_player | first_score | second_score |
-- +------------+--------------+---------------+-------------+--------------+
-- | 1          | 15           | 45            | 3           | 0            |
-- | 2          | 30           | 25            | 1           | 2            |
-- | 3          | 30           | 15            | 2           | 0            |
-- | 4          | 40           | 20            | 5           | 2            |
-- | 5          | 35           | 50            | 1           | 1            |
-- +------------+--------------+---------------+-------------+--------------+

-- Result table:
-- +-----------+------------+
-- | group_id  | player_id  |
-- +-----------+------------+ 
-- | 1         | 15         |
-- | 2         | 35         |
-- | 3         | 40         |
-- +-----------+------------+

-- DDL STATEMENTS:

CREATE TABLE Players
    (player_id int, group_id int)
;

INSERT ALL 
    INTO Players (player_id, group_id)
         VALUES (15, 1)
    INTO Players (player_id, group_id)
         VALUES (25, 1)
    INTO Players (player_id, group_id)
         VALUES (30, 1)
    INTO Players (player_id, group_id)
         VALUES (45, 1)
    INTO Players (player_id, group_id)
         VALUES (10, 2)
    INTO Players (player_id, group_id)
         VALUES (35, 2)
    INTO Players (player_id, group_id)
         VALUES (50, 2)
    INTO Players (player_id, group_id)
         VALUES (20, 3)
    INTO Players (player_id, group_id)
         VALUES (40, 3)
SELECT * FROM dual
;


CREATE TABLE Matches
    (match_id int, first_player int, second_player int, first_score int, second_score int)
;

INSERT ALL 
    INTO Matches (match_id, first_player, second_player, first_score, second_score)
         VALUES (1, 15, 45, 3, 0)
    INTO Matches (match_id, first_player, second_player, first_score, second_score)
         VALUES (2, 30, 25, 1, 2)
    INTO Matches (match_id, first_player, second_player, first_score, second_score)
         VALUES (3, 30, 15, 2, 0)
    INTO Matches (match_id, first_player, second_player, first_score, second_score)
         VALUES (4, 40, 20, 5, 2)
    INTO Matches (match_id, first_player, second_player, first_score, second_score)
         VALUES (5, 35, 50, 1, 1)
SELECT * FROM dual

-- Solution:

with player_score as
(select m.first_player as player, m.first_score as score
from matches m
UNION ALL
(select m.second_player as player, m.second_score as score 
from matches m)),
temp as
(select p.*,t.group_id from player_score p join players t
on p.player = t.player_id)
select group_id, player
from (select player, group_id, sum(score) as ss,  rank() over (partition by group_id order by sum(score) desc,player
)as rn from temp group by player, group_id) where rn=1;


