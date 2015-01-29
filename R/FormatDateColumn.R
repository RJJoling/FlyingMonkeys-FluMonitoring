FormatDateColumn <- function(filepaths){

  # This function changes the data type of the second column to 'date'
  #
  # Args:
  # filepaths = list of filepaths to .CSV-files
  #
  # Returns: Same .CSV-file as input file, with data type of the second column
  # changed to 'date'

  # Iterate the input filepaths, change data type of date/time column to 'date'
  for (file in filepaths){
    df <- read.csv(file)
    matrix <- as.matrix(df)
    date <- as.Date(matrix[ ,2])
    matrix[ ,2] <- format(date, "%B %Y")
    write.csv(matrix, file, row.names = FALSE)
  }
  print('Dates transformed : DONE')
}

