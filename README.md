# Diffusion Pattern of False Discovery Rate

Contributors:
- Ying Chen
- Xiaotian Wang
- Xiyu Yang
- Shuqi Yu

## What is this project about?

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