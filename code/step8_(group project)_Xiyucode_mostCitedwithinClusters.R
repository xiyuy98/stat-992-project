# step8_(group project)_Xiyucode_mostCitedwithinClusters.R

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# packages
library(dplyr)
library(tidytext)

# read in data
FDR_out <- read.csv(file = "data/fdr_out.csv")
FDR_in <- read.csv(file = "data/fdr_in.csv")

FDR_out <- FDR_out %>% 
  select(-X, -identifier) %>% 
  mutate(identifier = 1:nrow(FDR_out))
FDR_in <- FDR_in %>% 
  select(-X, -identifier)%>% 
  mutate(identifier = 1:nrow(FDR_in))

All_FDR_papers <- FDR_out %>% 
  select(id) %>% 
  rename(word = id)

# count inCitations in each paper
sortInCit_out1 <- FDR_out %>% 
  select(id, cluster_out, inCitation) %>%  
  unnest_tokens(word, inCitation) %>% 
  inner_join(All_FDR_papers) %>% 
  group_by(cluster_out, id) %>% 
  count() ## # of inCitations that cites the influential paper

sortInCit_out2 <- FDR_out %>% 
  select(id, cluster_out, inCitation) %>%  
  unnest_tokens(word, inCitation) %>% 
  anti_join(All_FDR_papers) %>% 
  group_by(cluster_out, id) %>% 
  count() ## # of inCitations that does not cite the influential paper

sortInCit_out <- sortInCit_out1

cluster1_out <- sortInCit_out %>% 
  filter(cluster_out == 1) %>% 
  arrange(desc(n))

# top: Biology
View(FDR_out %>% 
       filter(id == "772f5fca88de0f6f38116d73cc32e23efe780a10"|
              id == "0e2fe165dc627220cc711e1e03b8bea599112884"|
              id == "fa60b6806050255a77699bd0f9f5d824884c5162"))

cluster2_out <- sortInCit_out %>% 
  filter(cluster_out == 2) %>% 
  arrange(desc(n))

# top: Computer Science; Medicine
View(FDR_out %>% 
       filter(id == "f5def76fcebb36c826e17e6f68a5b875c356451b"|
              id == "c83cb156e8812906bf79337032e076f734eb5d80"|
              id == "ece35ca3c934fce37b357231fd1dfe26f65e8c1d"))

cluster3_out <- sortInCit_out %>% 
  filter(cluster_out == 3) %>% 
  arrange(desc(n))

# top: Medicine; Biology
View(FDR_out %>% 
       filter(id == "f7bb8b20c217c81cb446b0bd9c3f6b187de80b6c"|
              id == "38eb73ec8ea218bf1e8dc0e0629339509251c08a"|
              id == "6feecdab4c4cd80ce1d20099fe3e0cafe38f48b4"))

cluster4_out <- sortInCit_out %>% 
  filter(cluster_out == 4) %>% 
  arrange(desc(n))

# top: Medicine; Biology
View(FDR_out %>% 
       filter(id == "247813e9093c48598aabc75b6c1b889b34b097d9"|
              id == "edf68e674840d305cfd64ab4ef76a625a70057d3"|
              id == "22726ca13bef154eff28e508bb2595edf3d91af3"))

cluster5_out <- sortInCit_out %>% 
  filter(cluster_out == 5) %>% 
  arrange(desc(n))

# top: CS, Bio, Math
View(FDR_out %>% 
       filter(id == "dbc447956c16e27cfb030e40552359d3c79bc690"|
              id == "156e7730b8ba8a08ec97eb6c2eaaf2124ed0ce6e"|
              id == "4b6835c8aa28eb6669e9043c7d778efeed918eb0"))

