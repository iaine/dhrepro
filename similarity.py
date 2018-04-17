'''
   Find similarities
'''

class Similarity:

    def find_jaccard_similarity(listA, listB):
        setA = set(listA)
        setB = set(listB)
        return float(len(seta.intersection(setb))) / float(len(seta.union(setb)))
