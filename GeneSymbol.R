# GeneSymbol --------------------------------------------------------------
GeneSymbol <- function(chrom=NA,chromStart=NA,chromEnd=NA){
 require(dplyr)
 require(GenomicFeatures)
 require(TxDb.Hsapiens.UCSC.hg19.knownGene)
 require(org.Hs.eg.db) # gene symobols

 txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
 
 #valid chrom names
 chr <- paste0("chr",c(1:22,"X","Y"))
 
 # Input checks ----------------------------------------------------------
 if(!is.character(chrom) |
 length(chrom)!=1 |
 !chrom %in% chr) stop("chrom: must be character class with length(chrom)==1, e.g.: chr1")
 
 if(is.na(chromStart) |
 chromStart < 0) warning("chromStart: setting to default value 0")
 
 if(is.na(chromEnd)) warning("chromEnd: default value last position for chromosome")
 
 # Validate start end position for chrom - using txdb chrominfo table
 chrominfo <- 
 dbGetQuery(txdb$conn,
  paste0("select * from chrominfo where chrom='",
   chrom,"'"))
 chromStart <- ifelse(is.na(chromStart) | 
    chromStart < 0,
   0,chromStart)
 chromEnd <- ifelse(is.na(chromEnd) | 
   chromEnd > chrominfo$length |
   chromEnd < chromStart,
   chrominfo$length, chromEnd)
 
 #Print summary for selection region of interest
 print(paste0("Collapsing to gene symbols, region: ",
  chrom,":",chromStart,"-",chromEnd))
 
 # Get chromosome start end positions to subset TXDB for transcripts
 roi_chr <- GRanges(seqnames=chrominfo$chrom,
   IRanges(start=chromStart,
    end=chromEnd,
    names=chrom))
 # Collapse to gene symbol -----------------------------------------------
 # Subset txdb over overlaps for chr-start-end
 keys_overlap_tx_id <- 
 subsetByOverlaps(transcripts(txdb),roi_chr) %>% 
 as.data.frame() %>% 
 .$tx_id %>% as.character
 
 # Match TX ID to GENEID
 TXID_GENEID <- AnnotationDbi::select(txdb,
     keys=keys_overlap_tx_id,
     columns=c("TXNAME","GENEID"),
     keytype="TXID")
 
 # Select transcipts from txdb which have GENEID
 Trans <- AnnotationDbi::select(txdb,
     keys=as.character(TXID_GENEID$TXID),
     columns=columns(txdb),
     keytype = "TXID")
 
 # Get gene symbol
 gene_symbol <- unique(
 AnnotationDbi::select(org.Hs.eg.db,
    keys=Trans[ !is.na(Trans$GENEID),"GENEID"],
    columns="SYMBOL",
    keytype="ENTREZID"))
 
 # Match GENEID, SYMBOL
 TXID_GENEID <- left_join(TXID_GENEID,gene_symbol,
    by=c("GENEID" = "ENTREZID"))
 
 # If not match on gene symbol, then TXNAME is gene symbol
 TXID_GENEID$SYMBOL <- ifelse(is.na(TXID_GENEID$SYMBOL),
    TXID_GENEID$TXNAME,TXID_GENEID$SYMBOL)
 
 # merge to add gene symbol
 Trans <- left_join(Trans,TXID_GENEID,
   by=c("TXID","GENEID","TXNAME"))
 
 # If not match on gene symbol, then TXNAME is gene symbol
 Trans$SYMBOL <- ifelse(is.na(Trans$SYMBOL),
    Trans$TXNAME,Trans$SYMBOL)
 
 #Make Granges object 
 CollapsedGenes <- 
 GRanges(seqnames=Trans$EXONCHROM,
  IRanges(start=Trans$EXONSTART,
   end=Trans$EXONEND),
  strand=Trans$EXONSTRAND)
 CollapsedGenes$gene_id <- Trans$SYMBOL
 
 # Output ----------------------------------------------------------------
 #return collapsed genes per CHR
 return(CollapsedGenes)
 }
