## Week 4 Quiz ##

## exercise 1

################################################################################
# The American Community Survey distributes downloadable data about United
# States communities. Download the 2006 microdata survey about housing for the 
# state of Idaho using download.file() from here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Apply strsplit() to split all the names of the data frame on the characters 
# "wgtp". What is the value of the 123 element of the resulting list?
# 
# "15"
# 
# "" "15"
# 
# "w" "15"
# 
# "wgtp" "15"
################################################################################
if (!file.exists("data")) {
        dir.create("./data")
}

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/idaho_2006.csv")
idaho_2006 <- read.csv("./data/idaho_2006.csv", header = TRUE)

result <- strsplit(names(idaho_2006), "wgtp")
result[[123]]





## exercise 2


################################################################################
# Load the Gross Domestic Product data for the 190 ranked countries in this 
# data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Remove the commas from the GDP numbers in millions of dollars and average
# them. What is the average?
# 
# Original data sources:
#         
#         http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# 293700.3
# 
# 381668.9
# 
# 387854.4
# 
# 377652.4
################################################################################
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileURL, destfile = "./data/GDP.csv")
GDP <- read.csv("./data/GDP.csv", header = TRUE, colClasses = "character")  

#removing extra rows, we only need the rows with a specific rank
GDP$Gross.domestic.product.2012 <- as.numeric(GDP$Gross.domestic.product.2012)
GDP <- GDP[!is.na(GDP$Gross.domestic.product.2012),]

GDP$amount <- as.numeric(gsub(",", "", GDP$X.3))
GDP_mean <- mean(GDP$amount, na.rm = TRUE)




## exercise 3

################################################################################
# In the data set from Question 2 what is a regular expression that would allow 
# you to count the number of countries whose name begins with "United"? Assume 
# that the variable with the country names in it is named countryNames.
# How many countries begin with United?
# 
# grep("United$",countryNames), 3
# 
# grep("^United",countryNames), 4
# 
# grep("*United",countryNames), 2
# 
# grep("^United",countryNames), 3
################################################################################
GDP$countryNames <- GDP$X.2
countryNames <- GDP$countryNames

grep("^United",countryNames)
countryNames[grep("^United",countryNames)]




## exercise 4

################################################################################
# Load the Gross Domestic Product data for the 190 ranked countries in this
# data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. Of the countries for which 
# the end of the fiscal year is available, how many end in June?
# 
# Original data sources:
#         
#         http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats
# 
# 16
# 
# 7
# 
# 8
# 
# 13
# 
################################################################################

library(dplyr)

fileURL1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileURL1, destfile = "./data/GDP.csv")
GDP <- read.csv("./data/GDP.csv", header = TRUE)
# transforming factor to numeric
GDP$Rank <- as.numeric(as.character(GDP$Gross.domestic.product.2012)) 


fileURL2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileURL2, destfile = "./data/educational.csv")
educational <- read.csv("./data/educational.csv", header = TRUE)

data_merged <- merge(GDP, educational, by.x = "X", by.y = "CountryCode", all = FALSE)

tbl_merged <- tbl_df(data_merged) %>%
        filter(!is.na(Rank)) %>% # removing NAs        
        arrange(desc(Rank))

result2 <- grep("Fiscal year end: June",tbl_merged$Special.Notes)
length(result2)





## exercise 5

################################################################################
# You can use the quantmod (http://www.quantmod.com/) package to get historical 
# stock prices for publicly traded companies on the NASDAQ and NYSE. Use the
# following code to download data on Amazon's stock price and get the times 
# the data was sampled.
# 
# library(quantmod)
# amzn = getSymbols("AMZN",auto.assign=FALSE)
# sampleTimes = index(amzn)
# 
# How many values were collected in 2012? How many values were collected on 
# Mondays in 2012?
# 
################################################################################
library(quantmod)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn)

library(lubridate)
sum(year(sampleTimes) == 2012)

sum(year(sampleTimes) == 2012 & wday(sampleTimes) == 2) # Sunday is 1
