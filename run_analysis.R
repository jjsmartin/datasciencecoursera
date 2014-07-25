# data from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# data set description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


## READ IN THE DATA
# training data:
X_train       <- read.table( "UCI HAR Dataset\\train\\X_train.txt", header=FALSE, sep="" )
y_train       <- read.table( "UCI HAR Dataset\\train\\y_train.txt",  header=FALSE, sep="" )
subject_train <- read.table( "UCI HAR Dataset\\train\\subject_train.txt", header=FALSE, sep="" )

# test data:
X_test       <- read.table( "UCI HAR Dataset\\test\\X_test.txt", header=FALSE, sep="" )
y_test       <- read.table( "UCI HAR Dataset\\test\\y_test.txt", header=FALSE, sep="" )
subject_test <- read.table( "UCI HAR Dataset\\test\\subject_test.txt", header=FALSE, sep="" )



## MERGE INTO A SINGLE DATASET, ADDING DESCRIPTIVE NAMES TO EACH VARIABLE AND LABELLING THINGS AS WE GO
# first merge the training and test versions of each variable 
X       <- rbind( X_train, X_test ) 
y       <- rbind( y_train, y_test ) 
subject <- rbind( subject_train, subject_test )   

## label the variables and translate the number for each activity to more meaningful descriptions
names( y )           <- "activity"                 
y$activity           <- as.factor(y$activity)   
levels( y$activity ) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING" );

names( subject )  <- "subjectID"  # identifiers of the subjects who carried out each experiment
subject$subjectID <- as.factor( subject$subjectID )

# the data set comes with a text file that lists feature names. Use these as names for the signals data "X"
X.features <- read.table( "UCI HAR Dataset\\features.txt" )
names( X ) <- X.features$V2
  
## now merge the labelled variables into a single data set
activity_recognition_data <- cbind( subject, y, X )
  



## GET MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
# (note that we don't do this for the subject and activity columns, since that would be meaningless)
activity_recognition_mean  <- apply( activity_recognition_data[,-c(1,2)], 2, mean )
activity_recognition_sd    <- apply( activity_recognition_data[,-c(1,2)], 2, sd )



## CREATE SECOND TIDY DATA SET WITH AVERAGES OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT
# aggregate the data by activity and subjectID, taking the mean over each variable
subject_and_activity_means  <- aggregate( activity_recognition_data[,-c(1,2)],  # don't try and get the mean of the subjectID and activity name columns
                                          by  = list( activity_recognition_data$subjectID, activity_recognition_data$activity ),
                                          FUN = mean,
                                          na.rm=TRUE)

# re-apply the names of the columns we're grouping by (they seem to get lost...)
names(subject_and_activity_means)[1] <- names( activity_recognition_data )[1]       
names(subject_and_activity_means)[2] <- names( activity_recognition_data )[2]    

#  shape the dataset into tidy form
library(reshape2)
activity_molten <- melt( subject_and_activity_means, 
                         id = c( "subjectID", "activity" ) )
names( activity_molten )[4] <- "mean"

# finally, write to a file
write.table(activity_molten, 
            file      = "activity_recognition_means.txt",
            sep       = "\t",    
            row.names = FALSE )











