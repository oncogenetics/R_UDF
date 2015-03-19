R_UDF
=====

# R functions

## SampleLocation - DNA selection from plates...

## GeneSymbol - collapse transcripts into gene symbols. Output is a Granges object for defined region in a chromosome.
### Example 1: Get all genes for chr17
```r
allGenesChr17 <- udf_GeneSymbol(chrom = "chr17")
# Define region of interest - ROI
roi <- GRanges(seqnames="chr17",
               IRanges(start=41150000,
               end=41300000,
               names="myRegion"))
# Plot using ggbio - geom_alignment
ggplot(subsetByOverlaps(allGenesChr17,roi)) + 
  geom_alignment(aes(group=gene_id,fill=strand,col=strand))
```
### Example 2: Get all genes for chr17:41150000,41300000
```r
subsetGenesChr17 <- udf_GeneSymbol("chr17",41150000,41300000)
ggplot(subsetGenesChr17) + 
 geom_alignment(aes(group=gene_id,fill=strand,col=strand))
```
