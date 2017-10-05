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

#------
# read readme files
getProjectREADME <- function(ftplink){
  # ftplink <- 'ftp://ftp.pride.ebi.ac.uk/pride/data/archive/2017/01/old_PXD005231/README.txt'
  #----
  # to avoid permission deny
  # check url exist/not
  # ftplink <- 'ftp://ftp.pride.ebi.ac.uk/pride/data/archive/2017/05/PXD006174/README.txt'
  url <- gsub('README.txt','',ftplink)
  status.url <- suppressWarnings(RCurl::url.exists(url))
  if(status.url){
    dat <- read.delim(ftplink,stringsAsFactors = FALSE,sep='\t',header = TRUE)
  }else{
    # data not available
    dat <- NA
  }
  return(dat)
}
