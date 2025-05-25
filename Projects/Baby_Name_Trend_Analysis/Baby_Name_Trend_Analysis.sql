
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
use baby_names_db;
select * from baby_names_db.names;
select count(*) from baby_names_db.names;
select * from baby_names_db.regions;
select count(*) from baby_names_db.regions;

















