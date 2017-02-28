
getwd()

mydata=read.csv("nm-logit.csv")
mydata
summary(mydata)


attach(mydata)
regression=lm(Loyalty~Brand+Product+Shopping)
summary(regression)

plot(Loyalty~Brand+Product+Shopping, data = mydata)

abline(regression)


regression=lm(Loyalty~Brand)
summary(regression)
anova(regression)

Predict=predict(regression)
test <- data.frame(Loyalty, Brand, Predict)
test
ggplot(data = mydata, aes(x=Brand, y=Loyalty)) + geom_point() + 
  stat_smooth(method="glm", formula = Brand, family = binomial())

logit=glm(Loyalty~Brand+Product+Shopping, family = binomial())

anova(logit)
logit
lrtest(logit)
summary(logit)
confint(logit)
exp(coef(logit))
predict(logit,type = "response")

#curve(predict(logit,type = "response"))

??curve
pred=fitted(logit)

gg1=floor(pred+.5)

table(Actual=Loyalty, prediction=gg1)

pred
library(lmtest)
library(pscl)
library(Deducer)
library(fmsb)

pR2(logit)

rocplot(logit)

