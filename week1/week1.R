week1 <-function() {
        #ex1
        setwd("~/software/getdata/week1")
        ex1 <- read.csv('getdata_data_ss06hid.csv')
        res1 <- sum(na.omit(ex1[,'VAL']) == 24)
        cat('res 1: ', res1, '\n')
        
        
        #ex3        
        library(xlsx)
        rowIndex = 17:23
        colIndex = 7:15
        dat <- read.xlsx('getdata_data_DATA.gov_NGAP.xlsx', sheetIndex=1, rowIndex=rowIndex, colIndex=colIndex, header=TRUE)
        res3 <- sum(dat$Zip*dat$Ext,na.rm=T)
        cat('res3: ', res3, '\n')
        
        #ex4
        library('XML')
        restaurants <- xmlTreeParse("getdata_data_restaurants.xml", useInternal=T)
        rootNode <- xmlRoot(restaurants)
        zipcodes = xpathSApply(rootNode, "//row/row/zipcode", xmlValue)
        res4 <- sum (zipcodes == '21231')
        cat('res4: ', res4, '\n')
        
        #ex5
        library("data.table")
        library("RCurl")
        if (!file.exists("ex5.csv")) {
                download.file(fileUrl, destfile="ex5.csv", method="curl")
        }
        DT <- fread("ex5.csv")
        system.time(replicate(1000, sapply(split(DT$pwgtp15,DT$SEX),mean)))
        system.time(replicate(1000, tapply(DT$pwgtp15,DT$SEX,mean)))
        #wrong
        system.time(replicate(1000, DT[,mean(pwgtp15),by=SEX]))
        cat('res5: ', 'sapply...', '\n')
        
        
}