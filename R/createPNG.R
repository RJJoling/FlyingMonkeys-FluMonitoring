

createPNG <- function(month){
    png(paste("data/", month, ".png", sep = ""), height = 3000, width = 5000, res = 300)
    createMap(month)
    dev.off()
}