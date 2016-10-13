## Week 1 Quiz ##

if (!file.exists("data")) {
        dir.create("data")
}
        


#############################################################################################
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
# from here: 
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# 
# and load the data into R. 
# 
# The code book, describing the variable names is here: 
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
# 
# How many housing units in this survey were worth more than $1,000,000?
#############################################################################################

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/housing.csv", method = "curl")
housingData <- read.csv("./data/housing.csv")

nrow(subset(housingData, housingData$VAL == 24))


#############################################################################################
# Download the Excel spreadsheet on Natural Gas Aquisition Program here: 
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx 
# 
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called dat 
# 
# What is the value of:
#   sum(dat$Zip*dat$Ext,na.rm=T) 
# 
# (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)
#############################################################################################
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./data/naturalGas.xlsx", method = "curl")

library(xlsx)
# Reading specific rows and columns
colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("./data/naturalGas.xlsx", sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex)

sum(dat$Zip*dat$Ext,na.rm=T) 


#############################################################################################
# Read the XML data on Baltimore restaurants from here: 
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml 
# 
# How many restaurants have zipcode 21231?
#############################################################################################
library(XML)
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
restaurants <- xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode <- xmlRoot(restaurants)
# Get the items on the menu and prices
zipcodes <- xpathSApply(rootNode, "//zipcode", xmlValue)
sum(zipcodes == "21231")


#############################################################################################
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
# from here: 
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv 
# 
# using the fread() command load the data into an R object DT 
# 
# Which of the following is the fastest way to calculate the average value of the variable pwgtp15 
# broken down by sex using the data.table package?
# mean(DT$pwgtp15,by=DT$SEX)
# sapply(split(DT$pwgtp15,DT$SEX),mean)
# DT[,mean(pwgtp15),by=SEX]
# mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
# rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
# tapply(DT$pwgtp15,DT$SEX,mean)
#############################################################################################
library(data.table)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/housingIdaho.csv", method = "curl")
DT <- fread("./data/housingIdaho.csv")

system.time(DT[,mean(pwgtp15),by=SEX])

