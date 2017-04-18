ex3 <- function() {
        setwd("~/software/getdata/week3")
        filename1 <- "gdp.csv"
        filename2 <- "ed.csv"
        if (!file.exists(filename1)) {
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", filename1, "wget")    
        }
        if (!file.exists(filename2)) {
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", filename2, "wget")    
        }
        gdp <- read.csv(filename1)
        gdp <- subset(gdp, !is.na(Ranking))
        gdp$GDP <- as.numeric(sub(",", ".", gdp$GDP, fixed = TRUE))
        ed <- read.csv(filename2)
        data <- merge(gdp, ed, by.x="shortcode", by.y="CountryCode", all=TRUE)
        found <- length(intersect(gdp$shortcode, ed$CountryCode))
        thirteenCountry <- as.vector(data[order(data$Ranking, decreasing = TRUE), "name"])[13]
        cat("ex3: ", found, ",", thirteenCountry, '\n')
        
        datafull = subset(data, !is.na(data$Ranking))
        meanrank <- tapply(datafull$Ranking, datafull$Income.Group, mean)
        hi_oecd_meanrank <- meanrank[["High income: OECD"]]
        hi_noecd_meanrank <- meanrank[["High income: nonOECD"]]
        cat("ex4: ", hi_oecd_meanrank, ",", hi_noecd_meanrank, '\n')
        
        res5 <- length(which(datafull$Income.Group == "Lower middle income" & datafull$Ranking <= 38))
        cat("ex5: ", res5, '\n')
}