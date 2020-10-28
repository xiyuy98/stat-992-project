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
  includedLine = 0
  X <- as.list(seq_len(100)) #Xiyu: How many lines do you expect in each file? ## Strategy: add more lines than needed
  while(1){ #Xiyu: process 200000 lines
    tick = tick + 1
    if(tick%in% c(1, 10000,100000,500000,1000000)) print(paste0(datfile, log10(tick)))
    x = getLine(in.con); # slow?
    if(x[1] == "THIS IS THE ERROR STRING RETURNED"){
      print(paste(datfile, "terminated early, at line", tick))
      break
    }
    if(includeLine(x)){
      includedLine = includedLine + 1
      X[[includedLine]] = processLine(x)
    }
  }
  X <- X[1:includedLine] # Delete the unused elements in X
  X <- do.call(rbind,X)
  close(in.con)
  if(!includedLine==0){ #Xiyu: if X did not add any row, the following code won't run
    write_csv(X, file = paste0("data/", outputPath,"/", datfile, ".csv"))
  }
  return(includedLine)
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
