require(twitteR)
require(ROAuth)
#The original example used the twitteR library to pull in a user stream
#Instead, I'm going to pull in a search around a hashtag.
options(httr_oauth_cache=T)
api_key <- "y9rsFAuHjptL1WRHgvKdnIehN"

api_secret <- "184vfE03L7R5q6TyIgP7leQFRURbyogyMNAsWXAbMfyY0ubeCE"

access_token <- "105202631-2Y1NDPiOWySghC3mB9Pp3xNVV4zKNxDDyLZPRLOk"

access_token_secret <- "4rlCQ6GPaoUQhSeFSDkhosZ1kRUnbcDIbjC7VWQJTeIda"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

trends = c("#Jallikattu" ,  "#JusticeforJallikattu", "#Jallikattuprotest", 'saveJallikattu', "wewantjallikattu", "banpetaindia")

days <- seq(from=as.Date('2017-01-23'), to=as.Date("2017-01-25"),by='days' )
for ( day in seq_along(days) )
{
  for (trend in trends)
  {

    #rdmTweets2 <- searchTwitter(trend, n=5000, since=str(days[day]), until=str(days[day]))
    rdmTweets2 <- searchTwitter("#VikasVsSCAM", n=5000)
    
    # Note that the Twitter search API only goes back 1500 tweets (I think?)
    
    #Create a dataframe based around the results

    df2 <- do.call("rbind", lapply(rdmTweets2, as.data.frame))
    #Here are the columns
  # names(df2)
    #And some example content
   # head(df2,3)
    

    
    write.csv(df2, "file.csv")
    
  }
  
}




prabanch <- userTimeline(user = "@prabanch",
                             n = 200, includeRts = TRUE, retryOnRateLimit = 2000)  

#Put the tweets downloaded into a data.frame

prabanch <- twListToDF(prabanch)


write.csv(prabanch, "file1.csv")

updateStatus('Testing from R', lat=NULL, long=NULL, placeID=NULL,
             displayCoords=NULL, inReplyTo=NULL, mediaPath=NULL,
             bypassCharLimit=FALSE)

cor1<-gsub("@\\w+","", cor1)
cor1<-gsub("[[:punct:]]","",cor1)
cor1<-gsub("[[:digit:]]","",cor1)
cor1<-gsub("http\\w+","",cor1)
cor1<-gsub("rt","",cor1)
cor1<-gsub("uu+\\w+","",cor1)
cor1<-gsub("hh+\\w+","",cor1)
cor1<-gsub("ha+\\w+","",cor1)
cor1<-gsub("TNSaysNo2Sasi","", cor1)
cor1<-gsub("RipTN","",cor1)
cor1<-gsub("RT","",cor1)

cor1 <- substr(cor1, start=1, stop=100)
cor1 = paste(cor1, "#TNSaysNo2Sasi","#RipTN", "#AIADMKFails") 

rdmTweets2 <- searchTwitter("#???????????????????????????_????????????_??????????????????", n=15)

df <- do.call("rbind", lapply(rdmTweets2, as.data.frame))
i = 1 +1


while ( i <= nrow(df))
{
  cor1 <- substr(df[i,]$text, start=1, stop=90)
  cor1 = paste(cor1, "#???????????????????????????_????????????_??????????????????")
  cor1
  setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
  
  updateStatus(cor1, lat=NULL, long=NULL, placeID=NULL,
                             displayCoords=NULL, inReplyTo=NULL, mediaPath=NULL,
                             bypassCharLimit=FALSE)
  
  
  i = i+ 1
}



i

status = tweet("Testing from R 5")
status
names(status)

deleteStatus(status)



