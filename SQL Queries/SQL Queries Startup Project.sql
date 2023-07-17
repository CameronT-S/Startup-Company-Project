-- Company Table
-- Performing Exploratory Data Analysis on the data to explore the data by using univariate analysis and bivariate analysis.

SELECT * 
FROM startup.company


-- Remote Startups vs Non Remote Startups
-- Looking at the proportions of the companies that are Remote vs Non Remote to get an idea of how many startups are operating Remotely:
-- With remote startups making up 46.3% of startups and 53.7% making up non remote startups, we can say that it is relatively equal in proportion

SELECT remote, count(remote) AS Remote_Total,
    (COUNT(remote) * 100.0) / (SELECT COUNT(*) FROM startup.company) AS Percentage
FROM startup.company
GROUP BY remote

-- Number of Startups Founded by Year
-- To compare how many startups were founded by each year to see if there is a trend over time:
-- The number of Startup Companies being founded each year appears to be trending upwards, indicating that year on year there is an increase in startups being founded. 

SELECT founded, COUNT(founded) AS Companies_Founded, (COUNT(founded) * 100.0) / (SELECT COUNT(*) FROM startup.company) AS Proportions
FROM startup.company
WHERE founded IS NOT NULL
GROUP BY founded

-- Distribution of Team Size
-- Calculating the distribution of team sizes per startup to see what the most common team size is for the startup companies:
-- Looking at the data it appears to be left skewed and we can get a better idea of the distribution of the data using a histogram.

SELECT team_size, COUNT(team_size) AS team_size_total
FROM startup.company
WHERE team_size IS NOT NULL
GROUP BY team_size
ORDER BY team_size ASC;

-- Distribution of Total Founders per Company
-- Calculating the distribution of the most common number of founders when founding a company:
-- Looking at the data it appears to be unimodal and we can get a better idea of the distribution of the data using a histogram.

SELECT no_founders, COUNT(no_founders) AS total_founders_per_company
FROM startup.company
GROUP BY no_founders

-- Distribution of Company Socials
-- Calculating the most common number of social media account each company has on average and the distribution of social media accounts each company has:
-- The average for number of social media accounts for a company is 2.4.

SELECT AVG(no_company_socials) AS average_social_total
FROM startup.company

SELECT no_company_socials, COUNT(no_company_socials) AS total_social_per_company
FROM startup.company
GROUP BY no_company_socials

-- Number of Startups by Country
-- Looking at the most common countries in which startups are founded:
-- The USA appears to be the most common country for startups to be founded with India being the second most common.

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
 GROUP BY country_category;

-- Number of Startups by City
-- Looking at the most common cities in which startups are founded:
-- San Fransisco is the city with the most start ups compared with the other cities.

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

SELECT *
FROM startup.founder

-- Most Common Roles for Founders
-- To look at the most common roles that founders have when starting their company, not taking into account less common Other options:
-- CEO appears to be the most common role being followed by CTO and COO.

SELECT role, COUNT(role) AS role_totals
FROM startup.founder
WHERE role != 'Other'
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


