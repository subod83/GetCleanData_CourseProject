---
title: "Readme"
output: html_document
---


### 1. Merges the training and the test sets to create one data set.

a. Features being measured in the training data and test data
 
```
features <- read.csv("UCI HAR Dataset/features.txt", sep=" ", header = FALSE)
```

b. Types of activities performed by subjects are loaded

```
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"")
```

c. Subjects performing activities for the test and training dataset are loaded

```
subject_test <- read.delim("UCI HAR Dataset/test/subject_test.txt", sep=" ", header = FALSE)
subject_train <- read.delim("UCI HAR Dataset/train/subject_train.txt", sep=" ", header = FALSE)
```

d. Training and Test datasets loaded

```
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"")
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"")
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"")
```

e. Labelling the variables from the features and additional labels for 'subject' and 'activity'

```
features <- transform(features, V2 = as.character(V2))
names(X_test) <- features$V2
names(X_train) <- features$V2
names(subject_train) <- c("subject")
names(subject_test) <- c("subject")
names(Y_test) <- c("activity")
names(Y_train) <- c("activity")
```

f. Merging fixed variable data (subject, activity) with coressponding measured variable data

```
traindata <- cbind (subject_train, Y_train, X_train)
testdata <- cbind (subject_test, Y_test, X_test)
```

g. Adding additional column to identify the source of the data before merging into one data set

```
traindata$datasource <- "train"
testdata$datasource <- "test"
```

h. Merging training data and test data into one data set

```
datafull <- rbind(traindata, testdata)
```


### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

Subsets the data to include only measurements that have 'mean' or 'std' in the variable name or is 'subject' or 'activity'

```
meanstddata <- datafull[,grepl("[Mm]ean", names(datafull))|grepl("std", names(datafull))|grepl("activity", names(datafull))|grepl("subject", names(datafull))]
```

###3. Uses descriptive activity names to name the activities in the data set

The activity is changed to a factor with the labels sourced from activity_labels

```
meanstddata <- transform(meanstddata, activity = factor(activity, labels = activity_labels$V2))
```

###4. Appropriately labels the data set with descriptive variable names. 

The labels from the features.txt file are relatively self explanatory, the prefix of 't' and 'f' were not too clear so that was changed to 'time' and 'frequency' correspondingly. Please refer to the CodeBook for further details.

```
names(meanstddata) <- gsub("^[f]", "frequency", names(meanstddata))
names(meanstddata) <- gsub("^[t]", "time", names(meanstddata))
```

###5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

As specified the table has been tidied with the average of each variable for each activity and each subject.

```
install.packages("dplyr")
library(dplyr)
datatable <- tbl_df(meanstddata)
tidydata <- datatable %>% group_by(subject, activity) %>% summarise_each(funs(mean))
```
