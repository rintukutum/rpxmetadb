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


getProjectREADME <- function(prideID){
  return(dat)
}
