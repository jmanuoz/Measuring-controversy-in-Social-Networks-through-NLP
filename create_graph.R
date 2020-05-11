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
net = network_graph(tweets.df, .e = c("retweet"))

save.image("datasets/filename.RData")
#GENERO EL LAYOUT (PARA VISUALIZARLO)

