-- Run entire script before using the Queries.sql file

---Data Cleaning, table creation and variable type modifications

--1.
ALTER TABLE team
ALTER COLUMN attendance TYPE numeric USING attendance::numeric;

--2.
ALTER TABLE team
ALTER COLUMN hr TYPE numeric USING hr::numeric;


--3.
SELECT*
INTO batting_2
FROM batting
WHERE hr IS NOT NULL
AND hr > 0
AND ab IS NOT NULL
AND ab > 0;

--4
ADD COLUMN full_name VARCHAR(50);

UPDATE player
SET full_name = CONCAT(name_first, ' ', name_last);

