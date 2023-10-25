--1. The best hitters in history by home runs

SELECT player_id, SUM(hr)
FROM batting
GROUP BY 1
HAVING SUM(hr) is not null
ORDER BY 2 DESC
LIMIT 25;

--2.  Most homeruns by Boston Red Sox players ever

SELECT b.player_id, CONCAT (p.name_first, ' ', p.name_last) full_name, SUM(hr)
FROM batting_2 b
JOIN player p 
ON b.player_id = p.player_id
WHERE team_id = 'BOS'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

--3. Ranking players by homeruns, in case of players having the same number of home runs the rank will take number of hits into consideration.

SELECT RANK() OVER (ORDER BY hr DESC, h / ab DESC ) Rank, full_name, hr, ROUND((h / ab), 3) batting_avg
FROM batting_2
JOIN player p
ON batting_2.player_id = p.player_id
WHERE year = 2015
LIMIT 25;

--4.Best homeruns per at bat averages from the New York Yankees players since 2000´s

SELECT b.player_id, full_name, SUM(hr) homeruns, SUM(ab) at_bats, ROUND(SUM(hr) / SUM(ab), 3) Homeruns_per_at_bat_AVG
FROM batting_2 b
JOIN player p
ON b.player_id = p.player_id
WHERE ab >= 100
AND year = 2000
GROUP BY 1, 2
ORDER BY 5 DESC
LIMIT 50;

--5.New York Yankees players batting average and determing which ones are above the league ´ s average

WITH league_avg AS
    (SELECT ROUND(SUM(h) / SUM(ab), 3) league_avg
     FROM batting_2
     WHERE ab >= 100 )

SELECT b.player_id, full_name, ROUND(SUM(h) / SUM(ab), 3) batting_avg, SUM(ab) at_bats,
    CASE
     WHEN ROUND(SUM(h) / SUM(ab), 3) > league_avg THEN 'Above avg'
     ELSE 'Below avg'
    END AS batting_performance
FROM league_avg, batting_2 b
JOIN player p 
ON b.player_id = p.player_id
WHERE ab >= 200
AND team_id = 'NYA'
GROUP BY 1,2, league_avg
ORDER BY 3 DESC
LIMIT 25;

--6.Teams with the highest avg attendance per game in 21st century

SELECT name, ROUND(SUM(attendance) / sum(g)) avg_attendance_per_game
FROM team
WHERE year >= 2000
GROUP BY 1
ORDER BY 2 DESC;
-- In avg the NYY have the "best fans" or the highest attendance average receiving 22k fans per game

--7. Top Pitchers of all time based on the highest number of Pitching Triple Crown player award

SELECT p.player_id, full_name, COUNT(award_id) total
FROM player p
JOIN player_award pa 
ON p.player_id = pa.player_id
WHERE award_id = 'Pitching Triple Crown'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

--8.Teams with the highest salary disparity
SELECT team_id, ROUND(AVG(salary)) avg_salary, MAX(salary) max_salary, ROUND((MAX(salary) - AVG(salary)) / AVG(salary) * 100, 2) ||'%' salary_disparity
FROM salary s
JOIN player p
ON s.player_id = p.player_id
WHERE year = 2015
GROUP BY 1
ORDER BY 4 DESC;

--9. Top 10 players with the highest number of hits who are also members of the Hall of Fame
SELECT b.player_id, full_name, SUM(h)
FROM batting_2 b
JOIN player p 
ON b.player_id = p.player_id
JOIN hall_of_fame h 
ON h.player_id = p.player_id
WHERE year > 1950
AND inducted = 'Y'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 25;

-- Fielding position and salary analysis
--10. Best paid players and their fielding position

SELECT f.player_id, full_name, MAX(salary) max_salary, pos as position
FROM salary s
JOIN fielding f 
ON s.player_id = f.player_id
JOIN player p 
ON p.player_id = s.player_id
GROUP BY 1,2,4
ORDER BY 3 DESC
LIMIT 50;

--11.Average salary per fielding position since 2000`s

SELECT pos as position, ROUND(AVG(salary)) avg_salary
FROM salary s
JOIN fielding f 
ON s.player_id = f.player_id
WHERE f.year >= 2000
GROUP BY 1
ORDER BY 2 DESC;

--12.Pitchers that earn more than the average salary in the mlb for the year 2015

SELECT full_name, salary
FROM player p
JOIN salary s 
ON p.player_id = s.player_id
JOIN fielding f 
ON p.player_id = f.player_id
WHERE s.salary >
    (SELECT AVG(salary)
     FROM salary
     WHERE year = 2015)
AND s.year = 2015
AND pos = 'P'
GROUP BY 1,2
ORDER BY salary DESC
LIMIT 25;

--13.Average strikeouts per game by decade

SELECT ((year / 10) * 10) decade, ROUND(SUM(so) / SUM(g), 2) avg_so_per_game
FROM team
GROUP BY 1
ORDER BY 1 DESC;

/*
We can observe a trend showing each decade we have more strikeouts per game. This indicates there´s a possible
improvement in pitchers technique and ability. Pitchers nowadays are also throwing harder with more ball movement
which makes it harder for batters make contact with the baseball.
 */

--14.Average homeruns per game by decade

SELECT ((year / 10) * 10) decade, ROUND(SUM(hr) / SUM(g), 3) avg_hr_per_game
FROM team
GROUP BY 1
ORDER BY 1 DESC;

/*
We can also see a trend here in which each decade there are more homeruns per game except por the 2010´s, but still the upward
trend is pretty clear. As pitchers have become more focused on strikeouts, they may be more likely to throw pitches with higher velocity
and spin rate, which can lead to more home run opportunities for batters when they finally reach contact with the baseball.
Also some stadiums have been modified to be "homerun friendly". Changes in bat design and materials have led to bats that can generate more power when the ball is struck.
These may be some of the reasons we find these two interesting trends.
*/

--15.Most wins in a season without winning the World Series.

SELECT name, g games, w games_won, ROUND((w:: numeric/ g * 100),2) winning_percentage, year
FROM team
WHERE ws_win = 'N'
AND year >= 2000
GROUP BY 1,2,3,4,5
ORDER BY 3 DESC
LIMIT 5;

--16. Minimum wins in a season and winning the World Series since 21st century.

SELECT name, g, w, ROUND((w:: numeric / g),3) , year
FROM team
WHERE ws_win = 'Y'
AND year >= 2000
GROUP BY 1,2,3,5
ORDER BY 4;

--17 Average salaries per decade evolution for MLB players
--Note: This query takes values for year variable from the 1985´s and not from the beginning of the 80`s decade

SELECT ((year / 10) * 10)
 decade, ROUND(AVG(salary)) avg_salary_per_decade
FROM salary
GROUP BY 1
ORDER BY 1 DESC;


--18.Average salaries by team and which of them have the best and worst compensation to their players in comparison to the league `s average salary using percentiles

CREATE TEMP TABLE avg_salary_percentiles AS
SELECT percentile_cont(0.1) WITHIN
GROUP (
       ORDER BY avg_salary) p10,
      percentile_cont(0.25) WITHIN
GROUP (
       ORDER BY avg_salary) p25,
      percentile_cont(0.75) WITHIN
GROUP (
       ORDER BY avg_salary) p75,
      percentile_cont(0.9) WITHIN
GROUP (
       ORDER BY avg_salary) p90
FROM (SELECT avg(salary) avg_salary
     FROM salary
     WHERE year = 2015
     GROUP BY team_id) avg_salaries;

SELECT team_id, ROUND(AVG(salary)) avg_salary,
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

--19. Comparison for the 
rank the teams by the amount of salary spend, and then rank them by the position of the end of the year by wins
compare pitchers performance (win and losses) when they allowed a homerun and when they didnt
for position players, look first how many error they have on the season compare to what was the season average of error on a player on that position (maybe you can do instead of the 9 positions, do outfiels, middle infiels (ss,2b), third base,first base, catcher, pitcher) and you can look either how many season they ended playing the players that were always under the average amount of errors, or look the hall of famers and compare the season they were under and over the average

WITH ranked_data as 
(
SELECT name, SUM(salary), w wins, RANK() OVER(ORDER BY SUM(salary) DESC) salary_rank, RANK() OVER(ORDER BY w DESC) win_rank
FROM salary s
JOIN team t
ON s.team_id = t.team_id
WHERE t.year = 2015
GROUP BY 1,3
)

SELECT name, salary_rank, win_rank
FROM ranked_data
ORDER BY 2;