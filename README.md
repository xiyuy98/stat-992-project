# Diffusion Pattern of False Discovery Rate

Contributors:
- Ying Chen
- Xiaotian Wang
- Xiyu Yang
- Shuqi Yu

Navigation Panel:

+ What is this project about?
+ 

## What is this project about?

This is a class project for Statistics 992 Data Science with Graphs which is taught by Professor Karl Rohe. This project is motivated by the following facts: Many current research on citation networks focus on general citation patterns only in the field of statistics. A good summary of the previous studies are provided by Radicchi, Fortunato, and Vespignani (2012).  However, to our knowledge, very few work (if any) focuses on a specific statistical technique, tracking its citation patterns in different fields of study over time.

In this project, we study the citation patterns of false discovery rate (FDR). We would like to understand the citation changes of Benjamini and Hochberg's FDR paper (1995) over time and across different fields. We name such changes as the paper's diffusion pattern because its influence spreads across the citation network over time. Specifically, we observe whether a time lag appears and compare the time lag difference across research fields. For time lag, we mean whether there exists a gap between the time when the paper was published and when it gained its popularity. We then plot the shape of the citation patterns in each field. We observe that diffusion pattern in one field differs based on the field's closeness to statistics. 

## Data

### Data description

We used the Semantic Scholar's records, which gives information on research papers. The corpus is composed of rich abstracts, bibliographic references, and structured full texts. The full text comes with automatically detected inline citations, figures, and tables. Also, each citation is linked to its corresponding paper. In Semantic Scholar's dataset, papers from hundreds of academic publishers and digital archives are aggregated into a single source. With the well-developed tool, we downloaded and configured the whole dataset with 220 million papers and over 100Gb meta data. They are well prepared, machine-readable academic texts

### Data collection

We used two methods to extract FDR-related papers. For the first method, we picked all research papers that mention FDR in their abstracts. To include all related papers, we used the key phase 'false discovery rate' when scanning through all the abstracts. We brought in eleven columns while extracting the data. The columns are listed below: 

  + paper ID
  + paper title
  + abstract
  + published year
  + fields of study
  + list of author IDs and names
  + list of paper IDs which cited this paper (inCitation)
  + list of paper IDs which this paper cited (outCitation)
  + name of the journal that published this paper
  + the volume of the journal where this paper was published
  + the pages of the journal where this paper was published.

In total, we collected 8,787 papers using this method.

We used the following R code to extract FDR papers. The code is adapted from Professor Karl Rohe's code:

```r
includeLine = function(x) {
  if(nchar(x$paperAbstract) == 0) return(F) 
  grepl("false discovery rate|False Discovery Rate|False discovery rate", x$paperAbstract)
}

processLine = function(x) tibble(
  id = x$id,
  title = x$title,
  abstract = x$paperAbstract,
  year = x$year,
  field = paste(x$fieldsOfStudy, collapse='; '),
  author = paste(x$authors, collapse='; '),
  inCitation = paste(x$inCitations, collapse='; '),
  outCitation = paste(x$outCitations, collapse='; '),
  journalName = x$journalName,
  journalVolume = x$journalVolume,
  journalPages = x$journalPages)

outputPath = "FDR"

processDataFiles(includeLine, processLine, outputPath)
```

For the second method, we extracted all papers which cited Benjamini and Hochberg's FDR paper. If a paper's outCitation contains the id of Benjamini and Hochberg's paper, we would select the paper into our dataset. The code we used are the same as for the first method, except for the includeLine function:

```r
includeLine = function(x) {
  return(firstPaper_id %in% x$outCitation)
}
```

We collected 41067 papers by this method. 

## Analysis

### Overall citation trends by year

We plotted the paper's overall citation trends by year. These trends are extracted and plotted based on the inCitation and outCitation networks. Notice that instead of plotting the paper's citation frequency, we plot the ratios obtained by dividing the number of papers, which is cited by FDR paper, published in a certain year by the total number of published papers in that year. 

![image](/image/citOverYear_total_outCitation_(method2).png)

The code we used to plot the images is displayed here:

```r
ggplot(data=citYear_total_out, aes(x=year, y=ratio)) + 
  geom_line() +    
  scale_y_log10(limits = c(1e-6,1e-3)) +
  xlim(1995, 2020) +
  theme_classic() +
  ggtitle("Plot of the overall FDR citation change over time (outCitation network)")
```

### Citation in different fields

#### Find clusters

To find how many clusters are included in the networks, we applied Vintage Sparse principal component analysis (VSP) to the matrices built from our inCitation and outCitation networks. For example, by applying VSP on the data collected by our second method, we found seven clusters in the inCitation network. 

![image](/image/vsp_in_(method2).png)

The code we used is here:

```r
fa_in = vsp(A_in, rank = 7, scale = TRUE, rescale = FALSE)
plot_varimax_z_pairs(fa_in, 1:7)
```

#### Contextualize clusters

After we decided the number of clusters in each network, we applied the best feature function on the results of VSP and the paper-term matrices obtained by tokenizing abstracts. In this way, we contextualized our data and gave each cluster a name. We present the results of inCitation network obtained by the second data collection method:

For the inCitation network, we named the 7 meaningful clusters as: 

* V1: hypothesis testing
* V2: feature engineering
* V3: gene expression
* V4: neuroscience
* V5: digestive physiology
* V6: radiology
* V7: vinification (wine making)

|V1|V2|V3|V4|V5|V6|V7|
|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
|false|extraction|gene|brain|microbiota|features|fruit|
|discovery|unsupervised|genes|imaging|gut|radiomics|ripening|
|testing|feature|expression|neuroimaging|microbial|imaging|vitis|
|hypotheses|principal|genome|tensor|microbiome|radiomic|berries|
|fdr|component|http|alzheimer's|composition|tumor|grape|
|rate|fe|microarray|mri|bacterial|images|sauvignon|
|procedure|proposed|biological|connectivity|rrna|image|tomato|
|procedures|recently|wide|cognitive|fecal|cancer|cabernet|
|null|pca|seq|subjects|intestinal|tumors|vinifera|
|error|mirnas|genomic|matter|abundance|prognostic|ethylene|
|benjamini|applied|differential|scans|metagenomic|ct|plant|
|hochberg|drug|sets|cortical|firmicutes|texture|biosynthesis|
|multiple|difficult|rna|regions|host|predictive|fruits|
|controlling|microrna|differentially|diffusion|sequencing|lung|berry|
|statistics|successfully|expressed|magnetic|bacteria|patients|lycopersicum|
|proposed|silico|methylation|morphometry|diet|tomography|transcripts|
|true|tensor|motivation|resonance|bateroidetes|feature|plants|
|proportion|mrnas|package|structural|faecal|computed|solanum|
|power|causing|data|healthy|bacteroides|nsclc|wine|
|values|mrna|throughput|maps|microbes|glioblastoma|metabolism|

We used the following code to do the contextualization:

The function, bff(), is developed by Alex Hayes and Fan Chen, and posted under Karl 
Rohe's GitHub repository, vsp.

```r
# function, bff()
bff.default <-  function(loadings, features, num_best, ...) {
  
  loadings[loadings < 0] <-  0
  k <- ncol(loadings)
  
  best_feat <- matrix("", ncol = k, nrow = num_best)
  
  ## normalize the cluster to a probability distribution (select one member at random)
  nc <- apply(loadings, 2, l1_normalize)
  nOutC <- apply(loadings == 0, 2, l1_normalize)
  
  inCluster <- sqrt(crossprod(features, nc))
  outCluster <- sqrt(crossprod(features, nOutC))
  
  # diff is d x K, element [i,j] indicates importance of i-th feature to j-th block
  # contrast: sqrt(A) - sqrt(B), variance stabilization
  diff <-  inCluster - outCluster
  
  for (j in 1:k) {
    bestIndex <-  order(-diff[,j])[1:num_best]
    best_feat[,j] <-  colnames(features[, bestIndex])
  }
  
  best_feat
}

# simplify matrix, A_abs, for bff on incitations
id_in = edgeList_in %>% select(id) %>% unique()
id_in = id_in$id
A_abs_in = A_abs[id_in, ]

# apply bff on inCitation adjacency matrix
keypapers_in = bff(fa_in$Z, A_abs_in, 20) %>% t
```
#### Citation trends within clusters

Similar to what we did by plotting the paper's overall citation trends, we plotted the citation trends within each clusters. We display the citation trends of five clusters in the outCitation network below. This network is obtained by our second data collection method. 

![image](/image/citOverYear_clusters_outCitation_(method2).png)

### Further look into clusters

#### Visualize clusters

After identifying the clusters, we wanted to visualize them and find the across-cluster connections. In each cluster, we ranked papers by loading. The higher the loading is, the closer the paper is related to the cluster. To make the plot clearer, we picked the top 10% and the top 50 papers, and visualized them. Each dot denotes a paper and each line denotes the citation relationship between two nodes. We see more citations within a cluster than between two clusters. The following figure shows the seven clusters of the outCitation network obtained by the first data collection method:

![image](/image/visClusters_top50_outCitation_method1.jpg)

We simplify the above graph by presenting each cluster as a dot. The size of the dot indicates the number of papers in the cluster. We only keep the edges in which the number of citations counts for more than 5% total citations. It is clear in the updated graph that cluster 1 (hypothesis testing) contains the most papers. Cluster 6 (regression), which is closer to hypothesis testing, has a larger citation number compared to the other clusters. Keep in mind that we use out citation for the graph, which means most papers are cited by the hypothesis testing cluster.

![image](/image/visClusters_outCitation_method2.png)

#### Bridge paper

Because when we visualized the clusters, we saw more within-cluster citations than between-cluster citations. This brings us to the question whether there exists some 'bridge' paper. We define bridge paper as an influential paper in a research field (cluster) that other papers in the same field cite instead of citing Benjamini and Hochberg's FDR paper. We plotted the following figure to visualize our thinkings:

![image](/image/bridge_paper.png)

In the above graph, round dots are those cited the original FDR paper whereas the squared dots are those did not. Comparing the hypothesis testing cluster with the human genetics cluster, we find that the clusters closely related to statistics are more likely to cite the original work directly while those clusters less affiliated with statistics are more likely to have a "bridge" paper in their own field.

## Conclusion

There are four main findings in our project:

+ There is almost no time lag( less than 3 years)  for FDR, however the lag do exist in application fields outside of Statistics (e.g. genetic, engineering).

+ The overall diffusion pattern for FDR is partially Bell-shaped and the increasing rate of the paper's popularity slows down in the past 5 years.

+ The diffusion patterns are different across the fields, but most patterns are Bell-shaped with different flatness.

+ The "bridge" papers exist in the fields other than Statistics. But unfortunately, this phenomenon cannot be well studied base on our current dataset.

