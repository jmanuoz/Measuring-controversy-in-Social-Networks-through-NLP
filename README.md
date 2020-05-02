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
  
- File "create_graph.R" download data by a hashtag or key word, creates the retweet graph and save enviroment
- Bash file "calculate" recieves as parameter the name of the saved enviroment and do the following steps:
  - Create training and test files for Fasttext
  - Train the NLP model
  - Estimate embbedings
  - Measure controversy
  
-It is important to give permission to create files inside the folder and to give execution permission to file calcular if you want to use it
- Example: ./calculate bigil
  ## Datasets
  
  Tweet's id used in the paper are in folder tweet_ids
