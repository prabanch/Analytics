# mytrainData = Paulbrooks.csv,
# myTestData - Paulbrooks2.CSV


myTestData
names(myTrainData)
names(myTestData)
attach(myTrainData)
attach(myTestData)
logit=glm(Purchase~Months+NoBought, family = binomial)
logit
lrtest(logit)

pR2(logit)
rocplot(logit)
confint(logit)
exp(coef(logit))
exp((confint(logit)))

NagelkerkeR2(logit)
prediction=predict(logit, type = "response", newdata = myTestData)
table(Actual=Purchase, prediction=floor(prediction+.5))
gg2=floor(prediction>(1/7))
table(gg2)


