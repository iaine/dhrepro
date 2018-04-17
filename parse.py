'''
   Class to the parse the file
'''
from bs4 import BeautifulSoup


class ParseFile:

    def parseHtml(words):
        '''
           Function to parse html
        '''
        soup = BeautifulSoup(words, 'html.parser')
        return soup.get_text().split()

    def parseText(words):
        '''
           Function to parse text into list
        '''
        return words.split()
