import pandas as pd
from scipy.stats import mode
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
#plots
import plotly.plotly as py
import plotly.graph_objs as go

# Create random data with numpy
import numpy as np


risk = pd.read_csv('Risk_15_03_17.csv', encoding='cp1252')

print(risk.head())
#print(risk["Risk Score"])

print(risk.columns)
'''Applicable At', 'Project Category', 'Horizontal Name', 'Vertical Name',
       'Sub-Vertical Name', 'Business Unit Name', 'SBU1 Name', 'SBU2 Name',
       'Practice Name', 'Project ID', 'Project Name', 'DE Scope',
       'Solution Type', 'Parent Account Name', 'Methodology', 'Domain',
       'Sub domain', 'Technology', 'Rhythm', 'ProjectManagerID',
       'ProjectManagerName', 'Account Name', 'Account ID', 'Opportunity Name',
       'Opportunity ID', 'Region Name', 'Region ID', 'Risk ID', 'Risk Name',
       'Risk Description', 'Impact Area', 'Risk Owner', 'Risk Score',
       'Risk Dimension', 'Risk Sub-Dimension', 'Risk Type', 'Risk Source',
       'Risk Stage', 'Workpackage', 'Sprint', 'C2-Subproject',
       'Target Closure Date', 'Initial Target Closure Date',
       'Promote Risk to Organization Dashboard', 'Risk Occurred',
       'Service Model', 'Risk Inherited', 'Risk Status', 'Risk Raised on',
       'Risk Logged by', 'Mitigation Target Closure Date', 'Mitigation Status',
       'Mitigation Plan Description', 'Contingency Target Closure Date',
       'Contingency Status', 'Contingency Plan Description',
       'Cost Benefit Analysis Decision', 'Cost Benefit Analysis Description',
       'Risk Cost', 'Mitigation Cost', 'Mitigation/Risk Cost Currency',
       'Problem Reported by Client', 'Escalation ID', 'Severity of Problem',
       'Problem Description', 'DateClosed', 'LastModifiedDate',
       'Risk Created By LoginID', 'Risk Age Based On Current Date'''

group_risk = risk.groupby('Risk Score')
#print(group_risk.first())

print(risk['Risk Score'].value_counts())
risk['Risk Score'].hist(bins=50)
risk.boxplot(column='Risk Score')


'''
import numpy as np
import matplotlib.pyplot as plt

plt.plot([1,2,3,4], [1,4,9,16], 'ro')
plt.axis([0, 6, 0, 20])
plt.show()
'''