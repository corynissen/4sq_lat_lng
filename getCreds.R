
library("ROAuth")
library("stringr")
library("twitteR")

# put your keys here...
consumerkey <- ""
consumersecret <- ""
accesstoken <- ""
accesstokensecret <- ""
requesttokenurl <- ""
accesstokenurl <- ""
authorizeurl <- ""

cred <- OAuthFactory$new(consumerKey=consumerkey, consumerSecret=consumersecret,
                         requestURL=requesttokenurl, accessURL=accesstokenurl,
                         authURL=authorizeurl)
cred$handshake()
registerTwitterOAuth(cred)

# save handshake
save(cred, file="cred.Rdata")
