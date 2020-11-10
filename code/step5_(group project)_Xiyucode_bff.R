# step5_(group project)_Xiyucode_bff

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# source file
source("code/step3_(group project)_Xiyucode_adjacencyMatrix_outcitations.R")
source("code/step3_(group project)_Xiyucode_adjacencyMatrix_incitations.R")
source("code/step4_(group project)_Xiyucode_vsp.R")
source("code/sourceCode_bff.R")

# simplify matrix, A_abs, for bff on incitations
id_in = edgeList_in %>% select(id) %>% unique()
id_in = id_in$id
A_abs_in = A_abs[id_in, ]

# apply bff on inCitation adjacency matrix
keypapers_in = bff(fa_in$Z, A_abs_in, 20) %>% t ## cluster by rows (fa$Z)
keypapers_in %>% t %>% View

# simplify matrix, A_abs, for bff on outcitations
id_out = edgeList_out %>% select(id) %>% unique()
id_out = id_out$id
A_abs_out = A_abs[id_out, ]

# apply bff on outCitation adjacency matrix
keypapers_out = bff(fa_out$Z, A_abs_out, 25) %>% t ## cluster by rows (fa$Z)
keypapers_out %>% t %>% View
