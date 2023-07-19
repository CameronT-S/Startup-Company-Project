-- Company Table
-- Performing Exploratory Data Analysis on the data to explore the data by using statistical analysis.

SELECT * 
FROM startup.company

-- The Founded Column:
-- Looking at the data, the range of 16 goes from the year 2006 to 2022. The average year appears to be 2018 approximately.

SELECT AVG(founded) AS average_founded, 
MIN(founded) AS min_founded, 
MAX(founded) AS max_founded, 
(MAX(founded) - MIN(founded)) AS range_founded
FROM startup.company

-- Number of Startups Founded by Year
-- To compare how many startups were founded by each year to see if there is a trend over time:
-- The number of Startup Companies being founded each year appears to be trending upwards, we can check this further using a time series graph visualisation.. 

SELECT founded, COUNT(founded) AS Companies_Founded, (COUNT(founded) * 100.0) / (SELECT COUNT(*) FROM startup.company) AS Proportions
FROM startup.company
WHERE founded IS NOT NULL
GROUP BY founded

-- Number of Founders Column:
-- The average number of founders appears to be approximately 2 with the minimum value being 1 and max value being 6 with a range of 5.

SELECT AVG(no_founders) AS average_no_founders, 
MIN(no_founders) AS min_no_founders, 
MAX(no_founders) AS max_no_founders, 
(MAX(no_founders) - MIN(no_founders)) AS range_no_founders
FROM startup.company
WHERE no_founders IS NOT NULL AND no_founders != 0

-- Distribution of Total Founders per Company
-- Calculating the distribution of the most common number of founders when founding a company:
-- Looking at the data it appears to be unimodal and we can get a better idea of the distribution of the data using a histogram.

SELECT no_founders, COUNT(no_founders) AS total_founders_per_company
FROM startup.company
GROUP BY no_founders

-- Remote Startups vs Non Remote Startups
-- Looking at the proportions of the companies that are Remote vs Non Remote to get an idea of how many startups are operating Remotely:
-- With remote startups making up 46.3% of startups and 53.7% making up non remote startups, we can say that it is relatively equal in proportion

SELECT remote, count(remote) AS Remote_Total,
    (COUNT(remote) * 100.0) / (SELECT COUNT(*) FROM startup.company) AS Percentage
FROM startup.company
GROUP BY remote

-- Country Column:
-- The total number of countries in the dataset is 55.

SELECT COUNT(DISTINCT country_cleaned) AS total_countries
FROM startup.company

-- Number of Startups by Country
-- Looking at the most common countries in which startups are founded:
-- The USA is the Mode and appears to be the most common country for startups with 682 startups to be founded with India being the second most common with 47 startups.

SELECT country_cleaned, COUNT(*) AS Startups_by_Country
FROM startup.company
WHERE country_cleaned IS NOT NULL
GROUP BY country_cleaned
ORDER BY Startups_by_Country DESC;

-- Countries Less Than 10 Grouped by Other:

SELECT 
  CASE
    WHEN Startups_by_Country < 10 THEN 'Other'
    ELSE country_cleaned
  END AS country_category,
  SUM(Startups_by_Country) AS Startups_by_Country
 FROM (
  SELECT country_cleaned, COUNT(*) AS Startups_by_Country
  FROM startup.company
  WHERE country_cleaned IS NOT NULL
  GROUP BY country_cleaned) sub
 GROUP BY country_category
 ORDER BY Startups_by_Country DESC;

--City Column:
-- The total number of cities in the dataset is 178.

SELECT COUNT(DISTINCT city) AS total_cities
FROM startup.company

-- Number of Startups by City
-- Looking at the most common cities in which startups are founded:
-- San Fransisco is the Mode and the city with the most start ups with 323 startups compared with the other cities with New York following with 85 startups.


SELECT city, COUNT(*) AS Startups_by_City
FROM startup.company
WHERE city IS NOT NULL
GROUP BY city 
ORDER BY Startups_by_City DESC;

-- Cities Less Than 10 Grouped by Other:

 SELECT
  CASE
    WHEN Startups_by_City < 10 THEN 'Other'
    ELSE city
  END AS city_category,
  SUM(Startups_by_City) AS Startups_by_City
 FROM (
  SELECT city, COUNT(*) AS Startups_by_City
  FROM startup.company
  WHERE city IS NOT NULL
  GROUP BY city) 
 GROUP BY city_category;

-- Founder Table:
-- This table has 2047 rows of data with 938 roles input and 1109 missing values, this may not be data we can rely on due to the high numbers of missing values.

SELECT COUNT(*)
FROM startup.founder
WHERE role IS NOT NULL

SELECT COUNT(*)
FROM startup.founder
WHERE role IS NULL

-- Most Common Roles for Founders
-- To look at the most common roles that founders have when starting their company:
-- CEO appears to be the most common role being followed by CTO and COO for founders
-- There are also a significant number of founders that have not been assigned a role.
-- The Mode for this data is the Founder.

SELECT role, COUNT(role) AS role_totals
FROM startup.founder
GROUP BY role
ORDER BY COUNT(role) DESC;

-- The Number of Startups per Industry
-- Looking at the data to see what industries are the most popular:
-- SaaS and Fintech companies seem to be the most common startups that have been founded.

SELECT industry, COUNT(industry) AS industry_total
FROM startup.company AS comp
JOIN startup.company_to_tag AS comptag
ON comp.id = comptag.company_id
JOIN startup.tags AS tag
ON tag.id = comptag.tag_id
GROUP BY industry
ORDER BY COUNT(industry) DESC

-- The Startups per Industry by Year
-- Looking at the data to see if there is a trend of industries over time for startups being founded:

SELECT founded, industry, COUNT(industry) AS num_startups
FROM startup.company AS comp
JOIN startup.company_to_tag AS comptag
ON comp.id = comptag.company_id
JOIN startup.tags AS tag
ON tag.id = comptag.tag_id
WHERE founded IS NOT NULL AND industry IS NOT NULL
GROUP BY industry, founded
ORDER BY founded ASC

-- Number of Startups by Industry by Country
-- Looking at the data to see if there is a trend of industries by country:

SELECT country_cleaned, industry, COUNT(industry) AS num_startups
FROM startup.company AS comp
JOIN startup.company_to_tag AS comptag
ON comp.id = comptag.company_id
JOIN startup.tags AS tag
ON tag.id = comptag.tag_id
WHERE country_cleaned IS NOT NULL AND industry IS NOT NULL
GROUP BY industry, country_cleaned
ORDER BY country_cleaned ASC

-- The Top 5 Industries Growth Over Time:
-- Looking at the data to see if there is a trend of industries over time for the top 5 industries:


WITH industry_counts AS (
    SELECT industry, COUNT(*) AS count
    FROM startup.company AS comp
    JOIN startup.company_to_tag AS comptag
    ON comp.id = comptag.company_id
    JOIN startup.tags AS tag
    ON tag.id = comptag.tag_id
    WHERE founded IS NOT NULL AND industry IS NOT NULL
    GROUP BY industry
    ORDER BY count DESC
    LIMIT 5
)

SELECT comp.founded, tag.industry, COUNT(tag.industry) AS num_startups
FROM startup.company AS comp
JOIN startup.company_to_tag AS comptag
ON comp.id = comptag.company_id
JOIN startup.tags AS tag
ON tag.id = comptag.tag_id
JOIN industry_counts
ON tag.industry = industry_counts.industry
WHERE comp.founded IS NOT NULL AND tag.industry IS NOT NULL
GROUP BY tag.industry, comp.founded
ORDER BY comp.founded ASC, num_startups DESC

-- After looking at the data, there are some interesting topics to explore with further statistical analysis and visualisations
-- We can study the trends of startups over time:
-- The number of startups founded over time from the year 2006 to 2022.
-- We can break this down by countries, cities and industries to see if there are any trends in the companies being founded related to these variables.
-- We can also look at the proportion of remote companies and the distribution of number of founders per company founded.