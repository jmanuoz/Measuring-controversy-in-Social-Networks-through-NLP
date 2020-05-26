
from scipy import spatial
import numpy as nx
import sys
from math import*
from scipy.spatial import distance
file2 = sys.argv[1];
def is_number(a):
    # will be True also for 'NaN'
    try:
        number = float(a)
        return True
    except ValueError:
        return False
def has_nostrings(a):
    return  (len([s for s in a if is_number(s)]) == len(a))
f = open(file2+"-C1-vec.txt", "r", encoding = "ISO-8859-1")

distances = list()
a = 0
for x in f:   
    preEmb = x.split(' ')
    emb = preEmb[(len(preEmb)-201):(len(preEmb)-1)]
    if has_nostrings(emb):
        if a == 0:
            tweetsc1 = nx.array([emb]).astype(nx.float)
            a=1
        if(len(preEmb) > 200):
            tweetsc1 = nx.vstack((tweetsc1, nx.array(emb).astype(nx.float)))


f = open(file2+"-C2-vec.txt", "r", encoding = "ISO-8859-1")

distances = list()
a = 0
for x in f:   
    preEmb = x.split(' ')
    emb = preEmb[(len(preEmb)-201):(len(preEmb)-1)]
    if has_nostrings(emb):
        if a == 0:
            tweetsc2 = nx.array([emb]).astype(nx.float)
            a=1
        if(len(preEmb) > 200):
            tweetsc2 = nx.vstack((tweetsc2, nx.array(emb).astype(nx.float)))

X = nx.concatenate((tweetsc1, tweetsc2), axis=0)
# divide 2 clusters
c1 = tweetsc1
c2 = tweetsc2

# calculate centroids
cent1 = c1.mean(axis=0)
cent2 = c2.mean(axis=0)
cent0 = X.mean(axis=0)

v = nx.cov(X.T)
SS0 = 0
for row in X:
    #SS0 = SS0 + distance.mahalanobis(row,cent0,v)
    SS0 = SS0 + distance.cosine(row,cent0)
    #SS0 = SS0 + distance.euclidean(row,cent0)
    #SS0 = SS0 + distance.cityblock(row,cent0)
v = nx.cov(c1.T)
SS1 = 0
for row in c1:
    #SS1 = SS1 + distance.mahalanobis(row,cent1,v)
    SS1 = SS1 + distance.cosine(row,cent1)
    #SS1 = SS1 + distance.euclidean(row,cent1)
    #SS1 = SS1 + distance.cityblock(row,cent1)
v = nx.cov(c2.T)
SS2 = 0
for row in c2:
    #SS2 = SS2 + distance.mahalanobis(row,cent2,v)
    SS2 = SS2 + distance.cosine(row,cent2)
    #SS2 = SS2 + distance.euclidean(row,cent2)
    #SS2 = SS2 + distance.cityblock(row,cent2)
# Controversy index
idx = (SS1+SS2)/SS0
print(idx)
