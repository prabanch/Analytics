import tweepy
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


def get_api(cfg):
  auth = tweepy.OAuthHandler(cfg['consumer_key'], cfg['consumer_secret'])
  auth.set_access_token(cfg['access_token'], cfg['access_token_secret'])
  return tweepy.API(auth)

def main():
  # Fill in the values noted in previous step here
  cfg = {
    "consumer_key"        : "y9rsFAuHjptL1WRHgvKdnIehN",
    "consumer_secret"     : "184vfE03L7R5q6TyIgP7leQFRURbyogyMNAsWXAbMfyY0ubeCE",
    "access_token"        : "105202631-2Y1NDPiOWySghC3mB9Pp3xNVV4zKNxDDyLZPRLOk",
    "access_token_secret" : "4rlCQ6GPaoUQhSeFSDkhosZ1kRUnbcDIbjC7VWQJTeIda"
    }

  tweets = [" People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?1 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?2 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?3 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?4 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?5 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?6 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?7 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?8 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?9 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?10 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?11 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?    #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  1 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  2 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  3 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  6 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  4 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?11 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?    #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  11 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  22 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  32 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  62 #TNSaysNo2Sasi",
            " People Of Tamil Nadu Voted For #Amma,Not For #Chinnamma.Who Is She To Lead Them?  42 #TNSaysNo2Sasi"

            ]

  def process_tweet_text(tweet):
    if tweet.startswith('@null'):
      return "[Tweet not available]"
    tweet = re.sub(r'\$\w*', '', tweet)  # Remove tickers
    tweet = re.sub(r'https?:\/\/.*\/\w*', '', tweet)  # Remove hyperlinks
    tweet = re.sub(r'[' + string.punctuation + ']+', ' ', tweet)  # Remove puncutations like 's
    return tweet

  api = get_api(cfg)

  tweets_texts = tweets
  cleaned_tweets = []
  for tw in tweets_texts:
    words = process_tweet_text(tw)
    cleaned_tweet = " ".join(w for w in words if len(w) > 2 and w.isalpha())  # Form sentences of processed words
    cleaned_tweets.append(cleaned_tweet)
    api.update_status(status=tw)
    # Yes, tweet is called 'status' rather confusing

if __name__ == "__main__":
  main()
