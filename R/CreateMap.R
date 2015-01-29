
library(plyr)
library(ggmap)
library(grid)

filenames <- c("data/verkoudTweets.csv", "data/griepTweetsFiltered.csv", "data/koortsTweetsFiltered.csv")
combined.df <- do.call("rbind", lapply(filenames, read.csv, header = TRUE))


# Count the number of tweets in the same geographic area.
RADIUS = 20 # Bucket tweets within 2 * RADIUS latitude/longitude degrees of each other.
bucket.df = transform(combined.df, latitude = round(RADIUS * latitude) / RADIUS, longitude = round(RADIUS * longitude) / RADIUS)
count.df = ddply(bucket.df, .(tweet_datetime, longitude, latitude, keyword), summarise, count = length(longitude))


createMap <- function(month){
data = subset(count.df, tweet_datetime == month)


  theme = theme(plot.title = element_text(size=rel(3)),
                panel.grid.minor = element_blank(),
                panel.grid.major = element_blank(),
                panel.margin = unit(0.5, "lines"),
                panel.border = element_rect(colour = "black", fill = NA),
                axis.title.x = element_blank(),
                axis.title.y = element_blank(),
                axis.line = element_blank(),
                axis.ticks = element_blank(),
                axis.text.y = element_blank(),
                axis.text.x = element_blank(),
                strip.background = element_blank(),
                strip.text = element_blank(),
                legend.title = element_text(size = 14, face = "bold"),
                legend.key = element_rect(fill='white'),
                legend.text = element_text(size = 12))


getmap <- get_stamenmap(bbox = c(left = 2.917310, bottom = 50.507220, right = 7.438184, top = 53.579787), zoom = 7, maptype = "toner")

basemap <- ggmap(getmap)

min <- 1.5*min(data$count)

max <- 1.5*max(data$count)

title <- paste("Sickness distribution in the Netherlands for:\n", month, sep = "")

map <- basemap + geom_point(data = data, alpha = 0.5, aes(x = longitude, y = latitude, colour = keyword, size = count)) +
  scale_colour_manual(values = c("#D7191C", "#FF7F00", "#2C7BB6")) +
  scale_size(range = c(min,max)) +
  guides(colour = guide_legend(override.aes = list(size=4)), size = FALSE) +
  facet_grid(. ~ keyword) +
  labs(title = title) +
  theme

return(map)
}

