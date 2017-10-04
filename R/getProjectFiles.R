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
  dat.ftp <-list()
  for( i in 1:length(ftplink)){
    tmpfile <- prideID
    cmd <- paste0("curl -s ",
                  ftplink[i],
                  " > ",
                  tmpfile
    )

    system(cmd)
    dat.ftp[[i]] <- readLines(tmpfile)
  }
  unlink(tmpfile)
  dat <- dat.ftp
  return(dat)
}
