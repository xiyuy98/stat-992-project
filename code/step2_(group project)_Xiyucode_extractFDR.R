# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

library(tidyverse)
source("code/step2_(group project)_Xiyucode_getData.R")

start_time = Sys.time()

includeLine = function(x) {
  if(nchar(x$paperAbstract) == 0) return(F) 
  grepl("false discovery rate", x$paperAbstract) # capitalization? FDR?
}

# 1. inclusion criteria: 1) citations (popular ones); 2) abstract

processLine = function(x) tibble(title = x$title, 
                                 abstract = x$paperAbstract,
                                 year = x$year)
outputPath = "FDR"
processDataFiles(includeLine, processLine, outputPath)

end_time = Sys.time()

print(paste0("total time: ", end_time-start_time))

dat = pullDataFiles(outputPath)