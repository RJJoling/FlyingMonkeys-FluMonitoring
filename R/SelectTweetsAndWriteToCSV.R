# Import libraries
if(!require(sp)){install.packages('sp')}
if(!require(rgdal)){install.packages('rgdal')}
if(!require(rgeos)){install.packages('rgeos')}
if(!require(RPostgreSQL)){install.packages('RPostgreSQL')}

simpleCap <- function(x) {

  # This function calculates NDVI values
  #
  # Source: toupper function help
  #
  # Args:
  # x = string to be capitalised
  #
  # Returns: capitalised words of input string

  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}


SelectTweetsAndWriteToCSV <- function(list){

  # This function takes a list of keywords and retrieves tweets from the connected
  # server that include the input keyword(s).
  #
  # Args:
  # list = list of keywords
  #
  # Returns: tweets, date and time, coordinates, for each individual keyword,
  # saved as .CSV

  # Get boundary of the Netherlands
  datdir <- 'data'
  dir.create(datdir, showWarnings = FALSE)
  adm <- raster::getData("GADM", country = "NLD", level = 0, path = datdir)

  # Select tweets by keyword
  for (keyword in list){

    print(paste('Keyword = ', keyword))

    query <- paste("select tweet_text, tweet_datetime, latitude,
                   longitude from tweets2601 where tweet_text like '%",
                   keyword, "%' or tweet_text like '%", simpleCap(keyword),
                   "%'", sep = "")

    tweets <- dbSendQuery(con, query)
    df <- fetch(tweets,n=-1)

    print('Data collected')

    # Turn dataframe into a spatial points dataframe
    xy <- cbind(df$longitude, df$latitude)
    sp.df <- SpatialPointsDataFrame(xy, df,
             proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))

    print('Spatial df created')

    # Clip points to boundary of the Netherlands
    pts.intersect <- gIntersection(adm, sp.df, byid = TRUE)

    # Get row ID of points that are within the intersect
    pts.intersect.strsplit <- strsplit(dimnames(pts.intersect@coords)[[1]], " ")
    pts.intersect.id <- as.numeric(sapply(pts.intersect.strsplit, "[[", 2))

    # Match attributes of original dataframe with intersected points, by row ID
    nld.df <- sp.df[pts.intersect.id, ]

    print('Data clipped to boundary')

    # Add column with keyword of the data

    nld.df$keyword <- c(keyword)

    # Write filtered tweets to .CSV file
    write.csv(nld.df@data, file = paste("data/", keyword, "Tweets.csv", sep = ""), row.names = FALSE)

    print('CSV written : DONE')
  }
}

