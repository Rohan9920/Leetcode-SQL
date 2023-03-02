-- Table Variables:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | name          | varchar |
-- | value         | int     |
-- +---------------+---------+
-- name is the primary key for this table.
-- This table contains the stored variables and their values.
 

-- Table Expressions:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | left_operand  | varchar |
-- | operator      | enum    |
-- | right_operand | varchar |
-- +---------------+---------+
-- (left_operand, operator, right_operand) is the primary key for this table.
-- This table contains a boolean expression that should be evaluated.
-- operator is an enum that takes one of the values ('<', '>', '=')
-- The values of left_operand and right_operand are guaranteed to be in the Variables table.
 

-- Write an SQL query to evaluate the boolean expressions in Expressions table.

-- Return the result table in any order.

-- The query result format is in the following example.

-- Variables table:
-- +------+-------+
-- | name | value |
-- +------+-------+
-- | x    | 66    |
-- | y    | 77    |
-- +------+-------+

-- Expressions table:
-- +--------------+----------+---------------+
-- | left_operand | operator | right_operand |
-- +--------------+----------+---------------+
-- | x            | >        | y             |
-- | x            | <        | y             |
-- | x            | =        | y             |
-- | y            | >        | x             |
-- | y            | <        | x             |
-- | x            | =        | x             |
-- +--------------+----------+---------------+

-- Result table:
-- +--------------+----------+---------------+-------+
-- | left_operand | operator | right_operand | value |
-- +--------------+----------+---------------+-------+
-- | x            | >        | y             | false |
-- | x            | <        | y             | true  |
-- | x            | =        | y             | false |
-- | y            | >        | x             | true  |
-- | y            | <        | x             | false |
-- | x            | =        | x             | true  |
-- +--------------+----------+---------------+-------+
-- As shown, you need find the value of each boolean exprssion in the table using the variables table.


-- DDL Scripts

CREATE TABLE Variables
    (name varchar2(1), value int)
;

INSERT ALL 
    INTO Variables (name, value)
         VALUES ('x', 66)
    INTO Variables (name, value)
         VALUES ('y', 77)
SELECT * FROM dual
;

CREATE TABLE Expressions
    (left_operand varchar2(1), operator varchar2(1), right_operand varchar2(1))
;

INSERT ALL 
    INTO Expressions (left_operand, operator, right_operand)
         VALUES ('x', '>', 'y')
    INTO Expressions (left_operand, operator, right_operand)
         VALUES ('x', '<', 'y')
    INTO Expressions (left_operand, operator, right_operand)
         VALUES ('x', '=', 'y')
    INTO Expressions (left_operand, operator, right_operand)
         VALUES ('y', '>', 'x')
    INTO Expressions (left_operand, operator, right_operand)
         VALUES ('y', '<', 'x')
    INTO Expressions (left_operand, operator, right_operand)
         VALUES ('x', '=', 'x')
SELECT * FROM dual
;

-- Solution

with temp as
(select e.left_operand, e.operator, e.right_operand, v1.value as left_val, v2.value as right_val
from expressions e join variables v1 on e.left_operand = v1.name
join variables v2 on v2.name = e.right_operand)
select left_operand, operator, right_operand, 
case when operator = '>'then
case when left_val>right_val then 'true'
else 'false'
end
when operator = '<' then
case when left_val<right_val then 'true'
else 'false'
end
when operator = '=' then
case when left_val=right_val then 'true'
else 'false'
end
end as value from temp;