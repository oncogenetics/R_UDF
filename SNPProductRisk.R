#### In progress....


# Calculate population risk per SNP ---------------------------------------
#prepare map file
map <- map %>% 
  mutate(major=paste0(Reference_Allele,Reference_Allele),
         het1=paste0(Reference_Allele,Effect_Allele),
         het2=paste0(Effect_Allele,Reference_Allele),
         minor=paste0(Effect_Allele,Effect_Allele),
         hetRisk=Odds_Ratio,
         majorAlleleRisk=Odds_Ratio^2,
         popRisk=Frequency^2*majorAlleleRisk+2*Frequency*(1-Frequency)*hetRisk+(1-Frequency)^2)

#loop through sample - per row and calculate PRS
dat$PRS3 <- 
  sapply(1:nrow(geno),function(i){
    g <- as.character(geno[i,15:85])
    m <- cbind(map,g)
    riskPerSNP <- (
      (m$g==m$major) + 
        ((m$g==m$het1)+(m$g==m$het2))*m$hetRisk + 
        (m$g==m$minor)*m$majorAlleleRisk
    )/m$popRisk
    #if no genotype then risk is 1
    riskPerSNP <- ifelse(riskPerSNP==0,1,riskPerSNP)
    #overall SNP pruduct of all SNP risks
    prod(riskPerSNP)
  })
