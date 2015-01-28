
library(plyr)
library(ggmap)

df <- read.csv("data/verkoudTweets.csv", header = T)

# Count the number of tweets in the same geographic area.
RADIUS = 20 # Bucket tweets within 2 * RADIUS latitude/longitude degrees of each other.
d = transform(df, latitude = round(RADIUS * latitude) / RADIUS, longitude = round(RADIUS * longitude) / RADIUS)
d = ddply(d, .(tweet_datetime, longitude, latitude), summarise, count = length(longitude))



data = subset(d, tweet_datetime == "februari 2014")



basemap <- get_stamenmap(bbox = c(left = 2.917310, bottom = 50.507220, right = 7.438184, top = 53.579787), zoom = 7, maptype = "toner")

map <- ggmap(basemap, alpha = .2)

map + geom_jitter(data = data, aes(x=longitude, y=latitude, size = count), color = 'darkgreen', alpha = 1)

