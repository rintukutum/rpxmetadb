#------
#' @author RINTU KUTUM
#' @description Get PRIDE project files based on
#' pride ID
#' @export
getProjectFiles <- function(prideID){
  data("prideDF")
  # prideID = 'PXD000044'
  idx <- grep(paste0('^',prideID,'$'),
              prideDF$prideID)
  ftplink <- prideDF$ftp[idx]
  dat <- sapply(ftplink,function(x){strsplit(RCurl::getURL(x),'\n')[[1]]})
  return(dat)
}


getProjectREADME <- function(ftplink){
  url <- 'ftp://ftp.pride.ebi.ac.uk/pride/data/archive/2017/01/old_PXD005231/README.txt'
  dat <- read.table(url,stringsAsFactors = FALSE,sep='\t',header = TRUE)
  return(dat)
}
