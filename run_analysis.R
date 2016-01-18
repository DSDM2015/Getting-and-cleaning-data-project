setwd("C:/DATA/Office/Current/Coursera/Getting Data/Assignment")
### Merge test and training data
## Labels, subjects and data are in different files
##
## Getting training data into data frames
training_data<-read.table("./UCI HAR Dataset/train/X_train.txt")
dim(training_data)
# contains 7352 rows and 561 columns
training_labels<-read.table("./UCI HAR Dataset/train/y_train.txt")
dim(training_labels)
table(training_labels)
# contains 7352 rows and has six categories
training_subjects<-read.table("./UCI HAR Dataset/train/subject_train.txt")
dim(training_subjects)
table(training_subjects)
# contains 7532 rows with values ranging from 1 to 30 (subject numbers)
# Merging subjects, labels and data
training_complete<-cbind(training_subjects, training_labels, training_data)
rm(training_subjects, training_labels, training_data)
##
## Getting test data into data frames
test_data<-read.table("./UCI HAR Dataset/test/X_test.txt")
dim(test_data)
# contains 2947 rows and 561 columns
test_labels<-read.table("./UCI HAR Dataset/test/y_test.txt")
dim(test_labels)
table(test_labels)
# contains 2947 rows and has six categories
test_subjects<-read.table("./UCI HAR Dataset/test/subject_test.txt")
dim(test_subjects)
table(test_subjects)
# contains 2947 rows with values ranging from 2 to 24 (subject numbers)
# Merging subjects, labels and data
test_complete<-cbind(test_subjects, test_labels, test_data)
rm(test_subjects, test_labels, test_data)
##
## Merging training and test data frames
data_all<-rbind(training_complete, test_complete)
dim(data_all)
rm(training_complete, test_complete)
#contains 10299 rows and 563 columns
## Adding variable names
# Variable names are contained in a seperate file
variable_names<-read.table("./UCI HAR Dataset/features.txt")
head(variable_names)
# Second column contains variables names
variable_names<-as.vector(variable_names[, 2])
# Add column names for the columns added to the data earlier (subjects, labels)
variable_names<-append(variable_names, c("Subject", "ActivityID"), after=0)
colnames(data_all)<-variable_names
head(data_all)
dim(data_all)
##
##
### Subsetting data (only mean and standard deviations)
# Determining which columns to keep
keep_col_index<-grep("Subject|Activity|mean\\(\\)|std\\(\\)", names(data_all))
# 68 columns to keep (Subject, Activity, 66 mean and standard deviations)
data_subset<-data_all[, keep_col_index]
head(data_subset)
dim(data_subset)
rm(data_all)
# Subsetted data frame contains 10299 observations for 68 variables (including subject ID and activities)
##
##
### Adding descriptive values for activities 
# The second column contains codes for activity labels
table(data_subset[, 2])
# The coding for activities is contained in a seperate file
labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
names(labels)<-c("ActivityID", "Activity")
# Merging data sets to add column with descriptive labels
data_subset<-merge(x=labels, y=data_subset, by.x=c("ActivityID"), by.y=c("ActivityID"))
# Deleting superfluous activityID column
data_subset<-data_subset[,-1]
# Cleaning up descriptive column
data_subset[,1]<-tolower(sub("_", " ", data_subset[,1]))
data_subset[,1]<-paste(toupper(substring(data_subset[,1], 1,1)), substring(data_subset[,1], 2), sep="")
##
##
### Using descriptive variable names
names(data_subset) <- gsub("\\(|\\)|-", "", names(data_subset))
names(data_subset) <- sub("Acc", " Accelerometer", names(data_subset))
names(data_subset) <- sub("Gyro", " Gyroscope", names(data_subset))
names(data_subset) <- sub("Jerk", " Jerk signal", names(data_subset))
names(data_subset) <- sub("Mag", " Magnitude", names(data_subset))
names(data_subset) <- gsub("meanX\\>"," Mean for X", names(data_subset))
names(data_subset) <- gsub("meanY\\>"," Mean for Y", names(data_subset))
names(data_subset) <- gsub("meanZ\\>"," Mean for Z", names(data_subset))
names(data_subset) <- gsub("stdX\\>"," Standard Deviation for X", names(data_subset))
names(data_subset) <- gsub("stdY\\>"," Standard Deviation for Y", names(data_subset))
names(data_subset) <- gsub("stdZ\\>"," Standard Deviation for Z", names(data_subset))
names(data_subset) <- gsub("std", " Standard Deviation", names(data_subset))
names(data_subset) <- gsub("\\<tBody\\>", "Body", names(data_subset))
names(data_subset) <- gsub("\\<tGravity\\>", "Gravity", names(data_subset))
names(data_subset) <- gsub("fBody|fBodyBody", "Body Frequency", names(data_subset))
names(data_subset) <- gsub("Magnitudemean", "Magnitude Mean", names(data_subset))
names(data_subset) <- gsub("Magnitudestd", "Magnitude Standard Deviation", names(data_subset))
names(data_subset)
##
##
### Create new data set with mean values for subject and activity
measurement_mean_by_sub_act = ddply(data_subset, c("Subject","Activity"), numcolwise(mean))
dim(measurement_mean_by_sub_act)
# 30 subjects x 6 activities=180 observations (mean values)
write.table(measurement_mean_by_sub_act, file = "tidy_data_means.txt", row.names = FALSE, quote = FALSE)
