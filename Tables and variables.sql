--El punto de este script es que tenga todo lo necesario para formatear las tablas y dejarlas como nosotros las usamos
--Deberia estar hecho de una manera que corriendo todas las lineas quie seran 100 algo, se formateen las tablas sin ningun error
--que me recuerde son 3 cosas:

---Data Cleaning, table creation and variable type modifications

--1. Usando batting averiguamos si player_id tiene valores unicos para usarla de primary key
SELECT COUNT(player_id)
FROM batting;

SELECT DISTINCT COUNT(player_id)
FROM batting;


--2. Confirmamos que player_id en la tabla player es primary key tambien.
SELECT COUNT(player_id)
FROM player;

SELECT DISTINCT COUNT(player_id)
FROM player;


--3. Checking primary keys for park and team join
SELECT COUNT(park_name)
FROM park;

SELECT DISTINCT COUNT(park_name)
FROM park;

SELECT COUNT(park)
FROM team;

SELECT DISTINCT COUNT(park)
FROM team;


--4.
ALTER TABLE team
ALTER COLUMN attendance TYPE numeric USING attendance::numeric;

--5.
ALTER TABLE team
ALTER COLUMN hr TYPE numeric USING hr::numeric;


--6. SELECT *
INTO batting2
FROM batting
WHERE hr IS NOT NULL;

