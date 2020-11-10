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
A_abs = readRDS("data/abstract_adjMatrix.rds")

# inspect data
cs_out = colSums(A_out)
A_out = A_out[, cs_out > 5]
A_out[1:5,1:10]
str(A_out)
dim(A_out)
hist(rowSums(A_out))
hist(log10(cs_out[cs_out>1]))

cs_in = colSums(A_in)
A_in = A_in[, cs_in > 5]
A_in[1:5,1:10]
str(A_in)
dim(A_in)
hist(rowSums(A_in))
hist(log(cs_in[cs_in>1]))

cs_abs = colSums(A_abs)
A_abs = A_abs[, cs_abs > 5]
A_abs[1:5,1:10]
str(A_abs)
dim(A_abs)
hist(rowSums(A_abs))
hist(log10(cs_abs[cs_abs>1]))

# apply vsp
fa_out = vsp(A_out, rank = 6, scale = TRUE, rescale = FALSE)
plot_varimax_z_pairs(fa_out, 1:6)

fa_in = vsp(A_in, rank = 5, scale = TRUE, rescale = FALSE)
plot_varimax_z_pairs(fa_in, 1:5)

fa_abs = vsp(A_abs, rank = 4, scale = TRUE, rescale = FALSE)
plot_varimax_z_pairs(fa_abs, 1:4)

# diagnostics
plot(fa_out$d)
plot(fa_out$u[,1])
str(fa_out)
plot(fa_out$u[,1])
plot(fa_out$u[,2])
max(A_out@x)

plot(fa_in$d)

plot(fa_abs$d)
