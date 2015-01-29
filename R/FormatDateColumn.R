

FormatDateColumn <- function(filepaths){

  for (file in filepaths){
    df <- read.csv(file)
    matrix <- as.matrix(df)
    date <- as.Date(matrix[ ,2])
    matrix[ ,2] <- format(date, "%B %Y")
    write.csv(matrix, file, row.names = FALSE)
  }
  print('Dates transformed : DONE')
}

