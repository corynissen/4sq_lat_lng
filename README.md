4sq_lat_lng
===========

This is a little package that takes a twitter username, finds links in their past tweets, resolves those links, looks for foursquare links, uses the foursquare api to get lat lngs for those links. Then using the lat lngs, it finds the middle of the largest cluster and that is a "guess" for a twitter users "home" area. Using openstreetmaps, I create a plot of the data with the cluster center.

