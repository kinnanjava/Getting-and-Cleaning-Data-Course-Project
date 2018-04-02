install.packages("reshape2")
library(reshape2)


## The data set is already downloaded to folder UCI HAR Dataset
setwd("C:/coursera/Getting-and-Cleaning-Data-Course-Project")

#Read Activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
#change the label to character class
activityLabels[,2] <- as.character(activityLabels[,2])

#read features
features <- read.table("UCI HAR Dataset/features.txt")
#change the feature to character class
features[,2] <- as.character(features[,2])

#We need to extracts only the measurements on the mean and standard deviation for each measurement.
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
#Some beautification on the names
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#read training data set with only features wanted ie. Mean and Standard deviation
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
#read train activities and subjects and combine them to train
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#similarly read test data
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
#read test activities and subjects and combine them to test
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


#now we need to Merges the training and the test sets to create one data set.
fulldata <- rbind(train,test)
colnames(fulldata) <- c("subject", "activity", featuresWanted.names) #give meaningful col names


#now we need to give descriptive activity names to name the activities in the data set
fulldata$activity <- factor(fulldata$activity, levels = activityLabels[,1], labels = activityLabels[,2])
fulldata$subject <- as.factor(fulldata$subject)

#now  creates a second, independent tidy data set with the average of each variable for each activity and each subject.
fulldata.melt <- melt(fulldata, id = c("subject", "activity"))
fulldata.mean <- dcast(fulldata.melt, subject + activity ~ variable, mean)
write.table(fulldata.mean, "Tidy.txt", row.names = FALSE, quote = FALSE)
