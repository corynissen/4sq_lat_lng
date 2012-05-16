
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

getLatLngs <- function(username, n=100){
  # I have saved OAuth creds for twitter, to use this, you'll have to get your own.
  load("/media/windrive/chicago/tweets/autoresponder/cred.Rdata")
  registerTwitterOAuth(cred)  
  tl_list <- userTimeline(username, n=n)
  tl <- sapply(tl_list, "[[", "text")
  
  links <- unlist(sapply(tl, getLinks), use.names=F)
  longlinks <- sapply(links, getLongURL)
  names(longlinks) <- NULL
  foursq_links <- longlinks[grep("foursquare.com", longlinks)]
  latlngs <- lapply(foursq_links, function(x)getLatLng(x, short=FALSE))
  return(latlngs)
}
