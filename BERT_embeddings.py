import pandas as pd
import pickle

from bert_serving.client import BertClient
bc = BertClient()

import sys
# name of the file containing the dataset
name_file  = sys.argv[1]

# load data
df = pd.read_csv(name_file+'.txt', engine='python')

# encode data using the Client (the sentences are in column "sentence" of df)
vec = bc.encode(list(df["sentence"].values))

# save encoded data in a pickle file
pickle.dump(vec, open(name+'_encoded.pkl', 'wb'))
