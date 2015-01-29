# Team Name:               Team Members:               Date:
# Flying Monkeys           Robbert-Jan Joling          29-01-2015
#                          Damiano Luzzi

# Import libraries
if(!require(RPostgreSQL)){install.packages('RPostgreSQL')}

# Load functions
source("R/SelectTweetsAndWriteToCSV.R")
source("R/FilterRelevantTweets.R")
source("R/FormatDateColumn.R")
source("R/createMap.R")
source("R/BucketTweets.R")


# PRE-PROCESSING ----------------------------------------------------------

# Get driver for database and make connection to it
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host='10.75.14.108', dbname='gis', user='gisuser', password='user')

# Select and save tweets based on keywords, save as .CSV
tweets <- c('griep', 'verkoud', 'koorts')
SelectTweetsAndWriteToCSV(tweets)

# Disconnect connection and unload driver
dbDisconnect(con)
dbUnloadDriver(drv)

# Remove irrelevant tweets from files using a filter
griep.filepath <- 'data/griepTweets.csv'
griep.filter <- c('vogelgriep', 'griepepidemie','griepprik', 'griep-epidemie')
FilterRelevantTweets(griep.filepath, griep.filter)

koorts.filepath <- 'data/koortsTweets.csv'
koorts.filter <- c('goudkoorts', 'carnavalskoorts', 'hooikoorts', 'koortslip',
                   'elfstedenkoorts', 'q-koorts', 'plankenkoorts', 'oranjekoorts')
FilterRelevantTweets(koorts.filepath, koorts.filter)

# Format dates of tweets to month/year
filepaths <- c('data/griepTweetsFiltered.csv', 'data/koortsTweetsFiltered.csv', 'data/verkoudTweets.csv')
FormatDateColumn(filepaths)


# ANALYSIS ----------------------------------------------------------------
# Combine tweets that are within radius
radius <- 20
combined.tweets <- BucketTweets(filepaths, radius)


# VISUALISATION -----------------------------------------------------------

# Create Maps

months <- levels(combined.tweets$tweet_datetime)
count <- 1

while (count <= length(months)){
  month = months[count]
  print(month)
  map <- createMap(combined.tweets, month)
  png(paste("output/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
  plot(map)
  dev.off()
  count <- count + 1
}

