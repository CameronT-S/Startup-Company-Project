# Startup-Company-Project

Introduction:
- This project will be exploring the data on startup companies in the US and other countries from 2006 until 2022. I want to look into the data to understand the startup market in more depth and to understand what trends are currently ongoing in the startup market and if there are any common traits between startups.
- Data Source: Kaggle (https://www.kaggle.com/datasets/thedevastator/empowering-the-next-wave-of-entrepreneurs?datasetId=2644305&sortBy=dateRun&tab=bookmarked&select=ycombinator.csv)

Visualisation on Tableau:
-
- https://public.tableau.com/views/StartupCompaniesProject/Story1?:language=en-US&:display_count=n&:origin=viz_share_link

On this project we will be performing the following tasks:

- Data Cleaning and Wrangling in Python
- Exploratory Analysis with SQL Google BigQuery
- Data Visualisation with Tableau

Questions to Answer:
- Is there a trend for startups being founded over-time?
- Are there particular countries or cities that have more startups compared with others?
- Is there a trend in industries growth over-time?
- What are the most common industries for startups?

Data Analysis: Is there a trend for startups being founded over-time?
- 
- Using the column founded and calculating the total startups founded by year I created a time-series line graph to view the trend of data.
- Looking at this data there is an upwards trend along the line graph from 2006 to 2022, This indicates that the startup industry is growing.

- Method Used: The data was cleaned in Python. Using SQL to group by the founded column displaying the count of the founded column for each year. And using Tableau to visualise a time-series graph.
  
Conclusion:
- Yes, there is an upwards trend for startups being founded over-time.

Data Analysis: Are there particular countries or cities that have more startups compared with others?
-
- When looking at the countries data compared with the aggregate count of countries in the data set we can see that there is a majority of startups being founded in the USA. Out of 1000 companies, 68.2% of those companies are from the USA followed by India having just 4.7%, this shows that there is a very large market for Startups in the USA compared with other countries.
- When you break it down even further to look at the cities, there is again a city that contains the majority of startups, San Fransisco with 32.3% followed by New York with 8.5%, this is interesting and can lead to further questions as to why this is the case.

- Method Used: The data was cleaned in Python. Using SQL grouping by country and city and getting the count of cities and countries to get the totals. And using Tableau to visualise the countries using a bar graph and cities with a tree map.
  
Conclusion:
- Yes, the city with the most startups being founded is San Fransisco and the country with the most startups being founded is the USA. 

Data Analysis: Is there a trend in industries growth over-time?
-
- Looking at the industries over-time, we can use a time-series line graph to review the trend, the trend as expected follows a similar trend to the growth of the startup industry for most industries.
- The industries that have grown the most over-time since 2006 to 2022 are the Software as a Service industry, the Fintech industry and the Developer Tools industry. They also as of 2022 make up the majority of startups.

- Method Used: The data was cleaned in Python. Using SQL to group by the industry column and founded column displaying the count of the industry column for each year. And using Tableau to visualise a time-series graph.
  
Conclusion:
- Yes, The trend for industries growth is an upwards trend mainly for particular industries that are growing in popularity.

Data Analysis: What are the most common industries for startups?
-
- The data seems to show that the most popular industries that startups are going into are the SaaS with 233 startups, Fintech with 188 startups, Developer Tools with 82 startups and Marketplace with 72.

- Method Used: The data was cleaned in Python. Using SQL to group by industry and getting the count of companies per industry to work out the totals. And using Tableau to visualise a tree map to see the biggest industries.
  
Conclusion:
- The most common industries appear to be SaaS and Fintech followed by Development Tools.

Conclusions:
-
- Is there a trend for startups being founded over-time?
  Yes, there is an upwards trend for startups being founded over-time.
- Are there particular countries or cities that have more startups compared with others?
  Yes, the city with the most startups being founded is San Fransisco and the country with the most startups being founded is the USA.
- Is there a trend in industries growth over-time?
  Yes, The trend for industries growth is an upwards trend mainly for particular industries that are growing in popularity.
- What are the most common industries for startups?
  The most common industries appear to be SaaS and Fintech followed by Development Tools.
