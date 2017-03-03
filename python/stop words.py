
from nltk.corpus import stopwords


from nltk.stem.snowball import SnowballStemmer

import nltk
sw = stopwords.words("english")
stemer = SnowballStemmer("english")
print(stemer.stem("unresponsiveness"))
print(len(sw))
print(sw)