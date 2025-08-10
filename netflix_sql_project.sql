CREATE TABLE Netflix(
	show_id VARCHAR(500),	
	type VARCHAR(500)	,
	title VARCHAR(200),
	director VARCHAR(355),
	casts VARCHAR(1000),
	country	VARCHAR(1000),
	date_added VARCHAR(500),
	release_year INT,
	rating VARCHAR(100),
	duration VARCHAR(280),
	listed_in VARCHAR (300),
	description VARCHAR(900)

);
DROP TABLE Netflix;
SELECT * FROM Netflix;

SELECT COUNT(*) AS total_count FROM Netflix; 
SELECT DISTINCT type FROM Netflix; 

--2 COUNT the  number of movies vs TV show
SELECT type,COUNT(*) FROM Netflix
GROUP BY type; 
--Find the most commen rating for movies and tv show
-- SELECT type,
-- --rating 
-- MAX(rating)
-- FROM Netflix 
-- GROUP BY 1; 

SELECT type,rating FROM(
SELECT type,
rating, 
COUNT(*),  
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM Netflix 
GROUP BY 1,2
 ) AS t1
 WHERE ranking =1;

--3 List of all movies relese in a specific year
SELECT * FROM Netflix;

SELECT * FROM Netflix WHERE type='Movie' AND release_year =2020;

--FIND the TOP 5 countries  With the most content On Netflix

SELECT UNNEST (STRING_TO_ARRAY(country,',') )AS new_country,
COUNT(show_id) AS total_content
FROM Netflix
GROUP BY 1 ORDER BY total_content DESC LIMIT 5;


-- 5 Identify the Longest Movies

SELECT * FROM Netflix;

SELECT * FROM Netflix WHERE 
type='Movie' AND
duration =(SELECT MAX(duration )FROM Netflix);

--6 FIND the content added in last 5 years
-- SELECT CURRENT_DATE -INTERVAL '5 years'
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7 SELECT  all movies and TV show  by director 'rajiv chilaka'
SELECT * FROM Netflix 
WHERE director ILIKE '%Rajiv Chilaka%' ;


-- 9 List all TV show with more than 5 seconds
-- SELECT TYPE,duration FROM Netflix WHERE type= 'TV Show' AND duration >'5 Season '
SELECT * FROM Netflix 
	WHERE 
type= 'TV Show' AND 
SPLIT_PART(duration ,' ',1):: numeric >5

--10 Count the  NO OF Content iems in genre
-- SELECT show_id,listed_in ,
-- UNNEST(STRING_TO_array(listed_in,','))
-- FROM Netflix;

SELECT 
UNNEST(STRING_TO_array(listed_in,',')),
COUNT(show_id) AS Total_genre
FROM Netflix 
GROUP BY 1;

--11Find each year and the average number of content released by INDIA on Netflix 
-- AND return the top 5 years with the highest average content release
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS yearly_content,
    ROUND(COUNT(*)::numeric / (
        SELECT COUNT(*) 
        FROM netflix 
        WHERE country ILIKE '%india%'
    )::numeric * 100 ,2)AS average_content_per_year
FROM netflix 
WHERE country ILIKE '%india%'
GROUP BY 1
;

--12 list of all Movies that are in documantaries 
SELECT 
* FROM Netflix
WHERE type='Movie' AND listed_in ILIKE '%documentaries%'


-- 13 FIND All content without director
SELECT * FROM Netflix WHERE director isNull;

-- 14 find in how many movies actor 'salman khan ' appeared in last 10 years
SELECT * FROM Netflix WHERE casts ILIKE '%salman khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;


-- 15 Find the top 10 ACTOR WHO have appeared in the highest numbers of movies prodused in india
SELECT
UNNEST(STRING_TO_ARRAY(casts,',') )AS Actors,
COUNT(*) as total_content
FROM Netflix
WHERE country ILIKE '%india%'
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;


-- 16 Categorize the content based on the presence of the keyword 'kill' and 'violence' in
-- the description field. Lable Content Containing these keyword as 'bad' and all other
-- content as 'Good' Count how many items fall into each category.

WITH new_table
AS(

SELECT *,
CASE
WHEN description ILIKE '%kill%' OR 
description ILIKE '%voilence%' THEN 'Bad_Conetnt'
ELSE 'Good_Content'
END category 
FROM Netflix)

SELECT category,COUNT(*) AS total_count
FROM new_table
GROUP BY category;
 

