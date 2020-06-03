# Measuring controversy in Social Networks through NLP
Python and R code to identify automatically controversy on Twitter through text


## Requirements 

- R version 3.6.0
- R libraries
  - igraph
  - rtweet
  - plyr
  - textclean
  - tidyverse
  
- Python 3
- Python libraries
  - numpy
  - scipy
  
  ## Usage
  
- `create_graph.R` downloads data by a hashtag or key word, creates the retweet graph and save enviroment
- Bash file `calculate` recieves as parameter the name of the saved enviroment and do the following steps:
  - Create training and test files for Fasttext (or BERT)
  - Train Fasttext model
  - Estimate embbedings
  - Measure controversy
  
It is important to give permission to create files inside the folder and to give execution permission to file calcular if you want to use it.

Example for "bigil" dataset: `./calculate bigil`

### BERT Variant

As described in the paper, BERT can be used instead of Fastext, to create embeddings of users.

Use the labels computed (with `calculate`) for FastText to create a train file to finetune BERT using `create_trainBERT.py`

Finetune of BERT as in the [original repository](https://github.com/google-research/bert). Be sure to properly set `$DATA_DIR`, `$BERT_BASE_DIR` and `$OUTPUT_DIR`

```
python bert/run_classifier.py \
  --task_name=CoLA \
  --do_train=true \
  --do_eval=true \
  --data_dir=$DATA_DIR \
  --vocab_file=$BERT_BASE_DIR/vocab.txt \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --init_checkpoint=$BERT_BASE_DIR/bert_model.ckpt \
  --max_seq_length=128 \
  --train_batch_size=32 \
  --learning_rate=1e-5 \
  --num_train_epochs=6.0 \
  --output_dir=$OUTPUT_DIR \
  --do_lower_case=False
```

Computation of embeddings using [bert-as-service](https://github.com/hanxiao/bert-as-service)

* Start Client 

```
bert-serving-start \
  -pooling_strategy CLS_TOKEN \
  -model_dir=$BERT_BASE_DIR
  -tuned_model_dir=$OUTPUT_DIR
  -ckpt_name=$CKPT
  -max_seq_len 150
```

* Compute embeddings using `BERT_embeddings.py`

To compute the controversy score, use `score.py` as before

## Datasets
  
Due to privacy policies, the 30 Datasets of Tweet's used in the paper are stored by ids in folder `tweet_ids` 
