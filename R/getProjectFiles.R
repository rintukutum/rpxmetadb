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
  num <- as.numeric(sapply(ftplink,function(x){strsplit(x,split='\\/')[[1]][7]}))
  idx <- which.max(num)
  ftplink <- ftplink[idx]
  tmpfile <- prideID
  cmd <- paste0("curl -s ",
                  ftplink,
                  " > ",
                  tmpfile
  )

  system(cmd)
  dat <- readLines(tmpfile)
  unlink(tmpfile)
  return(dat)
}
