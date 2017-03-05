#read the files
require(xlsx)
library(caret)
library(ggplot2)
## loading the library
library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)

library(DMwR)
library(pROC)
library(pscl)
library("Deducer")
library(randomForest)
library(car)
library(caTools)
#set seed
set.seed(100)

loan <- read.xlsx("training.xlsx", sheetName = 'training')
loanTest <- read.xlsx("test.xlsx", sheetName = 'test')
l=loan
loan=l
View(loan)
#Checking the data set
nrow(loan)
str(loan)

#Visualise & Cleaning the outliers
summary(loan)
boxplot(loan)
ggplot(loan, aes(loan$Casenum, loan$DebtRatio)) + geom_point()
ggplot(loan, aes(loan$Casenum, loan$RevolvingUtilizationOfUnsecuredLines)) + geom_point()
ggplot(loan, aes(loan$Casenum, loan$NumberOfOpenCreditLinesAndLoans)) + geom_point()
# Removing or Imputing outliers
#Max value of 168835.00 DebtRatio looks like to be an outlier. 
#Max value of 6324.000 RevolvingUtilizationOfUnsecuredLines looks like to be an outlier. 
x <- loan$DebtRatio
qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
caps <- quantile(x, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(x, na.rm = T)
loan$DebtRatio[loan$DebtRatio > (qnt[2] + H)] = qnt[2] + H


x <- loan$RevolvingUtilizationOfUnsecuredLines
qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
caps <- quantile(x, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(x, na.rm = T)
loan$RevolvingUtilizationOfUnsecuredLines[loan$RevolvingUtilizationOfUnsecuredLines > (qnt[2] + H)] = qnt[2] + H


boxplot(loan[,-1])
boxplot(loan$RevolvingUtilizationOfUnsecuredLines)
summary(loan$SeriousDlqin2yrs)
table(loan$SeriousDlqin2yrs)

#clean na values in Dependents column
table(loan$NumberOfDependents)
#Greater than 50% of the data has 0 values. So in this case it is safe to set the "NA" values to 0
loan$NumberOfDependents[loan$NumberOfDependents=='NA'] <- 0
#Explicitly converting factors to Numberic values conver levels to number. Make sure that trap
loan$NumberOfDependents = as.numeric(levels(loan$NumberOfDependents))[as.integer(loan$NumberOfDependents)]

#Visaulize the data after cleaning
ggplot(loan, aes(loan$Casenum, loan$DebtRatio)) + geom_point()
ggplot(loan, aes(loan$Casenum, loan$RevolvingUtilizationOfUnsecuredLines)) + geom_point()
ggplot(loan, aes(loan$Casenum, loan$NumberOfOpenCreditLinesAndLoans)) + geom_point()

#check ratio
table(loan$SeriousDlqin2yrs)
#Find correlation
cor(loan) 
#From the result it can be implied that the data is not correlated

loan$SeriousDlqin2yrs = as.factor(loan$SeriousDlqin2yrs) 
#1 Fit the glm model using caret package
ctrl <- trainControl(method = "repeatedcv", number = 10, savePredictions = TRUE, repeats = 5)
glmModel <- train(SeriousDlqin2yrs~ .  , data = loan[,-1], method="glm", family="binomial",trControl = ctrl)
summary(glmModel)
#Predict the values
pred = predict(glmModel)
str(pred)
#Confusion Matrix
confusionMatrix(pred, loan$SeriousDlqin2yrs)

# estimate variable importance
glmVarImp <- varImp(glmModel, scale=TRUE)
# summarize importance
print(glmVarImp)
# plot importance
plot(glmVarImp)

# Compute AUC for predicting Class with the variable CreditHistory.Critical
pred = as.numeric(pred)
plot(roc(loan$SeriousDlqin2yrs, pred, direction="<"),col="red", lwd=3, main="ROC CUrve", print.auc=TRUE)

#Synthetic minority over sampling technique from DMWR PACKAGE
loan$SeriousDlqin2yrs = as.factor(loan$SeriousDlqin2yrs) #Convert to factor
#Over sample minority items. 
loanSmote = SMOTE(SeriousDlqin2yrs~.,loan[,-1],  perc.over = 1000, perc.under = 150)
#Check the results
table(loanSmote$SeriousDlqin2yrs)
#Check the no of 1 & 0's
table(loanSmote$SeriousDlqin2yrs)/nrow(loanSmote) * 100

#Visualize the data before and after smoting
ggplot(loan, aes(x=RevolvingUtilizationOfUnsecuredLines, y=DebtRatio, color = SeriousDlqin2yrs)) + geom_point()
ggplot(loanSmote, aes(x=RevolvingUtilizationOfUnsecuredLines, y=DebtRatio, color = SeriousDlqin2yrs)) + geom_point() 

#Apply Logistic regression after OVer sampling
ctrl <- trainControl(method = "repeatedcv", number = 10,  savePredictions = TRUE, repeats = 5)
glmModelSmoted <- train(SeriousDlqin2yrs~ .  , data = loanSmote, method="glm", family="binomial",trControl = ctrl)


summary(glmModelSmoted)
pred_smote = predict(glmModelSmoted)
summary(pred_smote)
#Confusion matrix
confusionMatrix(pred_smote,loanSmote$SeriousDlqin2yrs)

# estimate variable importance
glmSmoteVarImp <- varImp(glmModelSmoted, scale=FALSE)
# summarize importance
print(glmSmoteVarImp)
# plot importance
plot(glmSmoteVarImp)


# Compute AUC for predicting Class with the variable CreditHistory.Critical
pred_smote = as.numeric(pred_smote)
plot(roc(loanSmote$SeriousDlqin2yrs, pred_smote, direction="<"),col="red", lwd=3, main="ROC CUrve", print.auc=TRUE)

#Greater than 50% of the data has 0 values. So in this case it is safe to set the "NA" values to 0
loanTest$NumberOfDependents[loanTest$NumberOfDependents=='NA'] <- 0
#Explicitly converting factors to Numberic values conver levels to number. Make sure that trap
loanTest$NumberOfDependents = as.numeric(levels(loanTest$NumberOfDependents))[as.integer(loanTest$NumberOfDependents)]
table(loanTest$NumberOfDependents)
nrow(loanTest)
pred_glm_test = predict(glmModelSmoted, newdata = loanTest[,-1])
summary(pred_glm_test)
#Confusion matrix
confusionMatrix(pred_glm_test,loanTest$SeriousDlqin2yrs)


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


bestcp <- cartModel$cptable[which.min(cartModel$cptable[,"xerror"]),"CP"]
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

#Predict using the cart model
cartPredTest = predict(cartModel.pruned, newdata = loanTest[,-1], type = 'class')
summary(cartPredTest)
#Confusion matrix
confusionMatrix(cartPredTest,loanTest$SeriousDlqin2yrs)

#loanSmote$SeriousDlqin2yrs = as.numeric(loanSmote$SeriousDlqin2yrs)
#(mae.a1.tree<- mean(abs(prediction - loanSmote$SeriousDlqin2yrs)))
#length(prediction)
#nrow(loanSmote)

#(nmse.a1.tree <- mean((prediction - loanSmote$SeriousDlqin2yrs)^2)/
#   mean((mean(loanSmote$SeriousDlqin2yrs)-loanSmote$SeriousDlqin2yrs)^2))


# Fitting model
#fit <- randomForest(loanSmote$SeriousDlqin2yrs ~ ., loanSmote,ntree=500)
#summary(fit)
#Predict Output 
#prediction= predict(fit,loanSmote)
#PredictBinary = prediction > .5
#summary(prediction)


#KNN Neighbour

ctrl <- trainControl(method="repeatedcv",repeats = 2) 
knnFit <- train(SeriousDlqin2yrs ~ ., data = loanSmote, method = "knn", trControl = ctrl, tuneLength = 20)

#Output of kNN fit
knnFit
#Plotting yields Number of Neighbours Vs accuracy (based on repeated cross validation)
plot(knnFit)
knnPredict <- predict(knnFit )
#Get the confusion matrix to see accuracy value and other parameter values
confusionMatrix(knnPredict, loanSmote$SeriousDlqin2yrs )
summary(knnPredict)
str(knnPredict)
# Compute AUC for predicting Class with the variable CreditHistory.Critical
knnPredict = as.numeric(knnPredict)
plot(roc(loanSmote$SeriousDlqin2yrs, knnPredict, direction="<"),col="red", lwd=3, main="ROC CUrve", print.auc=TRUE)


#Predict using the KNN model
knnPredTest = predict(knnFit, newdata = loanTest[,-1])
summary(knnPredTest)
#Confusion matrix
confusionMatrix(knnPredTest,loanTest$SeriousDlqin2yrs)
