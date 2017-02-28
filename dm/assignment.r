
#read the files
hr <- read.csv("C:/Users/prabanch/Desktop/PGBA/dm/1452762979_586__HR_Employee_Attrition_Data.csv")
View(hr)
summary(hr)
is.na(hr)

library(caTools)
set.seed(100)

#check ratio
View(hr)

split = sample.split(hr$Attrition, SplitRatio =0.75)
split

str(split)

nrow(hr)
table(hr$Attrition)
#split 
train = subset(hr, split == TRUE)
View(train)
str(train)
nrow(train)
table(train$Attrition)

test = subset(hr, split == FALSE)
View(test)
str(test)

## loading the library
library(rpart)
library(rpart.plot)

## setting the control paramter inputs for rpart
r.ctrl = rpart.control(minsplit=100, minbucket = 10, cp = 0.001, xval = 10)


## calling the rpart function to build the tree
##m1 <- rpart(formula = Target ~ ., data = CTDF.dev[which(CTDF.dev$Holding_Period>10),-1], method = "class", control = r.ctrl)
m1 <- rpart(formula = train$Attrition ~ ., data = train, method = "class", control = r.ctrl)
m1
printcp(m1)

plotcp(m1)

print(m1) 	#print results


library(DMwR)
m2 = rpartXse(train$Attrition ~ ., data = train, method = "class")
m2

summary(m1) #	detailed results including surrogate splits
library(rattle)
library(RColorBrewer)
fancyRpartPlot(m1)

train$Attrition  = as.factor(train$Attrition)
glm = glm(train$Attrition ~ train$MonthlyRate + train$MonthlyIncome, data = train, family = binomial())
glm

bestcp <- m1$cptable[which.min(m1$cptable[,"xerror"]),"CP"]

# Step3: Prune the tree using the best cp.
tree.pruned <- prune(m1, cp = bestcp)


# confusion matrix (training data)
conf.matrix <- table(train$Attrition, predict(m1,type="class"))
rownames(conf.matrix) <- paste("Actual", rownames(conf.matrix), sep = ":")
colnames(conf.matrix) <- paste("Pred", colnames(conf.matrix), sep = ":")
conf.matrix1 = conf.matrix
print(conf.matrix1)

#Aftter pruning
conf.matrix <- table(train$Attrition, predict(tree.pruned,type="class"))
rownames(conf.matrix) <- paste("Actual", rownames(conf.matrix), sep = ":")
colnames(conf.matrix) <- paste("Pred", colnames(conf.matrix), sep = ":")
conf.matrix2 = conf.matrix
print(conf.matrix2)



PredTest= predict(tree.pruned, test, type="class")
table(test$Attrition,PredTest)
summary(PredTest)

prp(tree.pruned, faclen = 0, cex = 0.8, extra = 1)

# faclen = 0 means to use full names of the factor labels
# extra = 1 adds number of observations at each node; equivalent to using use.n = TRUE in plot.rpart

tot_count <- function(x, labs, digits, varlen)
{
  paste(labs, "\n\nn =", x$frame$n)
}

prp(tree.pruned, faclen = 0, cex = 0.8, node.fun=tot_count)


only_count <- function(x, labs, digits, varlen)
{
  paste(x$frame$n)
}

boxcols <- c("pink", "palegreen3")[tree.pruned$frame$yval]

par(xpd=TRUE)
prp(tree.pruned, faclen = 0, cex = 0.8, node.fun=only_count, box.col = boxcols)
legend("bottomleft", legend = c("Yes","No"), fill = c("pink", "palegreen3"),
       title = "Group")



