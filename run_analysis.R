library(plyr)
##author: Suki Lin

##step1 - Merges the training and the test sets to create one data set
#read raw data from training set
train_x<-read.table("train/X_train.txt")
train_y<-read.table("train/y_train.txt")
train_subject<-read.table("train/subject_train.txt")

#read raw data from testing set
test_x<-read.table("test/X_test.txt")
test_y<-read.table("test/y_test.txt")
test_subject<-read.table("test/subject_test.txt")

#to merge, create a new training set and a new corresponding lable set
#merged by adding rows together
train_data <- rbind(train_x,test_x)
lables_data <- rbind(train_y, test_y)
subjects_data <-rbind(train_subject, test_subject)

##step2 - Extracts only the measurements on the mean and stndard deviation for each measurement
features <- read.table("features.txt")
feature_extractor<- grep(".*mean.*|.*std.*",features[,2])

#extract the targets features with the mean/std deviation measurements
train_data<-train_data[,feature_extractor]
#rename the name of each coloumn to corresponding feature name
names(train_data) <- features[feature_extractor,2]

##step3 - Use descriptive activity names to name eh activities in the data set
activities <- read.table("activity_labels.txt")
lables_data[,1] <-activities[lables_data[,1],2]
names(lables_data)<-"activity"

##step4 - Appropriately labels the data set with descriptive variable names
names(subjects_data)<- "subject"

#combine all the training, labeling and subject data together by columns
combined_data <- cbind(train_data, lables_data, subjects_data)

##step 5 - Create a second, independent tidy data set with the average of each variable for each activity and aech subject
averages <- ddply(combined_data, .(subject, activity), function(x) colMeans(x[,1:79])) #get the first 66 cols of data

write.table(averages, "averages_data.txt", row.names = FALSE)


