
#pull it all together

source("getLatLng.R")
source("getInfoForUser.R")
source("clusterLatLng.R")
source("plotLatLngs.R")
load("cred.Rdata")
registerTwitterOAuth(cred)

# sample username...
username <- "michaelmcgee"
# takes time to run... lots of api calls to resolve t.co links
latlngs <- getLatLngs(username, n=100)

# cluster those latlngs and get a center
clusterCenter <- getClusterCenter(latlngs)

# see the latlngs on a map...
# make sure latlngs isn't empty for the username you've chosen
makeGraph(latlngs, zoom=1) + addPoint(clusterCenter, size=2, colour="blue")
ggsave("michaelmcgee_cluster_center.png")
