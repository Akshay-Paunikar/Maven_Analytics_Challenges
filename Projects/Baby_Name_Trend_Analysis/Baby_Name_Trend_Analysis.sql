
-- ---------------------------
-- Baby Name Trend Analysis --
-- ---------------------------
/*
Baby names over three decades broken down by state, gender and birth year and 
baby names from social security card applications in the United States spanning three decades, 
including state, gender, year of birth, name, and the number of babies given each name.

Recommended Analysis:
 - What were the most popular baby names of each decade? How does this change over time?
 - Which baby names had the biggest jumps and drops in popularity?
 - Are there differences in which names are given to boys vs girls vs both over time?
 - Are there differences in baby name popularity based on the region in the United States?

Data Dictionary: 
Table: names
 - State: State (abbreviation) where the babies were born
 - Gender: Gender of the babies at birth
 - Year: Year the babies were born
 - Name: Name given to the babies
 - Births: Number of babies given a name for a specific state & gender & year

Table: regions
 - State: State (abbreviation) in the United States
 - Region: Region of the United States that the state is located in
*/
USE baby_names_db;
SELECT * FROM baby_names_db.names;
SELECT COUNT(*) FROM baby_names_db.names;
SELECT * FROM baby_names_db.regions;
SELECT COUNT(*) FROM baby_names_db.regions;

-- Objective 1 : Track changes in name popularity
/* Your first objective is to see how the most popular names have changed over time, 
and also to identify the names that have jumped the most in terms of popularity.*/
-- Task 1: Find the overall most popular girl and boy names and show how they have changed in popularity rankings over the years --
-- most popular girl names --
SELECT name, sum(births) AS counts
FROM baby_names_db.names
WHERE gender = "F"
GROUP BY name
ORDER BY counts DESC
LIMIT 1; -- ANSWER: Jessica --

-- most popular boy names --
SELECT name, sum(births) AS counts
FROM baby_names_db.names
WHERE gender = "M"
GROUP BY name
ORDER BY counts DESC
LIMIT 1; -- ANSWER: Michael --

-- popularity rankings over the years (girls) --

SELECT * FROM (
	WITH girl_names AS (
		SELECT year, name, SUM(births) AS counts
		FROM baby_names_db.names
		WHERE gender = "F"
		GROUP BY year, name)
		
	SELECT year, name,
		ROW_NUMBER() OVER (PARTITION BY year ORDER BY counts DESC) AS popularity
	FROM girl_names) AS popular_girl_name
WHERE name = "Jessica";

-- popularity rankings over the years (boys) --

SELECT * FROM (
	WITH boy_names AS (
		SELECT year, name, SUM(births) AS counts
		FROM baby_names_db.names
		WHERE gender = "M"
		GROUP BY year, name)
		
	SELECT year, name,
		ROW_NUMBER() OVER (PARTITION BY year ORDER BY counts DESC) AS popularity
	FROM boy_names) AS popular_boy_names
WHERE name = "Michael";

-- Find the names with the biggest jumps in popularity from the first year of the data set to the last year --
WITH names_1980 AS(
	WITH all_names AS (
		SELECT year, name, SUM(births) AS counts
		FROM baby_names_db.names
		GROUP BY year, name)
			
	SELECT year, name,
			ROW_NUMBER() OVER (PARTITION BY year ORDER BY counts DESC) AS popularity	
	FROM all_names
    WHERE year = 1980),
names_2009 AS(
	WITH all_names AS (
		SELECT year, name, SUM(births) AS counts
		FROM baby_names_db.names
		GROUP BY year, name)
			
	SELECT year, name,
			ROW_NUMBER() OVER (PARTITION BY year ORDER BY counts DESC) AS popularity	
	FROM all_names
    WHERE year = 2009)
    
SELECT t1.year, t1.name, t1.popularity, t2.year, t2.name, t2.popularity,
	CAST(t2.popularity AS SIGNED) - CAST(t1.popularity AS SIGNED) AS diff
FROM names_1980 AS t1
	INNER JOIN names_2009 AS t2
		ON t1.name = t2.name
ORDER BY diff ASC;











