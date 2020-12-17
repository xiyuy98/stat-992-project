# Diffusion Pattern of False Discovery Rate

Contributors:
- Ying Chen
- Xiaotian Wang
- Xiyu Yang
- Shuqi Yu

## Navigation Panel:

* [Background](https://github.com/xiyuy98/stat-992-project#background)
* [Data](https://github.com/xiyuy98/stat-992-project#data)
* [Analysis](https://github.com/xiyuy98/stat-992-project#analysis)
  * [Overall citation trends by year](https://github.com/xiyuy98/stat-992-project#overall-citation-trends-by-year)
  * [Citation in different fields](https://github.com/xiyuy98/stat-992-project#citation-in-different-fields)
  * [Further look into clusters](https://github.com/xiyuy98/stat-992-project#further-look-into-clusters)
* [Conclusion](https://github.com/xiyuy98/stat-992-project#conclusion)
* [Reference](https://github.com/xiyuy98/stat-992-project#reference)

## Background

This is a class project for Statistics 992 Data Science with Graphs which is taught by [Professor Karl Rohe](http://pages.stat.wisc.edu/~karlrohe/index.html). This project is motivated by the following facts: Many current research on citation networks focus on general citation patterns only in the field of statistics. A good summary of the previous studies are provided by Radicchi, Fortunato, and Vespignani (2012).  However, to our knowledge, very few work (if any) focuses on a specific statistical technique, tracking its citation patterns in different fields of study over time.

In this project, we study the citation patterns of false discovery rate (FDR). We would like to understand the citation changes of [Benjamini and Hochberg's FDR paper (1995)](https://www.jstor.org/stable/pdf/2346101.pdf?casa_token=qlxs1uyCcj8AAAAA:G5YA-dmXlC4ejoC1OVLKHTq8MvccB-zQtXSZI8VHg9fgHAH9n4B0NESP200mDtLf8pmLh-MZ3fV1cWZhRj7h2isC_MpCZhAJCGhSHScvGW54Bb69pIU) over time and across different fields. We name such changes as the paper's diffusion pattern because its influence spreads across the citation network over time. Specifically, we are curious to know whether a time lag exists and compare the time lag difference across research fields. For time lag, we mean whether there exists a gap between the time when the paper was published and when it gained its popularity. We then plot the shape of the citation patterns in each field. We find that the diffusion pattern in one field differs based on the field's closeness to statistics. 

## Data

### Data description

We used the [Semantic Scholar's records](http://s2-public-api-prod.us-west-2.elasticbeanstalk.com/corpus/), a dataset aggregates papers from hundreds of academic publishers and digital archives into a single source. The corpus is composed of rich abstracts, bibliographic references, and structured full texts. The full text comes with automatically detected inline citations, figures, and tables. Moreover, each citation is linked to its corresponding paper. Following the instructions of the Semantic Scholar, we downloaded and configured the whole dataset with 220 million papers and over 100Gb meta data. They are well prepared, machine-readable academic texts.

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

For the second method, we extracted all papers which cite Benjamini and Hochberg's FDR paper. If a paper's outCitation contains the ID of Benjamini and Hochberg's paper, we would select the paper into our dataset. The code we used are the same as for the first method, except for the includeLine function:

```r
includeLine = function(x) {
  return(firstPaper_id %in% x$outCitation)
}
```

We collected 41067 papers by this method. 

## Analysis

### Overall citation trends by year

We plotted the paper's overall citation trends by year. These trends are extracted and plotted based on the inCitation and outCitation networks. Notice that instead of plotting the paper's citation frequency, we plot the ratios obtained by dividing the number of papers, which is cited by FDR paper, published in a certain year by the total number of published papers in that year. The plot displayed below shows that FDR paper's popularity steadily increases since its publication.

![image](/image/citOverYear_total_outCitation_(method2).png)

*Figure 1. Plot of the overall FDR citation changes by year (data collection method 2, outCitation network).*

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

To find how many clusters are included in the networks, we applied [Vintage Sparse principal component analysis (VSP)](https://arxiv.org/pdf/2004.05387.pdf) to the matrices built from our inCitation and outCitation networks. For example, by applying VSP on the data collected by our second method, we found seven clusters in the inCitation network. We can see clear L-shape plots in almost every subplot of the VSP results, indicating that setting the number of clusters to seven is a reasonable choice. However, the L-shape in subplot of z1 against z3 is not very clear. Some papers might have mixed-membership, meaning that they are members of both cluster 1 and cluster 3. 

![image](/image/vsp_in_(method2).png)

*Figure 2. Scatterplot of the Vintage Sparse PCA results for inCitation network (data collection method 2).*

The code we used is here:

```r
fa_in = vsp(A_in, rank = 7, scale = TRUE, rescale = FALSE)
plot_varimax_z_pairs(fa_in, 1:7)
```

#### Contextualize clusters

After we decided the number of clusters in each network, we applied the [best feature function](https://www.stat.uga.edu/sites/default/files/psji/SCC-disc3.pdf) on the results of VSP and the paper-term matrices obtained by tokenizing abstracts. In this way, we contextualized our data and gave each cluster a name. We present the results of inCitation network obtained by the second data collection method:

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

*Table 1. Summary of the best feature function results for inCitation network (data collection method 2).*

We used the following code to do the contextualization:

The function, bff(), is developed by Alex Hayes and Fan Chen, and posted under [Rohe Lab's GitHub repository, vsp](https://github.com/RoheLab/vsp).

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

Similar to what we did by plotting the paper's overall citation trends, we plotted the citation trends within each clusters. We display the citation trends of five clusters in the outCitation network below. This network is obtained by our second data collection method. We see that the popularity of FDR paper increases over time in the five fields, gene expression, microbiology, neuroscience, hypothesis testing, and population genetics. Moreover, we can observe some time lags in certain fields. For instance, the field, microbiology, has a 5-year time lag, and the field, population genetics, has a 6-year time lag.

![image](/image/citOverYear_clusters_outCitation_(method2).png)

*Figure 3. Plot of citation trends within each cluster (data collection method 2, outCitation network).*

### Further look into clusters

#### Visualize clusters

After identifying the clusters, we wanted to visualize them and find the across-cluster connections. In each cluster, we ranked papers by loading. The higher the loading is, the closer the paper is related to the cluster. To make the plot clearer, we picked the top 10% and the top 50 papers, and visualized them. Each dot denotes a paper and each line denotes the citation relationship between two nodes. We see more citations within a cluster than between two clusters. The following figure shows the seven clusters of the outCitation network obtained by the first data collection method:

![image](/image/visClusters_top50_outCitation_method1.jpg)

*Figure 4. Visualization of clusters sampled by the top 50 papers (data collection method 1, outCitation network).*

We simplify the above graph by presenting each cluster as a dot. The size of the dot indicates the number of papers in the cluster. We only keep the edges in which the number of citations counts for more than 5% total citations. It is clear in the updated graph that cluster 1 (hypothesis testing) contains the most papers. Cluster 6 (regression), which is closer to hypothesis testing, has a larger citation number compared to the other clusters. Keep in mind that we use out citation for the graph, which means most papers are cited by the hypothesis testing cluster.

![image](/image/visClusters_outCitation_method2.png)

*Figure 5. Simplified visualization of clusters (data collection method 1, outCitation network).*

#### Bridge paper

Because when we visualized the clusters, we saw more within-cluster citations than between-cluster citations. This brings us to the question whether there exists some 'bridge' paper. We define bridge paper as an influential paper in a research field (cluster) that other papers in the same field cite instead of citing Benjamini and Hochberg's FDR paper. We plotted the following figure to visualize our thinkings:

![image](/image/bridge_paper.png)

*Figure 6. Display bridge paper effects by comparing between the hypothesis testing cluster (left) and the genetic variations in human cluster (right) in 2013 and 2020 (data collection 1, outCitation network).*

In the above graph, round dots are those cited the original FDR paper whereas the squared dots are those did not. Comparing the hypothesis testing cluster with the human genetics cluster, we find that the clusters closely related to statistics are more likely to cite the original work directly while those clusters less affiliated with statistics are more likely to have a "bridge" paper in their own field.

## Conclusion

There are four main findings in our project:

+ There is no time lag (the gap is less than 3 years) for FDR. However, some lags do exist in application fields outside of statistics such as genetics, neuroscience, etc.

+ The overall diffusion pattern for FDR is partially bell-shaped and the increasing rate of Benjamini and Hochberg's FDR paper's popularity slows down in the past 5 years.

+ The diffusion patterns are different across research fields, but most patterns are bell-shaped with different flatness.

+ Bridge papers exist in the fields other than statistics. But unfortunately, this phenomenon cannot be well studied based on our current dataset.

## Reference

Waleed Ammar, Dirk Groeneveld, Chandra Bhagavatula, Iz Beltagy, Miles Crawford, Doug Downey, Jason Dunkelberger, Ahmed Elgohary, Sergey Feldman, Vu Ha, et al. Construction of the literature graph in semantic scholar. *arXiv preprint arXiv:1805.02262*, 2018.

Yoav Benjamini and Yosef Hochberg. Controlling the false discovery rate: a practical and powerful approach to multiple testing. *Journal of the Royal statistical society: series B (Methodological)*, 57(1):289-300, 1995.

Pengsheng Ji, Jiashun Jin, et al. Coauthorship and citation networks for statisticians. *The Annals of Applied Statistics*, 10(4):1779-1812, 2016.

Filippo Radicchi, Santo Fortunato, and Alessandro Vespignani. Citation networks. *Models of science dynamics*, pages 233-257. Springer, 2012.

Karl Rohe and Muzhe Zeng. Vintage factor analysis with varimax performs statistical inference. *arXiv preprint arXiv:2004.05387*, 2020.

Song Wang and Karl Rohe. Don't mind the (eigen) gap.