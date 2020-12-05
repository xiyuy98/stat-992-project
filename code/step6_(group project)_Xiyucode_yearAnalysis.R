# step6_(group project)_Xiyucode_yearAnalysis

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# packages
library(dplyr)

# read in data
files <- list.files(path = "data/Year", pattern = "*.csv", full.names = T)
year <- as.list(seq_len(length(files)))
for (i in 1:length(files)){
  data = read.csv(files[i])
  data <- data %>% 
    filter(year > 1985) %>% 
    group_by(year) %>% 
    table()
  data = as.data.frame(data)
  names(data) <- c("year", paste0("paperNum", "_file", i))
  year[[i]] = data
}

# combine all data sets in list year into one data set
years = year[[1]]
for (i in 2:length(files)){
  years <- years %>% left_join(year[[i]])
}

# calculate the average paper number and its standard deviation of each year
years$paperNum_mean = rowMeans(years[,-1])
years$paperNum_sd = apply(years[, 2:20], 1, sd, na.rm = TRUE)
years$paper_ratio = years$paperNum_sd/years$paperNum_mean ## compute the ratio of standard deviation/mean
max(years$paper_ratio, na.rm = TRUE)
