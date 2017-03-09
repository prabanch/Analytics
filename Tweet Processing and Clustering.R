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
  cor1[[j]]<-gsub(".","",cor1[[j]])
}

#cor1$content[1]


cor_data1<- as.data.frame(cor1)
corpus<- Corpus(DataframeSource(cor_data1))


#corpus<-tm_map(corpus,removePunctuation)
corpus<-tm_map(corpus,removeNumbers)
corpus<-tm_map(corpus,removeWords,stopwords("english"))
corpus<-tm_map(corpus,removeWords,c("doc", "phirjumla","kno","dec","hhmmm","a","aur","all","and","also","bahutkrantikari","babaji","ayega"))
corpus<-tm_map(corpus,stripWhitespace)
corpus<-tm_map(corpus,stemDocument)

corpus_df<- as.data.frame(corpus)

#corpus$content[[1]]
#str(corpus)

#dtm <-DocumentTermMatrix(corpus)
#dtm
#dim(dtm)
#inspect(dtm[1:5,1:20])

#sparse.dtm <- removeSparseTerms(dtm, sparse = 0.98)
#corpus_sparse.dtm <- as.Corpus(sparse.dtm)
#wordcloud::wordcloud(corpus_sparse.dtm,max.words = 50)

cleaned_data<-as.data.frame(as.matrix(dtm))
write.csv(cleaned_data, "D:/CAPSTONE/docu_term_new.csv")


#corpus_df<- as.data.frame(cor1)


library(sentiment)
require(sentiment)

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
result
head(result)
head(data)

negative.words <- c(negative.words, "rushforcash","moditakesbrib","cashcrunch", "modisurgicalstrikeoncommonman")
positive.words<- c(positive.words, "iamwithmodi", "corruptioncleanup","lessen","waiv")

result1 = getSentimentScore(corpus_df$text, positive.words , negative.words)
head(result1)

result1$sentiment <- ifelse(result1$score==0,"Neutral",ifelse(result1$score>=1,"Positive","Negative"))
head(result1)


require(ggplot2)
ggplot(result1, aes(x=sentiment)) + geom_bar()


