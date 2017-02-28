#Read the data

hr <- read.csv('C:/Users/prabanch/Desktop/PGBA/dm/HR.csv')


#Find the structure
str(hr)
attach(hr)
View(hr)

#Summarise the data
summary(hr)
head(hr)

f=sapply(hr, is.factor)
which(f)
chisq.test(Age, Attrition)

chisq.test(hr)

hr$Age

View(hr)



i =0
while(i <= length(names(hr))) 
{
  ifelse((sapply(hr[,i],is.factor)), hr[,i], (hr[,i]=cut(hr[,i], 10, seq(from = min(hr[,i]), to = max(hr[,i])), include.lowest = TRUE)))
  i = i+1
}

hr$Attrition = cut(hr$Attrition, 10, seq(from = min(hr$Attrition), to = max(hr$Attrition)), include.lowest = TRUE)
hr$Age = cut(hr$Age, 5, include.lowest = TRUE)
hr$Attrition =  as.numeric(hr$Attrition)
hr$Age = as.factor(hr$Age)

names(hr)
i = 0
while(i <= 6) 
{
  chisq.test(hr[,i], hr$Attrition)  
  i = i+1
}

chisq.test(hr$Age, hr$Attrition)  
chisq.test(hr$BusinessTravel, hr$Attrition) 
chisq.test(hr$DailyRate, hr$Attrition) 
chisq.test(hr$Department, hr$Attrition) 
chisq.test(hr$DistanceFromHome, hr$Attrition) 
chisq.test(hr$Education, hr$Attrition) 
chisq.test(hr$EducationField, hr$Attrition)  
#chisq.test(hr$EmployeeCount, hr$Attrition) 
chisq.test(hr$EnvironmentSatisfaction, hr$Attrition) 
chisq.test(hr$Gender, hr$Attrition) 
chisq.test(hr$HourlyRate, hr$Attrition) 
chisq.test(hr$JobInvolvement, hr$Attrition) 
chisq.test(hr$MaritalStatus, hr$Attrition)  
chisq.test(hr$MonthlyIncome, hr$Attrition) 
chisq.test(hr$MonthlyRate, hr$Attrition) 
chisq.test(hr$NumCompaniesWorked, hr$Attrition) 
chisq.test(hr$Over18, hr$Attrition) 
chisq.test(hr$OverTime, hr$Attrition) 

chisq.test(hr$PercentSalaryHike, hr$Attrition) 
chisq.test(hr$PerformanceRating, hr$Attrition) 
chisq.test(hr$RelationshipSatisfaction, hr$Attrition) 
#chisq.test(hr$StandardHours, hr$Attrition) 
chisq.test(hr$StockOptionLevel, hr$Attrition) 
chisq.test(hr$TotalWorkingYears, hr$Attrition) 
chisq.test(hr$TrainingTimesLastYear, hr$Attrition) 
chisq.test(hr$WorkLifeBalance, hr$Attrition) 
chisq.test(hr$YearsAtCompany, hr$Attrition) 
chisq.test(hr$YearsInCurrentRole, hr$Attrition) 
chisq.test(hr$YearsSinceLastPromotion, hr$Attrition) 
chisq.test(hr$YearsWithCurrManager, hr$Attrition) 


#install.packages("partykit")
#install.packages("CHAID", repos="http://R-Forge.R-project.org")

library(partykit)
library(CHAID)
library(tree)
set.seed(10)
ctrl <- chaid_control(minbucket = 100, minsplit = 100, alpha2=.05, alpha4 = .05)
chaid.tree <-chaid(Attrition~Age+BusinessTravel+DailyRate+Department +
                     DistanceFromHome+EducationField+EmployeeCount+EnvironmentSatisfaction+HourlyRate+
                     JobInvolvement+JobLevel+JobRole+JobSatisfaction+MaritalStatus+
                     MonthlyIncome+NumCompaniesWorked+OverTime+
                     RelationshipSatisfaction+StandardHours+
                     StockOptionLevel+TotalWorkingYears+
                     TrainingTimesLastYear+WorkLifeBalance+
                     YearsAtCompany+YearsInCurrentRole+
                     YearsSinceLastPromotion+YearsWithCurrManager,
                    data=hr, control = ctrl)

ctrl <- chaid_control(minbucket = 100, minsplit = 100, alpha2=.05, alpha4 = .05)
chaid.tree <-chaid(Attrition~Age  ,data=hr, control = ctrl)


print(chaid.tree)
plot(chaid.tree, gp = gpar(fontsize=6))

text(chaid.tree, pretty=0)


## loading the library
library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)
## setting the control parameter inputs for rpart
r.ctrl = rpart.control(minsplit=100, minbucket = 10, cp = 0, xval = 10)
## calling the rpart function to build the tree
m1 <- rpart(Attrition~Age+BusinessTravel+DailyRate+Department +
              DistanceFromHome+EducationField+EmployeeCount+EnvironmentSatisfaction+HourlyRate+
              JobInvolvement+JobLevel+JobRole+JobSatisfaction+MaritalStatus+
              MonthlyIncome+NumCompaniesWorked+OverTime+
              RelationshipSatisfaction+StandardHours+
              StockOptionLevel+TotalWorkingYears+
              TrainingTimesLastYear+WorkLifeBalance+
              YearsAtCompany+YearsInCurrentRole+
              YearsSinceLastPromotion+YearsWithCurrManager ,data=hr, method = "class", control = r.ctrl)
ctrl <- chaid_control(minbucket = 100, minsplit = 100, alpha2=.05, alpha4 = .05)
chaid.tree <-chaid(Attrition~Age +  OverTime + Over18 + TotalWorkingYears ,data=hr, control = ctrl)


print(m1)

fancyRpartPlot(m1)
