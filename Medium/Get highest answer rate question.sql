-- Get the highest answer rate question from a table survey_log with these columns: id, action, question_id, answer_id, q_num, timestamp.

-- id means user id; action has these kind of values: "show", "answer", "skip"; answer_id is not null when action column is "answer", 
-- while is null for "show" and "skip"; q_num is the numeral order of the question in current session.

-- Write a sql query to identify the question which has the highest answer rate.

-- Example:

-- Input:
-- +------+-----------+--------------+------------+-----------+------------+
-- | id   | action    | question_id  | answer_id  | q_num     | timestamp  |
-- +------+-----------+--------------+------------+-----------+------------+
-- | 5    | show      | 285          | null       | 1         | 123        |
-- | 5    | answer    | 285          | 124124     | 1         | 124        |
-- | 5    | show      | 369          | null       | 2         | 125        |
-- | 5    | skip      | 369          | null       | 2         | 126        |
-- +------+-----------+--------------+------------+-----------+------------+
-- Output:
-- +-------------+
-- | survey_log  |
-- +-------------+
-- |    285      |
-- +-------------+
-- Explanation:
-- question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.
 

-- Note: The highest answer rate meaning is: answer number's ratio in show number in the same question.

-- DDL Scripts:

CREATE TABLE survey_log
    (id int, action varchar2(6), question_id int, answer_id varchar2(6), q_num int, timestamp int)
;

INSERT ALL 
    INTO survey_log (id, action, question_id, answer_id, q_num, timestamp)
         VALUES (5, 'show', 285, NULL, 1, 123)
    INTO survey_log (id, action, question_id, answer_id, q_num, timestamp)
         VALUES (5, 'answer', 285, '124124', 1, 124)
    INTO survey_log (id, action, question_id, answer_id, q_num, timestamp)
         VALUES (5, 'show', 369, NULL, 2, 125)
    INTO survey_log (id, action, question_id, answer_id, q_num, timestamp)
         VALUES (5, 'skip', 369, NULL, 2, 126)
SELECT * FROM dual
;

-- Solution:

with temp as
(select question_id, avg(case when action = 'answer' then 1 else 0 end) as rate from
(select * from survey_log where action != 'show')
group by question_id)
select question_id from temp where rate = (select max(rate) from temp);