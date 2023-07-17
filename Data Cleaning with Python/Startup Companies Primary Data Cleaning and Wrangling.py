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


# # Data Cleaning and Wrangling
# 
# When looking at the data for the 7 datasets, we can see that most of the datasets are relatively usable. We do however need to clean the data for both the founder.csv and the company.csv datasets. We also want to add columns for the tags.csv data to make it more usable for anlysis.
# 
# We will start the project by cleaning the data in Python Pandas and begin to perform analysis on this data with SQL, visualisations with Tableau and further statistical analysis with Python.
# 
# # Cleaning Company Table
# 
# When looking at the company table we needed to remove the not so relevant columns such as 'description', 'link' and 'short_description' as these were not helpful for the purposes of our analysis. 
# 
# With the column 'country' we had two useful peices of information. Whether a company was remote or not and which country the startup is located. 
# 
# We can create a column for whether a company is remote or not and also clean the country data to just display which country the startup is located in without the remote information. 
# 
# For the city data we can remove the country data as we already have a column that contains this information.
# 
# With the column 'founded' we see that some values for the year were input as -1 and this is not correct data, we converted the -1 values to NaN to not interfere with the analysis in the future.
# 
# For the team_size column, we want to remove the -1 and 0 data as this doesnt seem to be a realistic number for a team to be and so we will set these as NaN.

# In[3]:


company.info()


# In[4]:


company.describe()


# In[5]:


company.drop(['link', 'short_description', 'description'], axis=1, inplace=True)


# In[6]:


company['founded'] = company['founded'].replace(-1, np.nan)


# In[7]:


company.founded.unique()


# In[8]:


company['Remote'] = company['country'].str.contains('Remote').replace({True: 'Yes', False: 'No'})


# In[9]:


company['country_cleaned'] = company['country'].replace({'; Remote': '', 'Remote;': ''}, regex=True).str.strip()


# In[10]:


company['country_cleaned'] = company['country_cleaned'].replace('na', np.nan)


# In[11]:


company['country_cleaned'] = company['country_cleaned'].replace('Remote', np.nan)


# In[12]:


company['team_size'] = company['team_size'].replace(-1, np.nan).astype('Int64')


# In[13]:


company['team_size'] = company['team_size'].replace(0, np.nan).astype('Int64')


# In[14]:


company['city'] = company['location'].str.split(',', expand=True)[0]


# In[15]:


company.drop(['country', 'location'], axis=1, inplace=True)


# In[16]:


company['city'] = company['city'].replace('NY', np.nan)


# In[17]:


company['city'] = company['city'].replace('CA', np.nan)


# In[18]:


company['founded'] = company['founded'].astype('Int64')


# In[19]:


company.to_csv('cleaned_company.csv', index = False)


# In[20]:


company.team_size.unique()


# # Cleaning Founder Table
# 
# For the Founder table we just need to clean two columns which is the 'name' column, we need to remove the role from the column as we already have a column for the role in the table. Then we need to categorize the roles of the founders to be able to get summarize the data, we can do this by having a standard set of roles and also an option of other for the less common roles.

# In[21]:


founder.describe()


# In[22]:


founder.info()


# In[23]:


founder['name_cleaned'] = founder['name'].str.split(',', expand=True)[0]


# In[24]:


founder.drop(['name'], axis=1, inplace=True)


# In[25]:


founder['role'] = founder['role'].astype(str)

standard_roles = ['CEO', 'COO', 'CTO', 'CMO', 'CFO', 'CCO', 'CIO', 'President', 'Chief']

def assign_role(role):
    if role.lower() == 'nan':  # add this line
        return np.nan
    for standard_role in standard_roles:
        if standard_role in role:
            return standard_role
    return 'Other'

founder['role'] = founder['role'].apply(assign_role)


# In[26]:


founder.name_cleaned = founder.name_cleaned.str.title()


# In[27]:


founder.to_csv('cleaned_founder.csv', index = False)


# # Cleaning Tag Table
# 
# In this table we can see that most of the tags are related to industry, however there is also S and W values which related to the Summer and Winter batches that went through Y - Combinator respectively, These batches have a year assigned to them and we would like to seperate out industry and y-combinator batch to analyse the data effectively.
# We also see that there are some option that state whether the company is active, B2B, public or non-profit, this is something else that we can also create a column for.

# In[28]:


tags.describe()


# In[29]:


tags.info()


# In[30]:


tags['batch'] = tags['tag'][tags['tag'].str.contains('^[WS]\d{2}$', na=False)]


# In[31]:


tags['nonprofit'] = tags['tag'].str.contains('Nonprofit').map({True: 'Yes', False: 'No'})


# In[32]:


tags['b2b'] = tags['tag'].str.contains('B2B').map({True: 'Yes', False: 'No'})


# In[33]:


tags['public'] = tags['tag'].str.contains('Public').map({True: 'Yes', False: 'No'})


# In[34]:


tags['active'] = tags['tag'].str.contains('Active').map({True: 'Yes', False: 'No'})


# In[35]:


tags['acquired'] = tags['tag'].str.contains('Acquired').map({True: 'Yes', False: 'No'})


# In[36]:


mask = ~(tags['tag'].str.contains('^[WS]\d{2}$', na=False) |
         tags['tag'].str.contains('Nonprofit') |
         tags['tag'].str.contains('B2B') |
         tags['tag'].str.contains('Public')|
         tags['tag'].str.contains('Active') |
         tags['tag'].str.contains('Acquired'))

tags['industry'] = tags['tag'][mask]


# In[37]:


tags.to_csv('cleaned_tags.csv', index = False)

