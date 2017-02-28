#Problem 2



Torque=c(8,13,15,10,16,11,14,11,14,20,15,16,12,15,13,12,13,16,17,17,14,14,14,18,15)
range(Torque)
breaks=seq(8,23,by=3)
breaks
Torque.Class=cut(Torque, breaks, right = FALSE)
Torque.Class
plot(Torque.Class)
summary(Torque)
plot(Torque)
plot(Torque.Class,main="histogram of Torque",xlab="Calss interveal", ylab="Frequency", space=(0), col="red")
sd(Torque)
boxplot(Torque, horizontal = TRUE, col = "red")
breaks
hist(Torque)
library(e1071)
skewness(Torque)
kurtosis(Torque)
mode(Torque)
cbind(table(Torque.Class))
mode(1,1,1,2)
data.frame(Torque.Class)
x=mode(Torque)

f= table(as.vector(Torque))
m=names(f)[f==max(f)]
m
Torque
f

