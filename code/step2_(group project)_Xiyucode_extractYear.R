# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

library(tidyverse)
source("code/step2_(group project)_Karlcode_getData.R")

start_time = Sys.time()

includeLine = function(x) {return(T)}

processLine = function(x) tibble(year = x$year)

outputPath = "Year"
processDataFiles(includeLine, processLine, outputPath)

# tryCatch(
#   {
#     message("This is the 'try' part")
#     processDataFiles(includeLine, processLine, outputPath)
#   },
#   error=function(cond) {
#     message("Here's the original error message:")
#     message(paste0(cond, "\n"))
#     # Choose a return value in case of error
#     # return(NA)
#   },
#   warning=function(cond) {
#     message("Here's the original warning message:")
#     message(paste0(cond, "\n"))
#     # Choose a return value in case of warning
#     # return(NULL)
#   },
#   finally={
#   }
# )

end_time = Sys.time()

print(paste0("total time: ", end_time-start_time))

dat = pullDataFiles(outputPath)