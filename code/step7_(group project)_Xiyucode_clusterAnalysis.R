# step7_(group project)_Xiyucode_clusterAnalysis
# description: analyze time lag in each cluster

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# source file
source("code/step6_(group project)_Xiyucode_clusterAssignment.R")

# compute the average paper year in each cluster
# inCitation
FDR_in %>% 
  group_by(cluster_in) %>% 
  mutate(year_avg = mean(year)) %>% 
  select(year_avg) %>% 
  unique()

# outCitation
FDR_out %>% 
  group_by(cluster_out) %>% 
  mutate(year_avg = mean(year)) %>% 
  select(year_avg) %>% 
  unique()

