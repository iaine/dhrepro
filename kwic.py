'''
   Script to look for Reproducible or Reproducibility
   as a Key Word in the DHC Abstracts
'''
import glob
import string
import sys
from collections import defaultdict, Counter

kwic = defaultdict(int)
stopwords = set(['and', 'a', 'an','as', 'or', 'with', 'in', 'of', 'be', 'the','by', 'that', 'since', 'are', 'others', 'what', 'to', 'is','for','it','at', 'than', '14', 'while','which'])

file_path = sys.argv[1]

file_write = sys.argv[2]

ngrams = []

table = str.maketrans('','', string.punctuation)

def getNGrams(words, ngrams, n):
    for i in range(len(words)-(n-1)):
        ngrams.append(words[i:i+n])
    return ngrams

def findMidPoint(ngrams):
    return len(ngrams[0]) // 2

for raw_file in glob.glob(file_path + "*.txt"):
    with open(raw_file, 'rb') as f:
        data = f.read().split()
        getNGrams(data, ngrams, 5)

midpoint = findMidPoint(ngrams)

keywords = filter(lambda l: l[midpoint].startswith(b'reproducib'), ngrams)

#create list of keywords
for line in keywords:
    for word in line:
        _tmp = word.decode('utf-8').lower()
        _tmp = _tmp.translate(table)
        if _tmp not in stopwords:
            kwic[_tmp] +=1
s = sorted(kwic.items(), key=lambda v: v[1], reverse=True)
f = open(file_write, 'w')
for term, count in s:
    f.write("{},{}\n".format(term,count))

f.close
