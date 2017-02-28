setwd("C:/Users/prabanch/Desktop/R Programming")
mydata=read.csv("Health.csv", header=TRUE)
mydata
attach(mydata)

#What do the numbers tell me at macro level?
summary(mydata)
#Sampling is chosen in a specific order by hospital
#inspite of substantail of lagging performance in pay and promotion the work environment showing a very high score 
#shows that all is not too late that the work environment could improve substantially if proper steps are taken.
#Supposed that is this is ignored the work enviroment might further come down. 
by(mydata,  INDICES = Hospital, FUN = summary)

#With median as reference pay is better in "university" hospitalll when compared to the Private and va hospitals
#
boxplot(Work, Pay, Promotion)
boxplot(Work, Pay, Promotion, names = c("Work", "Pay", "Promotion"))
boxplot(Work, Pay, Promotion, names = c("Work", "Pay", "Promotion"), horizontal = TRUE)
boxplot(Work, Pay, Promotion, names = c("Work", "Pay", "Promotion"), col=c("Red", "Pink", "blue"),horizontal = TRUE)
#When in the boxplot there is  outlier there are values outside the allowable
#limit IQR - q3- q1. L= q1 -1.5 IQR, U = q3 + 1.5 IQR
boxplot(Work~Hospital, names = c("va", "Private", "University"), col=c("Red", "Pink", "blue"),horizontal = TRUE)

hist(Work, col = "Red")
hist(Pay, col = "Blue")
hist(Promotion, col = "Green")
# at the macro level it is very evidenet that work enviroonment is the best performenr int he minds of the nurses inspite of the rather meger pay
#
par(mfrow = c(2,2))

work
plot(Work, Pay)

list.files()

