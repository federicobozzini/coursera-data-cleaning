ex4 <- function() {
        setwd("~/software/getdata/week4")
        res <- list()
        
        
        filename1 <- "e1.csv"
        if (!file.exists(filename1)) {
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", filename1, "wget")    
        }
        e1 <- read.csv(filename1)
        e1_names <- names(e1)
        splitted_names <- sapply(e1_names, strsplit, "wgtp")
        res1 <- splitted_names[123]$wgtp15
        res <- c(res, "ex1"=res1)
        
        
        trim <- function (x) gsub("^\\s+|\\s+$", "", x)
        removeCommas <- function(x) gsub(",", "", x)
        clean <- function(x) as.numeric(trim(removeCommas(x)))
        filename2 <- "e2.csv"
        if (!file.exists(filename2)) {
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", filename2, "wget")    
        }
        e2 <- read.csv(filename2, header=F)
        e2_clean <- subset(e2, !is.na(V5) & grepl("[0-9]", V5) & grepl("[0-9]", V2))
        gdps_str <- e2_clean$V5
        gdps <- sapply(gdps_str, clean)
        res2 <- mean(gdps)
        res <- c(res, "ex2"=res2)
        
        
        countryNames <- e2_clean$V4       
        res3 <- sum(grepl("^United",countryNames)) 
        res <- c(res, "ex3"=res3)
        
        
        filename4 <- "e4.csv"
        if (!file.exists(filename4)) {
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", filename4, "wget")    
        }
        e4 <- read.csv(filename4, header=T)
        countryData <- merge(e2_clean, e4, by.x = "V1", by.y = "CountryCode")        
        res4 <- sum(grepl("Fiscal.+?[jJ]une 30", countryData$Special.Notes))
        res <- c(res, "ex4"=res4)
        
        isOn2012 <- function(x) format(x, "%Y") == "2012"
        isOnMondays2012 <- function(x) isOn2012(x) & weekdays(x) == "lunedì"
        library(quantmod)
        amzn = getSymbols("AMZN",auto.assign=FALSE)
        sampleTimes = index(amzn) 
        on2012 <- sum(sapply(sampleTimes, isOn2012))
        onMondays2012 <- sum(sapply(sampleTimes, isOnMondays2012))
        res5 <- c(on2012, onMondays2012)
        res <- c(res, "ex5"=res5)
        
        res
        
}