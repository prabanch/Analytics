
#loan
#loan_default .csv



library(caTools)
set.seed(100)

#check ratio
View(loan)

split = sample.split(loan$bad_flag, SplitRatio =0.75)
split

#split 
train = subset(loan, split == TRUE)
View(train)
str(train)

test = subset(loan, split == FALSE)
View(test)
str(test)


table(loan$bad_flag)

table(train$bad_flag)
table(test$bad_flag)

Model1 <- glm(bad_flag~ tenure+margin+amtfin+exist  , data = train, family = binomial())
library(lmtest)
#Step 1: Log Likelihood Ratio Test - (Validity of the model)
summary(Model1)
test$pred = predict(Model1, newdata= test, type="response")

summary(test$pred)

#navie threshld of .5
PredictBinary = test$pred > .5
summary(test$pred)

table(test$bad_flag,PredictBinary)

library(pscl)
pR2(Model1)
library("Deducer")
rocplot(Model1)


#Smotingg 

library(DMwR)
train$bad_flag = as.factor(train$bad_flag)
trainSMOTE = SMOTE(bad_flag~., as.data.frame(train),  perc.over =  500)
train$bad_flag = as.numeric(train$bad_flag)

table(train$bad_flag)
table(trainSMOTE$bad_flag)


SmoteModel <- glm(bad_flag~ tenure+margin+amtfin+exist  , data = trainSMOTE, family = binomial())

library(lmtest)
#Step 1: Log Likelihood Ratio Test - (Validity of the model)
summary(SmoteModel)


Smotepred = predict(SmoteModel, newdata= test, type="response")

summary(Smotepred)

#navie threshld of .5
PredictBinary = Smotepred > .5
summary(Smotepred)


table(test$bad_flag,PredictBinary)

library(pscl)
pR2(SmoteModel)
library("Deducer")
rocplot(SmoteModel)

library(ggplot2)
ggplot(test, aes(x = test$tenure , y = test$pred)) + geom_smooth()

## loading the library
library(rpart)
library(rpart.plot)
## setting the control paramter inputs for rpart
r.ctrl = rpart.control(minsplit=1000, minbucket = 1000
                       , cp = 0, xval = 10)

?rpart.control
## calling the rpart function to build the tree
##m1 <- rpart(formula = Target ~ ., data = CTDF.dev[which(CTDF.dev$Holding_Period>10),-1], method = "class", control = r.ctrl)

m1 <- rpart(formula = bad_flag ~ tenure+margin+amtfin+exist, 
                      data = loan, method = "class", 
                      control = rpart.control(minbucket = 1000))
m1
plot(m1)
library(rattle)
library(RColorBrewer)
fancyRpartPlot(m1)

