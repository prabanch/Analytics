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
