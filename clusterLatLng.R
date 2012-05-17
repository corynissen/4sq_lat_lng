
library(mclust)

# kmeans, 2 clusters
#cl <- kmeans(df, 2)
#plot(df, col=cl$cluster)

getClusterCenter <- function(latlngs){
  # make list a dataframe
  lat <- sapply(latlngs, "[[", "lat")
  lng <- sapply(latlngs, "[[", "lng")
  df <- data.frame(lat=unlist(lat), lng=unlist(lng))
  
  # mclust
  cl <- Mclust(df)
  # get largest cluster
  tab <- table(cl$classification)
  largestcl <- names(tab)[tab==max(tab)]
  # probably debatable whether just taking the average is the
  # right thing here...  let's just do it for now
  meanlat <- mean(df$lat[cl$classification==largestcl])
  meanlng <- mean(df$lng[cl$classification==largestcl])
  clusterCenter <- list(lat=meanlat, lng=meanlng)
  return(clusterCenter)
}

