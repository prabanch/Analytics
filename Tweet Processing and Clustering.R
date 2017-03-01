require(tm) # to perfrom word preprocessing and corpus
require(qdap) # converting corpus to data frame
require(SnowballC)
require(RSentiment)
require(cluster)
require(fpc)
require(syuzhet)
require(plyr)
require(stringr)

rm(list=ls())

ls()
###############################################################,"################################################################

data <- read.csv("C:/Users/prabanch/Desktop/PGBA/CAPSTONE/15-16/Book1.csv", stringsAsFactors = T)
cor1 <- Corpus(DataframeSource(data))
head(data)

str(data)
cor1$content

#cleaning data

for(j in seq(cor1)) {
  cor1[[j]]<-tolower(cor1[[j]])
  cor1[[j]]<-gsub("@\\w+", "" , cor1[[j]])
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
head(cor_data1)
corpus<- Corpus(DataframeSource(cor_data1))
corpus<-tm_map(corpus,removePunctuation)
corpus<-tm_map(corpus,removeNumbers)
corpus<-tm_map(corpus,removeWords,stopwords("english"))
corpus<-tm_map(corpus,removeWords,c("phirjumla","kno","dec","hhmmm","a","aur","all","and","also","bahutkrantikari","babaji","ayega"))
corpus<-tm_map(corpus,stripWhitespace)
corpus<-tm_map(corpus,stemDocument)
corpus<-tm_map(corpus,tolower)


corpus_df <-as.data.frame(corpus)
head(corpus_df)
head(data)

######################documnet Term Matrix###########################

head(corpus_df)

meta(corpus[[1]])
dtm <-DocumentTermMatrix(corpus)
dtm
names(dtm)

#dim(dtm)
#x<-as.data.frame(as.matrix(dtm))
#write.csv(x, "docu_term.csv")
inspect(dtm[,1:35])
inspect(dtm)
writeLines(as.character(corpus_df[[2]]))
#Find frequency terms
findFreqTerms(dtm, 5)
#Find associations   
findAssocs(dtm, "black", 0.5)
#find sparse terms
inspect(removeSparseTerms(dtm, 0.9))
sparse.dtm <- removeSparseTerms(dtm, sparse = 0.98)
sparse.dtm
#examine.data.frame <- as.data.frame(as.matrix(examine.dtm))
#head(examine.data.frame)
#top.words <- Terms(examine.dtm)
#print(top.words)
inspect(sparse.dtm[1:5,1:35])

#####Word cluod

library(wordcloud)
 m <- as.matrix(dtm)
 # calculate the frequency of words
 v <- sort(rowSums(m), decreasing=TRUE)
 myNames <- names(v)
 k <- which(names(v)=="miners")
 myNames[k] <- "mining"
 d <- data.frame(word=myNames, freq=v)
 wordcloud(d$word, d$freq, min.freq=3)

######


##############################################################################
afinn_list <- read.delim(file='D:/CAPSTONE/AFINN/AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
names(afinn_list) <- c('word', 'score')
afinn_list$word <- tolower(afinn_list$word)

vNegTerms <- afinn_list$word[afinn_list$score==-5 | afinn_list$score==-4]
negTerms <- c(afinn_list$word[afinn_list$score==-3 | afinn_list$score==-2 | afinn_list$score==-1], "second-rate", "moronic", "third-rate", "flawed", "juvenile", "boring", "distasteful", "ordinary", "disgusting", "senseless", "static", "brutal", "confused", "disappointing", "bloody", "silly", "tired", "predictable", "stupid", "uninteresting", "trite", "uneven", "outdated", "dreadful", "bland")
posTerms <- c(afinn_list$word[afinn_list$score==3 | afinn_list$score==2 | afinn_list$score==1], "first-rate", "insightful", "clever", "charming", "comical", "charismatic", "enjoyable", "absorbing", "sensitive", "intriguing", "powerful", "pleasant", "surprising", "thought-provoking", "imaginative", "unpretentious")
vPosTerms <- c(afinn_list$word[afinn_list$score==5 | afinn_list$score==4], "uproarious", "riveting", "fascinating", "dazzling", "legendary")   


################### K means clustering  ##############################
tfidf <- weightTfIdf(sparse.dtm)
names(tfidf)

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


########################syzhuet######################################
#Rsentiment package###
sent <- calculate_score(corpus_df$text)
sent1 <- calculate_sentiment(corpus_df$text)
head(sent1, 50)
names(sent1$sentiment)

?RSentiment

######QDAP Package#####
sent2 <-polarity(corpus_df)


#####Sentiment package#############
require(devtools)

install_github("okugami79/sentiment140")

library(sentiment)
senti <- sentiment(corpus_df$text)
names(senti)
head(senti)
table(senti$polarity)


####################################################################

getSentimentScore = function(sentences, positive.words, negative.words)
  
{
  require(plyr)
  require(stringr)
  
  scores = laply(sentences, function(sentence, positive.words, negative.words) {
    
    # Let first remove the Digit, Punctuation character and Control characters:
    #sentence = gsub('[[:cntrl:]]', '', gsub('[[:punct:]]', '', gsub('\\d+', '', sentence)))
    
    # Then lets convert all to lower sentence case:
    #sentence = tolower(sentence)
    
    # Now lets split each sentence by the space delimiter
    words = unlist(str_split(sentence, '\\s+'))
    
    # Get the boolean match of each words with the positive & negative opinion-lexicon
    pos.matches = !is.na(match(words, positive.words))
    neg.matches = !is.na(match(words, negative.words))
    
    # Now get the score as total positive sentiment minus the total negatives
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, positive.words, negative.words)
  
  # Return a data frame with respective sentence and the score
  return(data.frame(text=sentences, score=scores))
}

result = getSentimentScore(corpus_df$text, positive.words , negative.words)
head(result)


negative.words <- c(negative.words, "rushforcash","moditakesbrib","cashcrunch", "modisurgicalstrikeoncommonman")
positive.words<- c(positive.words, "iamwithmodi", "corruptioncleanup")

