# Check if required package is installed
require("RPostgreSQL")

# Import libraries
library('RPostgreSQL')
library('sp')
library('rgdal')
library('rgeos')

# Get driver for database and make connection to it
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host='10.75.14.108', dbname='gis', user='gisuser', password='user')

# Select tweets by keyword
rs <- dbSendQuery(con, "select tweet_text, tweet_datetime, latitude, longitude from tweets2601 where tweet_text like ('%griep%')")
griep.df <- fetch(rs,n=-1)

# Turn dataframe into a spatial points dataframe
xy <- cbind(griep.df$longitude, griep.df$latitude)
griep.sp.df <- SpatialPointsDataFrame(xy, griep.df, proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))

# Get boundary of the Netherlands
datdir <- 'data'
dir.create(datdir, showWarnings = FALSE)
adm <- raster::getData("GADM", country = "NLD", level = 0, path = datdir)

# Clip points to boundary of the Netherlands
pts.intersect <- gIntersection(adm, griep.sp.df, byid = TRUE)

# Get row ID of points that are within the intersect
pts.intersect.strsplit <- strsplit(dimnames(pts.intersect@coords)[[1]], " ")
pts.intersect.id <- as.numeric(sapply(pts.intersect.strsplit, "[[", 2))

# Match attributes of original dataframe with intersected points, by row ID
griep.nld.df <- griep.sp.df[pts.intersect.id, ]

# Write filtered tweets to .CSV file
write.csv(griep.nld.df@data, file = "data/GriepTweets.csv", row.names = FALSE)

# Disconnect connection and unload driver
dbDisconnect(con)
dbUnloadDriver(drv)


