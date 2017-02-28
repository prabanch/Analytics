#read the files
require(xlsx)
library(caret)


loan <- read.xlsx("C:/Users/prabanch/Desktop/PGBA/FR/off campus assignment/training.xlsx", sheetName = 'training')
View(loan)
summary(loan)
is.na(loan)
nrow(loan)
str(loan)
loan$NumberOfDependents = as.numeric(loan$NumberOfDependents)
library(caTools)
#set seed
set.seed(100)

length(which(is.na(loan$NumberOfDependents)))
table(loan$NumberOfDependents)

loan[is.na(loan)] = 0


plot(loan$DebtRatio, loan$NumberOfDependents)

View(loan)
#check ratio
table(loan$SeriousDlqin2yrs)
#Find correlation
loan$NumberOfDependents = as.numeric(loan$NumberOfDependents)
cor(loan) 
#From the result it can be implied that the data is not correlated

#ggplot
library(ggplot2)
ggplot(loan, aes(SeriousDlqin2yrs, DebtRatio)) + geom_boxplot()
head(loan[,-1])
#Apply Logistic regressn
Model1 <- glm(SeriousDlqin2yrs~ .  , data = loan[,-1], family = binomial())
library(lmtest)
#Step 1: Log Likelihood Ratio Test - (Validity of the model)
summary(Model1)

prediction = predict(Model1, type="response")
summary(prediction)

ctrl <- trainControl(method = "repeatedcv", number = 10, savePredictions = TRUE)
glmModel <- train(SeriousDlqin2yrs~ .  , data = loan[,-1], method="glm", family="binomial",trControl = ctrl)

?predict
pred = predict(glmModel)
str(pred)
confusionMatrix(data=pred, loan$SeriousDlqin2yrs)

# estimate variable importance
glmVarImp <- varImp(glmModel, scale=TRUE)
# summarize importance
print(glmVarImp)
# plot importance
plot(glmVarImp)


# Compute AUC for predicting Class with the variable CreditHistory.Critical
pred = as.numeric(pred)
plot(roc(loan$SeriousDlqin2yrs, pred, direction="<"),col="red", lwd=3, main="ROC CUrve", print.auc=TRUE)

library(DMwR)
loan$SeriousDlqin2yrs = as.factor(loan$SeriousDlqin2yrs)
loanSmote = SMOTE(SeriousDlqin2yrs~.,loan[,-1],  perc.over = 1000, perc.under = 100)
table(loanSmote$SeriousDlqin2yrs)
table(loanSmote$SeriousDlqin2yrs)/nrow(loanSmote)




#Apply Logistic regressn
ctrl <- trainControl(method = "repeatedcv", number = 10,  savePredictions = TRUE)
glmModelSmoted <- train(SeriousDlqin2yrs~ .  , data = loanSmote, method="glm", family="binomial",trControl = ctrl)


library(lmtest)
#Step 1: Log Likelihood Ratio Test - (Validity of the model)

summary(glmModelSmoted)
pred_smote = predict(glmModelSmoted)
summary(pred_smote)


confusionMatrix(pred_smote,loanSmote$SeriousDlqin2yrs)

# estimate variable importance
glmSmoteVarImp <- varImp(glmModelSmoted, scale=FALSE)
# summarize importance
print(glmSmoteVarImp)
# plot importance
plot(glmSmoteVarImp)

library(pROC)
# Compute AUC for predicting Class with the variable CreditHistory.Critical
pred_smote = as.numeric(pred_smote)
plot(roc(loanSmote$SeriousDlqin2yrs, pred_smote, direction="<"),col="red", lwd=3, main="ROC CUrve", print.auc=TRUE)

prediction = predict(glmModelSmoted, data=loanSmote, type="response")


confusionMatrix(pred_smote,loanSmote$SeriousDlqin2yrs)

#normalized mean squared error (NMSE).

loanSmote$SeriousDlqin2yrs = as.numeric(loanSmote$SeriousDlqin2yrs)
(mae.a1.lm <- mean(abs(prediction - loanSmote$SeriousDlqin2yrs)))
length(prediction)
nrow(loanSmote)

(nmse.a1.glm <- mean((prediction - loanSmote$SeriousDlqin2yrs)^2)/
   mean((mean(loanSmote$SeriousDlqin2yrs)-loanSmote$SeriousDlqin2yrs)^2))

library(pscl)
pR2(glmModelSmoted)
library("Deducer")
rocplot(glmModelSmoted)

par(mfrow = c(1, 2))
plot(loan$NumberOfDependents, loan$DebtRatio, pch = 19 + as.integer(loan$DebtRatio), main = "Original Data")
plot(loanSmote$NumberOfDependents, loanSmote$DebtRatio, pch = 19 + as.integer(loanSmote$DebtRatio), main = "SMOTE'd Data")

# confusion matrix (training data)
#conf.matrix <- table(loanSmote$SeriousDlqin2yrs, PredictBinary)

#rownames(conf.matrix) <- paste("Actual", rownames(conf.matrix), sep = ":")
#colnames(conf.matrix) <- paste("Pred", colnames(conf.matrix), sep = ":")
#conf.matrix1 = conf.matrix
#print(conf.matrix1)


## loading the library
library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)
## setting the control paramter inputs for rpart
r.ctrl = rpart.control(minsplit=100, minbucket = 100 , cp = 0, xval = 10)

## calling the rpart function to build the tree
##m1 <- rpart(formula = Target ~ ., data = CTDF.dev[which(CTDF.dev$Holding_Period>10),-1], method = "class", control = r.ctrl)

cartModel <- rpart(formula = SeriousDlqin2yrs ~ ., data = loanSmote, method = "class", control = r.ctrl)

plot(cartModel)
summary(cartModel)

fancyRpartPlot(cartModel)
cartModel
prediction = predict(cartModel, type = 'class')
head(prediction)
summary(prediction)
str(prediction)
confusionMatrix(prediction,loanSmote$SeriousDlqin2yrs)


bestcp <- m1$cptable[which.min(m1$cptable[,"xerror"]),"CP"]
# Step3: Prune the tree using the best cp.
cartModel.pruned <- prune(cartModel, cp = bestcp)

plot(cartModel.pruned)
summary(cartModel.pruned)

fancyRpartPlot(cartModel.pruned)
cartModel.pruned
prunedPrediction = predict(cartModel.pruned, type = 'class')
head(prunedPrediction)
summary(prunedPrediction)
confusionMatrix(prunedPrediction,loanSmote$SeriousDlqin2yrs)

#loanSmote$SeriousDlqin2yrs = as.numeric(loanSmote$SeriousDlqin2yrs)
#(mae.a1.tree<- mean(abs(prediction - loanSmote$SeriousDlqin2yrs)))
#length(prediction)
#nrow(loanSmote)

#(nmse.a1.tree <- mean((prediction - loanSmote$SeriousDlqin2yrs)^2)/
#   mean((mean(loanSmote$SeriousDlqin2yrs)-loanSmote$SeriousDlqin2yrs)^2))

library(randomForest)

# Fitting model
#fit <- randomForest(Smoted_Loan$SeriousDlqin2yrs ~ ., Smoted_Loan,ntree=500)
#summary(fit)
#Predict Output 
#prediction= predict(fit,Smoted_Loan)
#PredictBinary = prediction > .5
#summary(prediction)


table(loanSmote$SeriousDlqin2yrs,PredictBinary)

#KNN Neighbour

ctrl <- trainControl(method="repeatedcv",repeats = 10) #,classProbs=TRUE)
knnFit <- train(Smoted_Loan$SeriousDlqin2yrs ~ ., data = Smoted_Loan, method = "knn", trControl = ctrl, preProcess = c("center","scale"), tuneLength = 20)

#Output of kNN fit
knnFit
#Plotting yields Number of Neighbours Vs accuracy (based on repeated cross validation)
plot(knnFit)
knnPredict <- predict(knnFit )
#Get the confusion matrix to see accuracy value and other parameter values
confusionMatrix(knnPredict, Smoted_Loan$SeriousDlqin2yrs )
summary(knnPredict)
str(knnPredict)
# Compute AUC for predicting Class with the variable CreditHistory.Critical
knnPredict = as.numeric(knnPredict)
plot(roc(loanSmote$SeriousDlqin2yrs, knnPredict, direction="<"),col="red", lwd=3, main="ROC CUrve", print.auc=TRUE)
