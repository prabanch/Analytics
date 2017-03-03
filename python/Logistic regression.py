# -*- coding: utf-8 -*-
"""
Created on Thu Nov 17 00:01:57 2016

@author: prabanch
"""

import matplotlib.pyplot as plt
import numpy as np
from sklearn import *
import pandas as pd
import csv
import sys
from sklearn.cross_validation import train_test_split

# Load the diabetes dataset
#diabetes = datasets.load_diabetes()

df = pd.read_csv("C:\\Users\\prabanch\\Desktop\\PGBA\\Python\\Cellphone.csv")
#print(df.head())
# Use only one feature
train, test = train_test_split(df, test_size = 0.2)
# Create linear regression object
regr = linear_model.LogisticRegression()


# Train the model using the training sets
regr.fit(train, test)

# The coefficients
print('Coefficients: \n', regr.coef)


"""print("Mean squared error: %.2f"
      % np.mean((regr.predict(diabetes_X_test) - diabetes_y_test) ** 2))
# Explained variance score: 1 is perfect prediction
print('Variance score: %.2f' % regr.score(diabetes_X_test, diabetes_y_test))

# Plot outputs
plt.scatter(diabetes_X_test, diabetes_y_test,  color='black')
plt.plot(diabetes_X_test, regr.predict(diabetes_X_test), color='blue',
         linewidth=3)

plt.xticks(())
plt.yticks(())

plt.show()"""