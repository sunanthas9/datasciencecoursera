#Prep
##Loading the R packages required for successful execution of this script.

library(dplyr)
library(data.table)

#Part1
##Reading data and generating one large dataset
### All the .csv files from folders and subfolders of the .zip files were first read into R using the read.csv command. The analogous training and test data files were merged using rbind. Data frames with information about subjects and activities were de novo assigned column names. For the data frames with 561 vectors, column names were read from the list Features. The Subject, activity and measurement files were then merged to make one huge dataset.

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


#Part2
##Filtering out mean and std information
###A grep statement was formulation to efficiently represent all the mean and std data in the dataset. The data set was subsetted using the grep statement and also the first two columns: subject and activity. The subsetted data was stored as a new data frame 'newdata'.

meanstd <- grep(".*Mean.*|.*Std.*", names(Data), ignore.case=TRUE)
choice <- c(1,2,meanstd)
newdata <- Data[,choice]

#Part3
##Assigning names of activities
### Unlike assigning measurements as column names, activities were assigned as factors. To make that possible, first the column 'Activity' in new data table was coerced to hold character objects. Using a for loop, and the initally read Activities list, the elements of the activity column were re-assigned the activity names. After the for loop, they were converted to factors than just strings. 

newdata$Activity <- as.character(newdata$Activity)
for(i in 1:6) {
  newdata$Activity[newdata$Activity==i] <- as.character(Activities[i,2])
}
newdata$Activity <- as.factor(newdata$Activity)

#Part4
##Making it readable
### Some of the abbreviations in the variable names were renamed using the gsub command to more understandable words. Finally the subjects were assigned as factors than numbers to enable grouping data by subjects if required.

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

#Part5
##Saving as tidy data
### The results from part 4 was ordered by Subjects, then Activity and the output was written to a table called "TidyData.txt" using the write.table() command.

tidydata <- newdata[order(newdata$Subject,newdata$Activity),]
write.table(tidydata, file="TidyData.txt", row.names=FALSE)




