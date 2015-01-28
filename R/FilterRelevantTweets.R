require(sqldf)

library(sqldf)

FilterRelevantTweets <- function(CSV.file){
  """" This is a docstring
  """"
  df <- read.csv.sql('data/griepTweets.csv', sql = "select * from file where tweet_text not like 'vogelgriep' or tweet_text not like 'griepepidemie'")
}

df <- read.csv('data/griepTweets.csv')
df2 <- sqldf("select * from file where tweet_text not like 'vogelgriep' or tweet_text not like 'griepepidemie'")

temp <- read.csv.sql("data/griepTweets.csv",
                      filter = "perl -p -e 's{(\"[^\",]+),([^\"]+\")}{$_= $&, s/,/_/g, $_}eg'",
                      header=FALSE)
