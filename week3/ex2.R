ex2 <- function() {
        library("jpeg")
        setwd("~/software/getdata/week3")
        filename <- "ex2.csv"
        if (!file.exists(filename)) {
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", filename, "wget")    
        }
        image <- readJPEG(filename, native=TRUE)
        quantile(image, prob=c(0.3, 0.8))
}