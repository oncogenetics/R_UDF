sampleLocation <- function(targetSamples,SampleLocRaw="Path:/to/progeny/DNA/file.txt" )
{
  
  # Function arguments:
  # 1. targetSamples - vector of SampleIDs
  #    e.g.: c("XYZ0001","XYZ0002","XYZ0003","XYZ0004")
  #
  # 2. SampleLocRaw - Path to progeny output - DNA sample locations file
  #    e.g.: "C:/Docs/Progeny/myFile.txt"
  
  # read progny DNA location file
  SampleLocRaw <- read.delim(SampleLocRaw, na.strings=c("NA","","./."), as.is=T)
  
  #Filter ALL sample by target samples
  SampleLocRaw <- SampleLocRaw[ SampleLocRaw$Study.ID %in% targetSamples, ]
  
  #vector of input samples
  VecIn <- unique(SampleLocRaw$Study.ID)
  
  #filter available samples
  SampleAvail <- SampleLocRaw[SampleLocRaw$DNA.Status=="Available",]
  
  #vector of input samples
  VecAvail <- unique(SampleAvail$Study.ID)
  
  #Make df of unavailable samples
  #Define variables
  temp=NULL
  SampleUnavail=NULL
  
  for(i in c(setdiff(VecIn, VecAvail))) {
    temp <- SampleLocRaw[SampleLocRaw$Study.ID == i,]
    SampleUnavail <- rbind(SampleUnavail, temp)
  }
  
  #Combine avail and unavail
  SampleLoc <- rbind(SampleAvail, SampleUnavail)
  
  #Set sample preference: choose from Left to Right
  SamOrder <- c("Secondary", "Primary", "Stock", "Surplus", "Dilution")
  
  #Loop through every sample and pick DNA
  selectVec <- 
    sapply(unique(SampleLoc$Study.ID),function(x) {
      #create vector of row.namefor sample "x"
      unsorted <- row.names(SampleLoc)[SampleLoc$Study.ID %in% x]
      #order vector by sample preference and take first row.name from vector
      unsorted[order(match(t(as.data.frame(SampleLoc[unsorted, "Plate.Type"],
                                           row.names=unsorted,
                                           stringsAsFactors=F)),
                           SamOrder))][1]
      })
  
  #Subset DNAs based on preference
  SamLocOutput <- SampleLoc[selectVec,]
  
  #Sort by pos and plate
  SamLocOutput <- SamLocOutput[order(SamLocOutput$Position),]
  SamLocOutput <- SamLocOutput[order(SamLocOutput$Plate.ID),]
  return(SamLocOutput)
}
