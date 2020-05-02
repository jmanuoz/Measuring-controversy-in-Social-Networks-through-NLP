library(rtweet)
library(igraph)
library(tidyverse)

##CREO EL TOKEN EN BASE A MI APLICACIÓN EN TWITTER (https://developer.twitter.com/en/apps)
create_token(
  app = "",
  consumer_key = "",
  consumer_secret = " "
) -> twitter_token

#BAJO LOS TWEETS
tweets.df <- search_tweets("search", n=250000,token=twitter_token,retryonratelimit = TRUE)

#CREO EL GRAFO DE RETWEETS
filter(tweets.df, retweet_count > 0) %>% 
  select(screen_name, mentions_screen_name) %>%
  unnest(mentions_screen_name) %>% 
  filter(!is.na(mentions_screen_name)) %>% 
  graph_from_data_frame() -> net

save.image("datasets/filename.RData")
#GENERO EL LAYOUT (PARA VISUALIZARLO)

