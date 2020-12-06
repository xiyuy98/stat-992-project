# remove all
rm(list = ls())

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

library(tidyverse)
source("code/step2_(group project)_Karlcode_getData.R")

start_time = Sys.time()

# method 1 (Error: Internal error in `vec_proxy_assign_opts()`: `proxy` of type `double` incompatible with `value` proxy of type `NULL`)
# firstPaper_id <- "fcef2258a963f3d3984a486185ddc4349c43aa35"
# return(firstPaper_id %in% x$outCitation)

# method 2 (Super Slow)
# firstPaper_inCit <- readRDS(file = "data/firstPaper_inCit.RDS")
# inCit <- firstPaper_inCit$inCitation
# inCit <- paste(inCit, collapse = "; ")
# if (x$id == 0) return(F)
# grepl(x$id, inCit)

# method 3 (Error: Internal error in `vec_proxy_assign_opts()`: `proxy` of type `double` incompatible with `value` proxy of type `NULL`)
# firstPaper_inCit <- readRDS(file = "data/firstPaper_inCit.RDS")
# inCit <- firstPaper_inCit$inCitation
# return(x$id %in% inCit)

includeLine = function(x) {
  
}

processLine = function(x) tibble(
  id = x$id,
  title = x$title,
  abstract = x$paperAbstract,
  year = x$year,
  field = paste(x$fieldsOfStudy, collapse='; '),
  author = paste(x$authors, collapse='; '),
  inCitation = paste(x$inCitations, collapse='; '),
  outCitation = paste(x$outCitations, collapse='; '),
  journalName = x$journalName,
  journalVolume = x$journalVolume,
  journalPages = x$journalPages)

outputPath = "FDR_000_001"
processDataFiles(includeLine, processLine, outputPath)

end_time = Sys.time()

print(paste0("total time: ", end_time-start_time))

dat = pullDataFiles(outputPath)