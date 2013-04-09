
Sys.setenv(NOAWT=1) #call this before loading OpenStreetMap
library(maps)
library(ggplot2)
library(OpenStreetMap)
library(rgdal)

getMaxMins <- function(latlngs){
  # returns the min and max lat and lng
  a <- unlist(latlngs)
  minlat <- min(a[names(a)=="lat"])
  maxlat <- max(a[names(a)=="lat"])
  minlng <- min(a[names(a)=="lng"])
  maxlng <- max(a[names(a)=="lng"])
  return(list(minlat=minlat, maxlat=maxlat, minlng=minlng, maxlng=maxlng))
}

addPoint <- function(latlngList, size=1, colour="red"){
  proj.merc <- projectMercator(latlngList$lat, latlngList$lng)
  df <- data.frame(x=proj.merc["x"], y=proj.merc["y"])
  return(geom_point(data=df, aes(x, y), colour=colour, size=size))
}

makeGraph <- function(latlngs, zoom=2){
  w <- getMaxMins(latlngs)
  w.merc.min <- projectMercator(w$minlat, w$minlng)
  w.merc.max <- projectMercator(w$maxlat, w$maxlng)
  w.merc <- list(minx=w.merc.min["x"], miny=w.merc.min["y"],
                 maxx=w.merc.max["x"], maxy=w.merc.max["y"])
  #world<-maps::map("usa")
  my.theme <- theme(panel.background = element_blank(),
                   panel.grid.major = element_blank(),
                   panel.grid.minor = element_blank(),
                   axis.text.x = element_blank(),
                   axis.text.y = element_blank(),
                   axis.ticks = element_blank())
  zoom <- zoom / 10
  mp <- openmap(c(w$minlat-zoom,w$maxlng+zoom), c(w$maxlat+zoom,w$minlng-zoom),
                type="osm")
  p <- autoplot(mp) +
       my.theme +
       xlab("") +
       ylab("")
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
