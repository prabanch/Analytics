#read the files
require(xlsx)
library(caret)
library(ggplot2)
## loading the library
library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)
library(lmtest)
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
View(loan)
#Checking the data set
nrow(loan)
str(loan)
summary(loan)
boxplot(loan)
#Visualise the outliers
ggplot(loan, aes(loan$Casenum, loan$DebtRatio)) + geom_point()
ggplot(loan, aes(loan$Casenum, loan$RevolvingUtilizationOfUnsecuredLines)) + geom_point()
ggplot(loan, aes(loan$Casenum, loan$NumberOfOpenCreditLinesAndLoans)) + geom_point()

# findOutlier <- function(data, cutoff = 5) {
#   ## Calculate the sd
#   sds <- apply(loan[,-1], 2, sd, na.rm = TRUE)
#   ## Identify the cells with value greater than cutoff * sd (column wise)
#   result <- mapply(function(d, s) {
#     which(d > cutoff * s)
#   }, data, sds)
#   result
# }
# 
# apply(loan,1, is.na)
# outliers <- findOutlier(loan[,-1])
# outliers
# 
# loan[4855,]
# 
# removeOutlier <- function(data, outliers) {
#   result <- mapply(function(d, o) {
#     res <- d
#     res[o] <- NA
#     return(res)
#   }, data, outliers)
#   return(as.data.frame(result))
# }
# 
# dataFilt <- removeOutlier(loan[,-1], outliers)


x <- loan$DebtRatio
qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
caps <- quantile(x, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(x, na.rm = T)
loan$DebtRatio[loan$DebtRatio > (qnt[2] + H)] = 0 

x <- loan$RevolvingUtilizationOfUnsecuredLines
qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
caps <- quantile(x, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(x, na.rm = T)
loan$RevolvingUtilizationOfUnsecuredLines[loan$RevolvingUtilizationOfUnsecuredLines > (qnt[2] + H)] = 0




loan$NumberOfDependents = as.numeric(loan$NumberOfDependents)
boxplot(loan[,-1])
boxplot(loan$RevolvingUtilizationOfUnsecuredLines)
summary(loan$DebtRatio)


length(which(is.na(loan$NumberOfDependents)))
table(loan$NumberOfDependents)
loan[is.na(loan)] = 0



View(loan)
#check ratio
table(loan$SeriousDlqin2yrs)
#Find correlation
loan$NumberOfDependents = as.numeric(loan$NumberOfDependents)
cor(loan) 
#From the result it can be implied that the data is not correlated


# head(loan[,-1])
# #Apply Logistic regressn
# Model1 <- glm(SeriousDlqin2yrs~ .  , data = loan[,-1], family = binomial())
# 
# #Step 1: Log Likelihood Ratio Test - (Validity of the model)
# summary(Model1)
# 
# prediction = predict(Model1, type="response")
# summary(prediction)

#1 Fit the glm model using caret package
ctrl <- trainControl(method = "repeatedcv", number = 10, savePredictions = TRUE)
glmModel <- train(SeriousDlqin2yrs~ .  , data = loan[,-1], method="glm", family="binomial",trControl = ctrl)
#Predict the values
pred = predict(glmModel)
str(pred)
#Confusion Matrix
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

#Synthetic minority over sampling technique from DMWR PACKAGE
loan$SeriousDlqin2yrs = as.factor(loan$SeriousDlqin2yrs) #Convert to factor
#Over sample minority items. 
loanSmote = SMOTE(SeriousDlqin2yrs~.,loan[,-1],  perc.over = 1000, perc.under = 150)
#Check the results
table(loanSmote$SeriousDlqin2yrs)
#Check the no of 1 & 0's
table(loanSmote$SeriousDlqin2yrs)/nrow(loanSmote)


#Apply Logistic regression after OVer sampling
ctrl <- trainControl(method = "repeatedcv", number = 10,  savePredictions = TRUE)
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

prediction = predict(glmModelSmoted, data=loanSmote, type="response")

confusionMatrix(pred_smote,loanSmote$SeriousDlqin2yrs)

#normalized mean squared error (NMSE).

# loanSmote$SeriousDlqin2yrs = as.numeric(loanSmote$SeriousDlqin2yrs)
# (mae.a1.lm <- mean(abs(prediction - loanSmote$SeriousDlqin2yrs)))
# length(prediction)
# nrow(loanSmote)
# 
# (nmse.a1.glm <- mean((prediction - loanSmote$SeriousDlqin2yrs)^2)/
#    mean((mean(loanSmote$SeriousDlqin2yrs)-loanSmote$SeriousDlqin2yrs)^2))
# 

par(mfrow = c(1, 2))
plot(loan$NumberOfDependents, loan$DebtRatio, pch = 19 + as.integer(loan$DebtRatio), main = "Original Data")
plot(loanSmote$NumberOfDependents, loanSmote$DebtRatio, pch = 19 + as.integer(loanSmote$DebtRatio), main = "SMOTE'd Data")

# confusion matrix (training data)
#conf.matrix <- table(loanSmote$SeriousDlqin2yrs, PredictBinary)

#rownames(conf.matrix) <- paste("Actual", rownames(conf.matrix), sep = ":")
#colnames(conf.matrix) <- paste("Pred", colnames(conf.matrix), sep = ":")
#conf.matrix1 = conf.matrix
#print(conf.matrix1)



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


# Fitting model
#fit <- randomForest(loanSmote$SeriousDlqin2yrs ~ ., loanSmote,ntree=500)
#summary(fit)
#Predict Output 
#prediction= predict(fit,loanSmote)
#PredictBinary = prediction > .5
#summary(prediction)


table(loanSmote$SeriousDlqin2yrs,PredictBinary)

#KNN Neighbour

ctrl <- trainControl(method="repeatedcv",repeats = 10) #,classProbs=TRUE)
knnFit <- train(loanSmote$SeriousDlqin2yrs ~ ., data = loanSmote, method = "knn", trControl = ctrl, preProcess = c("center","scale"), tuneLength = 20)

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
