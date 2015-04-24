## Load data from the files provided
## Features being measured
features <- read.csv("UCI HAR Dataset/features.txt", sep=" ", header = FALSE)

## Types of activities performed by subjects
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"")

## Subjects performing activities for the test dataset
subject_test <- read.delim("UCI HAR Dataset/test/subject_test.txt", sep=" ", header = FALSE)

## Subjects performing activities for the training dataset
subject_train <- read.delim("UCI HAR Dataset/train/subject_train.txt", sep=" ", header = FALSE)

## Training and Test datasets loaded
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"")
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"")
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"")

## Labelling the variables from the features andadditional labels for 'subject' and 'activity'
features <- transform(features, V2 = as.character(V2))
names(X_test) <- features$V2
names(X_train) <- features$V2
names(subject_train) <- c("subject")
names(subject_test) <- c("subject")
names(Y_test) <- c("activity")
names(Y_train) <- c("activity")

## Merging fixed variable data (subject, activity) with coressponding measured variable data
traindata <- cbind (subject_train, Y_train, X_train)
testdata <- cbind (subject_test, Y_test, X_test)

## Adding additional column to identify the source of the data before merging into one data set
traindata$datasource <- "train"
testdata$datasource <- "test"

## Merging training data and test data into one data set
datafull <- rbind(traindata, testdata)

## Extracts only the measurements on the mean and standard deviation for each measurement. 
meanstddata <- datafull[,grepl("[Mm]ean", names(datafull))|grepl("std", names(datafull))|grepl("activity", names(datafull))|grepl("subject", names(datafull))]

## Changing to descriptive activity names to name the activities in the data set
meanstddata <- transform(meanstddata, activity = factor(activity, labels = activity_labels$V2))

## Appropriately labels the data set with descriptive variable names. 
names(meanstddata) <- gsub("^[f]", "frequency", names(meanstddata))
names(meanstddata) <- gsub("^[t]", "time", names(meanstddata))

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("dplyr",character.only = TRUE))
{
    install.packages("dplyr",dep=TRUE)
    if(!require("dplyr",character.only = TRUE)) stop("Package not found")
}
library(dplyr)
datatable <- tbl_df(meanstddata)
tidydata <- datatable %>% group_by(subject,activity) %>% summarise_each(funs(mean))
tidydata
