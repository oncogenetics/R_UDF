udf_getMAF<-function(Z,missing=9){
  # Input Z:
  #         input is a matrix
  #         rows samples, columns are SNPs
  # Input missing:
  #         value used to indicate missing value, default 9 
  
  # convert missing genotype to NA
  is.missing<-which(Z == missing)
  Z[is.missing]<-NA
  
  # MAF = mean divided by 2.
  maf<-colMeans(Z,na.rm = TRUE)/2
  
  #return MAF
  return(maf)
}
