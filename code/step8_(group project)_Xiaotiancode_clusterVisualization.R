# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# package
library(igraph)
library(dplyr)

data = read.csv("data/fdr_out.csv")

nclu = max(data$cluster_out)


Sampling <- function(data, method, alpha,num){
  nclu = max(data$cluster_out)
  
  # Method 1
  num1clu1 = rep(num,nclu)
  
  # Method 2
  num1clu2 = rep(0,nclu)
  for(i in 1:nclu){
    num1clu2[i] = sum(data$cluster_out==i)
  }
  num1clu2 = as.integer(num1clu2*alpha)
  
  if(method==1)
    num1clu = num1clu1
  else
    num1clu=num1clu2
  
  new_data = tibble()
  for(i in 1:nclu)
  {
    this_cluster = data[which(data$cluster_out==i),]
    temp = arrange(this_cluster,desc(this_cluster$loading_out))
    thresh = temp$loading_out[num1clu[i]]
    this_cluster = this_cluster[which(this_cluster$loading_out>=thresh),]
    new_data = rbind.data.frame(new_data,this_cluster)
  }
  
  return(new_data)
}

data = Sampling(data, method=2, alpha=0.2, num=50)


n = length(data$id)




adj = matrix(0,n,n)
# colnames(adj) = data$title
# rownames(adj) = data$title

for(i in 1:n){
  for(j in 1:n){
    if(grepl(data$id[i],data$outCitation[j]))
      adj[i,j]=1
  }
  if((i %% 100)==0)
    print(i)
}

set.seed(0)

G = graph.adjacency(adjmatrix = adj,mode="undirected")
plot(G,
     vertex.label = NA,
     # vertex.label = data$cluster_out,
     vertex.color = data$cluster_out,
     vertex.size = 8,
     width = 3
)



# Show by year


plotYear <- function(year,data,G){
  
  showThem = (data$year<=year)*7
  noshowThem = (data$year>year)*3
  Show = showThem+noshowThem
  set.seed(0)
  plot(G,
       vertex.label = NA,
       # vertex.label = data$cluster_out,
       vertex.color = data$cluster_out,
       vertex.size = Show,
       #vertex.shapes=Show,
       width = 3
  )
}
yearlist = c(2008,2010,2012,2014,2016,2018,2020)

for(year in yearlist){
  plotYear(year,data,G)
}




