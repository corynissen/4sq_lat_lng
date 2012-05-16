
library(maps)
library(ggplot2)

getMaxMins <- function(latlngs){
  # returns the min and max lat and lng
  a <- unlist(latlngs)
  minlat <- min(a[names(a)=="lat"])
  maxlat <- max(a[names(a)=="lat"])
  minlng <- min(a[names(a)=="lng"])
  maxlng <- max(a[names(a)=="lng"])
  return(list(minlat=minlat, maxlat=maxlat, minlng=minlng, maxlng=maxlng))
}

addPoint <- function(latlngList){
  df <- data.frame(lat=latlngList$lat, lng=latlngList$lng)
  return(geom_point(data=df, aes(lng, lat), colour="red", size=2))
}

makeGraph <- function(latlngs, zoom=3){
  w <- getMaxMins(latlngs)
  world<-map_data("usa")
  p <- ggplot(legend=FALSE) +
    geom_polygon( data=world, aes(x=long, y=lat,group=group)) +
      opts(panel.background = theme_blank()) +
        opts(panel.grid.major = theme_blank()) +
          opts(panel.grid.minor = theme_blank()) +
            opts(axis.text.x = theme_blank(),axis.text.y = theme_blank()) +
              opts(axis.ticks = theme_blank()) +
                xlab("") + ylab("") + coord_cartesian(xlim=c(w$minlng-zoom, w$maxlng+zoom), ylim=c(w$minlat-zoom, w$maxlat+zoom))
  for(i in 1:length(latlngs)){
    if(!is.null(latlngs[[i]]$lat)){
      p <- p + addPoint(latlngs[[i]])
    }
  }
  return(p)
}

# try it...
# using latlngs object from getInfoForUser.R
# makeGraph(latlngs)
