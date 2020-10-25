# this file gives a function for scanning through the raw data:
#   processDataFiles(includeLine, processLine, outputPath)
# includeLine and processLine are functions. 
# if x is a line of data, then includeLine(x) is a boolian 
#    to denote whether this line should be processed.
# if true, then processLine(x) is written to a new line of 
#    data/outputPath/xxx.txt
#  where xxx is the name of the file from which x was drawn.


# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

library(tidyverse)
source("code/step2_(group project)_Karlcode_getLine.R")

processDataFiles = function(includeLine, processLine, outputPath){
  
  dir.create(paste0("data/",outputPath))
  howManyRows = 0
  filenames = read_csv("raw/manifest.txt")  %>% pull  
  for(datfile in filenames) howManyRows = howManyRows+processOneDataFile(datfile, includeLine, processLine, outputPath)
  
  cat(howManyRows, file  =  paste0("data/", outputPath,"/howManyRows.txt"))
  return(howManyRows)
}




processOneDataFile = function(datfile,includeLine, processLine, outputPath){
  
  in.con = paste0("raw/", datfile) %>% file("r")
  tick = 0
  firstLine = TRUE
  while(tick < 200001){ #Xiyu: process 200000 lines
    tick = tick +1
    if(tick%in% c(1, 10000,100000,500000)) print(paste0(datfile, log10(tick)))
    x = getLine(in.con); 
    if(x[1] == "THIS IS THE ERROR STRING RETURNED"){
      print(paste(datfile, "terminated early, at line", tick))
      break
    }
    if(includeLine(x)){
      addThis = processLine(x) 
      if(firstLine){ #initiate data tibble
        X = tibble() #Xiyu: create an empty tibble to avoid error: object 'X' not found
        X = tibble(addThis)
        firstLine = F
      }else{
        X = add_row(X, addThis)
      }
    }
  }
  close(in.con)
  if(!nrow(X)==0){ #Xiyu: if X did not add any row, the following code won't run
    write_csv(X, path= paste0("data/", outputPath,"/", datfile))
  }
  return(nrow(X))
}

readNoNames = function(fileName) read_csv(fileName, col_names = F)

pullDataFiles = function(outputPath, checkSize = T){
  x = ""
  files<-list.files(paste0("data/",outputPath),full.names = T)
  if(checkSize){ 
    vect_size <- sapply(files, file.size)
    print(paste("total size on disc in mb:",sum(vect_size)/10^6,".  enter any character to cancel."))
    x = scan()
  }
  if(length(x) >0) break
  
  
  files = files[grepl("s2-corpus", files)]
  tmp = lapply(X = files, function(x) FUN = read_csv(file = x))
  do.call(rbind, tmp)
}


# ### TEST:
#
# includeLine= function(x) TRUE
# processLine = function(x) tibble("title" = x$title)
# outputPath = "test"
# processDataFiles(includeLine, processLine, outputPath)

# dat = pullDataFiles(outputPath)  # some rows are missing!  what's up with that?
# Encoding(dat$title) <- "ASCII"
