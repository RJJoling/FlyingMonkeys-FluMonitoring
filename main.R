# Check if required package is installed
require("RPostgreSQL")

# Import libraries
library('RPostgreSQL')

# Load functions
source("R/SelectTweetsAndWriteToCSV.R")


# Get driver for database and make connection to it
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host='xx', dbname='xx', user='xx', password='xx')

## Index dataset, filter to data required
## Clip dataset to the Netherlands
## Write database to txt or csv
tweets <- c('griep', 'verkoud', 'koorts')

SelectTweetsAndWriteToCSV(tweets)

## Bucket tweets from municipalites into clusters

## Create monthly averages

## Plot monthly averages

## Create GUI interface to show monthly averages compare to each other


# Disconnect connection and unload driver
dbDisconnect(con)
dbUnloadDriver(drv)

# name <- ""
# for (char in keyword){
#
#   if (char in [a-zA-Z]){
#     name <- paste(name, "")
#   }
# }
#
#   name <- paste(name, sub("[^[:alpha:]]","",char, sep = "")
# }
# if (is.character(char)){
#   name += char
# }}
# paste("data/", name, "Tweets.csv", sep = "")
