##The following script will download, unzip, and load the accelerometer
##data into R, and will assemble and appropriately label the accelerometer data
##into several dataframes for later use, including both the training and testing
##data.

##The accdata dataframe includes the raw data for the means and standard
##deviations of each signal measurement taken for all subjects and all
##activities

##The acc_averages dataframe gives the average for each mean and standard
##deveiation measurement variable, for each subject, for each activity type.

##The acc_averages dataframe is exported to a space delimited text file in the
##working directory called "Accelerometer Avereages by Subject By Activity.txt"

##In order for the script to work properly, you must have the following packages
##installed in R: downloader, plyr, dplyr, and reshape2.



##Load needed packages.
library(downloader)
library(plyr)
library(dplyr)
library(reshape2)

##Download and unzip the accelerometer data files,
##and remove the zip file.
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
         dest = "accelerometerdata.zip", mode="wb")
unzip("accelerometerdata.zip")
if (file.exists("accelerometerdata.zip")) file.remove("accelerometerdata.zip")

##Read the relevant files into R (features file, as well as the subject, X, and
##Y files for both the train and test datasets)
features<-as.vector(read.table("UCI HAR Dataset/features.txt")[,2])
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")

##Merge the test and train data for the three data types (subject, y, X) into
##a single dataframe
accdata<-cbind(rbind(subject_train,subject_test),
               rbind(y_train,y_test),
               rbind(X_train,X_test)
               )

##Clean up names in features file for correct tidy data standards
features<-gsub("-","_",features)
features<-gsub("()","",features, fixed=TRUE)
features<-gsub("BodyBody","Body",features)

##Assign column names to the datatable using features file
names(accdata)<-c("SubjectID","Activity",features)

##Remove columns with duplicate names, and remove measurement data except for
##means and standard deviations (do not inlcude angle or mean frequency data)
accdata <- accdata[, !duplicated(colnames(accdata))]
accdata<-cbind(accdata[,1:2],
                          select(accdata,contains("mean")),
                          select(accdata,contains("std"))
               )
accdata<-select(accdata,-contains("angle"),-contains("meanFreq"))

##Complete accdata dataframe by giving disctriptive names to values in the
##"Activities" column
accdata$Activity<-as.factor(accdata$Activity)
accdata$Activity<-revalue(accdata$Activity,
                          c("1"="walking",
                            "2"="walking_upstairs",
                            "3"="walking_downstairs",
                            "4"="sitting",
                            "5"="standing",
                            "6"="laying"
                            )
                          )

##Create melted version of the datatable
acc_melt<-melt(accdata,id.vars=c("SubjectID","Activity"))

##Cast datatable into new shape showing avereage for each measurement variable,
##by subject by activity.
acc_averages<-dcast(acc_melt, SubjectID+Activity~variable, mean)

##Send acc_averages table to a space-delimited text file
write.table(acc_averages,
            file="Accelerometer Avereages by Subject By Activity.txt",
            row.name=FALSE
                )