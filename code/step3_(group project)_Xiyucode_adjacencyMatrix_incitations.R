# step3_(group project)_Xiyucode_adjacencyMatrix_incitations

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# packages
library(dplyr)
library(readr)
library(tidyverse)
library(tidytext)

# read in data
files <- list.files(path = "data/fdr", pattern = "*.csv", full.names = T)
df <- as.list(seq_len(length(files)))
for (i in 1:length(files)){
  data = read.csv(files[i])
  df[[i]] = data
}
df = do.call(rbind,df)

# identifier_in
inCitations = df %>% 
  select(inCitation) %>% 
  unnest_tokens(word, inCitation) %>% 
  rename(id = word)

paper_ids = df %>% 
  select(id) %>% 
  rbind(inCitations) %>% 
  unique()

identifiers_in = paper_ids %>% 
  mutate(identifier_in = 1:nrow(paper_ids))

# edge list
edgeList_in = df %>% 
  select(id, inCitation) %>% 
  unnest_tokens(word, inCitation) %>% 
  rename(inCitation = word) %>% 
  left_join(identifiers_in, by = "id") %>% 
  select(identifier_in, inCitation) %>% 
  rename(id = identifier_in)

edgeList_in = edgeList_in %>% 
  left_join(identifiers_in, by=c("inCitation" = "id")) %>% 
  select(id, identifier_in) %>% 
  rename(inCitation = identifier_in)

# adjacency matrix
adjMatrix = cast_sparse(edgeList_in, id, inCitation)

# save adjacency matrix as rds file
saveRDS(adjMatrix, file = "data/incitation_adjMatrix.rds")
saveRDS(identifiers_in, file = "data/identifiers_in.rds")
