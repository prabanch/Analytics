
#Logit simmmoons
tail(dSimons)
attach(dSimons)
summary(dSimons)
head(dSimons)

logit=glm(Purchase~Spending+Card, family = binomial)
logit
summary(logit)
lrtest(logit)

pR2(logit)
rocplot(logit)
confint(logit)
exp(coef(logit))
exp((confint(logit)))

NagelkerkeR2(logit)
prediction=predict(logit, type = "response", newdata = dSimons)
prediction
table(Actual=Purchase, prediction>.2)
gg2=floor(prediction>(1/7))
table(gg2)

