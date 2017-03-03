
import pandas as pd
from scipy.stats import mode

tweets = pd.read_csv('2016-11-08  #BlackMoney.csv')

print(tweets.shape)
print(tweets.columns.values)

#Create a new function:
def num_missing(x):
  return sum(x.isnull())

#Applying per column:
print("Missing values per column:")
print(tweets.apply(num_missing, axis=0)) #axis=0 defines that function is to be applied on each column

#Applying per row:
print("\nMissing values per row:")
print(tweets.apply(num_missing, axis=1).head()) #axis=1 defines that function is to be applied on each ro

#First we import a function to determine the mode
data = tweets
print(mode(data['id']))
#Determine pivot table

print(data.shape)
print(data.sum)
print(data.min)

data_sorted = data.sort_values(["date"], ascending=False)
print(data_sorted[['date']].head(10))