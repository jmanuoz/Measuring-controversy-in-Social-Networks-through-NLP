import pandas as pd
import numpy as np
import sys
name_file = sys.argv[1]

def set_labels(text):
    return text[-2]

df = pd.read_csv(name_file+'.txt', header=None)
df[3] = df[1]
df[1] = df[0].apply(set_labels)
df[0] = ' '
df[2] = np.nan
df[[0, 1, 2, 3]].to_csv(name_file'BERT.tsv',
        sep='\t', header=None, index=None)

