
FilterRelevantTweets <- function(CSV.filepath, list){


df <- read.csv(CSV.filepath)
matrix <- as.matrix(df)
matrix2 <- tolower(matrix)

for (row in nrow(matrix): 1){
  line <- matrix2[row, ]
  for (keyword in list){
    if (grepl(keyword, matrix2[row, 1])){
      matrix <- matrix[-row, ]
      break
    }
   }
  }
file <- strsplit(CSV.filepath, ".csv")
write.csv(matrix, file = paste(file, 'Filtered.csv', sep = ""), row.names = FALSE)
print('Filtered CSV written : DONE')
}