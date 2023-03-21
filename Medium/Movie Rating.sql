-- Table: Movies

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | title         | varchar |
-- +---------------+---------+
-- movie_id is the primary key for this table.
-- title is the name of the movie.
-- Table: Users

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | name          | varchar |
-- +---------------+---------+
-- user_id is the primary key for this table.
-- Table: Movie_Rating

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | user_id       | int     |
-- | rating        | int     |
-- | created_at    | date    |
-- +---------------+---------+
-- (movie_id, user_id) is the primary key for this table.
-- This table contains the rating of a movie by a user in their review.
-- created_at is the user's review date. 
 

-- Write the following SQL query:

-- Find the name of the user who has rated the greatest number of the movies.
-- In case of a tie, return lexicographically smaller user name.

-- Find the movie name with the highest average rating in February 2020.
-- In case of a tie, return lexicographically smaller movie name.

-- Query is returned in 2 rows, the query result format is in the folowing example:

-- Movies table:
-- +-------------+--------------+
-- | movie_id    |  title       |
-- +-------------+--------------+
-- | 1           | Avengers     |
-- | 2           | Frozen 2     |
-- | 3           | Joker        |
-- +-------------+--------------+

-- Users table:
-- +-------------+--------------+
-- | user_id     |  name        |
-- +-------------+--------------+
-- | 1           | Daniel       |
-- | 2           | Monica       |
-- | 3           | Maria        |
-- | 4           | James        |
-- +-------------+--------------+

-- Movie_Rating table:
-- +-------------+--------------+--------------+-------------+
-- | movie_id    | user_id      | rating       | created_at  |
-- +-------------+--------------+--------------+-------------+
-- | 1           | 1            | 3            | 2020-01-12  |
-- | 1           | 2            | 4            | 2020-02-11  |
-- | 1           | 3            | 2            | 2020-02-12  |
-- | 1           | 4            | 1            | 2020-01-01  |
-- | 2           | 1            | 5            | 2020-02-17  | 
-- | 2           | 2            | 2            | 2020-02-01  | 
-- | 2           | 3            | 2            | 2020-03-01  |
-- | 3           | 1            | 3            | 2020-02-22  | 
-- | 3           | 2            | 4            | 2020-02-25  | 
-- +-------------+--------------+--------------+-------------+

-- Result table:
-- +--------------+
-- | results      |
-- +--------------+
-- | Daniel       |
-- | Frozen 2     |
-- +--------------+

-- Daniel and Maria have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
-- Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.

-- DDL Scripts:

CREATE TABLE movies
    (movie_id int, title varchar2(8))
;

INSERT ALL 
    INTO movies (movie_id, title)
         VALUES (1, 'Avengers')
    INTO movies (movie_id, title)
         VALUES (2, 'Frozen 2')
    INTO movies (movie_id, title)
         VALUES (3, 'Joker')
SELECT * FROM dual
;

CREATE TABLE users
    (user_id int, name varchar2(6))
;

INSERT ALL 
    INTO users (user_id, name)
         VALUES (1, 'Daniel')
    INTO users (user_id, name)
         VALUES (2, 'Monica')
    INTO users (user_id, name)
         VALUES (3, '03ia')
    INTO users (user_id, name)
         VALUES (4, 'James')
SELECT * FROM dual
;



CREATE TABLE movie_rating
    (movie_id int, user_id int, rating int, created_at date)
;

INSERT ALL 
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (1, 1, 3, '2020-01-12')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (1, 2, 4, '2020-02-11')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (1, 3, 2, '2020-02-12')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (1, 4, 1, '2020-01-01')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (2, 1, 5, '2020-02-17')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (2, 2, 2, '2020-02-01')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (2, 3, 2, '2020-03-01')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (3, 1, 3, '2020-02-22')
    INTO movie_rating (movie_id, user_id, rating, created_at)
         VALUES (3, 2, 4, '2020-02-25')
SELECT * FROM dual
;

-- Solution 1:
select name from
(select a.user_id, b.name, count(a.user_id) from movie_rating a, users b where a.user_id = b.user_id group by a.user_id, b.name
order by count(a.user_id) desc, b.name) where rownum = 1
UNION 
(select title from(select a.movie_id, b.title, avg(a.rating) from movie_rating a, movies b where a.movie_id = b.movie_id and TO_CHAR(a.created_at, 'YYYY-MM') = '2020-02' group by a.movie_id, b.title order by avg(a.rating) desc)where rownum = 1);


-- Solution 2:
with temp1 as
(select user_id, count(movie_id) as cnt from movie_rating group by user_id),
temp2 as
(select u.name, rank() over (order by t.cnt desc,u.name) as rnk from temp1 t, users u where t.user_id=u.user_id),
temp3 as
(select movie_id, avg(rating) as avg_rating from movie_rating 
where TO_CHAR(created_at,'YYYY-MM')= '2020-02'
group by movie_id),
temp4 as
(select m.title, rank() over (order by t.avg_rating desc, m.title) as rnk from movies m, temp3 t where t.movie_id = m.movie_id)
select name from temp2 where rnk=1 UNION ALL (select title from temp4 where rnk=1);