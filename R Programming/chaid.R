

#HR DATA
nrom(HOLDOUT_SAMPLE)
summary(HOLDOUT_SAMPLE)
attach(ctdf)

sum(Target)

View(ctdf)

structure(ctdf)
str(ctdf)

ctdf$Holding_Period  <- as.factor(ctdf$Holding_Period)

tbl <- table(Holding_Period, Target)

tbl 


install.packages("partykit")
install.packages('CHAID', repos = 'http://r-forge.r-project.org/')



chisq.test(tbl)
ctdf$Target = as.factor(ctdf$Target)
library(CHAID)
ctrl <- chaid_control(minbucket = 100, minsplit = 100, alpha2=.05, alpha4 = .05)
chaid.tree <-chaid(Target~Holding_Period+Occupation+Gender+AGE_BKT,data=ctdf, control = ctrl)
print(chaid.tree)
plot(chaid.tree)



## install.packages("rpart")
install.packages("rpart.plot")

library(rpart)
library(rpart.plot)
library(RColorBrewer)
library(rattle)
r.ctrl = rpart.control(minsplit=100, minbucket = 10, cp = 0, xval = 10)
m1 <- rpart(formula = Target ~ ., data = CTDF.dev[,-1], method = "class", control = r.ctrl)
m1

plot(m1)
prp(m1)
fancyRpartPlot(m1)
