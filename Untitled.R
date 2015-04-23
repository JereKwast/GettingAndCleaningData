install.packages("dplyr")
library(dplyr)

install.packages("data.table")
library(data.table)

temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
xtest <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
xtrain <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))

features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))

test.activities <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
xtest <- mutate(xtest, test.activities)