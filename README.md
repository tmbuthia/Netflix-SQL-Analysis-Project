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

![image](https://github.com/user-attachments/assets/c3bbb568-5963-4b3a-adc5-b66252e77f9a)
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
![image](https://github.com/user-attachments/assets/3980d45f-4b32-454a-834c-b664768a4f16)
![image](https://github.com/user-attachments/assets/22ac820a-983c-49a5-88ff-f54df9aec85c)
![image](https://github.com/user-attachments/assets/b6833ef0-5ac8-4a7a-bc39-59e0bdc60ea2)

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
