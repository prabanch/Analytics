
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

'''
sentences = [['data', 'science'], ['vidhya', 'science', 'data', 'analytics'],['machine', 'learning'], ['deep', 'learning'],["subscript", "subscribe"]]

# train the model on your corpus
model = Word2Vec(sentences, min_count = 1)

print(model.similarity("data", "subscribe"))

from nltk.stem.wordnet import WordNetLemmatizer
lem = WordNetLemmatizer()

from nltk.stem.porter import PorterStemmer
stem = PorterStemmer()

word = "subscription"
print(lem.lemmatize(word, "n"))
print(lem.lemmatize("subscribe", "v"))

print("lancaster")
from nltk.stem.lancaster import LancasterStemmer
st = LancasterStemmer()
print(st.stem('subscription'),  st.stem('subscribe'))
print(st.stem('husband'),  st.stem('spouse'))

print("porter")
from nltk.stem.porter import PorterStemmer
ps = PorterStemmer()
print(ps.stem('subscription'),  ps.stem('subscribe'))
print(ps.stem('husband'),  ps.stem('spouse'))
#print(model['learning'])

print("tessts")


tweet_text = ["subscription", "subscribe"]

print(len(tweet_text))
'''

tweets_texts = tweets['text']
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
   tokens = [i.lower() for i in tokens if i not in stopwords and len(i) > 2 and i in english_vocab]
   return tokens



words = ["subscription", "subscribe"]
'''
for tw in tweets_texts:
      words += process_tweet_text(tw)
'''

# load nltk's SnowballStemmer as variabled 'stemmer'

stemmer = SnowballStemmer("english")
# here I define a tokenizer and stemmer which returns the set of stems in the text that it is passed


def tokenize_and_stem(text):
    # first tokenize by sentence, then by word to ensure that punctuation is caught as it's own token
    tokens = [word for sent in nltk.sent_tokenize(text) for word in nltk.word_tokenize(sent)]
    filtered_tokens = []
    # filter out any tokens not containing letters (e.g., numeric tokens, raw punctuation)
    for token in tokens:
        if re.search('[a-zA-Z]', token):
            filtered_tokens.append(token)
    stems = [stemmer.stem(t) for t in filtered_tokens]
    return stems

'''

def tokenize_only(text):
    # first tokenize by sentence, then by word to ensure that punctuation is caught as it's own token
    tokens = [word.lower() for sent in nltk.sent_tokenize(text) for word in nltk.word_tokenize(sent)]
    filtered_tokens = []
    # filter out any tokens not containing letters (e.g., numeric tokens, raw punctuation)
    for token in tokens:
        if re.search('[a-zA-Z]', token):
            filtered_tokens.append(token)
    return filtered_tokens
'''

# not super pythonic, no, not at all.
# use extend so it's a big flat list of vocab
totalvocab_stemmed = []
totalvocab_tokenized = []
for i in words:
    allwords_stemmed = tokenize_and_stem(i)  # for each item in 'synopses', tokenize/stem
    totalvocab_stemmed.extend(allwords_stemmed)  # extend the 'totalvocab_stemmed' list

   # allwords_tokenized = tokenize_only(i)
   #totalvocab_tokenized.extend(allwords_tokenized)



print(totalvocab_stemmed)
print(totalvocab_tokenized)

#Text Exploration
bigram_measures = nltk.collocations.BigramAssocMeasures()
finder = BigramCollocationFinder.from_words(words, 5)
finder.apply_freq_filter(5)
print(finder.nbest(bigram_measures.likelihood_ratio, 10))

cleaned_tweets = []
for tw in tweets_texts:
    print("Raw --",tw)
    words = process_tweet_text(tw)
    print("Processed --", words)
    cleaned_tweet = " ".join(w for w in words if len(w) > 2 and w.isalpha()) #Form sentences of processed words
    print("Cleaned --", cleaned_tweet)
    cleaned_tweets.append(cleaned_tweet)

tweets["cleaned_tweets"] = cleaned_tweets
print(tweets["text"],tweets["cleaned_tweets"])

#vectorisation
tfidf_vectorizer = TfidfVectorizer(use_idf=True, ngram_range=(1,3))
tfidf_matrix = tfidf_vectorizer.fit_transform(cleaned_tweets)
feature_names = tfidf_vectorizer.get_feature_names() # num phrases

dist = 1 - cosine_similarity(tfidf_matrix)
print(dist)

num_clusters = 3
km = KMeans(n_clusters=num_clusters)
km.fit(tfidf_matrix)
clusters = km.labels_.tolist()
tweets['ClusterID'] = clusters
print(tweets['ClusterID'].value_counts())

#sort cluster centers by proximity to centroid
order_centroids = km.cluster_centers_.argsort()[:, ::-1]
for i in range(num_clusters):
    print("Cluster {} : Words :".format(i))
    for ind in order_centroids[i, :10]:
        print(' %s' % feature_names[ind])


'''
exclude = set(string.punctuation)
lemma = WordNetLemmatizer()
def clean(doc):
    stop_free = " ".join([i for i in doc.lower().split() if i not in stopwords])
    punc_free = ''.join(ch for ch in stop_free if ch not in exclude)
    normalized = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    return normalized

texts = [text for text in cleaned_tweets if len(text) > 2]
doc_clean = [clean(doc).split() for doc in texts]
dictionary = corpora.Dictionary(doc_clean)
doc_term_matrix = [dictionary.doc2bow(doc) for doc in doc_clean]
ldamodel = models.ldamodel.LdaModel(doc_term_matrix, num_topics=6, id2word =
dictionary, passes=5)
for topic in ldamodel.show_topics(num_topics=6, formatted=False, num_words=6):
    print("Topic {}: Words: ".format(topic[0]))
    topicwords = [w for (w, val) in topic[1]]
    print(topicwords)



#set up colors per clusters using a dict
cluster_colors = {0: '#1b9e77', 1: '#d95f02', 2: '#7570b3', 3: '#e7298a', 4: '#66a61e'}

#set up cluster names using a dict
cluster_names = {0: 'Family, home, war',
                 1: 'Police, killed, murders',
                 2: 'Father, New York, brothers',
                 3: 'Dance, singing, love',
                 4: 'Killed, soldiers, captain'}

# some ipython magic to show the matplotlib plots inline


# create data frame that has the result of the MDS plus the cluster numbers and titles
df = pd.DataFrame(dict(x=xs, y=ys, label=clusters, title=titles))

# group by cluster
groups = df.groupby('label')

# set up plot
fig, ax = plt.subplots(figsize=(17, 9))  # set size
ax.margins(0.05)  # Optional, just adds 5% padding to the autoscaling

# iterate through groups to layer the plot
# note that I use the cluster_name and cluster_color dicts with the 'name' lookup to return the appropriate color/label
for name, group in groups:
    ax.plot(group.x, group.y, marker='o', linestyle='', ms=12,
            label=cluster_names[name], color=cluster_colors[name],
            mec='none')
    ax.set_aspect('auto')
    ax.tick_params( \
        axis='x',  # changes apply to the x-axis
        which='both',  # both major and minor ticks are affected
        bottom='off',  # ticks along the bottom edge are off
        top='off',  # ticks along the top edge are off
        labelbottom='off')
    ax.tick_params( \
        axis='y',  # changes apply to the y-axis
        which='both',  # both major and minor ticks are affected
        left='off',  # ticks along the bottom edge are off
        top='off',  # ticks along the top edge are off
        labelleft='off')

ax.legend(numpoints=1)  # show legend with only 1 point

# add label in x,y position with the label as the film title
for i in range(len(df)):
    ax.text(df.ix[i]['x'], df.ix[i]['y'], df.ix[i]['title'], size=8)

plt.show()  # show the plot

# uncomment the below to save the plot if need be
# plt.savefig('clusters_small_noaxes.png', dpi=200)
'''