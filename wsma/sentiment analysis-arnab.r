
library(SnowballC)
library(tm)
library(ggplot2)
library(RColorBrewer)
library(wordcloud)
library(topicmodels)
library(data.table)
library(stringi)
library(qdap)
library(dplyr)
library(rJava)


# Set directory and read data
setwd("C:\\Users\\prabanch\\Desktop")

tweets.df <- read.csv("arnab2.csv")

# Convert char date to correct date format


tweets.df$created <- as.Date(substr(x = tweets.df$date, start = 1, stop = 10))



#Cleaning the text data by removing links, tags and delimiters.
#Build a Corpus, and specify the location to be the character Vectors

# Remove character string between < >
tweets.df$text <- genX(tweets.df$text, " <", ">")

# Create document corpus with tweet text
myCorpus<- Corpus(VectorSource(tweets.df$text)) 


#convert to Lowercase

myCorpus <- tm_map(myCorpus, content_transformer(stri_trans_tolower))


#Remove the links (URLs)

removeURL <- function(x) gsub("http[^[:space:]]*", "", x)  
myCorpus <- tm_map(myCorpus, content_transformer(removeURL))

#Remove anything except the english language and space

removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)   
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

#Remove Stopwords

myStopWords<- c((stopwords('english')),c("rt", "use", "used", "via", "amp"))
myCorpus<- tm_map(myCorpus,removeWords , myStopWords) 

#Remove Single letter words

removeSingle <- function(x) gsub(" . ", " ", x)   
myCorpus <- tm_map(myCorpus, content_transformer(removeSingle))

#Remove Extra Whitespaces

myCorpus<- tm_map(myCorpus, stripWhitespace) 


#keep a copy of "myCorpus" for stem completion later

myCorpusCopy<- myCorpus

#Stem words in the corpus

myCorpus<-tm_map(myCorpus, stemDocument)
writeLines(strwrap(myCorpus[[250]]$content,60))



#Function to correct/complete the text after stemming

stemCompletion2 <- function(x,dictionary) {
  x <- unlist(strsplit(as.character(x)," "))
  x <- x[x !=""]
  x <- stemCompletion(x, dictionary = dictionary)
  x <- paste(x, sep="", collapse=" ")
  PlainTextDocument(stripWhitespace(x))
}


#Stem Complete and Display the same tweet above with the completed and corrected text.

#myCorpus <- lapply(myCorpus, stemCompletion2, dictionary=myCorpusCopy)
myCorpus <- Corpus(VectorSource(myCorpus))
writeLines(strwrap(myCorpus[[250]]$content, 60))

#Term Document matrix
tdm<- TermDocumentMatrix(myCorpus, control= list(wordLengths= c(1, Inf)))
tdm

#Find the terms used most frequently

(freq.terms <- findFreqTerms(tdm, lowfreq = 50))

#Convert to Data frame
term.freq <- rowSums(as.matrix(tdm))
term.freq <- subset(term.freq, term.freq > 50)
df <- data.frame(term = names(term.freq), freq= term.freq)

#plotting the graph of frequent terms

ggplot(df, aes(reorder(term, freq),freq)) + theme_bw() + geom_bar(stat = "identity")  + coord_flip() +labs(list(title="Term Frequency Chart", x="Terms", y="Term Counts")) 


#calculate the frequency of words and sort it by frequency and setting up the Wordcloud

word.freq <-sort(rowSums(as.matrix(tdm)), decreasing= F)
pal<- brewer.pal(8, "Dark2")
wordcloud(words = names(word.freq), freq = word.freq, min.freq = 2, random.order = F, colors = pal, max.words = 100)


# Identify and plot word correlations. For example - corrupt
WordCorr <- apply_as_df(myCorpus[1:500], word_cor, word = "corrupt", r=.25)
plot(WordCorr)

#heat map
qheat(vect2df(WordCorr[[1]], "word", "cor"), values=TRUE, high="red",
      digits=2, order.by ="cor", plot = FALSE) + coord_flip()

# Messages with word - love
df <- data.frame(text=sapply(myCorpus, `[[`, "content"), stringsAsFactors=FALSE)
head(unique(df[grep("corrupt", df$text), ]), n=10)

#Find association with a specific keyword in the tweets - usopen, grandslam

findAssocs(tdm, "corrupt", 0.2)


#Topic Modelling to identify latent/hidden topics using LDA technique

dtm <- as.DocumentTermMatrix(tdm)

rowTotals <- apply(dtm , 1, sum)

NullDocs <- dtm[rowTotals==0, ]
dtm   <- dtm[rowTotals> 0, ]

if (length(NullDocs$dimnames$Docs) > 0) {
  tweets.df <- tweets.df[-as.numeric(NullDocs$dimnames$Docs),]
}

lda <- LDA(dtm, k = 5) # find 5 topic
term <- terms(lda, 7) # first 7 terms of every topic
(term <- apply(term, MARGIN = 2, paste, collapse = ", "))

###########This is not working as data is NA################3
topics<- topics(lda)
topics<- data.frame(date=(tweets.df$created), topic = topics)
head(topics)
qplot (date, ..count.., data=topics, geom ="density", fill= term[topic], position="stack")


#Sentiment Analysis to identify positive/negative tweets
# Use qdap polarity function to detect sentiment
sentiments <- polarity(tweets.df$text)
sentiments <- data.frame(sentiments$all$polarity)

sentiments[["polarity"]] <- cut(sentiments[[ "sentiments.all.polarity"]], c(-5,0.0,5), labels = c("negative","positive"))

table(sentiments$polarity)

#Sentiment Plot by date

sentiments$score<- 0
sentiments$score[sentiments$polarity == "positive"]<-1
sentiments$score[sentiments$polarity == "negative"]<- -1
sentiments$date <- as.IDate(tweets.df$created)
result <- aggregate(score ~ date, data = sentiments, sum)
plot(result, type = "l")

#Stream Graph for sentiment by date

Data<-data.frame(sentiments$polarity)
colnames(Data)[1] <- "polarity"
Data$Date <- tweets.df$created
Data$text <- NULL
Data$Count <- 1

graphdata <- aggregate(Count ~ polarity + as.character.Date(Date),data=Data,FUN=length)
colnames(graphdata)[2] <- "Date"
str(graphdata)
