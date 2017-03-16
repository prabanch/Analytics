
import pandas as pd
from scipy.stats import mode
from sklearn.linear_model import LogisticRegression

titanic = pd.read_csv('train.csv')
titanic.head()
titanic.describe()
survived = titanic.columns[1:2]


# change male to 1 and female to 0
titanic["Sex"] = titanic["Sex"].apply(lambda sex: 1 if sex == "male" else 0)
cols = ["Pclass", "Sex", "Age"]


data_train = titanic[cols]

titanic[cols].plot.hist()
data_dependent = titanic[survived]
model = LogisticRegression()
model.fit(data_train, titanic[survived].values.ravel())
print(model)
print(model.score(data_train, titanic[survived].values.ravel()))
titanic[cols].plot.hist()
titanic_test = pd.read_csv('test.csv')
# change male to 1 and female to 0
titanic_test["Sex"] = titanic_test["Sex"].apply(lambda sex: 1 if sex == "male" else 0)
titanic_test = titanic_test.fillna(0)
data_test = titanic_test[cols]
predicted = model.predict(data_test)
print(predicted)
#predicted = model.predict(data_test)

