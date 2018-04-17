'''
   Class to run the 
'''

class Keywords:

    def get_ngrams(words, ngrams, n):
        '''
           Function to create the Ngrams to  a given length
        '''
        for i in range(len(words)-(n-1)):
            ngrams.append(words[i:i+n])
        return ngrams

    def find_midpoint(ngrams):
        '''
            Find the midlength of the line
        '''
        return len(ngrams[0]) // 2

    def filter_ngrams_by_words(ngrams, search_term, midpoint):
        '''
           Filter list by a particular word
        '''
        return filter(lambda l: l[midpoint].startswith(search_term), ngrams)

    def string_to_bytes(word):
        return word.decode('utf-8').lower()

    def string_to_lower(word):
        return word.lower()
