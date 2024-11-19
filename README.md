# Netflix-SQL-Analysis-Project
This project analyzes Netflix’s extensive content database to provide insights into content distribution, ratings, genres, actors, and more
# Project Overview
This project analyzes Netflix’s extensive content database to provide insights into content distribution, ratings, genres, actors, and more. With 15 business-related SQL queries, we uncover valuable insights into trends, classifications, and distributions within Netflix's offerings, helping to understand patterns that might drive content acquisition, user engagement, and platform strategies.

# Table of Contents
1. Project Setup
2. Dataset Schema
3. Business Questions and Solutions
4. Sample Queries
5. Insights and Findings
6. Project Setup
This project is built to run SQL queries on a PostgreSQL or compatible SQL database. Ensure the Netflix table is created and populated with the following schema:
```sql
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
```
# Dataset Schema
1. show_id: Unique identifier for each show.
2. type: Either 'Movie' or 'TV Show'.
3. title: Title of the content.
4. director: Director(s) of the content.
5. casts: List of main actors in the content.
6. country: Country or countries of production.
7. date_added: Date when the content was added to Netflix.
8. release_year: The year content was released.
9. rating: Content rating (e.g., PG, R, TV-MA).
10. duration: Duration for movies (in minutes) or the number of seasons for TV shows.
11. listed_in: Genres associated with the content.
12. description: Brief description of the content.
# Business Questions and Solutions
The project addresses the following business questions:
1. Count the number of Movies vs TV Shows.
2. Identify the most common rating for both movies and TV shows.
3. List all movies released in a specific year (e.g., 2020).
4. Find the top 5 countries with the highest content on Netflix.
5. Identify the longest movie by duration.
6. Identify content added to Netflix within the last 5 years.
7. List all content directed by Steven Spielberg.
8. List all TV shows with more than 5 seasons.
9. Count the number of content items in each genre.
10. Determine the top 5 years with the highest average content release in France.
11. List all movies that are documentaries.
12. Identify content without a listed director.
13. Count the number of movies featuring 'David Spade' in the last 10 years.
14. Identify the top 10 actors who appeared in the highest number of movies produced in the United States.
15. Classify content as 'Good' or 'Bad' based on the presence of 'kill' or 'violence' in descriptions.
```sql
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
```

# Insights and Findings
# Key Insights:
Movie vs. TV Show Count: Movies are more prevalent than TV shows on Netflix.
Content Ratings: Certain ratings are more common, highlighting Netflix’s target demographics.
Popular Countries for Production: The U.S., India, and other regions lead in content production.
Longest Movie: Finding the longest movie offers insight into Netflix’s range in film lengths.
Genre Distribution: Popular genres on Netflix help understand audience preferences.
# Findings:
Documentaries are primarily categorized under Movies.
A significant amount of content lacks a director listing, highlighting possible gaps in metadata.
Certain actors and directors, such as David Spade, are associated with significant numbers of content items, showing their influence on Netflix’s offerings.
# Conclusion
This project provides valuable insights into Netflix's content catalog, from genre distribution and duration insights to trends in ratings and actor appearances.
By making this data more accessible through SQL, we can better understand patterns in content creation, helping Netflix and its stakeholders tailor strategies to their audience's preferences.
