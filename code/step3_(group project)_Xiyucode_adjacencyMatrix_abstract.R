# step3_(group project)_Xiyucode_adjacencyMatrix_abstracts

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# packages
library(dplyr)
library(readr)
library(tidyverse)
library(tidytext)
data(stop_words)

# read in data
files <- list.files(path = "data/fdr", pattern = "*.csv", full.names = T)
df <- as.list(seq_len(length(files)))
for (i in 1:length(files)){
  data = read.csv(files[i])
  df[[i]] = data
}
df = do.call(rbind,df)

# identifier
abstracts = df %>% 
  select(abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  anti_join(stop_words) %>% 
  rename(id = word)

paper_ids = df %>% 
  select(id) %>% 
  rbind(abstracts) %>% 
  unique()

identifiers = paper_ids %>% 
  mutate(identifier = 1:nrow(paper_ids))

# edge list
edgeList = df %>% 
  select(id, abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  rename(abstract = word) %>% 
  left_join(identifiers, by = "id") %>% 
  select(identifier, abstract) %>% 
  rename(id = identifier)

# adjacency matrix
adjMatrix = cast_sparse(edgeList, id, abstract)

# save adjacency matrix as rds file
saveRDS(adjMatrix, file = "data/abstract_adjMatrix.rds")
