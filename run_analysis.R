##load Libraries
##install.packages("data.table")
##install.packages("dplyr")

library("data.table")
library("dplyr")

print("Reading Data")
##read data
features <- read.table("UCI HAR Dataset/features.txt", quote="\"")
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("Activity.ID", "Activity.Description"),quote="\"")

print("Reading Test Data")
##Test Data
test.var <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=features[[2]], quote="\"")
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject.ID"), quote="\"")
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("Activity.ID"), quote="\"")
##join activity description to ID
test.label <- left_join(test.activity, activity.labels, by="Activity.ID")

##add activity and subject columns to variable data
test.var <- dplyr::bind_cols(test.label, test.var)
test.var <- dplyr::bind_cols(test.subject, test.var)

##Select only the Standard Deviation and Mean variables
test.var <- select(test.var, Subject.ID, Activity.Description, matches("mean"), matches("std"), -matches("angle"))

print("Reading Training Data")
##Training Data
train.var <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features[[2]], quote="\"")
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("Subject.ID"), quote="\"")
train.activity <- read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("Activity.ID"), quote="\"")
##join activity description to ID
train.label <- left_join(train.activity, activity.labels, by="Activity.ID")

##add activity and subject columns to variable data
train.var <- dplyr::bind_cols(train.label, train.var)
train.var <- dplyr::bind_cols(train.subject, train.var)

##Select only the Standard Deviation and Mean variables
train.var <- select(train.var, Subject.ID, Activity.Description, matches("mean"), matches("std"), -matches("angle"))


print("Merge Training and Test")
##Merge Test and Training
df <- dplyr::bind_rows(test.var, train.var)
print("Summarize dataset")
##Summarize merged data set by averaging values for each subject and activity combination
df.Sum <- df %>% group_by(Subject.ID, Activity.Description) %>% summarise_each(funs(mean)) %>% arrange(Subject.ID, Activity.Description)

print("renaming columns")
##add descriptive column names
##create vector of column names from summarized data set
nm <- colnames(df)
nm <- gsub("BodyBody", "Body", nm)
nm <- gsub("Freq", "", nm)

##BodyAcc
nm <- gsub("tBodyAcc", "BodyAccelerationTime", nm)
nm <- gsub("fBodyAcc", "BodyAccelerationFrequency", nm)
##GravityAcc
nm <- gsub("tGravityAcc", "GravityAccelerationTime", nm)
nm <- gsub("fGravityAcc", "GravityAccelerationFrequency", nm)
##BodyAccJerk
nm <- gsub("tBodyAccJerk", "BodyAccelerationJerkTime", nm)
nm <- gsub("fBodyAccJerk", "BodyAccelerationJerkFrequency", nm)
##BodyGyro
nm <- gsub("tBodyGyro", "BodyAngularVelocityTime", nm)
nm <- gsub("fBodyGyro", "BodyAngularVelocityFrequency", nm)
##BodyGyroJerk
nm <- gsub("tBodyGyroJerk", "BodyAngularVelocityJerkTime", nm)
nm <- gsub("fBodyGyroJerk", "BodyAngularVelocityJerkFrequency", nm)
##BodyAccMag
nm <- gsub("tBodyAccMag", "BodyAccelerationMagnitudeTime", nm)
nm <- gsub("fBodyAccMag", "BodyAccelerationMagnitudeFrequency", nm)
##GravityAccMag
nm <- gsub("tGravityAccMag", "GravityAccelerationMagnitudeTime", nm)
nm <- gsub("fGravityAccMag", "GravityAccelerationMagnitudeFrequency", nm)
##BodyAccJerkMag
nm <- gsub("tBodyAccJerkMag", "BodyAccelerationJerkMagnitudeTime", nm)
nm <- gsub("fBodyAccJerkMag", "BodyAccelerationJerkMagnitudeFrequency", nm)
##BodyGyroMag
nm <- gsub("tBodyGyroMag", "BodyAngularVelocityMagnitudeTime", nm)
nm <- gsub("fBodyGyroMag", "BodyAngularVelocityMagnitudeFrequency", nm)
##BodyGyroJerkMag
nm <- gsub("tBodyGyroJerkMag", "BodyAngularVelocityJerkMagnitudeTime", nm)
nm <- gsub("fBodyGyroJerkMag", "BodyAngularVelocityJerkMagnitudeFrequency", nm)

nm <- gsub(".std", "StandardDeviation", nm)
nm <- gsub(".mean", "Mean", nm)
nm <- gsub("\\.", "", nm)
##rename columns in summarized dataset to new descriptive names in nm vector
colnames(df.Sum) <- nm

print("Writing output file")
##write dataset to file
write.table(df.Sum, file="GettingAndCleaningData-CourseProject-SamsungPhoneDataTidy.txt", sep=",", row.names=FALSE, col.names=TRUE)