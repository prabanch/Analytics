from nltk.corpus import wordnet
syns1 = wordnet.synsets("ex-husband")
print(syns1)
syns2 = wordnet.synsets("ex-spouse")
print(syns2)


w1 = wordnet.synset('husband.n.01')

w2 = wordnet.synset('spouse.n.01')

print(w1.wup_similarity(w2))
print('path similarity', w1.path_similarity(w2))


w1 = wordnet.synset('wife.n.01')
w2 = wordnet.synset('spouse.n.01')
print(w1.wup_similarity(w2))
print('path similarity', w1.path_similarity(w2))


'''
w1 = wordnet.synset('husband.n.01')
w2 = wordnet.synset('spouse.n.01')
print(w1.wup_similarity(w2))


syns1 = wordnet.synsets("wife")
print(syns1)
syns2 = wordnet.synsets("spouse")
print(syns2)

w1 = wordnet.synset('wife.n.01')
w2 = wordnet.synset('spouse.n.01')
print(w1.wup_similarity(w2))


syns1 = wordnet.synsets("subscription")
print(syns1)
syns2 = wordnet.synsets("subscribe")
print(syns2)
w1 = wordnet.synset('subscription.n.01')
w2 = wordnet.synset('subscribe.v.01')
print(w1.wup_similarity(w2))

synonyms = []
antonyms = []

for syn in wordnet.synsets("good"):
    for l in syn.lemmas():
        synonyms.append(l.name())
        if l.antonyms():
            antonyms.append(l.antonyms()[0].name())

print(set(synonyms))
print(set(antonyms))
'''

