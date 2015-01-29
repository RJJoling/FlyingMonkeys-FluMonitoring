# Check if required package is installed
require("RPostgreSQL")

# Import libraries
library('RPostgreSQL')

# Load functions
source("R/SelectTweetsAndWriteToCSV.R")
source("R/FilterRelevantTweets.R")
source("R/FormatDateColumn.R")
source("R/createMap.R", print.eval = F)
source("R/createPNG.R")

# Get driver for database and make connection to it
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host='10.75.14.108', dbname='gis', user='gisuser', password='user')

## Index dataset, filter to data required
## Clip dataset to the Netherlands
## Write database to txt or csv
tweets <- c('griep', 'verkoud', 'koorts')

SelectTweetsAndWriteToCSV(tweets)

# Disconnect connection and unload driver
dbDisconnect(con)

dbUnloadDriver(drv)

# Remove irrelevant tweets from files

list <- c('vogelgriep', 'griepepidemie','griepprik', 'griep-epidemie')
FilterRelevantTweets('data/griepTweets.csv', list)

list <- c('goudkoorts', 'carnavalskoorts', 'hooikoorts', 'koortslip', 'elfstedenkoorts', 'q-koorts', 'plankenkoorts', 'oranjekoorts')
FilterRelevantTweets('data/koortsTweets.csv', list)

# Format dates of tweets to Month/Year
files <- c('data/griepTweetsFiltered.csv', 'data/koortsTweetsFiltered.csv', 'data/verkoudTweets.csv')

FormatDateColumn(files)

months = c('november 2013', 'december 2013', 'januari 2014', 'februari 2014', 'maart 2014', 'april 2014', 'mei 2014', 'juni 2014', 'juli 2014', 'augustus 2014', 'september 2014', 'oktober 2014', 'november 2014', 'december 2014', 'januari 2015')

# Create Maps

month = 'november 2013'

png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()

month = 'december 2013'

png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'januari 2014'

png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()

month = 'februari 2014'

png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'maart 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'april 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'mei 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'juni 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'juli 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'augustus 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'september 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'oktober 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'november 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()
month = 'december 2014'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()

month = 'januari 2015'
png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
createMap(month)
dev.off()