# Diffusion Pattern of False Discovery Rate

Contributors:
- Ying Chen
- Xiaotian Wang
- Xiyu Yang
- Shuqi Yu

## What is this project about?

This is a class project for Statistics 992 Data Science with Graphs which is taught by Professor Karl Rohe. This project is motivated by the following facts: Many current research on citation networks focus on general citation patterns only in the field of statistics. A good summary of the previous studies are provided by Radicchi, Fortunato, and Vespignani (2012).  However, to our knowledge, very few work (if any) focuses on a specific statistical technique, tracking its citation patterns in different fields of study over time.

In this project, we study the citation patterns of false discovery rate (FDR). We would like to understand the citation changes of the first published paper of FDR over time and across different fields. We name such changes as the paper's diffusion patter because its influence spreads across the citation network over time. Specifically, we observe whether a time lag appears and compare the time lag difference across research fields. For time lag, we mean whether there exists a gap between the time when the paper was published and when it gained its popularity. We then plot the shape of the citation patterns in each field. We observe that diffusion pattern in one field differs based on the field's closeness to statistics. 


## Data description and collection

We use the Semantic Scholar's records, which gives information on research papers. The corpus is composed of rich abstracts, bibliographic references, and structured full texts. The full text comes with automatically detected inline citations, figures, and tables. Also, each citation is linked to its corresponding paper. In Semantic Scholar's dataset, papers from hundreds of academic publishers and digital archives are aggregated into a single source. With the well-developed tool, we download and configure the whole dataset with 220 million papers and over 100Gb meta data. They are well prepared, machine-readable academic texts

From the Semantic Scholar's records, we pick all research papers that mention FDR in their abstracts. To include all related papers, we use the key phase 'false discovery rate' when scanning through all abstracts. We bring in paper ID, title, abstract, year published, citation relationship, journal name, and field of study of each paper. For each paper, citation relationship includes two variables, inCitation and outCitation. InCitation is a list of paper IDs which cited this paper, while outCitaion is a list of paper IDs which this paper cited. We collected 8,787 papers in total by this method.

We used the following R code to extract FDR papers from the Semantic Scholar's records. The code is adapted from Professor Karl Rohe's code:

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