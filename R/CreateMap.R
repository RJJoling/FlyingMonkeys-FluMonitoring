# Import libraries
if(!require(ggmap)){install.packages('ggmap')}
if(!require(grid)){install.packages('grid')}


createMap <- function(combined.df, month){

  # This function creates a map from a dataframe, based on the input month
  #
  # Args:
  # combined.df = dataframe of combined tweets
  # month = required month
  #
  # Returns: map of combined tweets, based on the input month

  # Subset tweets by input month
  data <- subset(combined.df, tweet_datetime == month)

  # Define map theme
  theme <- theme(plot.title = element_text(size=rel(3)),
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

  # Create basemap
  getmap <- get_stamenmap(bbox = c(left = 2.917310, bottom = 50.507220, right = 7.438184,
                                   top = 53.579787), zoom = 7, maptype = "toner")
  basemap <- ggmap(getmap)

  # Create variable title, based on input month
  title <- paste("Sickness distribution in the Netherlands for:\n", month, sep = "")

  # Define scale size range
  min <- 1.5*min(data$count)
  max <- 1.5*max(data$count)

  # Create map
  map <- basemap + geom_point(data = data, alpha = 0.5,
         aes(x = longitude, y = latitude, colour = keyword, size = count)) +
         scale_colour_manual(values = c("#D7191C", "#FF7F00", "#2C7BB6")) +
         scale_size(range = c(min,max)) +
         guides(colour = guide_legend(override.aes = list(size=4)), size = FALSE) +
         facet_grid(. ~ keyword) +
         labs(title = title) +
         theme

  print(paste("Map for", month, "created : DONE"))

  return(map)
}

