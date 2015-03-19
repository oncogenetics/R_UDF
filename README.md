R functions
====

## 1. SampleLocation
DNA selection from plates...

## 2. GeneSymbol
Collapse transcripts into gene symbols. Output is a Granges object for defined region in a chromosome.

Required packages:
```r
require(dplyr)
require(GenomicFeatures)
require(TxDb.Hsapiens.UCSC.hg19.knownGene)
require(org.Hs.eg.db)
```

### Example 1:
Get all genes for chr17
```r
allGenesChr17 <- GeneSymbol(chrom = "chr17")
# Define region of interest - ROI
roi <- GRanges(seqnames="chr17",
               IRanges(start=41150000,
               end=41300000,
               names="myRegion"))
# Plot using ggbio - geom_alignment
ggplot(subsetByOverlaps(allGenesChr17,roi)) + 
  geom_alignment(aes(group=gene_id,fill=strand,col=strand))
```
### Example 2:
Get all genes for chr17:41150000,41300000
```r
subsetGenesChr17 <- GeneSymbol("chr17",41150000,41300000)
ggplot(subsetGenesChr17) + 
 geom_alignment(aes(group=gene_id,fill=strand,col=strand))
```

### Plot output for Example 1 and 2
![GeneSymbols_chr17_41150000_41300000](/images/chr17_41150000_41300000.jpeg)

