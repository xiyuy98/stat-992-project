# step3_(group project)_Xiyucode_adjacencyMatrix_abstracts

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# packages
library(dplyr)
library(readr)
library(tidyverse)
library(tidytext)
library(SnowballC)
data(stop_words)

# read in data
files <- list.files(path = "data/FDR_000_180", pattern = "*.csv", full.names = T)
df <- as.list(seq_len(length(files)))
for (i in 1:length(files)){
  data = read.csv(files[i])
  df[[i]] = data
}
df = do.call(rbind,df)

# identifier
paper_ids = df %>% 
  select(id) %>% 
  unique()

identifiers = paper_ids %>% 
  mutate(identifier = 1:nrow(paper_ids))

# edge list
df$abstract = str_replace_all(df$abstract, "[:digit:]", "")

edgeList = df %>% 
  select(id, abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  anti_join(stop_words) %>% 
#  mutate(word = wordStem(word)) %>% 
  rename(abstract = word) %>% 
  left_join(identifiers, by = "id") %>% 
  select(identifier, abstract) %>% 
  rename(id = identifier)

# adjacency matrix
adjMatrix = cast_sparse(edgeList, id, abstract)

# save adjacency matrix as rds file
saveRDS(adjMatrix, file = "data/abstract_adjMatrix_new.rds")
