# Diffusion Pattern of False Discovery Rate

Contributors:
- Ying Chen
- Xiaotian Wang
- Xiyu Yang
- Shuqi Yu

## What is this project about?

This is a class project for Statistics 992 Data Science with Graphs which is taught by Professor Karl Rohe. This project is motivated by the following facts: Many current research on citation networks focus on general citation patterns only in the field of statistics. A good summary of the previous studies are provided by Radicchi, Fortunato, and Vespignani (2012).  However, to our knowledge, very few work (if any) focuses on a specific statistical technique, tracking its citation patterns in different fields of study over time.

In this project, we study the citation patterns of false discovery rate (FDR). We would like to understand the citation changes of Benjamini and Hochberg's FDR paper (1995) over time and across different fields. We name such changes as the paper's diffusion pattern because its influence spreads across the citation network over time. Specifically, we observe whether a time lag appears and compare the time lag difference across research fields. For time lag, we mean whether there exists a gap between the time when the paper was published and when it gained its popularity. We then plot the shape of the citation patterns in each field. We observe that diffusion pattern in one field differs based on the field's closeness to statistics. 

## Data description and collection

We used the Semantic Scholar's records, which gives information on research papers. The corpus is composed of rich abstracts, bibliographic references, and structured full texts. The full text comes with automatically detected inline citations, figures, and tables. Also, each citation is linked to its corresponding paper. In Semantic Scholar's dataset, papers from hundreds of academic publishers and digital archives are aggregated into a single source. With the well-developed tool, we downloaded and configured the whole dataset with 220 million papers and over 100Gb meta data. They are well prepared, machine-readable academic texts

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

![image](/image/citOverYear_total_outCitation_(method1).jpg)

![image](/image/citOverYear_total_inCitation_(method2).png)

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

To find how many clusters are included in the networks, we applied Vintage Sparse principal component analysis (VSP) to the matrices built from our inCitation and outCitation networks. 

By applying VSP on the data collected by our first method, we found three clusters in the inCitation network and seven clusters in the outCitation network. 

![image](/image/vsp_in_(method1).png)

![image](/image/vsp_out_(method1).png)

When we applied VSP on the data collected by the second method, we found seven meaningful clusters in the inCitation network and five clusters in the outCitation network. 

![image](/image/vsp_in_(method2).png)

![image](/image/vsp_out_(method2).png)

#### Contextualize clusters

After we decided the number of clusters in each network, we applied the best feature function on the results of VSP and the paper-term matrices obtained by tokenizing abstracts. In this way, we contextualized our data and gave each cluster a name. The results listed below are based on our second data collection method:

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

For the outCitation network, we named the 5 meaningful clusters as:

* V1: gene expression
* V2: neuroscience
* V3: population genetics
* V4: microbiology
* V5: hypothesis testing

