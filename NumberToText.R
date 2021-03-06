# In Progress...
# convert some numbers to text for Rmd 
NumberToText <- function(x,format="lower"){
  
    d <- data.frame(
    Number=c(c(1:19),seq(20,100,10)),
    Text=c("one","two","three","four","five","six","seven","eight","nine","ten",
           "eleven","twelve","thirteen","fourteen","fifteen",
           "sixteen","seventeen","eighteen","nineteen","twenty",
           "thirty","forty","fifty","sixty","seventy","eighty","ninety",
           "one hundred"),
    stringsAsFactors = FALSE)

  output <- as.character(d[ d$Number==x,"Text"])
  output <- 
    switch(format,
           "lower"=tolower(output),
           "upper"=toupper(output),
           "proper"=paste0(toupper(substr(output,1,1)),
                           tolower(substr(output,2,nchar(output)))))
  return(output)
  }
