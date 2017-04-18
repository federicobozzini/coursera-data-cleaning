run_analysis <- function() {
        library("reshape2")
        
        #internal functions
        find_label <- function(activity_index) {
                as.vector(activity_labels[which(activity_labels$index == activity_index), "label"])
        }
        
        # filesystem setup
        train_dir <- "UCI HAR Dataset/train/"
        test_dir <- "UCI HAR Dataset/test/"
        subject_train_file <- paste(train_dir, "subject_train.txt", sep="")
        X_train_file <- paste(train_dir, "X_train.txt", sep="")
        Y_train_file <- paste(train_dir, "y_train.txt", sep="")
        subject_test_file <- paste(test_dir, "subject_test.txt", sep="")
        X_test_file <- paste(test_dir, "X_test.txt", sep="")
        Y_test_file <- paste(test_dir, "y_test.txt", sep="")
        
        #loading data
        subject_train <- read.table(subject_train_file)
        X_train <- read.table(X_train_file)
        Y_train <- read.table(Y_train_file)
        subject_test <- read.table(subject_test_file)
        X_test <- read.table(X_test_file)
        Y_test <- read.table(Y_test_file)
        
        #loading metadata
        activity_labels <- read.table("~/software/getdata/project/UCI HAR Dataset/activity_labels.txt")
        names(activity_labels) <- c("index", "label")
        features_labels <- read.table("~/software/getdata/project/UCI HAR Dataset/features.txt")
        features_labels <- features_labels$V2
        
        #merging data [1]
        X <- rbind(X_train, X_test)
        Y <- rbind(Y_train, Y_test)
        subject <- rbind(subject_train, subject_test)
        data <- cbind(subject, X, Y)
        
        #extracting interesting data (containing "mean()" or "std()" ) [2]
        useful_data_indexes <- grepl("mean()", features_labels, fixed=TRUE) | grepl("std()", features_labels, fixed=TRUE)
        useful_features_labels <- features_labels[useful_data_indexes]
        #adding the subject and activities indexes
        useful_data_indexes <- c(TRUE, useful_data_indexes, TRUE)
        useful_data <- data[useful_data_indexes]
        
        #using meaningful name for activities [3]
        activity_col = ncol(useful_data)
        useful_data[activity_col] <- sapply(useful_data[activity_col]$V1, find_label)
        
        #labeling the data in a meaningful way [4]
        labels <- c("subject", as.vector(useful_features_labels), "activity")
        names(useful_data) <- labels
        
        #create tidy dataset [5]
        
        tidy_tmp <- melt(d, id=c("subject", "activity"), measure.vars = useful_features_labels)
        tidy_dataset <- dcast(tidy_tmp, subject + activity ~ variable, mean)
        
        #output
        write.table(tidy_dataset, "tidy_dataset.txt", row.names = FALSE)
}