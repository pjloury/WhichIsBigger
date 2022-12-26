# importing the pandas library
import pandas as pd
  
# reading the csv file
df = pd.read_csv("ages.csv")
  
# updating the column value/data
df.loc[0, 'name'] = 'PJ Loury'
  
# writing into the file
df.to_csv("ages.csv", index=False)
  
print(df)