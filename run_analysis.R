# 1. Merges the training and the test sets to create one data set

library("data.table")
path <- setwd("C:/Users/rahadiyand/Documents/Coursera/GettingAndCleaningData")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, f))

## Downloaded file is unzipped without using R-Script
path <- setwd("C:/Users/rahadiyand/Documents/Coursera/GettingAndCleaningData")
pathIn <- file.path(path, "UCI HAR Dataset")

dtSubjectTrain <- fread(file.path(pathIn, "train", "subject_train.txt"))
dtSubjectTest <- fread(file.path(pathIn, "test", "subject_test.txt"))
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")

dtActivityTrain <- fread(file.path(pathIn, "train", "Y_train.txt"))
dtActivityTest <- fread(file.path(pathIn, "test", "Y_test.txt"))
dtActivity <- rbind(dtActivityTrain, dtActivityTest)
setnames(dtActivity, "V1", "activityNum")

dtTrain <- fread(file.path(pathIn, "train", "X_train.txt"))
dtTest <- fread(file.path(pathIn, "test", "X_test.txt"))
dt <- rbind(dtTrain, dtTest)

dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)



# 2. Extracts only the measurements on the mean and standard deviation for each measurement
dtFeatures <- fread(file.path(pathIn, "features.txt"))
setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))
dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]
setkey(dt, subject, activityNum)
select <- c(key(dt), dtFeatures$featureCode)
dt <- dt[,select, with = FALSE]

# 3. Appropriately labels the data set with descriptive variable names
setnames(dt, names(dt), c(key(dt), dtFeatures$featureName))

# 4. Uses descriptive activity names to name the activities in the data set

dtActivityNames <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activityNum","activityName") )
dt$activityNum <- factor(dt$activityNum, levels = dtActivityNames$activityNum, labels = dtActivityNames$activityName)


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
dt_second <- aggregate(dt[,3:68], by = list(activity = dt$activityNum, subject = dt$subject), FUN = mean)
write.table(x = dt_second, file = "tidy_data.txt", row.names = FALSE)
