#!/usr/bin/env python
# coding: utf-8

# In[1]:


# First let's import the packages we will use in this project
# You can do this all now or as you need them
import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None

# Now we need to read in the data
df = pd.read_csv(r'/Users/asmaabdallah/Downloads/movies.csv')



# In[2]:


# Now let's take a look at the data

df


# In[8]:


#Let's see if there is any missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[9]:


#Data types for our columns
df.dtypes


# In[14]:


df['budget'].dtype


# In[21]:


pd.set_option('display.max_rows',None)


# In[22]:


df


# In[24]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[28]:


#drop any duplicates
df.drop_duplicates()


# In[ ]:


#Budget high correlation
#Company high correlation



# In[31]:


#Scatter plit with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Gross Earnings')
plt.ylabel('Budget for film')
plt.show()


# In[33]:


#plot the budget vs gross using seaborn
sns.regplot(x='budget', y='gross', data=df)


# In[ ]:




