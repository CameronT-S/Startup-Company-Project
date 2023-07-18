#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import csv


# In[2]:


company = pd.read_csv('company.csv')
company_social_to_social = pd.read_csv('company_social_to_social.csv')
company_to_tag = pd.read_csv('company_to_tag.csv')
founder = pd.read_csv('founder.csv')
founder_social_to_social = pd.read_csv('founder_social_to_social.csv')
socials = pd.read_csv('socials.csv')
tags = pd.read_csv('tags.csv')
pd.set_option('display.max_rows', None)


# # Data Cleaning and Wrangling
# 
# When looking at the data for the 7 datasets using .describe(), .info(), .head(), we can see that most of the datasets are in a usable format.
# We have 3 datasets that we need to clean:
# 
# - company.csv
# - founder.csv
# - tags.csv
# 
# Data cleaning will be performed using Python Pandas, we will perform the following:
# 
# - Dealing with missing values
# - Checking for the correct data types 
# - Replacing incorrect values in columns
# - Looking for duplicates in columns
# - Renaming certain columns 
# 
# Once the data has been cleaned, we will performing the following:
# 
# - Exploratory Analysis with SQL
# - Further Analysis in Python
# - Data Visualisation with Tableau
# 
# # Cleaning Company Table
# 
# When looking at the company table we needed to do the following:
# 
# - First looking at the company table for any missing values or incorrect data types. Reviewing each column to see unique values and checking duplicate rows to see if any rows need to dropped.
# - The duplicates do not seem to be the same companies and so we do not need to remove any duplicate values.
# - The missing data doesnt seem to be substantial and so we can just drop the rows when querying and the data types are correct for the analysis we need to do.

# In[3]:


duplicates1 = company[company.duplicated(subset='company_name', keep=False)]
print(duplicates1)


# In[4]:


company.info()


# In[5]:


company.describe()


# In[6]:


company


# - With the column 'founded' we see that some values for the year were input as -1 and this is not correct data, we converted the -1 values to NaN to not interfere with the analysis in the future.

# In[7]:


company['founded'] = company['founded'].replace(-1, np.nan)


# In[8]:


company['founded'] = company['founded'].astype('Int64')


# The column 'country' we have two useful peices of information. Whether a company was remote or not and which country the startup is located. 
# - We can create a new column with boolean values based on whether country column contains 'Remote' or not.

# In[9]:


company['Remote'] = company['country'].str.contains('Remote').replace({True: 'Yes', False: 'No'})


# - We can strip the country column and create a new column so any column that contains Remote or a variation can be removed in the new column and replace 'na' values with NaN.

# In[10]:


company['country_cleaned'] = company['country'].replace({'; Remote': '', 'Remote;': ''}, regex=True).str.strip()


# In[11]:


company['country_cleaned'] = company['country_cleaned'].replace('na', np.nan)


# In[12]:


company['country_cleaned'] = company['country_cleaned'].replace('Remote', np.nan)


# - For the location data we can create a new column that contains just the city value and not the country values as we already have a column that contains this information.

# In[13]:


company['city'] = company['location'].str.split(',', expand=True)[0]


# In[14]:


company['city'] = company['city'].replace('NY', np.nan)


# In[15]:


company['city'] = company['city'].replace('CA', np.nan)


# - For the team_size column, replace the -1 and 0 data for NaN values as this is an incorrect value for the team size column.

# In[16]:


company['team_size'] = company['team_size'].replace(0, np.nan).astype('Int64')


# In[17]:


company['team_size'] = company['team_size'].replace(-1, np.nan).astype('Int64')


# - Dropping the not so relevant columns 'description', 'link' and 'short_description' as these were not helpful for the purposes of our analysis. And dropping the columns 'location' and 'country' as we have created new columns for the new cleaned data.

# In[18]:


company.drop(['country', 'location', 'link', 'short_description', 'description'], axis=1, inplace=True)


# In[19]:


company.to_csv('cleaned_company.csv', index = False)


# # Cleaning Founder Table
# 
# When looking at the company table we needed to do the following:
# 
# - First looking at the founder table for any missing values or incorrect data types. Reviewing each column to see unique values and checking duplicate rows to see if any rows need to dropped.
# - The duplicates in the data are different people with the same name so there is no need to drop any rows in the data.
# - The missing data does seem to be substantial for the roles of founders with over 50% of this data missing, we will clean this data, however when using this data to summarise roles it may not be substantial enough to be reliable.

# In[20]:


duplicates2 = founder[founder.duplicated(subset='name', keep=False)]
print(duplicates2)


# In[21]:


founder.describe()


# In[22]:


founder.info()


# In[23]:


founder


# - For the 'name' column, we need to remove the role from the values as we already have a column for the role in the table. We also want to set the name to title format

# In[24]:


founder['name_cleaned'] = founder['name'].str.split(',', expand=True)[0]


# In[25]:


founder.drop(['name'], axis=1, inplace=True)


# In[26]:


founder.name_cleaned = founder.name_cleaned.str.title()


# - We need to categorize the roles of the founders to be able to get summarize the data, we can do this by having 8 most common roles and also an option of other for the less common roles.

# In[27]:


founder.role.value_counts()


# In[28]:


founder['role'] = founder['role'].astype(str)

standard_roles = ['CEO', 'COO', 'CTO', 'CPO', 'CFO', 'Founder', 'CMO', 'President', 'Director']

def assign_role(role):
    if role.lower() == 'nan':  
        return np.nan
    for standard_role in standard_roles:
        if standard_role in role:
            return standard_role
    return 'Other'

founder['role'] = founder['role'].apply(assign_role)


# In[29]:


founder.to_csv('cleaned_founder.csv', index = False)


# # Cleaning Tag Table
# 
# When looking at the company table we needed to do the following:
# 
# - First looking at the founder table for any missing values or incorrect data types. Reviewing each column to see unique values and checking duplicate rows to see if any rows need to dropped.
# - After reviewing this data it does not have any incorrect data types, missing values or duplicate values and so we can move on to transforming the dataset to make it easier to interpret.

# In[30]:


tags.describe()


# In[31]:


tags.info()


# - In this table we can see that most of the tags are related to industry, however there is also S and W values which related to the Summer and Winter batches that went through Y - Combinator respectively, These batches have a year assigned to them and we would like to seperate out industry and y-combinator batch to analyse the data effectively.
# - We also see that there are some option that state whether the company is active, B2B, public or non-profit, this is something else that we can also create a column for.

# In[32]:


tags['batch'] = tags['tag'][tags['tag'].str.contains('^[WS]\d{2}$', na=False)]


# In[33]:


tags['nonprofit'] = tags['tag'].str.contains('Nonprofit').map({True: 'Yes', False: 'No'})


# In[34]:


tags['b2b'] = tags['tag'].str.contains('B2B').map({True: 'Yes', False: 'No'})


# In[35]:


tags['public'] = tags['tag'].str.contains('Public').map({True: 'Yes', False: 'No'})


# In[36]:


tags['active'] = tags['tag'].str.contains('Active').map({True: 'Yes', False: 'No'})


# In[37]:


tags['acquired'] = tags['tag'].str.contains('Acquired').map({True: 'Yes', False: 'No'})


# In[38]:


mask = ~(tags['tag'].str.contains('^[WS]\d{2}$', na=False) |
         tags['tag'].str.contains('Nonprofit') |
         tags['tag'].str.contains('B2B') |
         tags['tag'].str.contains('Public')|
         tags['tag'].str.contains('Active') |
         tags['tag'].str.contains('Acquired'))

tags['industry'] = tags['tag'][mask]


# In[39]:


tags.to_csv('cleaned_tags.csv', index = False)

