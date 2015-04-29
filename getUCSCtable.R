
udf_getUCSCTable <- function(url_gz=NULL) {
  # Example input:
  # url_gz="http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/kgXref.txt.gz"
  
  #get SQL table definition file URL
  url_sql <- gsub("txt.gz","sql",url_gz,fixed = TRUE)
  
  con <- gzcon(url(url_gz))
  txt <- readLines(con)
  ucsc_table <- read.delim(textConnection(txt),
                           sep="\t",header=FALSE,stringsAsFactors = FALSE)
  
  #Get column names from SQL definition script
  ucsc_table.sql <- readLines(url_sql)
  #get index of fields
  colnames_index <- 
    which(cumsum(grepl("CREATE TABLE|KEY",ucsc_table.sql)) == 1)[-1]
  myCols <- ucsc_table.sql[colnames_index]
  #http://stackoverflow.com/a/22924511/680068
  #extract colnames 
  myCols <- gsub("(.*`)(.*)(`.*)","\\2",myCols) 
  #update column name
  colnames(ucsc_table) <- myCols
  
  #result
  return(ucsc_table)
  }
