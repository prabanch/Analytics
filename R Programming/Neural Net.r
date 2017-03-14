

#my data = nm-logit.csv

mydata=read.csv("nm-logit.csv", header=TRUE)
mydata
detach(mydata)
attach(mydata)
library(nnet)
Model=nnet(Loyal~Brand+Product+Shopping, data=mydata,size=30, rang=0.1, decay=5e-4, maxit=500)
print(Model)
conf1 =  table(Actual=mydata$Loyal, Prediction=predict(Model, data=mydata, type="class"))
fitted.values(Model)
library(NeuralNetTools)
garson(Model)


Model2=nnet(Loyal~Brand+Product+Shopping, data=mydata,size=50, rang=0.1, decay=5e-4, maxit=1000)
print(Model2)
conf2 =  table(Actual=mydata$Loyal, Prediction=predict(Model2, data=mydata, type="class"))
fitted.values(Model2)
garson(Model2)

library(neuralnet)
model3 = neuralnet(Loyalty~Brand+Product+Shopping,
                   data = mydata,
                   hidden = 5, rep = 3,
                   err.fct = 'sse',
                   linear.output =FALSE,
                   lifesign = "full",
                   lifesign.step = 10,
                   threshold = 0.005,
                   stepmax = 2000)

plot(model3)
print(model3)
predict = model3$net.result[[1]]
cutoff = floor(model3$net.result[[1]]+.5)

conf3 =  table(Actual=mydata$Loyal, Prediction=cutoff)
fitted.values(model3)
garson(model3)

library(caret)

ctrl <- trainControl(method = "repeatedcv", number = 10, savePredictions = TRUE, repeats = 5)
mydata$Loyalty = as.factor(mydata$Loyalty)
glmModel <- train(Loyalty~Brand+Product+Shopping  , data = mydata, method="glm", family="binomial",trControl = ctrl)
summary(glmModel)
#Predict the values
pred = predict(glmModel)
str(pred)
#Confusion Matrix
confusionMatrix( mydata$Loyalty, pred)
