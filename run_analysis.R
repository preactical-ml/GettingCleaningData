act_labels <- read.table("activity_labels.txt", head=F)
col_names <- read.table("features.txt", head=F)

# Loads the test set
test_subject <- read.table("test/subject_test.txt", head=F)
test_raw_data <- read.table("test/X_test.txt", head=F)
test_activ_num <- read.table("test/Y_test.txt", head=F)
# Join activity ids with activity labels
test_activities <- merge(x=test_activ_num, y = act_labels, by = "V1")
# Adds the subject and activity columns to test data
test_data <- cbind(test_subject, test_activities[,2], test_raw_data)

# Loads the train data
train_subject <- read.table("train/subject_train.txt", head=F)
train_raw_data <- read.table("train/X_train.txt", head=F)
train_activ_num <- read.table("train/Y_train.txt", head=F)
# Join activity ids with activity labels
train_activities <- merge(x=train_activ_num, y = act_labels, by = "V1")
# Adds the subject and activity columns to test data
train_data <- cbind(train_subject, train_activities[,2], train_raw_data)

# assign meaningful names to the data
col_names <- c("Subject", "Activity", as.character(col_names[,2]))
names(test_data) <- col_names
names(train_data) <- col_names

# concatenate the two data sets
complete_data <- rbind(train_data, test_data)

# extract the columns with mean and standard deviation
std_names = grep("-std()", col_names, fixed = T)
mean_names = grep("-mean()", col_names, fixed = T)

# merge and sort the results to maintain the same column layout
selected_columns <- sort(c(std_names,mean_names))
# adds subject and activity colums
selected_columns <- c(1, 2, selected_columns)

# Selects only the requested columns
selected_data = complete_data[,selected_columns]
selected_names = names(complete_data)[selected_columns]

# Create the new data set by aggregating by subject and activity
aggregated_data <- aggregate(. ~ Activity + Subject, data= selected_data, FUN=mean, na.rm=TRUE)

# writes the data
write.csv(selected_data, "selected_data.txt")
write.csv(aggregated_data, "aggregated_data.txt")
