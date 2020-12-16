# This code is to do the aggregation by clusters

library(igraph)
library(dplyr)

data = read.csv("FDR_abs.csv")

nclu = max(data$cluster_out)



rownames(data) <- 1:length(data$identifier)

outCitations = data %>% 
  select(outCitation) %>% 
  unnest_tokens(word, outCitation) %>% 
  rename(id = word)

idlist = data$id
count=0
for(i in 1:length(outCitations$id))
{
  if(outCitations$id[i]%in%idlist)
  {
    outCitations$id[i]=which(idlist == outCitations$id[i])
    count = count+1}else
      outCitations$id[i]=NA
    if((i %% 10000)==0)
      print(i)
}
outCitations=na.omit(outCitations)

colum = c()
for(i in 1:length(outCitations$id)){
  if(is.na(str_locate(rownames(outCitations)[i],'[.]')[1]))
    colum[i]=rownames(outCitations)[i]
  else
    colum[i]=str_sub(rownames(outCitations)[i],1,str_locate(rownames(outCitations)[i],'[.]')[1]-1)
}

edges = cbind(colum,outCitations)
adj = cast_sparse(edges,colum,outCitations)

adj2 = matrix(0,nclu,nclu)

for(i in 1:adj@Dim[1])
{
  for(j in 1:adj@Dim[2]){
    if(adj[i,j]==1)
    {
      col = adj@Dimnames[[1]][i]
      row = adj@Dimnames[[2]][j]
      clu1 = data$cluster_out[as.integer(col)]
      clu2 = data$cluster_out[as.integer(row)]
      adj2[clu1,clu2]=adj2[clu1,clu2]+1
    }
  }
  if(i%%100==0)
    print(i)
}

t = 0.05
adj3 = adj2
for(i in 1:nclu){
  for(j in 1:nclu){
    if(adj2[i,j]<t*rowSums(adj2)[i]){
      adj3[i,j]=0
    }
  }
}

for(i in 1:nclu)
  adj3[i,i]=0

num1clu2 = rep(0,nclu)
for(i in 1:nclu){
  num1clu2[i] = sum(data$cluster_out==i)
}
size = num1clu2/50
g = graph.adjacency(adj3,weighted = TRUE)
edgelabel = as.character(t(adj3))
edgelabel = edgelabel[-which(edgelabel=="0")]
set.seed(0)
plot(g,edge.label = edgelabel,vertex.size = size,
     vertex.label=1:nclu,
     vertex.color = 1:nclu,
     edge.arrow.size=0.5
     )


