getwd()
library(DMwR)

algae <- read.csv('algae.csv',
                     header=F,
                     dec='.',
                     na.strings=c('XXXXXXX'))


colnames(algae)
names(algae) = c('season','size','speed','mxPH','mnO2','Cl',
                         'NH4','oPO4','PO4','Chla','a1','a2','a3','a4',
                       'a5','a6','a7')
names(algae)
summary(algae)

plot(algae$NH4, xlab = "")
abline(h = mean(algae$NH4, na.rm = T), lty = 1)
abline(h = mean(algae$NH4, na.rm = T) + sd(algae$NH4, na.rm = T),
          lty = 2)
abline(h = median(algae$NH4, na.rm = T), lty = 3)
abline(h = median(algae$NH4, na.rm = T), lty = 3.5)

identify(algae$NH4)


 plot(algae$NH4, xlab = "")
 clicked.lines <- identify(algae$NH4)
 algae[clicked.lines, ]
 
 View(algae)
 
 
 library(lattice)
 bwplot(size ~ a1, data=algae, ylab='River Size',xlab='Algal A1')

 
 algae[!complete.cases(algae),] 
 
 algae[48,]
 
 is.na(algae)
 manyNAs(algae, 0.1) 
 manyNAs(algae)
 
 str(algae)
 cor(algae[, 4:18], use = "complete.obs")
 
 symnum(cor(algae[, 4:18], use = "complete.obs"))
 
 
 algae <- algae[-manyNAs(algae), ]
 
 lm(PO4 ~ oPO4, data = algae)
 
 
 
 data(algae)
 algae <- algae[-manyNAs(algae), ]
 fillPO4 <- function(oP) {
    if (is.na(oP))
      return(NA)
    else return(42.897 + 1.293 * oP)
    }
algae[is.na(algae$PO4), "PO4"] <- sapply(algae[is.na(algae$PO4),
                                                   "oPO4"], fillPO4)

algae <- knnImputation(algae, k = 10, meth = "median")

View(algae)
algae <- algae[-manyNAs(algae), ]
clean.algae <- knnImputation(algae, k = 10)

attach(algae)
lm.a1 <- lm(a1 ~ ., data = algae[, 1:11])
plot(lm.a1)
clean.algae[, 1:12]
summary(lm.a1)

newLM = step(lm.a1)



library(rpart)
data(algae)
algae <- algae[-manyNAs(algae), ]
rt.a1 <- rpart(a1 ~ ., data = algae[, 1:12])
rt.a1

plot(rt.a1)
library(rattle)
library(RColorBrewer)
fancyRpartPlot(rt.a1)
prettyTree(rt.a1)
printcp(rt.a1)

plotcp(rt.a1)

rt2.a1 <- prune(rt.a1, cp = 0.08)
rt2.a1
fancyRpartPlot(rt2.a1)

(rt.a1 <- rpartXse(a1 ~ ., data = algae[, 1:12]))

first.tree <- rpart(a1 ~ ., data = algae[, 1:12])
snip.rpart(first.tree, c(4, 7))
prettyTree(first.tree)
my.tree <- snip.rpart(first.tree)

#predict
lm.predictions.a1 <- predict(lm.a1, clean.algae)
rt.predictions.a1 <- predict(rt.a1, algae)
