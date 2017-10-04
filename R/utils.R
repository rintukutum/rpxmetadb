#-------
# Get PRIDE ftp links
getPrideFTPlinks <- function(){
  url <- 'ftp://ftp.pride.ebi.ac.uk/pride/data/archive/'
  cmd <- paste0("curl -s ",
                url,
                " | awk '{print $9}' > tmpfile"
  )
  system(cmd)
  dat <- readLines('tmpfile')
  unlink('tmpfile')
  # generate more urls
  urls <- paste(url,dat,'/',collpase='',sep='')
  ftpLinks <- list()
  k <- 1
  for(i in 1:length(urls)){

    cmd <- paste0("curl -s ",
                  urls[i],
                  " | awk '{print $9}' > tmpfile2"
    )
    system(cmd)
    dat <- readLines('tmpfile2')
    unlink('tmpfile2')
    urls2 <- paste(urls[i],dat,'/',collpase='',sep='')
    for(j in 1:length(urls2)){
      cat(paste0('i = ',i,'\t','j = ',j,'\n'))
      cmd <- paste0("curl -s ",
                    urls2[j],
                    " | awk '{print $9}' > tmpfile3"
      )
      system(cmd)
      prideIDs <- readLines('tmpfile3')
      unlink('tmpfile3')
      ftpLinks[[k]] <- paste(urls2[j],prideIDs,'/',collpase='',sep='')
      cat(paste(ftpLinks[[k]],'\n',collapse = '\n'))
      cat('\n')
      k <- k+1
    }
  }
  ftpLinks <- unlist(ftpLinks)
  #----
  # remove the test folder
  prideFTPlinks <- ftpLinks[-grep('test',ftpLinks)]
  return(prideFTPlinks)
}

prideFTPdf <- function(){
  load('./data/prideFTPlinks.RData')
  prideIDs <- sapply(prideFTPlinks,getPrideID)
  outDF <- data.frame(prideID=prideIDs,ftp=prideFTPlinks,stringsAsFactors = FALSE)
  rownames(outDF) <- 1:nrow(outDF)
  return(outDF)
}

getPrideID <- function(ftplink){
  parts <- strsplit(ftplink,split = '\\/')[[1]]
  prideID <- parts[length(parts)]
  return(prideID)
}
#------
# get meta information regarding process and raw
# data in PRIDE ftp
# additionally information about the size of the
# files (estimation of size)



