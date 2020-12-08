# step7_(group project)_Shuqicode_citationOverYear
# description: analyze time lag in each cluster

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# source file
source("code/step6_(group project)_Xiyucode_clusterAssignment.R")

#split data with different clusters
library(ggplot2)
years <- readRDS("data/years.RDS")
paper_in_year<-years$paperNum_mean*187
#par(mfrow=c(4,2))
v = df$year
for(i in 1995:2018) {
  c[i-1994] <- length(v[v==i])/paper_in_year[i-1994]
}

year=1995:2018
total<-qplot(year, c, xlab="year",ylab="The frequence",geom="line")

d=matrix(nrow=5,ncol=2018-1994)
for(i in 1:5){
  g<-0
  g<-FDR_out[ which(FDR_out$cluster_out==i),]
  v = g$year
  for(j in 1995:2018) {
    d[i,j-1994] <- length(v[v==j])/paper_in_year[j-1994]
  }
}

d.df<-data.frame(year=1995:2018, cluster_1=d[1,],
                 cluster_2=d[2,],
                 cluster_3=d[3,],
                 cluster_4=d[4,],
                 cluster_5=d[5,])

#d.df <- as.data.frame(d)
p1<-ggplot(data=d.df,aes(x=year,y=cluster_1)) +
  geom_line()+ylim(0,5e-5)

p2<-ggplot(data=d.df,aes(x=year,y=cluster_2)) +
  geom_line()+ylim(0,5e-5)

p3<-ggplot(data=d.df,aes(x=year,y=cluster_3)) +
  geom_line()+ylim(0,5e-5)

p4<-ggplot(data=d.df,aes(x=year,y=cluster_4)) +
  geom_line()+ylim(0,5e-5)

p5<-p2<-ggplot(data=d.df,aes(x=year,y=cluster_5)) +
  geom_line()+ylim(0,5e-5)

# p6<-ggplot(data=d.df,aes(x=year,y=cluster_6)) +
#   geom_line()+ylim(0,5e-5)
# 
# p7<-ggplot(data=d.df,aes(x=year,y=cluster_7)) +
#   geom_line()+ylim(0,5e-5)

multiplot(total,p1, p2, p3, p4,p5, cols=2)

#year=1995:2018
#qplot(year, d[1,], xlab="Years",ylab="The counts of paper",ylim=c(1,150),geom="line")
#par(new=TRUE)


multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
