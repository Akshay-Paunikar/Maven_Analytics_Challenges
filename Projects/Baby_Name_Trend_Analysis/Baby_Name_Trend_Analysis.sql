
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
SELECT 
    *
FROM
    baby_names_db.names;
SELECT 
    COUNT(*)
FROM
    baby_names_db.names;
SELECT 
    *
FROM
    baby_names_db.regions;
SELECT 
    COUNT(*)
FROM
    baby_names_db.regions;

-- Objective 1 : Track changes in name popularity
/* Your first objective is to see how the most popular names have changed over time, 
and also to identify the names that have jumped the most in terms of popularity.*/
SELECT 
    name, SUM(births) AS counts
FROM
    baby_names_db.names
WHERE
    gender = 'F'
GROUP BY name
ORDER BY counts DESC
LIMIT 1;-- ANSWER: Jessica --

SELECT 
    name, SUM(births) AS counts
FROM
    baby_names_db.names
WHERE
    gender = 'M'
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

-- Objective 2: Compare popularity across decades --
-- Your second objective is to find the top 3 girl names and top 3 boy names for each year, and also for each decade --
-- Task 1: For each year, return the 3 most popular girl names and 3 most popular boy names --
SELECT * FROM
(WITH babies_by_year AS (SELECT year, gender, name, SUM(births) AS counts
FROM baby_names_db.names
GROUP BY year, gender, name)

SELECT year, gender, name, counts,
	ROW_NUMBER() OVER (PARTITION BY year, gender ORDER BY counts DESC) AS popularity
FROM babies_by_year) AS top_three
WHERE popularity < 4;

-- Task 2: For each decade, return the 3 most popular girl names and 3 most popular boy names --

SELECT * FROM
(WITH babies_by_decade AS (SELECT (CASE WHEN year BETWEEN 1980 AND 1989 THEN "80s"
										WHEN year BETWEEN 1990 AND 1999 THEN "90s"
                                        WHEN year BETWEEN 2000 AND 2009 THEN "2000s"
                                        ELSE "None" END) AS decade,
gender, name, SUM(births) AS counts
FROM baby_names_db.names
GROUP BY decade, gender, name)

SELECT decade, gender, name, counts,
	ROW_NUMBER() OVER (PARTITION BY decade, gender ORDER BY counts DESC) AS popularity
FROM babies_by_decade) AS top_three
WHERE popularity < 4;

-- Objective 3: Compare popularity across regions --
-- Your third objective is to find the number of babies born in each region, and also return the top 3 girl names and top 3 boy names within each region. --
-- Task 1: Return the number of babies born in each of the six regions (NOTE: The state of MI should be in the Midwest region)--

SELECT 
    *
FROM
    baby_names_db.regions;
SELECT DISTINCT
    (Region)
FROM
    baby_names_db.regions;

WITH clean_regions AS (SELECT state,
	CASE WHEN region = "New England" THEN "New_England" ELSE region END AS clean_region
FROM baby_names_db.regions
UNION
SELECT "MI" AS state, "Midwest" AS region)
SELECT clean_region, SUM(births) AS counts 
FROM names AS N 
	LEFT JOIN clean_regions CR
    ON N.state = CR.state
GROUP BY clean_region;

-- Task 2: Return the 3 most popular girl names and 3 most popular boy names within each region --

SELECT * FROM
(WITH babies_by_regions AS (
	WITH clean_regions AS (SELECT state,
		CASE WHEN region = "New England" THEN "New_England" ELSE region END AS clean_region
	FROM baby_names_db.regions
	UNION
	SELECT "MI" AS state, "Midwest" AS region)
	SELECT CR.clean_region, N.gender, N.name, SUM(N.births) AS counts 
	FROM names AS N 
		LEFT JOIN clean_regions CR
		ON N.state = CR.state
	GROUP BY CR.clean_region, N.gender, N.name)
SELECT clean_region, gender, name, 
	ROW_NUMBER() OVER (PARTITION BY clean_region, gender ORDER BY counts DESC) AS popularity
FROM babies_by_regions) AS region_popularity
WHERE popularity < 4;

-- Objective 4: Explore unique names in the dataset --
-- Your final objective is to find the most popular androgynous names, the shortest and longest names, and the state with the highest percent of babies named "Chris" --
-- Task 1: Find the 10 most popular androgynous names (names given to both females and males) --

SELECT 
    name,
    COUNT(DISTINCT gender) AS num_gender,
    SUM(Births) AS num_babies
FROM
    baby_names_db.names
GROUP BY name
HAVING num_gender = 2
ORDER BY num_babies DESC
LIMIT 10;

/* Task 2: Find the length of the shortest and longest names, and identify the most popular short names (those with the fewest characters) and 
long names (those with the most characters) */

SELECT 
    name, LENGTH(name) AS name_length
FROM
    baby_names_db.names
ORDER BY name_length;-- 2 characters --

SELECT 
    name, LENGTH(name) AS name_length
FROM
    baby_names_db.names
ORDER BY name_length DESC; -- 15 characters --

-- most popular short and long names --
WITH short_long_names AS (
	SELECT * FROM names
	WHERE length(name) IN (2,15))

SELECT 
	name, SUM(births) AS num_babies
FROM short_long_names
GROUP BY name
ORDER BY num_babies DESC;

-- Task 3: The founder of Maven Analytics is named Chris. Find the state with the highest percent of babies named "Chris" --
SELECT 
	state, 
    (num_chris/num_babies) * 100 AS pct_chris
FROM
(WITH chris_count AS (
SELECT 
	State, 
    SUM(Births) AS num_chris
FROM 
	baby_names_db.names
WHERE name = "Chris"
GROUP BY State),
count_all AS (
SELECT 
	State, 
    SUM(Births) AS num_babies
FROM 
	baby_names_db.names
GROUP BY State)

SELECT
	CC.state, CC.num_chris, CA.num_babies
FROM chris_count AS CC
	INNER JOIN count_all AS CA
		ON CC.state = CA.state) AS state_chris_all
ORDER BY pct_chris DESC; -- state LA --

-- lowest percent of babies named "Chris" --
SELECT 
	state, 
    (num_chris/num_babies) * 100 AS pct_chris
FROM
(WITH chris_count AS (
SELECT 
	State, 
    SUM(Births) AS num_chris
FROM 
	baby_names_db.names
WHERE name = "Chris"
GROUP BY State),
count_all AS (
SELECT 
	State, 
    SUM(Births) AS num_babies
FROM 
	baby_names_db.names
GROUP BY State)

SELECT
	CC.state, CC.num_chris, CA.num_babies
FROM chris_count AS CC
	INNER JOIN count_all AS CA
		ON CC.state = CA.state) AS state_chris_all
ORDER BY pct_chris;
