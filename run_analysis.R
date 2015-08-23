library(plyr)
# Read data in
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
# Mean and std features
features_mean_std <- features[,2][grepl("(*mean*|*std*)\\(\\)", features[,2])]

# Test Data
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/Y_test.txt")

# Train Data
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/Y_train.txt")

# Step 1: Merging Data
test_data <- cbind(test_subjects, test_y, test_x)
train_data <- cbind(train_subjects, train_y, train_x)
full_data <- rbind(train_data, test_data)

# Step 2: Subset data for mean and std features
full_data <- full_data[, c(1,2,features_mean_std)]

# Step 3: Descriptive Activity Name, fetch the activity name from activity labels 
full_data[,2] <- act_labels[full_data[,2],2]

# Step 4: Appropriately labels the data set with descriptive variable names 
colnames(full_data) <- c("subject", "activity", as.character(features_mean_std))

# Step 5: Create a tidy data set with the average of 
# each variable for each activity and each subject.
full_data <- ddply(full_data, .(activity, subject), function(x) colMeans(x[,3:68]))

# Final: Writing the data
write.table(full_data, "tidy-dataset.txt", row.names = FALSE)