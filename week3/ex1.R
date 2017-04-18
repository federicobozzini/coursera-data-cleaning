ex1 <- function() {
        setwd("~/software/getdata/week3")
        if (!file.exists("ex1.csv")) {
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "ex1.csv", "wget")    
        }
        data <- read.csv("ex1.csv")
        agricultureLogical <- data$ACR ==3 & data$AGS == 6
        head(which(agricultureLogical), 3)
}