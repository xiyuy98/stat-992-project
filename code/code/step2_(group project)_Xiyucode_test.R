# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# packages
library(dplyr)

# test1
addThis = "00000"
addThis = tibble(addThis)
X = addThis
addThis = as.character(list("1", "2"))
addThis
addThis = tibble(addThis)
X = add_row(X, addThis)
X

# test2
addThis = paste(list('A', 'B'), collapse='; ')
addThis = tibble(addThis)

# test3 outCitations
dat_test = readRDS("data/dat_test.rds")
dat_test %>% 
