#' PRIDE ftp links
#' @format A vector with all links
#' \describe{
#' \item{urls}{character}
#' }
#' @source \url{ftp://ftp.pride.ebi.ac.uk/pride/data/archive/}
"prideFTPlinks"

#' PRIDE ftp links with ID
#' @format A data frmae with prde ID and its url
#' \describe{
#' \item{PRIDE id}{ID}
#' \item{url}{link}
#' }
"prideDF"

#-----------------
# additonal functions for fomating size files

formatSpace <- function(x){
  if(!is.list(x)){
    x <- strsplit(sub("\\s++","",x,perl = TRUE),split = '\\s')
  }else{
    x <- lapply(x,formatSpace)
  }
  return(x)
}

getContent <- function(x){
  idx <- grep("^[[:digit:]]",x)[1]
  x <- x[idx:length(x)]
  idx <- which.min(sapply(x,nchar))
  x <- x[-idx]
  #-----
  idx.current <- grep('\\:',x)
  if(length(idx.current) != 0){
    y <- c()
    y[1:2] <- x[1:2]
    #----
    # date might be incorrect
    # must be replaced with
    # README file
    y[3] <- '1'
    y[4] <- "2017"
    y[5] <- x[4]
  }else{
    y <- c()
    if(length(x) > 5){
      y[1:4] <- x[1:4]
      y[5] <- paste(x[5:length(x)],collapse ='%20')
    }else{
      y <- x
    }
  }
  names(y) <- c('size','month','date','year','file.name')
  y <- t(data.frame(y,stringsAsFactors = FALSE))
  return(y)
}

checkREADME <- function(x){
  idx <- grep('\\sREADME.txt$',x)
  if(length(idx)!=0){
    return(TRUE)
  }else{
    return(FALSE)
  }
}


#----
# keep the latest README file only
getYearMonth <- function(url){
  val <- as.numeric(strsplit(url,split='\\/')[[1]][7:8])
  names(val) <- c('year','month')
  return(val)
}
getLatestREADME <- function(urls){
  idx.dup <- duplicated(urls)
  if(length(which(idx.dup)) != 0){
    urls <- urls[-idx.dup]
  }
  if(length(urls) > 1){
    yearMonth <- lapply(urls,getYearMonth)
    years <- sapply(yearMonth,function(x){x['year']})
    if(length(unique(years)) != 1){
      latest.url <- urls[which.max(years)]
    }else{
      months <- sapply(yearMonth,function(x){x['month']})
      latest.url <- urls[which.max(months)]
    }
  }else{
    latest.url <- urls
  }
  return(latest.url)
}
