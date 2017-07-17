rm(list=ls())

require(tm)

setwd("C:/Users/556995/Desktop/Risk Analytics")
rawdata=read.csv("AllScopeRiskDataReport.csv",stringsAsFactors = FALSE)
aqmsheet=read.csv("Final_Account Mapping_as_on_03_JUL_17.csv")
riskdb=merge(rawdata,aqmsheet,by.x = "Parent.Account.Name",by.y="Parent.Customer",all.x = TRUE)
write.csv(riskdb,"C:/Users/556995/Desktop/Risk Analytics/riskdb.csv")

#to get count of memes and text 

riskdb$context="NA"
riskdescription <- Corpus(VectorSource(riskdb$Risk.Description))
riskdb$context=gsub("context:","1",riskdb$Risk.Description)
View(riskdb)
riskdb$context
index1<- grep("Context",riskdb$Risk.Description, value=FALSE) #identify all Risk has RD as context

context<- data.frame(Type=c("context","0"), Total =c(0,0)) #create a data table to store the values

context$Total<- c(length(index1), dim(riskdb)[1]-length(index1)) #update the data table with memes and text 
riskdb[-index1,]
riskdb$context <- riskdb[-index1,]
View(riskdb)
write.csv(context,"C:/Users/556995/Desktop/Risk Analytics/context.csv")
index1
index <- grep("RT+",data$text, value=FALSE)
ReTweet_classification <- data.frame(Type=c("Retweet","Original"), Total =c(0,0)) #create a data table to store the values
ReTweet_classification$Total <- c(length(index), dim(data)[1]-length(index)) #update the data table with memes and text 


## to check the blank value 


risk
riskmitigation=riskdb$Mitigation.Plan.Description
riskdb$mitigationplanstatus=length(which(!complete.cases(riskmitigation)))
riskdb$mitigationplanstatus

## to cover the risk score as factor and create table

riskdb$Risk.Score=as.factor(riskdb$Risk.Score)
prop.table(table(riskdb$Risk.Score))
        

## To count the RD length
riskdescription <- Corpus(VectorSource(riskdb$Risk.Description))
riskdb$length=nchar(riskdescription)
summary(riskdb$length)

View(riskdb)

=========================
Prabanch
=========================

riskdb$Risk.Description_context<- 0
riskdb$Risk.Description_Consequence = 0
riskdb$Risk.Description_condition = 0
riskdb$Risk.Description_Length_not_50 = 'N'
  
for(i in 1:nrow(riskdb)) 
{
  rownum = i
  #Context
  test = grep("Context",riskdb[rownum,]$Risk.Description)
  riskdb[rownum,]$Risk.Description_context <- ifelse(is.integer(test) && length(test) == 0, 0 ,1)
  
  #Condition 
  test = grep("Condition",riskdb[rownum,]$Risk.Description)
  riskdb[rownum,]$Risk.Description_condition <- ifelse(is.integer(test) && length(test) == 0, 0 ,1)
  
  #Consequence
  test = grep("Consequence",riskdb[rownum,]$Risk.Description)
  riskdb[rownum,]$Risk.Description_Consequence <- ifelse(is.integer(test) && length(test) == 0, 0 ,1)

  #Find length
  riskdb$Risk.Description_Length_not_50 =  ifelse(nchar(riskdb[rownum,]$Risk.Description) < 50, 'Y', 'N')
} 



write.csv(riskdb,"final.csv")

