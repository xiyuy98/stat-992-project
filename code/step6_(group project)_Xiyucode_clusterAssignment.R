# step6_(group project)_Xiyucode_clusterAssignment
# description: assign each FDR paper to a cluster; recover the original paper 
#              information in each cluster; combine paper info with cluster info

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# source file
# rm(list=ls())
source("code/step3_(group project)_Xiyucode_adjacencyMatrix_outcitations.R")
source("code/step3_(group project)_Xiyucode_adjacencyMatrix_incitations.R")
source("code/step4_(group project)_Xiyucode_vsp.R")

# inCitation
# remove zeros from matrix, fa_in$Z
Z_in <- fa_in$Z[apply(fa_in$Z, 1, function(x) !all(x==0)),]

# extract the cluster assignment of each FDR paper based on its vsp loadings 
# Q: how to find mixed-membership?
cluster_in <- apply(Z_in, 1, which.max) ## cluster number
cluster_in %>% table() ## the number of papers in each cluster
loading_in <- apply(Z_in, 1, max) ## max loading of each paper

# find corresponding FDR papers in the inCitation matrix
rownames(Z_in) <- as.numeric(gsub("row", "", rownames(Z_in)))

FDR_in <- edgeList_in %>% 
  select(id) %>% 
  unique() %>% 
  left_join(identifiers_in, by=c("id"="identifier_in")) %>% 
  rename(identifier = id, id = id.y) %>% 
  left_join(df, by="id")

FDR_in <- FDR_in[rownames(Z_in),] ## extract papers with non-zero loadings.

# combine original FDR paper info with cluster info
FDR_in <- FDR_in %>% 
  cbind(cluster_in) %>% 
  cbind(loading_in)

# outCitation
# remove zeros from matrix, fa_out$Z
Z_out <- fa_out$Z[apply(fa_out$Z, 1, function(x) !all(x==0)),]

# extract the cluster assignment of each FDR paper based on its vsp loadings 
# Q: how to find mixed-membership?
cluster_out <- apply(Z_out, 1, which.max) ## cluster number
cluster_out %>% table ## the number of papers in each cluster
loading_out <- apply(Z_out, 1, max) ## max loading of each paper

# find corresponding FDR papers in the outCitation matrix
rownames(Z_out) <- as.numeric(gsub("row", "", rownames(Z_out)))

FDR_out <- edgeList_out %>% 
  select(id) %>% 
  unique() %>% 
  left_join(identifiers_out, by=c("id"="identifier_out")) %>% 
  rename(identifier = id, id = id.y) %>% 
  left_join(df, by="id")

FDR_out <- FDR_out[rownames(Z_out),] ## extract papers with non-zero loadings.

# combine original FDR paper info with cluster info
FDR_out <- FDR_out %>% 
  cbind(cluster_out) %>% 
  cbind(loading_out)