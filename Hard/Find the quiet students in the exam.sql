-- Table: Student

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | student_id          | int     |
-- | student_name        | varchar |
-- +---------------------+---------+
-- student_id is the primary key for this table.
-- student_name is the name of the student.
 

-- Table: Exam

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | exam_id       | int     |
-- | student_id    | int     |
-- | score         | int     |
-- +---------------+---------+
-- (exam_id, student_id) is the primary key for this table.
-- Student with student_id got score points in exam with id exam_id.
 

-- A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score.

-- Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.

-- Don't return the student who has never taken any exam. Return the result table ordered by student_id.

-- The query result format is in the following example.

 

-- Student table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Jade          |
-- | 3           | Stella        |
-- | 4           | Jonathan      |
-- | 5           | Will          |
-- +-------------+---------------+

-- Exam table:
-- +------------+--------------+-----------+
-- | exam_id    | student_id   | score     |
-- +------------+--------------+-----------+
-- | 10         |     1        |    70     |
-- | 10         |     2        |    80     |
-- | 10         |     3        |    90     |
-- | 20         |     1        |    80     |
-- | 30         |     1        |    70     |
-- | 30         |     3        |    80     |
-- | 30         |     4        |    90     |
-- | 40         |     1        |    60     |
-- | 40         |     2        |    70     |
-- | 40         |     4        |    80     |
-- +------------+--------------+-----------+

-- Result table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 2           | Jade          |
-- +-------------+---------------+

-- For exam 1: Student 1 and 3 hold the lowest and high score respectively.
-- For exam 2: Student 1 hold both highest and lowest score.
-- For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
-- Student 2 and 5 have never got the highest or lowest in any of the exam.
-- Since student 5 is not taking any exam, he is excluded from the result.
-- So, we only return the information of Student 2.


-- DDL statement:

CREATE TABLE Student
    (student_id int, student_name varchar2(8))
;

INSERT ALL 
    INTO Student (student_id, student_name)
         VALUES (1, 'Daniel')
    INTO Student (student_id, student_name)
         VALUES (2, 'Jade')
    INTO Student (student_id, student_name)
         VALUES (3, 'Stella')
    INTO Student (student_id, student_name)
         VALUES (4, 'Jonathan')
    INTO Student (student_id, student_name)
         VALUES (5, 'Will')
SELECT * FROM dual
;


CREATE TABLE Exam
    (exam_id int, student_id int, score int)
;

INSERT ALL 
    INTO Exam (exam_id, student_id, score)
         VALUES (10, 1, 70)
    INTO Exam (exam_id, student_id, score)
         VALUES (10, 2, 80)
    INTO Exam (exam_id, student_id, score)
         VALUES (10, 3, 90)
    INTO Exam (exam_id, student_id, score)
         VALUES (20, 1, 80)
    INTO Exam (exam_id, student_id, score)
         VALUES (30, 1, 70)
    INTO Exam (exam_id, student_id, score)
         VALUES (30, 3, 80)
    INTO Exam (exam_id, student_id, score)
         VALUES (30, 4, 90)
    INTO Exam (exam_id, student_id, score)
         VALUES (40, 1, 60)
    INTO Exam (exam_id, student_id, score)
         VALUES (40, 2, 70)
    INTO Exam (exam_id, student_id, score)
         VALUES (40, 4, 80)
SELECT * FROM dual
;

-- Solution 1:


with students as
( select s.student_id, s.student_name from Student s join (select distinct student_id from exam) e
 on s.student_id = e.student_id),
temp as
(select student_id, rank() over (partition by exam_id order by score) as lowest_score,
rank() over (partition by exam_id order by score desc) as highest_score from exam)
select s.student_id, s.student_name,a.student_id from students s left join
(select distinct student_id from temp where lowest_score = 1 or highest_score = 1)a
on a.student_id = s.student_id
where a.student_id is null;

-- Solution 2:

select student_id, student_name from student where student_id not in
(select distinct student_id from 
(select a.exam_id, a.student_id, rank() over (partition by a.exam_id order by 
score) as low_score, rank() over (partition by a.exam_id order by 
score desc) as high_score from exam a) where high_score =1 or low_score = 1)
and student_id in (select distinct student_id from exam);

