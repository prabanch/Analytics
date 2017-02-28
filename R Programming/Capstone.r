require(tm)
require(qdap)
require(SnowballC)
require(RSentiment)
require(cluster)
require(fpc)

rm(list=ls())


###############################################################,"################################################################

data <- read.csv("C:\\Users\\prabanch\\PycharmProjects\\Sentiment Analysis\\2016-11-08  #BlackMoney.csv",stringsAsFactors = F)
cor1 <- Corpus(DataframeSource(data))

#cleaning data

for(j in seq(cor1)) {
  cor1[[j]]<-tolower(cor1[[j]])
  cor1[[j]]<-gsub("@\\w+","", cor1[[j]])
  cor1[[j]]<-gsub("[[:punct:]]","",cor1[[j]])
  cor1[[j]]<-gsub("[[:digit:]]","",cor1[[j]])
  cor1[[j]]<-gsub("http\\w+","",cor1[[j]])
  cor1[[j]]<-gsub("rt","",cor1[[j]])
  cor1[[j]]<-gsub("uu+\\w+","",cor1[[j]])
  cor1[[j]]<-gsub("hh+\\w+","",cor1[[j]])
  cor1[[j]]<-gsub("ha+\\w+","",cor1[[j]])
  #cor1[[j]]<-gsub(".","",cor1[[j]])
}


cor_data1<- as.data.frame(cor1)

corpus<- Corpus(DataframeSource(cor_data1))
corpus<-tm_map(corpus,removePunctuation)
corpus<-tm_map(corpus,removeNumbers)
corpus<-tm_map(corpus,removeWords,stopwords("english"))
corpus<-tm_map(corpus,removeWords,c("phirjumla","kno","dec","hhmmm","a","aur","all","and","also","bahutkrantikari","babaji","ayega"))
corpus<-tm_map(corpus,stripWhitespace)
corpus<-tm_map(corpus,stemDocument)

corpus_df <-as.data.frame(corpus)

head(corpus_df)
dtm <-DocumentTermMatrix(corpus)
dtm$content
names(dtm)
#dim(dtm)
x<-as.data.frame(as.matrix(dtm))
write.csv(x, "docu_term.csv")
inspect(dtm[1:5,1:35])

sparse.dtm <- removeSparseTerms(dtm, sparse = 0.98)
sparse.dtm
#examine.data.frame <- as.data.frame(as.matrix(examine.dtm))
#head(examine.data.frame)
#top.words <- Terms(examine.dtm)
#print(top.words)
inspect(sparse.dtm[1:5,1:35])

tfidf <- weightTfIdf(sparse.dtm)
class(tfidf.mat)
tfidf.mat <- as.matrix(tfidf)

eucl <- function(m){
  m/apply(m,1,function(x) sum(x^2)^.5)
}
mat.norm <- eucl(tfidf.mat)

set.seed(3)
k <- 5
Kmeansresult <- kmeans(mat.norm,k)

names(Kmeansresult)
Kmeansresult$cluster[1:20]
table(Kmeansresult$cluster)

plotcluster(mat.norm,Kmeansresult$cluster)
