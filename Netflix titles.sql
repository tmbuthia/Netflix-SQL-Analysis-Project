-- Netflix Project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(20),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);


SELECT * FROM netflix;
-- Exploratory data analysis



-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
SELECT 
	type,
	count(*)
FROM netflix
GROUP BY type;

--2. Find the most common rating for movies and TV shows
SELECT type,rating
FROM
(SELECT
	type,
	rating,
	COUNT(*),
	RANK()OVER(PARTITION BY type ORDER BY COUNT(*) DESC)AS ranking
	FROM netflix
GROUP BY 1,2
) AS t1
WHERE ranking =1 ;

--3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix
WHERE type = 'Movie' AND 	release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	count(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER by 2 DESC
LIMIT 5;

--5. Identify the longest movie

SELECT * FROM netflix
WHERE type = 'Movie'
AND duration = (SELECT MAX(duration) FROM netflix)

--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY')  >= CURRENT_DATE - INTERVAL'5 years';

--7. Find all the movies/TV shows by director 'Steven Spielberg'!
SELECT *
FROM netflix
WHERE director iLIKE '%Steven Spielberg%';

--8. List all TV shows with more than 5 seasons
SELECT * FROM netflix
WHERE
	type = 'TV Show' AND
	CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5 ;
	
--9. Count the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as content_genre,count(show_id)
FROM netflix
GROUP BY content_genre
ORDER BY count(show_id) DESC;

--10.Find each year and the average numbers of content added in France on netflix. 
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*),
	ROUND(COUNT(*) ::numeric / (SELECT COUNT(*) FROM netflix WHERE country ILIKE '%France%')::numeric *100,2) AS avg_content,
    country_release
FROM (
    SELECT
        date_added,
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country_release
    FROM netflix
) AS unnested
WHERE country_release = 'France'
GROUP BY year, country_release;

--11. List all movies that are documentaries

SELECT * 
FROM netflix
WHERE type = 'Movie'
AND
listed_in ILIKE'%documentaries%' ;

--12. Find all content without a director
SELECT * 
FROM netflix
WHERE director IS NULL;

--13. Find how many movies actor 'David Spade' appeared in last 10 years!

SELECT * FROM netflix
WHERE type = 'Movie'
AND 
casts ILIKE'%David Spade%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in United States.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	count(*) AS total_content
FROM netflix
WHERE country ILIKE '%United States%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
WITH new_table
AS
(
SELECT
*,
	CASE 
	WHEN
		description ILIKE '%kill%' OR 
		description ILIKE '%violence%' THEN 'Bad content'
		ELSE 'Good content'
	END content_label
FROM netflix
)
SELECT 
	content_label,
	count(*) as total_content
FROM new_table
GROUP BY 1;


SELECT * FROM netflix;