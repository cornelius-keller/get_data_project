# inspired by http://rstudio-pubs-static.s3.amazonaws.com/10696_c676703d98c84553b9e3510b095153b9.html

library(dplyr)

ProjectDirectory = getwd()
DataDirectory = "UCI HAR Dataset/"
dataFile = "dataset.RData"
if (!file.exists(DataDirectory)) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                "data.zip", "curl", quiet = TRUE, mode = "wb")
  unzip("data.zip")
  file.remove("data.zip")
}
stopifnot(file.exists(DataDirectory))
setwd(DataDirectory)
if (!file.exists(dataFile)) {
  # read activity lables
  temp = read.table("activity_labels.txt", sep = "")
  activityLabels = as.character(temp$V2)
  
  # read feature names
  temp = read.table("features.txt", sep = "")
  attributeNames = temp$V2
  
  # make fetrure names proper names and unique
  attributeNames <- make.names(attributeNames, unique=TRUE)
  
  # read the training data set
  Xtrain = read.table("train/X_train.txt", sep = "")
  names(Xtrain) = attributeNames
  Ytrain = read.table("train/y_train.txt", sep = "")
  names(Ytrain) = "Activity"
  Ytrain$Activity = as.factor(Ytrain$Activity)
  levels(Ytrain$Activity) = activityLabels
  trainSubjects = read.table("train/subject_train.txt", sep = "")
  names(trainSubjects) = "subject"
  trainSubjects$subject = as.factor(trainSubjects$subject)
  
  # select only thte mean and std columns
  Xtrain_select <- select(Xtrain, contains(".mean.."), contains(".std.."))
  
  train = cbind(Xtrain_select, trainSubjects, Ytrain)
  
  # read the test data set
  
  Xtest = read.table("test/X_test.txt", sep = "")
  names(Xtest) = attributeNames
  Ytest = read.table("test/y_test.txt", sep = "")
  names(Ytest) = "Activity"
  Ytest$Activity = as.factor(Ytest$Activity)
  levels(Ytest$Activity) = activityLabels
  testSubjects = read.table("test/subject_test.txt", sep = "")
  names(testSubjects) = "subject"
  testSubjects$subject = as.factor(testSubjects$subject)
  
  # select only thte mean and std columns
  
  Xtest_select <- select(Xtest, contains(".mean.."), contains(".std.."))
  test = cbind(Xtest_select, testSubjects, Ytest)
  
  # combine testing and training data set
  combined <- rbind(test,train)
  
  # make names more readable 
  readable_names <- sub("\\.mean", "Mean", names(combined))
  readable_names <- sub("\\.std", "Std", readable_names)
  readable_names <- gsub("\\.","", readable_names)
  names(combined) <- readable_names

  # save combined dataset to dataFile 
  save(combined, file = dataFile)
  
  # clean intermediatae variabless
  rm(train, test, temp, Ytrain, Ytest, Xtrain, Xtest, trainSubjects, testSubjects, 
     activityLabels, attributeNames, Xtrain_select, Xtest_select, combined)
}

load(dataFile)
setwd(ProjectDirectory)

# create the tidy dataset required for step 5
final <- combined %>% group_by(subject, Activity) %>% summarise_each(funs(mean))

# write the data file

write.table(final, file="tidy.txt", row.names=FALSE)

# write tidy_features.txt with the feature names of the tidy dataset
write.table(names(final), file="tidy_freatures.txt", row.names=FALSE, col.names=FALSE)



