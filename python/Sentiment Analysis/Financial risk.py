import matplotlib.pyplot as plt
import numpy as np
from sklearn import *
import pandas as pd
import csv
import sys
from sklearn.cross_validation import train_test_split

# Load the diabetes dataset
#diabetes = datasets.load_diabetes()

df = pd.read_csv("training.csv")
print(df.head())
# Use only one feature
x = df[['RevolvingUtilizationOfUnsecuredLines','DebtRatio']]
y=df['SeriousDlqin2yrs']
#train, test = train_test_split(x,y, test_size = 0.2)
# Create linear regression object
regr = linear_model.LogisticRegression()


# Train the model using the training sets
regr.fit(x, y)

# The coefficients
print('Predicted vs Actual\n', regr.predict(x))
