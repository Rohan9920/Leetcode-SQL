-- Table Person:

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | id             | int     |
-- | name           | varchar |
-- | phone_number   | varchar |
-- +----------------+---------+
-- id is the primary key for this table.
-- Each row of this table contains the name of a person and their phone number.
-- Phone number will be in the form 'xxx-yyyyyyy' where xxx is the country code (3 characters) and yyyyyyy is the 
-- phone number (7 characters) where x and y are digits. Both can contain leading zeros.
-- Table Country:

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | name           | varchar |
-- | country_code   | varchar |
-- +----------------+---------+
-- country_code is the primary key for this table.
-- Each row of this table contains the country name and its code. country_code will be in the form 'xxx' where x is digits.
 

-- Table Calls:

-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | caller_id   | int  |
-- | callee_id   | int  |
-- | duration    | int  |
-- +-------------+------+
-- There is no primary key for this table, it may contain duplicates.
-- Each row of this table contains the caller id, callee id and the duration of the call in minutes. caller_id != callee_id
-- A telecommunications company wants to invest in new countries. The country intends to invest in the countries where the average call duration of the calls in this country is strictly greater than the global average call duration.

-- Write an SQL query to find the countries where this company can invest.

-- Return the result table in any order.

-- The query result format is in the following example.

-- Person table:
-- +----+----------+--------------+
-- | id | name     | phone_number |
-- +----+----------+--------------+
-- | 3  | Jonathan | 051-1234567  |
-- | 12 | Elvis    | 051-7654321  |
-- | 1  | Moncef   | 212-1234567  |
-- | 2  | Maroua   | 212-6523651  |
-- | 7  | Meir     | 972-1234567  |
-- | 9  | Rachel   | 972-0011100  |
-- +----+----------+--------------+

-- Country table:
-- +----------+--------------+
-- | name     | country_code |
-- +----------+--------------+
-- | Peru     | 051          |
-- | Israel   | 972          |
-- | Morocco  | 212          |
-- | Germany  | 049          |
-- | Ethiopia | 251          |
-- +----------+--------------+

-- Calls table:
-- +-----------+-----------+----------+
-- | caller_id | callee_id | duration |
-- +-----------+-----------+----------+
-- | 1         | 9         | 33       |
-- | 2         | 9         | 4        |
-- | 1         | 2         | 59       |
-- | 3         | 12        | 102      |
-- | 3         | 12        | 330      |
-- | 12        | 3         | 5        |
-- | 7         | 9         | 13       |
-- | 7         | 1         | 3        |
-- | 9         | 7         | 1        |
-- | 1         | 7         | 7        |
-- +-----------+-----------+----------+

-- Result table:
-- +----------+
-- | country  |
-- +----------+
-- | Peru     |
-- +----------+
-- The average call duration for Peru is (102 + 102 + 330 + 330 + 5 + 5) / 6 = 145.666667
-- The average call duration for Israel is (33 + 4 + 13 + 13 + 3 + 1 + 1 + 7) / 8 = 9.37500
-- The average call duration for Morocco is (33 + 4 + 59 + 59 + 3 + 7) / 6 = 27.5000 
-- Global call duration average = (2 * (33 + 3 + 59 + 102 + 330 + 5 + 13 + 3 + 1 + 7)) / 20 = 55.70000
-- Since Peru is the only country where average call duration is greater than the global average, it's the only recommended country.

-- DDL Scripts:

CREATE TABLE Person
    (id int, name varchar2(8), phone_number varchar2(11))
;

INSERT ALL 
    INTO Person (id, name, phone_number)
         VALUES (3, 'Jonathan', '051-1234567')
    INTO Person (id, name, phone_number)
         VALUES (12, 'Elvis', '051-7654321')
    INTO Person (id, name, phone_number)
         VALUES (1, 'Moncef', '212-1234567')
    INTO Person (id, name, phone_number)
         VALUES (2, 'Maroua', '212-6523651')
    INTO Person (id, name, phone_number)
         VALUES (7, 'Meir', '972-1234567')
    INTO Person (id, name, phone_number)
         VALUES (9, 'Rachel', '972-0011100')
SELECT * FROM dual
;

CREATE TABLE Country
    (name varchar2(8), country_code int)
;

INSERT ALL 
    INTO Country (name, country_code)
         VALUES ('Peru', 051)
    INTO Country (name, country_code)
         VALUES ('Israel', 972)
    INTO Country (name, country_code)
         VALUES ('Morocco', 212)
    INTO Country (name, country_code)
         VALUES ('Germany', 049)
    INTO Country (name, country_code)
         VALUES ('Ethiopia', 251)
SELECT * FROM dual
;

CREATE TABLE Calls
    (caller_id int, callee_id int, duration int)
;

INSERT ALL 
    INTO Calls (caller_id, callee_id, duration)
         VALUES (1, 9, 33)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (2, 9, 4)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (1, 2, 59)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (3, 12, 102)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (3, 12, 330)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (12, 3, 5)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (7, 9, 13)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (7, 1, 3)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (9, 7, 1)
    INTO Calls (caller_id, callee_id, duration)
         VALUES (1, 7, 7)
SELECT * FROM dual
;

-- Solution:

with temp as
(select caller_id, duration from calls UNION ALL (select callee_id, duration
from calls)),
temp2 as
(select c.name, avg(duration) over (partition by c.name) as ind_avg, avg(duration) over () as global_avg 
from temp t join person p on t.caller_id=p.id join country c
on substr(p.phone_number,1,3)=c.country_code)
select distinct name from temp2 where ind_avg > global_avg;