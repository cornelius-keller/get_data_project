# inspired by http://rstudio-pubs-static.s3.amazonaws.com/10696_c676703d98c84553b9e3510b095153b9.html

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
  temp = read.table("activity_labels.txt", sep = "")
  activityLabels = as.character(temp$V2)
  temp = read.table("features.txt", sep = "")
  attributeNames = temp$V2
  attributeNames <- make.names(attributeNames, unique=TRUE)
  
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
  
  Xtest = read.table("test/X_test.txt", sep = "")
  names(Xtest) = attributeNames
  Ytest = read.table("test/y_test.txt", sep = "")
  names(Ytest) = "Activity"
  Ytest$Activity = as.factor(Ytest$Activity)
  levels(Ytest$Activity) = activityLabels
  testSubjects = read.table("test/subject_test.txt", sep = "")
  names(testSubjects) = "subject"
  testSubjects$subject = as.factor(testSubjects$subject)
  Xtest_select <- select(Xtest, contains(".mean.."), contains(".std.."))
  test = cbind(Xtest_select, testSubjects, Ytest)
  
  combined <- rbind(test,train)
  
  save(combined, file = dataFile)
  rm(train, test, temp, Ytrain, Ytest, Xtrain, Xtest, trainSubjects, testSubjects, 
     activityLabels, attributeNames, Xtrain_select, Xtest_select, combined)
}

load(dataFile)
setwd(ProjectDirectory)


