#------
#' @author RINTU KUTUM
#' @description Get PRIDE project files based on
#' pride ID
#' @export
getProjectFiles <- function(prideID){
  load('./data/prideDF.RData')
  # prideID = 'PXD000044'
  idx <- grep(prideID,prideDF$prideID)
  ftplink <- prideDF$ftp[idx]
  dat.ftp <-list()
  for( i in 1:length(ftplink)){
    tmpfile <- prideID
    cmd <- paste0("curl -s ",
                  ftplink[i],
                  "README.txt > ",
                  tmpfile
    )
    system(cmd)

    dat <- readLines(tmpfile)

    if(length(dat) != 0){
      dat <- read.table(tmpfile,
                        sep='\t',
                        header = TRUE,
                        stringsAsFactors = FALSE)
      dat$url <- gsub(' ','%20',dat$URI)
      dat.ftp[[i]] <- data.frame(prideID = prideID,
                                 dat)

    }else{
      dat.ftp[[i]] <- NA
    }
    unlink(tmpfile)
  }
  check.content <- sapply(dat.ftp,nrow)
  idx.null <- which(sapply(check.content,is.null))
  if(length(null.val) != 0){
    #----
    # some repos with two submission
    dat <- dat.ftp[-idx.null][[1]]
  }else{
    # include both if necessary
    dat <- plyr::ldply(dat.ftp)
  }
  return(dat)
}
