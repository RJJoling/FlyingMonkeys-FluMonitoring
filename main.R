# Check if required package is installed
require("RPostgreSQL")

# Import libraries
library('RPostgreSQL')

# Load functions
source("R/SelectTweetsAndWriteToCSV.R")
source("R/FilterRelevantTweets.R")
source("R/FormatDateColumn.R")


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






