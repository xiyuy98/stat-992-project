# step3_(group project)_Xiyucode_adjacencyMatrix

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
outCitations = df %>% 
  select(outCitation) %>% 
  unnest_tokens(word, outCitation) %>% 
  rename(id = word)

paper_ids = df %>% 
  select(id) %>% 
  rbind(outCitations) %>% 
  unique()

identifiers = paper_ids %>% 
  mutate(identifier = 1:nrow(paper_ids))

# edge list
edgeList = df %>% 
  select(id, outCitation) %>% 
  unnest_tokens(word, outCitation) %>% 
  rename(outCitation = word) %>% 
  left_join(identifiers, by = "id") %>% 
  select(identifier, outCitation) %>% 
  rename(id = identifier)

edgeList = edgeList %>% 
  left_join(identifiers, by=c("outCitation" = "id")) %>% 
  select(id, identifier) %>% 
  rename(outCitation = identifier)

# adjacency matrix
adjMatrix = cast_sparse(edgeList, id, outCitation)

# save adjacency matrix as rds file
saveRDS(adjMatrix, file = "data/outcitation_adjMatrix.rds")
