FilterRelevantTweets <- function(CSV.filepath, list){

  # This function filters a .CSV-file by keywords from a list
  #
  # Args:
  # CSV.filepath = path to .CSV file
  # list = list of keywords to be filtered
  #
  # Returns: .CSV-file with rows removed where input keywords apply

  # Load .CSV-file (to memory) and create a matrix of it
  df <- read.csv(CSV.filepath)
  matrix <- as.matrix(df)
  matrix2 <- tolower(matrix)

  # Iterate each row in the .CSV file in reversed order,
  # delete the row when a keyword is found
  for (row in nrow(matrix): 1){
    line <- matrix2[row, ]
    for (keyword in list){
      if (grepl(keyword, matrix2[row, 1])){
        matrix <- matrix[-row, ]
        break
      }
    }
  }
  # Save filtered matrix to .CSV-file
  file <- strsplit(CSV.filepath, ".csv")
  write.csv(matrix, file = paste(file, 'Filtered.csv', sep = ""), row.names = FALSE)
  print('Filtered CSV written : DONE')
}
