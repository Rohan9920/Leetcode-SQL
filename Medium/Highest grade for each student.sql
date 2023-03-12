-- Table: Enrollments

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | course_id     | int     |
-- | grade         | int     |
-- +---------------+---------+
-- (student_id, course_id) is the primary key of this table.

-- Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

-- The query result format is in the following example:

-- Enrollments table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 2          | 2         | 95    |
-- | 2          | 3         | 95    |
-- | 1          | 1         | 90    |
-- | 1          | 2         | 99    |
-- | 3          | 1         | 80    |
-- | 3          | 2         | 75    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

-- Result table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 1          | 2         | 99    |
-- | 2          | 2         | 95    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

-- DDL Scripts:


CREATE TABLE Enrollments
    (student_id int, course_id int, grade int)
;

INSERT ALL 
    INTO Enrollments (student_id, course_id, grade)
         VALUES (2, 2, 95)
    INTO Enrollments (student_id, course_id, grade)
         VALUES (2, 3, 95)
    INTO Enrollments (student_id, course_id, grade)
         VALUES (1, 1, 90)
    INTO Enrollments (student_id, course_id, grade)
         VALUES (1, 2, 99)
    INTO Enrollments (student_id, course_id, grade)
         VALUES (3, 1, 80)
    INTO Enrollments (student_id, course_id, grade)
         VALUES (3, 2, 75)
    INTO Enrollments (student_id, course_id, grade)
         VALUES (3, 3, 82)
SELECT * FROM dual
;

-- Solution

with temp as
(select student_id, course_id, grade, rank() over (partition by student_id order by grade desc, course_id) as rnk
from enrollments)
select student_id, course_id, grade
from temp
where rnk = 1;
