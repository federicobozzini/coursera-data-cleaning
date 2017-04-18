# Analysis script

## What is this code:
This code contains the data for the project course of the course located at https://class.coursera.org/getdata-007.

## How to run this code
This code can be run by sourcing the code and typing the run_analysis() command.
### Gotchas
- You need to load the Samsung data in the folder yourself. Due to some bandwith limitation I could not load all the data by myself.
- You need to do a setwd to the source file directory before running the run_analysis() command.
- In case it's not present you need to install the "reshape2" library before running the script.

# Explanation
The function run_analysis performs the following tasks:

## Function definitions
At first we define some functions for internal usage. An example is the function to retrieve a the label of an activity given and index:
```{r}
        find_label <- function(activity_index) {
                as.vector(activity_labels[which(activity_labels$index == activity_index), "label"])
        }
```

## Data loading
Then we load the data we are going to use to perform the analysis:
```{r}
        train_dir <- "UCI HAR Dataset/train/"
        test_dir <- "UCI HAR Dataset/test/"
        subject_train_file <- paste(train_dir, "subject_train.txt", sep="")
        X_train_file <- paste(train_dir, "X_train.txt", sep="")
        Y_train_file <- paste(train_dir, "y_train.txt", sep="")
        subject_test_file <- paste(test_dir, "subject_test.txt", sep="")
        X_test_file <- paste(test_dir, "X_test.txt", sep="")
        Y_test_file <- paste(test_dir, "y_test.txt", sep="")
        

        subject_train <- read.table(subject_train_file)
        X_train <- read.table(X_train_file)
        Y_train <- read.table(Y_train_file)
        subject_test <- read.table(subject_test_file)
        X_test <- read.table(X_test_file)
        Y_test <- read.table(Y_test_file)
```

## Metadata loading
Then we load the metadata (labels for the features/measurements and the activicties):
```{r}
        activity_labels <- read.table("~/software/getdata/project/UCI HAR Dataset/activity_labels.txt")
        names(activity_labels) <- c("index", "label")
        features_labels <- read.table("~/software/getdata/project/UCI HAR Dataset/features.txt")
        features_labels <- features_labels$V2
```

## Data merging (point 1)
Then we merge the train data with the test data:
```{r}
        X <- rbind(X_train, X_test)
        Y <- rbind(Y_train, Y_test)
        subject <- rbind(subject_train, subject_test)
        data <- cbind(subject, X, Y)
```
We merge the data together. The subject comes first, then the measurements, then the activities.

## Data extraction (point 2)
We extract only the interesting data (mean and std measurements):
```{r}
        useful_data_indexes <- grepl("mean()", features_labels, fixed=TRUE) | grepl("std()", features_labels, fixed=TRUE)
        useful_features_labels <- features_labels[useful_data_indexes]
        #adding the subject and activities indexes
        useful_data_indexes <- c(TRUE, useful_data_indexes, TRUE)
        useful_data <- data[useful_data_indexes]
```
At first we get the indexes of the measurements involved with means and stds, then weuse this indexes to subset the data and the labels we are going to use since now on.

##Meaningful naming for the table (point 3)
We assign to our data some meaningful lables:
```{r}
        activity_col = ncol(useful_data)
        useful_data[activity_col] <- sapply(useful_data[activity_col]$V1, find_label)
```

##Menangiful naming for the activities (point 4)
We use the activity names instead of their indexes:
```{r}
        labels <- c("subject", as.vector(useful_features_labels), "activity")
        names(useful_data) <- labels
```

##Tidy dataset creation (point 5)
The tidy dataset is created with some reshaping:
```{r}
        tidy_tmp <- melt(d, id=c("subject", "activity"), measure.vars = useful_features_labels)
        tidy_dataset <- dcast(tidy_tmp, subject + activity ~ variable, mean)
```

##Output
A file tydy_dataset.txt is created with the result:
```{r}
        write.table(tidy_dataset, "tidy_dataset.txt", row.names = FALSE)
```

The tidy dataset format is explained in the file codebook.md
