##load Libraries
library("data.table")
library("dplyr")

setwd("~/R/getdata-projectfiles-UCI HAR Dataset")

##read data
features <- read.table("UCI HAR Dataset/features.txt", quote="\"")
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("Activity.ID", "Activity.Description"),quote="\"")
##Y_labels <- rename(Y_labels, ActivityID = V1 , ActivityDescription = V2)

##Test Data
test.var <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features[[2]], quote="\"")
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject.ID"), quote="\"")
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("Activity.ID"), quote="\"")
##Y_test <- rename(Y_test, ActivityID = V1)
test.label <- merge(test.activity, activity.labels, by="Activity.ID",all=TRUE)

test.var <- dplyr::bind_cols(test.label, test.var)
test.var <- dplyr::bind_cols(test.subject, test.var)

##Select STD and Mean Columns
test.var <- select(test.var, Subject.ID, Activity.ID, Activity.Description, matches("mean"), matches("std"))

##Training Data
train.var <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features[[2]], quote="\"")
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("Subject.ID"), quote="\"")
train.activity <- read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("Activity.ID"), quote="\"")
train.label <- merge(train.activity, activity.labels, by="Activity.ID",all=TRUE)

train.var <- dplyr::bind_cols(train.label, train.var)
train.var <- dplyr::bind_cols(train.subject, train.var)

train.var <- select(train.var, Subject.ID, Activity.ID, Activity.Description, matches("mean"), matches("std"))



##Merge Test and Training
df <- dplyr::bind_rows(test.var, train.var)



##add column names
colnames(X_test) <- features[[2]]
colnames(X_train) <- features[[2]]

##Merge Datasets
df <- dplyr::union(X_test,X_train)
