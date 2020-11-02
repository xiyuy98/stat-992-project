# step4_(group project)_Xiyucode_vsp

# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# packages
library(data.table)
library(tidyverse)
library(tidytext)
library(Matrix)
# devtools::install_github("RoheLab/vsp")
library(vsp)

# read in data
A_out = readRDS("data/outcitation_adjMatrix.rds")
A_in = readRDS("data/incitation_adjMatrix.rds")

# inspect data
A_out = A_out[, cs > 5]
A_out[1:5,1:10]
str(A_out)
dim(A_out)
hist(rowSums(A_out))
cs = colSums(A_out)
hist(log10(cs[cs>1]))

A_in[1:5,1:10]
str(A_in)
dim(A_in)
hist(rowSums(A_in))
cs = colSums(A_in)
hist(log(cs[cs>1]))

# apply vsp
fa_out = vsp(A_out, rank = 10, scale = TRUE, rescale = FALSE)
plot_varimax_z_pairs(fa_out, 1:10)

fa_in = vsp(A_in, rank = 30)
plot_varimax_z_pairs(fa_in, 1:10)

# d
plot(fa_out$d)
plot(fa_out$U[,1])
str(fa_out)
plot(fa_out$u[,1])
plot(fa_out$u[,2])
max(A_out@x)