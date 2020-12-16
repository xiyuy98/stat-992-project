# step3_(group project)_Xiyucode_firstFDRPaper

# remove all
rm(list = ls())

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# package
library(dplyr)
library(tidytext)

# read in data
files <- list.files(path = "data/FDR_000_180)", pattern = "*.csv", full.names = T)
df <- as.list(seq_len(length(files)))
for (i in 1:length(files)){
  data = read.csv(files[i])
  df[[i]] = data
}
df = do.call(rbind,df)

# find the first published FDR paper
firstPaper_id <- "fcef2258a963f3d3984a486185ddc4349c43aa35" 
firstPaper <- df %>% filter(id == firstPaper_id) ## Benjamini & Hochberg

# unnest the inCitations
firstPaper_inCit <- as.data.frame(firstPaper$inCitation) %>% 
  rename(inCitation = `firstPaper$inCitation`) %>% 
  select(inCitation) %>% 
  unnest_tokens(word, inCitation) %>% 
  rename(inCitation = word) ## 41615 in-citations in total

# save the inCitations of first published FDR paper into a RDS file
saveRDS(firstPaper_inCit, file = "data/firstPaper_inCit.RDS")
