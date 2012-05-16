
#pull it all together

source("getLatLng.R")
source("getInfoForUser.R")
source("plotLatLngs.R")

# sample username...
username <- "michaelmcgee"
# takes time to run... lots of api calls to resolve t.co links
latlngs <- getLatLngs(username, n=100)

# see the latlngs on a map...
# make sure latlngs isn't empty for the username you've chosen
makeGraph(latlngs, zoom=3)
