-- Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
 

-- Write a query to find the shortest distance between these points rounded to 2 decimals.
 

-- | x  | y  |
-- |----|----|
-- | -1 | -1 |
-- | 0  | 0  |
-- | -1 | -2 |
 

-- The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
 

-- | shortest |
-- |----------|
-- | 1.00     |
 

-- Note: The longest distance among all the points are less than 10000.

-- DDL Scripts:

CREATE TABLE point_2d
    (x int, y int)
;

INSERT ALL 
    INTO point_2d (x, y)
         VALUES (-1, -1)
    INTO point_2d (x, y)
         VALUES (0, 0)
    INTO point_2d (x, y)
         VALUES (-1, -2)
SELECT * FROM dual
;

-- Solution

select round(min(sqrt(power((a.x-b.x),2)+power((a.y-b.y),2))),2) as shortest_distance from point_2d a, point_2d b where (a.x != b.x or a.y!=b.y);