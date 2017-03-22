
import pandas as pd
import os
from nltk.tokenize import TweetTokenizer
from nltk.corpus import stopwords
import re, string
import nltk
from nltk.stem.snowball import SnowballStemmer
from sklearn.feature_extraction.text import TfidfVectorizer

from nltk.collocations import *
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.cluster import KMeans

from gensim import corpora, models
from nltk.corpus import stopwords
from nltk.stem.wordnet import WordNetLemmatizer
import string
import matplotlib
from gensim.models import Word2Vec

tweets = pd.read_csv('2016-11-08  #BlackMoney.csv')

print(tweets.shape)
print(tweets.columns.values)

tweets_texts = tweets["text"].tolist()
stopwords=stopwords.words('english')
english_vocab = set(w.lower() for w in nltk.corpus.words.words())

def process_tweet_text(tweet):
   if tweet.startswith('@null'):
       return "[Tweet not available]"
   tweet = re.sub(r'\$\w*','',tweet) # Remove tickers
   tweet = re.sub(r'https?:\/\/.*\/\w*','',tweet) # Remove hyperlinks
   tweet = re.sub(r'['+string.punctuation+']+', ' ',tweet) # Remove puncutations like 's
   twtok = TweetTokenizer(strip_handles=True, reduce_len=True)
   tokens = twtok.tokenize(tweet)
   tokens = [i.lower() for i in tokens if i not in stopwords and len(i) > 2 and
                                             i in english_vocab]
   return tokens

words = []
for tw in tweets_texts:
      words += process_tweet_text(tw)

print(words)

#Frequency distribution

fdist1 = nltk.FreqDist(words)
fdist1.plot(20)

bigram_measures = nltk.collocations.BigramAssocMeasures()
finder = BigramCollocationFinder.from_words(words, 5)
finder.apply_freq_filter(5)
print(finder.nbest(bigram_measures.likelihood_ratio, 10))

#Clustering

cleaned_tweets = []
for tw in tweets_texts:
    words = process_tweet_text(tw)
    cleaned_tweet = " ".join(w for w in words if len(w) > 2 and w.isalpha()) #Form sentences of processed words
    cleaned_tweets.append(cleaned_tweet)
CleanTweetText = cleaned_tweets

print(CleanTweetText)


https://www.analyticsvidhya.com/blog/2016/12/45-questions-to-test-a-data-scientist-on-regression-skill-test-regression-solution/
