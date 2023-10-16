-- There is a table courses with columns: student and class

-- Please list out all classes which have more than or equal to 5 students.

-- For example, the table:

-- +---------+------------+
-- | student | class      |
-- +---------+------------+
-- | A       | Math       |
-- | B       | English    |
-- | C       | Math       |
-- | D       | Biology    |
-- | E       | Math       |
-- | F       | Computer   |
-- | G       | Math       |
-- | H       | Math       |
-- | I       | Math       |
-- +---------+------------+

-- DDL statement

CREATE TABLE Courses
    (student varchar2(1), class varchar2(8))
;

INSERT ALL 
    INTO Courses (student, class)
         VALUES ('A', 'Math')
    INTO Courses (student, class)
         VALUES ('B', 'English')
    INTO Courses (student, class)
         VALUES ('C', 'Math')
    INTO Courses (student, class)
         VALUES ('D', 'Biology')
    INTO Courses (student, class)
         VALUES ('E', 'Math')
    INTO Courses (student, class)
         VALUES ('F', 'Computer')
    INTO Courses (student, class)
         VALUES ('G', 'Math')
    INTO Courses (student, class)
         VALUES ('H', 'Math')
    INTO Courses (student, class)
         VALUES ('I', 'Math')
SELECT * FROM dual
;

-- Solution:

select class from courses
group by class
having count(distinct student)>=5;