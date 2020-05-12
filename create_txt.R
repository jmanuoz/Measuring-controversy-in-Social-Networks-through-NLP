library("plyr")
library("igraph")
library("textclean")

args = commandArgs(trailingOnly=TRUE)
fileName = args[1]
load(paste0(fileName,".RData"))

my.com.fast = cluster_louvain(as.undirected(simplify(net)))
largestCommunities <- order(sizes(my.com.fast), decreasing=TRUE)[1:2]
community1 <- names(which(membership(my.com.fast) == largestCommunities[1]))
community2 <- names(which(membership(my.com.fast) == largestCommunities[2]))
users_text<-ddply(tweets.df,~screen_name,summarise,text=paste(text, collapse = " "))

net2=net

if(!grepl('@', users_text$screen_name[1]) & grepl('@', community1[1])){
  users_text$screen_name = paste('@',users_text$screen_name,sep="")
}
if(length(unique(users_text$text[which(paste('',users_text$screen_name,sep="") %in% community1)] )) > length(unique(users_text$text[which(paste('@',users_text$screen_name,sep="") %in% community2)]) ) ){
  to = length(unique(users_text$text[which(paste('',users_text$screen_name,sep="") %in% community2)] ))
}else{
  to = length(unique(users_text$text[which(paste('',users_text$screen_name,sep="") %in% community1)] ))
}
fileConn<-file(paste0(fileName,"-train.txt"), 'w')
text<-users_text$text[which(paste('',users_text$screen_name,sep="") %in% community1)]
#text <- unique(text)
# Here we pre-process the data in standard ways.
text <- gsub("RT", " ", text)  # Remove the "RT" (retweet) so duplicates are duplicates
text <- gsub("@\\w+", " ", text)  # Remove user names (all proper names if you're wise!)
text <- gsub("http.+ |http.+$", " ", text)  # Remove links
text <- gsub("[[:punct:]]", " ", text)  # Remove punctuation
text <- gsub("[ |\t]{2,}", " ", text)  # Remove tabs
text <- gsub("^ ", "", text)  # Leading blanks
text <- gsub(" $", "", text)  # Lagging blanks
text <- gsub(" +", " ", text) # General spaces (should just do all whitespaces no?)
text <- gsub("\n", " ", text) # General spaces (should just do all whitespaces no?)

text2<-users_text$text[which(paste('',users_text$screen_name,sep="") %in% community2)]
#text2 <- unique(text2)
text2 <- gsub("RT", " ", text2)  # Remove the "RT" (retweet) so duplicates are duplicates
text2 <- gsub("@\\w+", " ", text2)  # Remove user names (all proper names if you're wise!)
text2 <- gsub("http.+ |http.+$", " ", text2)  # Remove links
text2 <- gsub("[[:punct:]]", " ", text2)  # Remove punctuation
text2 <- gsub("[ |\t]{2,}", " ", text2)  # Remove tabs
text2 <- gsub("^ ", "", text2)  # Leading blanks
text2 <- gsub(" $", "", text2)  # Lagging blanks
text2 <- gsub(" +", " ", text2) # General spaces (should just do all whitespaces no?)


if(length(text) > length(text2) ){
  to = length(text2) 
}else{
  to = length(text) 
}
for(is in 1:to){
  write(paste("__label__1 , ",text[is]), file=fileConn,append=TRUE)
}
for(is in 1:to){
  write(paste("__label__2 , ",text2[is]), file=fileConn,append=TRUE)
}
close(fileConn)

principal_auth = sort(authority_score(net)$vector,decreasing = TRUE)[1:round(length(V(net))*0.3)]
principal_hub = sort(hub_score(net)$vector,decreasing = TRUE)[1:round(length(V(net))*0.3)]
useful = c(names(principal_auth),names(principal_hub))
if(!grepl('@', useful[1]) & grepl('@', community1[1])){
  useful = paste('@',useful,sep="")
}
c1useful =community1[which(community1 %in% useful)]
c2useful =community2[which(community2 %in% useful)]
users_text_train = users_text[which(users_text$screen_name %in% c1useful ),]
users_text_train2 = users_text[which(users_text$screen_name %in% c2useful ),]

fileConn<-file(paste0(fileName,"-C1.txt"), 'w')
text<-users_text_train$text
text <- unique(text)
# Here we pre-process the data in standard ways.
text <- gsub("RT", " ", text)  # Remove the "RT" (retweet) so duplicates are duplicates
text <- gsub("@\\w+", " ", text)  # Remove user names (all proper names if you're wise!)
text <- gsub("http.+ |http.+$", " ", text)  # Remove links
text <- gsub("[[:punct:]]", " ", text)  # Remove punctuation
text <- gsub("[ |\t]{2,}", " ", text)  # Remove tabs
text <- gsub("^ ", "", text)  # Leading blanks
text <- gsub(" $", "", text)  # Lagging blanks
text <- gsub(" +", " ", text) # General spaces (should just do all whitespaces no?)
text <- gsub("\n", " ", text)

for(is in 1:length(text)){
  write(text[is], file=fileConn,append=TRUE)
}
close(fileConn)


fileConn<-file(paste0(fileName,"-C2.txt"), 'w')
text<-users_text_train2$text
text <- unique(text)
text <- gsub("RT", " ", text)  # Remove the "RT" (retweet) so duplicates are duplicates
text <- gsub("@\\w+", " ", text)  # Remove user names (all proper names if you're wise!)
text <- gsub("http.+ |http.+$", " ", text)  # Remove links
text <- gsub("[[:punct:]]", " ", text)  # Remove punctuation
text <- gsub("[ |\t]{2,}", " ", text)  # Remove tabs
text <- gsub("^ ", "", text)  # Leading blanks
text <- gsub(" $", "", text)  # Lagging blanks
text <- gsub(" +", " ", text) # General spaces (should just do all whitespaces no?)
text <- gsub("\n", " ", text)

for(is in 1:length(text)){
  write(text[is], file=fileConn,append=TRUE)
}
close(fileConn)