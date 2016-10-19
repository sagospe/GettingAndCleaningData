## Week 3 Quiz ##

## exercise 1

################################################################################
# The American Community Survey distributes downloadable data about United 
# States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using
# download.file() from here:
#         
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is
# here:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Create a logical vector that identifies the households on greater than 10 
# acres who sold more than $10,000 worth of agriculture products. Assign that 
# logical vector to the variable agricultureLogical. Apply the which() function
# like thisto identify the rows of the data frame where the logical vector
# is TRUE.
#
# which(agricultureLogical)
# 
# What are the first 3 values that result?
# 
# 236, 238, 262
# 
# 403, 756, 798
# 
# 125, 238,262
# 
# 59, 460, 474
################################################################################
if (!file.exists("data")) {
        dir.create("./data")
}

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/idaho_2006.csv")
idaho_2006 <- read.csv("./data/idaho_2006.csv", header = TRUE)

agricultureLogical <- idaho_2006$ACR == 3 & idaho_2006$AGS == 6
which(agricultureLogical)
        


        

## exercise 2

################################################################################
# Using the jpeg package read in the following picture of your instructor into R
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the
# resulting data? (some Linux systems may produce an answer 638 different for
# the 30th quantile)
#
#-10904118 -10575416
#
#-16776430 -15390165
#
#10904118 -594524
#
#-15259150 -10575416
################################################################################

library(jpeg)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileURL, destfile = "./data/jeff.jpg")

picture <- readJPEG("./data/jeff.jpg", native = TRUE)
quantile(picture, probs = c(0.3, 0.8))






# exercise 3


################################################################################
# Load the Gross Domestic Product data for the 190 ranked countries in this
#  data set:
#         
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#         
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. How many of the IDs match? Sort
# the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame?
# 
# Original data sources:
#         
#        http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats
# 
# 189 matches, 13th country is St. Kitts and Nevis
# 
# 234 matches, 13th country is Spain
# 
# 189 matches, 13th country is Spain
# 
# 190 matches, 13th country is Spain
# 
# 234 matches, 13th country is St. Kitts and Nevis
# 
# 190 matches, 13th country is St. Kitts and Nevis
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





# exercise 4

################################################################################
# What is the average GDP ranking for the "High income: OECD" and 
# "High income: nonOECD" group?
# 
# 23.966667, 30.91304
# 
# 23, 30
# 
# 32.96667, 91.91304
# 
# 30, 37
# 
# 23, 45
# 
# 133.72973, 32.96667
################################################################################
tapply(tbl_merged$Rank,tbl_merged$Income.Group,mean)




# exercise 5

################################################################################
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus
# Income.Group. How many countries are Lower middle income but 
# among the 38 nations with highest GDP?
################################################################################

library(Hmisc)

tbl_merged$RankGroup <- cut2(tbl_merged$Rank, g = 5)
table(tbl_merged$RankGroup, tbl_merged$Income.Group)


