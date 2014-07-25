Getting and Cleaning Data - Class Project
==========================================

The run_analysis code first reads in the datasets from the working directory. These were originally were downloaded from: 
	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data consists of:
	- X_train, a training set of accelerometer measurements
	- y_train, a training set of activities corresponding to each set of measurements, represented as numbers
	- subject_train, a training set indicating which subjects were making the movements recorded.
	- test versions of each of these datasets -- making six files to be read in, in total.

(Note that there is also "Inertial Signals" data available from that source, but I didn't use it since FAQs on the course website said we didn't need to).

After reading in the data, we then merge all the data into a single dataset. We merge the training and test versions of X, y and subject together first, since this makes it more convenient when it comes to applying names.

The activity label data y is converted from numbers 1-6 to factors, and given more descriptive labels:

		1 : WALKING

		2 : WALKING_UPSTAIRS

		3 : WALKING_DOWNSTAIRS

		4 : SITTING

		5 : STANDING

		6 : LAYING
	
	
The subject data is also converted to factors, but not otherwise changed.

The accelerometer measurement variables in X are given names, which are read in directly from the features.txt file that was supplied with the original data.

Having merged and named these three datasets, we merge them them together into a single dataset using cbind.

Then we calculate the mean and sb of each variable (that is, each column in the dataset). Note that we don't calculate mean or sb for the subject IDs or activity labels, since that'd be meaningless.

Having extracted the mean and sd data, we move on to creating a second, tidy dataset with average (mean) of each variable for each activity and each subject. We use the aggregate() function to find the mean of every variable, then the melt() function from the reshape2 package to arrange it tidily.





