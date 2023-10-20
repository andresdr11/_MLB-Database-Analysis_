/*
SELECT *
INTO batting2
FROM batting
WHERE hr IS NOT NULL;
 */

/*
SELECT b.player_id, CONCAT(p.name_first, ' ', p.name_last) as full_name, SUM(hr)
FROM batting b
JOIN player p
ON b.player_id = p.player_id
WHERE team_id = 'BOS'
GROUP BY 1,2
HAVING SUM(hr) IS NOT NULL
ORDER BY 3 DESC
LIMIT 20;
 */

/*
SELECT b.player_id, CONCAT(p.name_first, ' ', p.name_last) as full_name, SUM(hr)
FROM batting2 b
JOIN player p
ON b.player_id = p.player_id
WHERE team_id = 'BOS'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 20;
 */
--Este no usa batting sino batting2 que es la que no tiene los nulls


SELECT DENSE_RANK() OVER(ORDER BY hr DESC, h DESC, rbi DESC) Rank, name_first  first_name, name_last last_name, hr, h
FROM batting2
JOIN player p
    ON batting2.player_id = p.player_id
WHERE year = 2015;

