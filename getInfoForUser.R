
#library(RJSONIO)
library(twitteR)
library(ROAuth)
library(RCurl)
library(stringr)

getLinks <- function(text){
  # extract urls from string
  return(str_extract_all(text, ignore.case("http://[a-z0-9].[a-z]{2,3}/[a-z0-9]+")))
}

getLongURL <- function(shorturl){
  # uses expandurl api to get expanded url from t.co links (or any link)
  expanderapi <- "http://expandurl.appspot.com/expand?url="
  apijson <- getURL(paste(expanderapi, curlEscape(shorturl), sep=""))
  apidata <- fromJSON(apijson)
  return(apidata$end_url)
}

getLongURL.curl <- function(shorturl){
  # uses curl statement to get expanded url from t.co links (or any link)
  # loop through until there's no location attribute... that's the long link.
  newurl <- shorturl
  url <- ""
  while(url != newurl){
    data <- system(paste0("curl -I ", newurl), intern=T)
    if(sum(grepl("location: ", tolower(data))) == 0){
      url <- newurl
    }else{
      data <- subset(data, tolower(substring(data, 1, 9))=="location:")
      stringurl <- substring(data[1], 11, nchar(data[1])-1)
      if(substring(stringurl, 1, 4)=="http"){
        newurl <- stringurl
      }else{
        url <- newurl
      }
    }
  }
  return(newurl)
}

getLongURL.py <- function(shorturl){
  # uses urlunshort python package and system call to get expanded url from t.co links (or any link)
  longurl <- system(paste0("python urlunshort.py ", shorturl), intern=T)
  return(longurl)
}

getLatLngs <- function(username, n=100){  
  tl_list <- userTimeline(username, n=n)
  tl <- sapply(tl_list, "[[", "text")
  
  links <- unlist(sapply(tl, getLinks), use.names=F)
  longlinks <- sapply(links, getLongURL.curl)
  names(longlinks) <- NULL
  foursq_links <- longlinks[grep("foursquare.com", longlinks)]
  latlngs <- lapply(foursq_links, function(x)getLatLng(x, short=FALSE))
  return(latlngs)
}
