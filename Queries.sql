--1. Mejores bateadores de la historia por Homeruns
SELECT player_id, SUM(hr)
FROM batting_2
GROUP BY 1
HAVING SUM(hr) IS NOT NULL
ORDER BY 2 DESC;



--2. Join de batting con player para tener los nombres completos de los jugadores.
-- Most HomeRuns by Boston Red Sox players ever

SELECT b.player_id, CONCAT(p.name_first, ' ', p.name_last) as full_name, SUM(hr)
FROM batting_2 b
JOIN player p
ON b.player_id = p.player_id
WHERE team_id = 'BOS'
GROUP BY 1,2
HAVING SUM(hr) IS NOT NULL
ORDER BY 3 DESC
LIMIT 20;


--3. Players ranked by hr, in case of players having the same number of home runs the rank will take number of hits into consideration.
SELECT RANK() OVER(ORDER BY hr DESC, h/ab DESC) Rank, name_first  first_name, name_last last_name, hr, ROUND((h/ab),3) as batting_avg
FROM batting_2
JOIN player p
    ON batting_2.player_id = p.player_id
WHERE year = 2015;




--4. Best homeruns per at bat avg from the New York Yankees players since 2000´s
SELECT b.player_id, CONCAT(p.name_first, ' ', p.name_last) as full_name, SUM(hr) as homeruns, SUM(ab) as at_bats, ROUND(SUM(hr) / SUM(ab),3) as Homeruns_per_at_bat_AVG
FROM batting_2 b
JOIN player p
ON b.player_id = p.player_id
WHERE team_id = 'NYA'
AND ab >= 200
GROUP BY 1,2
ORDER BY 5 DESC
LIMIT 50;



--5. New York Yankees players batting average and determing which ones are above the league´s average
WITH league_avg AS (
    SELECT ROUND(SUM(h) / SUM(ab),3) as league_avg
    FROM batting_2
    WHERE ab>=100
)
    SELECT b.player_id, CONCAT(p.name_first, ' ', p.name_last) as full_name, ROUND(SUM(h) / SUM(ab),3) as batting_avg,
           CASE
           WHEN ROUND(SUM(h) / SUM(ab),3) > league_avg THEN 'Above avg'
           ELSE 'Below avg'
    END AS batting_performance
    FROM league_avg, batting_2 b
    JOIN player p
    ON b.player_id = p.player_id
    WHERE ab>=100 and team_id = 'NYA'
    GROUP BY 1, 2, league_avg
ORDER BY 3 desc



--6.Team with the highest avg attendance in 21st century
SELECT name, ROUND(SUM(attendance)/sum(g)) as avg_attendance_per_game
FROM team
WHERE year >= 2000
GROUP BY 1
ORDER BY 2 DESC;
--In avg the NYY receive 22k fans in avg per game



--7.Best Pitchers of all-time in terms of more "Pitching Triple Crown" player awards
SELECT p.player_id, CONCAT(p.name_first, ' ', p.name_last) as full_name,  COUNT(pa.award_id)
FROM player p
JOIN player_award pa
ON p.player_id = pa.player_id
WHERE award_id = 'Pitching Triple Crown'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;



--8. Teams with the highest yearly pay to their players in most recent data (2015) and highest earner.

SELECT team_id, ROUND(AVG(salary)) as avg_salary, MAX (salary), p.name_first, p.name_last
FROM salary s
         JOIN player p
              ON s.player_id = p.player_id
WHERE year = 2015
GROUP BY 1, 4, 5
ORDER BY 2 DESC

--ARREGLAR ESTE, explicación abajo de lo que se quiere hacer
-- Quiero primero separar por team, después decir que paga cada team en average a sus jugadores, tercero sería el salario máximo
-- que paga cada uno de estos teams, y por ultima columna quién es el jugador que recibe este maximum pay.
-- Si quitas name_first y name_last el query tiene sentido entero y el avg_salary para cada team se calcula bien al igual que el max
-- salario que paga cada team. El tema es que este query no quiere calcular el avg salary bien, regresa el mismo resultado que la columna de max salary


SELECT  MAX(salary), name_first, name_last
FROM salary s
JOIN player p
ON s.player_id = p.player_id
WHERE year = 2015
GROUP BY  2, 3
ORDER BY 1 DESC



--9. Top 10 players by hits and part of the Hall of Fame
SELECT b.player_id, CONCAT(p.name_first, ' ', p.name_last) as full_name, SUM(h)
FROM batting_2 b
JOIN player p
ON b.player_id = p.player_id
JOIN hall_of_fame h
ON h.player_id = p.player_id
WHERE year>1950 and inducted = 'Y'
GROUP BY 1,2
HAVING SUM(h) IS NOT NULL
ORDER BY 3 DESC
LIMIT 25;


--10.Park Analysis
-- revisar si este join tiene sentido, terminar idea...
SELECT *
FROM park p
JOIN team t
    ON p.park_name = t.park






-- Fielding position and salary analysis
--11. Best paid players and their fielding position
SELECT f.player_id, p.name_first, p.name_last, MAX(salary), f.pos
FROM salary s
JOIN fielding f
ON s.player_id = f.player_id
JOIN player p
ON p.player_id = s.player_id
GROUP BY 1,2,3,5
ORDER BY 4 DESC
LIMIT 50;



--12. Average salary per fielding position
SELECT f.pos, ROUND(AVG(s.salary)) as avg_salary
FROM salary s
JOIN fielding f
ON s.player_id = f.player_id
WHERE f.year >= 2000
GROUP BY 1
ORDER BY 2 DESC


--13. Pitchers that earn more than the average salary in the mlb for the year 2015
SELECT p.name_first, p.name_last, s.salary
FROM player p
JOIN salary s ON p.player_id = s.player_id
JOIN fielding f ON p.player_id = f.player_id
WHERE s.salary > (
    SELECT AVG(salary)
    FROM salary
    WHERE year = 2015
) AND s.year = 2015 AND pos = 'P'
GROUP BY 1,2,3
ORDER BY s.salary DESC;



--14. Average strikeouts per game by decade
SELECT ((year / 10) * 10) as decade, ROUND(SUM(so) / SUM(g),2)as avg_so_per_game
FROM team
GROUP BY 1
ORDER BY 1 DESC;

-- We can clearly see a trend in which each decade we have more strikeouts per game indicating a possible improvement
--in pitchers technique and ability. Pitchers nowadays are also throwing harder with more ball movement.


--15. Average homeruns per game by decade
SELECT ((year / 10) * 10) as decade, ROUND(SUM(hr)/SUM(g),3) as avg_hr_per_game
FROM team
GROUP BY 1
ORDER BY 1 DESC

--We can also see a trend here in which each decade there are more homeruns per game except por the 2010´s, but still the upward
--trend is pretty clear. As pitchers have become more focused on strikeouts, they may be more likely to throw pitches with higher velocity
--and spin rate, which can lead to more home run opportunities for batters. Also some stadiums have been modified to be more
--"homerun friendly". Changes in bat design and materials have led to bats that can generate more power when the ball is struck.
--these may be some of the reasons we find these two interesting trends.



--16. Most wins in a season without winning the World Series.
SELECT name, g as games, w as games_won, ROUND(CAST (w AS REAL)/g*100) as winning_percentage, ws_win as World_Series_Win, year
    FROM team
    WHERE ws_win = 'N' AND year >= 2000
GROUP BY 1,2,3,4,5,6
ORDER BY 3 DESC
LIMIT 5;


--17. Minimum wins in a season and winning the World Series since 21st century.
SELECT name, g ,w, CAST(w AS REAL) /g as ratio, ws_win as world_series_win, year
FROM team
WHERE ws_win = 'Y' AND year >= 2000
GROUP BY 1,2,3,5,6
ORDER BY 4;


--18. Average salaries by team and which of them have the best and worst compensation in comparison to the league`s average salary using percentiles

CREATE TEMP TABLE avg_salary_percentiles AS
SELECT
            percentile_cont(0.1) WITHIN GROUP (ORDER BY avg_salary) as p10,
            percentile_cont(0.25) WITHIN GROUP (ORDER BY avg_salary) as p25,
            percentile_cont(0.75) WITHIN GROUP (ORDER BY avg_salary) as p75,
            percentile_cont(0.9) WITHIN GROUP (ORDER BY avg_salary) as p90
FROM (
         SELECT avg(salary) as avg_salary
         FROM salary
         WHERE year = 2015
         GROUP BY team_id
     ) as avg_salaries;

SELECT
    team_id,
    ROUND(AVG(salary)) as avg_salary,
    CASE
        WHEN AVG(salary) > (SELECT p90 FROM avg_salary_percentiles) THEN 'Very High Salaries'
        WHEN AVG(salary) < (SELECT p10 FROM avg_salary_percentiles) THEN 'Very Low Salaries'
        WHEN AVG(salary) > (SELECT p75 FROM avg_salary_percentiles) THEN 'High Salaries'
        WHEN AVG(salary) < (SELECT p25 FROM avg_salary_percentiles) THEN 'Low Salaries'
        ELSE 'Medium Salaries'
    END AS Compensation
FROM salary
WHERE year = 2015
GROUP BY team_id
ORDER BY avg_salary DESC;
