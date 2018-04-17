'''
   Script to look for Reproducible or Reproducibility
   as a Key Word in the DHC Abstracts
'''
import glob
import string
import sys
from collections import defaultdict, Counter

from parse import ParseFile
from keywords import Keywords

kwic = defaultdict(int)
stopwords = set(['and', 'a', 'an','as', 'or', 'with', 'in', 'of', 'be', 'the','by', 'that', 'since', 'are', 'others', 'what', 'to', 'is','for','it','at', 'than', '14', 'while','which', 'if', 'we', 'but','on'])

html_path = sys.argv[1]
text_path = sys.argv[2]
html_write = sys.argv[3]
text_write = sys.argv[4]

ngrams = []

table = str.maketrans('','', string.punctuation)

files = glob.glob(html_path)

for raw_file in files:
    with open(raw_file, 'rb') as f:
        data = ParseFile().parseHtml(f.read()) 
        Keywords().get_ngrams(data, ngrams, 5)

midpoint = Keywords().find_midpoint(ngrams)

keywords = Keywords().filter_ngrams_by_words(ngrams, 'software', midpoint)

#create list of keywords
for line in keywords:
    for word in line:
        _tmp = Keywords().string_to_lower(table)
        _tmp = _tmp.translate(table)
        if _tmp not in stopwords:
            kwic[_tmp] +=1

s = sorted(kwic.items(), key=lambda v: v[1], reverse=True)

f = open(html_write, 'w')
for term, count in s:
    f.write("{},{}\n".format(term,count))

f.close

ngrams = []

table = str.maketrans('','', string.punctuation)

files = glob.glob(text_path)

for raw_file in files:
    with open(raw_file, 'rb') as f:
        data = ParseFile().parseHtml(f.read())
        Keywords().get_ngrams(data, ngrams, 5)

midpoint = Keywords().find_midpoint(ngrams)

keywords = Keywords().filter_ngrams_by_words(ngrams, 'software', midpoint)

#create list of keywords
for line in keywords:
    for word in line:
        _tmp = Keywords().string_to_lower(table)
        _tmp = _tmp.translate(table)
        if _tmp not in stopwords:
            kwic[_tmp] +=1

s = sorted(kwic.items(), key=lambda v: v[1], reverse=True)

f = open(text_write, 'w')
for term, count in s:
    f.write("{},{}\n".format(term,count))

f.close
