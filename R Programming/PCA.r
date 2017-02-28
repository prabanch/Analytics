require(psych);
require(foreign);
install.packages("psych")
#fACTor analysis with interaction

#house hold and shopping data.sav
f1 = cbind(mydata$pricheck, mydata$homeeven, mydata$Magmovies, mydata$notbuypr, mydata$homebody, mydata$savecoup,
           mydata$adwaste)

write.csv(mydata, "Ads.csv")
write.csv(resort_visit, "resort.csv")
# Pricipal Components Analysis
# entering raw data and extracting PCs
# from the correlation matrix
fit <- princomp(f1, cor=TRUE)
names(fit)
(fit$sdev)^2
fit$loadings
fit$center
fit$call
fit$rotation
summary(fit) # print variance accounted for
loadings(fit) # pc loadings
plot(fit,type="lines") # scree plot
fit$scores # the principal components
biplot(fit)

# Varimax Rotated Principal Components
# retaining 5 components
library(psych)
fit2 <- principal(f1, nfactors=3, rotate="varimax")
summary(fit2) # print variance accounted for
loadings(fit2) # pc loadings
plot(fit2) # scree plot
fit2$scores # the principal components
biplot(fit2)
# Determine Number of Factors to Extract
library(nFactors)
ev <- eigen(cor(f1)) # get eigenvalues
ap <- parallel(subject=nrow(f1),var=ncol(f1),
  rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS) 

