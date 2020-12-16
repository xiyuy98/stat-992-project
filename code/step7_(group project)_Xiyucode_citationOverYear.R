# set working directory
setwd("C:/Users/Xiyu/Desktop/Xiyu's Folder/2020 Fall/Stat 992")

# source file
source("code/step6_(group project)_Xiyucode_clusterAssignment.R")

# package
library(ggplot2)
require(scales)

# read in data
years <- readRDS("data/years.RDS")
years$paperNum_total <- years$paperNum_mean*187

# years for FDR papers
FDR_years <- years %>% 
  filter(year %in% c("1995":"2019")) %>% 
  select(year, paperNum_total)
FDR_years$year = c(1995:2019)

# multiplot function created by Shuqi
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


## inCitation network
# combine FDR_out with FDR_years
# total
citYear_total_out <- FDR_out %>% 
  filter(year %in% c(1995:2019)) %>% 
  select(year) %>% 
  group_by(year) %>%
  count() %>% 
  left_join(FDR_years, by="year") %>% 
  mutate(ratio = n/paperNum_total)

# each cluster
citYear_out <- FDR_out %>% 
  filter(year %in% c(1995:2019)) %>% 
  select(year, cluster_out) %>% 
  group_by(cluster_out, year) %>%
  count() %>% 
  left_join(FDR_years, by="year") %>% 
  mutate(ratio = n/paperNum_total)

# visualization
total <- ggplot(data=citYear_total_out, aes(x=year, y=ratio)) + 
  geom_line() +    
  scale_y_log10(limits = c(1e-6,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the overall FDR citation change over time (outCitation network)")

p1<-ggplot(data=citYear_out %>% filter(cluster_out == 1),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Gene Expression)") 

p2<-ggplot(data=citYear_out %>% filter(cluster_out == 2),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Neuroscience)") 

p3<-ggplot(data=citYear_out %>% filter(cluster_out == 3),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Population Genetics)") 

p4<-ggplot(data=citYear_out %>% filter(cluster_out == 4),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Microbiology)") 

p5<-ggplot(data=citYear_out %>% filter(cluster_out == 5),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Hypothesis Testing)") 

multiplot(p1, p2, p3, p4, p5, cols=2)

## inCitation network
# combine FDR_in with FDR_years
# total
citYear_total_in <- FDR_in %>% 
  filter(year %in% c(1995:2019)) %>% 
  select(year) %>% 
  group_by(year) %>%
  count() %>% 
  left_join(FDR_years, by="year") %>% 
  mutate(ratio = n/paperNum_total)

# each cluster
citYear_in <- FDR_in %>% 
  filter(year %in% c(1995:2019)) %>% 
  select(year, cluster_in) %>% 
  group_by(cluster_in, year) %>%
  count() %>% 
  left_join(FDR_years, by="year") %>% 
  mutate(ratio = n/paperNum_total)

# visualization
total_in <- ggplot(data=citYear_total_in, aes(x=year, y=ratio)) + 
  geom_line() +
  scale_y_log10(limits = c(1e-7,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the overall FDR citation change over time (inCitation network)")

p1<-ggplot(data=citYear_in %>% filter(cluster_in == 1),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-4)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Hypothesis Testing)") 

p2<-ggplot(data=citYear_in %>% filter(cluster_in == 2),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-4)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Feature Engineering)") 

p3<-ggplot(data=citYear_in %>% filter(cluster_in == 3),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-4)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Gene Expression)") 

p4<-ggplot(data=citYear_in %>% filter(cluster_in == 4),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-4)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Neuroscience)") 

p5<-ggplot(data=citYear_in %>% filter(cluster_in == 5),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-4)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Digestive Physiology)") 

p6<-ggplot(data=citYear_in %>% filter(cluster_in == 6),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-4)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Radiology)") 

p7<-ggplot(data=citYear_in %>% filter(cluster_in == 7),aes(x=year,y=ratio)) +
  geom_line() + 
  scale_y_log10(limits = c(1e-7,1e-4)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the FDR citation change over time (Vinification/Wine Making)") 

multiplot(p1, p2, p3, p4, p5, p6, p7, cols=2)
