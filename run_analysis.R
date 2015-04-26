library(dplyr)
library(data.table)

Activities <- read.table("UCI HAR Dataset/activity_labels.txt")
Features <- read.table("UCI HAR Dataset/features.txt")
subTrain <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
subTest <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
actTrain <- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)
actTest <- read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE)
feaTrain <- read.table("UCI HAR Dataset/train/x_train.txt",header=FALSE)
feaTest <- read.table("UCI HAR Dataset/test/x_test.txt",header=FALSE)
subData <- rbind(subTrain,subTest)
actData <-rbind(actTrain,actTest)
feaData <- rbind(feaTrain,feaTest)
colnames(actData) <- "Activity"
colnames(subData) <- "Subject"
colnames(feaData) <- t(Features[2])
Data <- cbind(subData,actData,feaData)

meanstd <- grep(".*Mean.*|.*Std.*", names(Data), ignore.case=TRUE)
choice <- c(1,2,meanstd)
newdata <- Data[,choice]

newdata$Activity <- as.character(newdata$Activity)
for(i in 1:6) {
  newdata$Activity[newdata$Activity==i] <- as.character(Activities[i,2])
}
newdata$Activity <- as.factor(newdata$Activity)

names(newdata) <- gsub("Acc", "accelerometer", names(newdata))
names(newdata) <- gsub("Gyro", "gyroscope", names(newdata))
names(newdata) <- gsub("BodyBody", "Body", names(newdata))
names(newdata) <- gsub("tBody", "TotalBody", names(newdata))
names(newdata) <- gsub("^t", "time", names(newdata))
names(newdata) <- gsub("^f", "frequency", names(newdata))
names(newdata) <- gsub("-freq()", "frequency", names(newdata))
names(newdata) <- gsub("-mean()", "Mean", names(newdata))
names(newdata) <- gsub("-std()", "StdDev", names(newdata))

newdata$Subject <- as.factor(newdata$Subject)
newdata <- data.table(newdata)

tidydata <- newdata[order(newdata$Subject,newdata$Activity),]
write.table(tidydata, file="TidyData.txt", row.names=FALSE)




