# loading needed libraries
library(readr) #this library provides better performance to read table than base
library(dplyr)
library(plyr)

###############################################################################
# Step 1
# Merge the training and test sets to create one data set
###############################################################################

x_train <- read_table("./data/train/X_train.txt", col_names = FALSE)
y_train <- read_table("./data/train/y_train.txt", col_names = FALSE)
subject_train <- read_table("./data/train/subject_train.txt", col_names = FALSE)

x_test <- read_table("./data/test/X_test.txt", col_names = FALSE)
y_test <- read_table("./data/test/y_test.txt", col_names = FALSE)
subject_test <- read_table("./data/test/subject_test.txt", col_names = FALSE)

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)





###############################################################################
# Step 2
# Extract only the measurements on the mean and standard deviation for each
# measurement
###############################################################################

features <- read.table("./data/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]





###############################################################################
# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("./data/activity_labels.txt")

# updating column name
names(y_data) <- "activity"
names(activities) <- c("activity", "description")

# update values with correct activity names
y_data <- inner_join(y_data, activities, by = "activity")








###############################################################################
# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)




###############################################################################
# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# select every column but 'description' in order to make the average for 
# each column
# NOTE: summarise_each returns the result of funs in every column
averages_data  <- all_data %>% select(-description) %>% 
        group_by(subject, activity) %>% 
        summarise_each(funs(mean)) 


write.table(averages_data, "./averages_data.txt", row.name=FALSE)
