# step3_(group project)_Xiyucode_adjacencyMatrix_incitations

# remove all
# rm(list = ls())

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
df %>% filter(inCitation=="") %>% count()

# check how many only contains one or two inCitations
few_inCit <- df %>% 
  select(id,inCitation) %>% 
  unnest_tokens(word,inCitation) %>% 
  group_by(id) %>% 
  count() %>% 
  filter(n<=5)

# create identifiers for all the paper id (FDR paper + inCitation paper)
inCitations = df %>% 
  select(inCitation) %>% 
  unnest_tokens(word, inCitation) %>% 
  rename(id = word) ## select all the inCitation paper id

paper_ids = df %>% 
  select(id) %>% 
  rbind(inCitations) %>% 
  unique() ## select all the FDR paper id in the abstract network and rbind with inCitation paper id

identifiers_in = paper_ids %>% 
  mutate(identifier_in = 1:nrow(paper_ids)) ## create identifiers

# create an edge list, mapping each FDR paper to its inCitation paper
edgeList_in = df %>% 
  select(id, inCitation) %>% 
  unnest_tokens(word, inCitation) %>% 
  rename(inCitation = word) %>% 
  left_join(identifiers_in, by = "id") %>% 
  select(identifier_in, inCitation) %>% 
  rename(id = identifier_in) ## change all FDR paper ids to identifiers

edgeList_in = edgeList_in %>% 
  left_join(identifiers_in, by=c("inCitation" = "id")) %>% 
  select(id, identifier_in) %>% 
  rename(inCitation = identifier_in) ## change all inCitation paper ids to identifiers.

# adjacency matrix
adjMatrix = cast_sparse(edgeList_in, id, inCitation)

# save adjacency matrix as rds file
saveRDS(adjMatrix, file = "data/incitation_adjMatrix_new.rds")
saveRDS(identifiers_in, file = "data/identifiers_in_new.rds")
