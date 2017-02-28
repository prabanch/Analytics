
#pca nm

data1=read.csv("PCA-nm.csv", header=TRUE)
data1
names(data1)

attach(data1)
PCA=princomp(data1[, 1:6], cor=TRUE)
PCA

summary(PCA)

Factors=loadings(PCA)
Factors

Rotation=varimax(loadings(PCA))
row.names(Rotation$rotmat)=c("PreventCav","ShinyTeeth", "StrengthGum", "Fresh","Decay", "Attractive")
Rotation

plot(PCA, type="lines")

plot(PCA$scores[,1], PCA$scores[,2], col=c("Red", "Green"))

biplot(PCA, cex=0.7)



##Factors
attach(data1)
Factor=factanal(data1[,1:6], 2)
Factor
print(Factor, digits=2, cutoff=.3, sort=TRUE)
load =Factor$loadings[,1:2]
load
plot(load,type="n") # set up plot 
text(load,labels=names(data1),cex=.7) # add variable names cex=.7) # add variable names 
Factor1= factanal(data1[,1:6], 2, rotation="varimax")
Factor1
load1 =Factor1$loadings[,1:2]
plot(load1,type="n") # set up plot 
text(load1,labels=names(data1),cex=.7) # add variable names 




#MDS

mydata
row.names=c("AquaFresh",  "Crest",  "Colgate",  "Aim",  "Gleem",  "Maclean",  "Ultra",  "CloseUp",  "Pepsodent",  "Dentagard")
d=dist(mydata)
fit=cmdscale(d,eig=TRUE, k=2) # k is the number of dim
fit # view results
# plot solution 
x =fit$points[,1]
y =fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", 
     main="Metric MDS",type="n")
text(x, y, labels = row.names, cex=.7)

