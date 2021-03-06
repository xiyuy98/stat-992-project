# step3_(group project)_Xiyucode_adjacencyMatrix_outcitations

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# source file
source("code/step3_(group project)_Xiyucode_adjacencyMatrix_abstract.R")

# packages
library(dplyr)
library(readr)
library(tidyverse)
library(tidytext)

# read in data
files <- list.files(path = "data/FDR_000_180", pattern = "*.csv", full.names = T)
df <- as.list(seq_len(length(files)))
for (i in 1:length(files)){
  data = read.csv(files[i])
  df[[i]] = data
}
df = do.call(rbind,df)

abstract_ids <- edgeList$id %>% unique()
abstract_ids <- as.data.frame(abstract_ids)
abstract_ids <- abstract_ids %>% 
  left_join(identifiers, by=c("abstract_ids"="identifier")) %>% 
  select(id) ## find out papers included in the abstract network

df <- abstract_ids %>% left_join(df)

# check missing data
df %>% filter(outCitation=="") %>% count()

# check how many only contains one or two outCitations
few_outCit <- df %>% 
  select(id,outCitation) %>% 
  unnest_tokens(word,outCitation) %>% 
  group_by(id) %>% 
  count() %>% 
  filter(n<=5)

# identifier
outCitations = df %>% 
  select(outCitation) %>% 
  unnest_tokens(word, outCitation) %>% 
  rename(id = word)

paper_ids = df %>% 
  select(id) %>% 
  rbind(outCitations) %>% 
  unique()

identifiers_out = paper_ids %>% 
  mutate(identifier_out = 1:nrow(paper_ids))

# edge list
edgeList_out = df %>% 
  select(id, outCitation) %>% 
  unnest_tokens(word, outCitation) %>% 
  rename(outCitation = word) %>% 
  left_join(identifiers_out, by = "id") %>% 
  select(identifier_out, outCitation) %>% 
  rename(id = identifier_out)

edgeList_out = edgeList_out %>% 
  left_join(identifiers_out, by=c("outCitation" = "id")) %>% 
  select(id, identifier_out) %>% 
  rename(outCitation = identifier_out)

# adjacency matrix
adjMatrix = cast_sparse(edgeList_out, id, outCitation)

# save adjacency matrix as rds file
saveRDS(adjMatrix, file = "data/outcitation_adjMatrix_new.rds")
saveRDS(identifiers_out, file = "data/identifiers_out_new.rds")
