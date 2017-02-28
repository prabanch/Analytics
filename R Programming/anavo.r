
detach(SalesSalary)
attach(SalesSalary) 
summary(SalesSalary)

model1=lm(Salary~Experience)
summary(model1)
aov(model1)

scatter=plot(Salary,Position, col="red",  abline(lm(Salary~Position), col="blue"))

model2=lm(Salary~Position+Experience)
summary(model2)
aov(model2)
scatter=plot(Salary,Position,Experience, col="red",  abline(lm(Salary~Position+Experience), col="blue")))


model4=lm(Salary~Position+Experience+Position*Experience)
anova(model4)
summary(model4)

plot(Position, Salary)
abline(model4)

scatter=plot(Salary,Position,Experience, col="red",  abline(model4), col="blue")

colors =c(rep("Green",1), rep("Red",1), rep("Orange",1))
interaction.plot(Position,  Experience, Salary, col=colors)

inter



library(lmtest)
library(pscl)
library(deducer)
library(fmsb)

attach(Udacity)

u1_m = lm(Snapzi~Irisa~LolaMoon)
summary(u1_m)


