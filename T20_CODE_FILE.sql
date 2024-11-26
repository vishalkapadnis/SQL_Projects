SELECT *
FROM T20I;



-- Q1 Find the team with highest number of wins in 2024 and the total matches it won.

SELECT Winner, COUNT(*) AS Number_of_wins
FROM T20I
WHERE YEAR(MatchDate) = 2024
GROUP BY Winner
ORDER BY Number_of_wins DESC
LIMIT 1;

-- The query will return the team with the highest number of wins in 2024 and the total number of matches it won.


-- Q2 Rank the teams based on the total number of wins in 2024.

SELECT Winner, COUNT(*) AS 'Number of wins',
DENSE_RANK() OVER ( ORDER BY COUNT(*) DESC ) AS RANK_Assigned
FROM T20I
WHERE Winner NOT IN ('tied','no result')
GROUP BY Winner;


-- Q3 Which team had the highest average winning margin (in runs), and what was the average margin ?

SELECT Winner, 
       ROUND(AVG(CAST(SUBSTRING(Margin, 1, LOCATE(' ', Margin) - 1) AS UNSIGNED))) AS Rounded_Average_Winning_Margin
FROM T20I
WHERE Margin LIKE '%runs%'
GROUP BY Winner
ORDER BY Rounded_Average_Winning_Margin DESC
LIMIT 1;


-- Q4 Which team had the highest average winning margin (in wickets), and what was the average margin ?


SELECT Winner, 
       ROUND(AVG(CAST(SUBSTRING(Margin, 1, LOCATE(' ', Margin) - 1) AS UNSIGNED))) AS Avg_Margin_Wickets
FROM T20I
WHERE Margin LIKE '%wickets%'
GROUP BY Winner
ORDER BY Avg_Margin_Wickets DESC
LIMIT 1;


-- Q5 Identify matches played between two specific teams (e.g. India and South Africa) in 2024 and their results.

SELECT *
FROM T20I
WHERE (( Team1='India' AND Team2='South Africa') OR
		(Team1='South Africa' AND Team2='India' ));



-- Q6 List all matches where the winning margin was grater than the average margin across all matches. 

SELECT *,
       CAST(SUBSTRING(Margin, 1, LOCATE(' ', Margin) - 1) AS UNSIGNED) AS temp,  -- Extract numeric margin (before space)
       (SELECT AVG(CAST(SUBSTRING(Margin, 1, LOCATE(' ', Margin) - 1) AS UNSIGNED)) 
        FROM T20I
        WHERE Margin LIKE '%runs%' OR Margin LIKE '%wickets%') AS avg_margin,  -- Calculate overall average margin
       Winner AS temp1  -- Display the winner for rows where margin is greater than avg_margin
FROM T20I
WHERE CAST(SUBSTRING(Margin, 1, LOCATE(' ', Margin) - 1) AS UNSIGNED) > 
      (SELECT AVG(CAST(SUBSTRING(Margin, 1, LOCATE(' ', Margin) - 1) AS UNSIGNED)) 
       FROM T20I
       WHERE Margin LIKE '%runs%' OR Margin LIKE '%wickets%');  -- Filter rows where margin is greater than avg_margin
