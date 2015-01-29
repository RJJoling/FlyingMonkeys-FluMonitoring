# Import libraries
if(!require(plyr)){install.packages('plyr')}


BucketTweets <- function(filepaths, radius){

  # This function buckets tweets together, that fall within a certain distance,
  # based on (2 * radius) latitude/longitude degrees of each other
  #
  # Args:
  # filepaths = list of filepaths to .CSV-files
  # radius =
  #
  # Returns: capitalised words of input string

  # Combine files from the input filenames
  combined.df <- do.call("rbind", lapply(filepaths, read.csv, header = TRUE))

  # Count the number of tweets in the same geographic area, based on the input radius
  bucket.df <- transform(combined.df, latitude = round(radius * latitude) / radius,
                        longitude = round(radius * longitude) / radius)
  count.df <- ddply(bucket.df, .(tweet_datetime, longitude, latitude, keyword),
                   summarise, count = length(longitude))

  print("Bucket tweets : DONE")

  return count.df
}
