setwd("C:/coursera/UCI HAR Dataset")

#x_train<-read.csv("train/X_train.txt",sep = " ")

activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

featuresWanted <- grep(".*mean.*|.*std.*", features[,2])

featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)
train <- read.table("train/X_train.txt")[featuresWanted]
trainActivities <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)