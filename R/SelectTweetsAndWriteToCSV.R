# Import libraries
library('sp')
library('rgdal')
library('rgeos')
library('RPostgreSQL')

simpleCap <- function(x) {
  """" This is a docstring
  """"
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

SelectTweetsAndWriteToCSV <- function(list){
  """" This is a docstring
  """"

# Get boundary of the Netherlands
datdir <- 'data'
dir.create(datdir, showWarnings = FALSE)
adm <- raster::getData("GADM", country = "NLD", level = 0, path = datdir)

  # Select tweets by keyword
  for (keyword in list){

    print(paste('Keyword = ', keyword))

    query = paste("select tweet_text, tweet_datetime, latitude, longitude from tweets2601 where tweet_text like '%", keyword, "%' or tweet_text like '%", simpleCap(keyword), "%'", sep = "")
    rs <- dbSendQuery(con, query)
    df <- fetch(rs,n=-1)

    print('Data collected')

    # Turn dataframe into a spatial points dataframe
    xy <- cbind(df$longitude, df$latitude)
    sp.df <- SpatialPointsDataFrame(xy, df, proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))

    print('Spatial df created')

    # Clip points to boundary of the Netherlands
    pts.intersect <- gIntersection(adm, sp.df, byid = TRUE)

    # Get row ID of points that are within the intersect
    pts.intersect.strsplit <- strsplit(dimnames(pts.intersect@coords)[[1]], " ")
    pts.intersect.id <- as.numeric(sapply(pts.intersect.strsplit, "[[", 2))

    # Match attributes of original dataframe with intersected points, by row ID
    nld.df <- sp.df[pts.intersect.id, ]

    print('Data clipped to boundary')

    # Write filtered tweets to .CSV file

    write.csv(nld.df@data, file = paste("data/", keyword, "Tweets.csv", sep = ""), row.names = FALSE)

    print('CSV written : DONE')
  }
}



# Try to include an OR statment within SQL query
# Include print statements so that we know where we are at within the getting data process