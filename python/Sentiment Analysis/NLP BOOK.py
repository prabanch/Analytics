
from nltk.book import *

'''print(text1.tokens)'''
#print(text2.concordance("affection"))
#text4.dispersion_plot(["citizens", "democracy", "freedom", "duties", "America"])

#print(text3.generate())
freq = FreqDist(text1)
V = set(text1)
long_words = [w for w in V if len(w) > 5 and w.endswith('s')]
sorted(long_words)
