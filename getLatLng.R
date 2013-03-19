
library(RCurl)
library(RJSONIO)

getLatLng <- function(link, short=TRUE){
  # url is url from twitter... 
  # short=TRUE is a short link... 4sq.com
  if(short){
    url <- getURL(link)
  }else{
    url <- link
  }
  # parse out checkinid and signature from url
  checkinid <- substring(url, regexpr("checkin", url)+8, nchar(url))
  checkinid <- substring(checkinid, 1, regexpr("?s", checkinid)-2)
  signature <- substring(url, regexpr("?s=", url)+2, nchar(url))
  signature <- substring(signature, 1, regexpr("&", signature)-1)
  
  # format api request url
  oauthtoken <- scan("4sq_oauth_token", quiet=T, what="character")
  datecode <- gsub("-", "", Sys.Date())
  apiurl <- paste("https://api.foursquare.com/v2/checkins/", checkinid,
                  "?signature=", signature, "&oauth_token=", oauthtoken,
                  "&v=", datecode, sep="")

  # make request and parse results
  foursqjson <- getURL(apiurl)
  foursqdata <- fromJSON(foursqjson)
  lat <- foursqdata$response$checkin$venue$location$lat
  lng <- foursqdata$response$checkin$venue$location$lng
  return(list(lat=lat, lng=lng))
}
