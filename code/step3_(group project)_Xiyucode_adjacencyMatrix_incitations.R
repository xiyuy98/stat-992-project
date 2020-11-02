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

# identifier
inCitations = df %>% 
  select(inCitation) %>% 
  unnest_tokens(word, inCitation) %>% 
  rename(id = word)

paper_ids = df %>% 
  select(id) %>% 
  rbind(inCitations) %>% 
  unique()

identifiers = paper_ids %>% 
  mutate(identifier = 1:nrow(paper_ids))

# edge list
edgeList = df %>% 
  select(id, inCitation) %>% 
  unnest_tokens(word, inCitation) %>% 
  rename(inCitation = word) %>% 
  left_join(identifiers, by = "id") %>% 
  select(identifier, inCitation) %>% 
  rename(id = identifier)

edgeList = edgeList %>% 
  left_join(identifiers, by=c("inCitation" = "id")) %>% 
  select(id, identifier) %>% 
  rename(inCitation = identifier)

# adjacency matrix
adjMatrix = cast_sparse(edgeList, id, inCitation)

# save adjacency matrix as rds file
saveRDS(adjMatrix, file = "data/incitation_adjMatrix.rds")
