# Getting and Cleaning Data Project February 2015:
#### Assembling and Cleaning Data from the UCI ML Human Activity Recognition Using Smartphones Data Set 

######February 22nd, 2015

Codebook prepared by Erin Machell, based on an R script she created to clean data from the UCI ML Human Activity Recognition Using Smartphones data set

#  <br>
## Background

A team of researchers at the Universitá degli Studi di Genova conducted a study of smartphone accelerometer and gyroscope data from 30 adult volunteer subjects. The subjects were separated into a train group and a test group.

The researchers recorded the readings for 3-axial linear acceleration and 3-axial angular velocity while the subjects engaged in six different activities with a Samsung Galaxy S II on the waist: walking, walking upstairs, walking downstairs, sitting, standing, and lying. From this data they calculated a suite of statistical variables representing the data. The team released its data publicly in 2012, and published several papers related to the data.[^1]
[^1]: See the UCI ML data repo page for paper references.

The purpose of this project is to organize the data for the generated mean and standard deviation variables on the various data parameters into clean and appropriately labeled data tables for future analysis.

For the purposes of this project the data was downloaded from the [UCI Machine Learning Repository.](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
 
For more information on the study design and dataset, please see the following:

* The UCI ML repo
* The readme and features_info files that are incuded with the dataset
* The following paper: [A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning](https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf)[^2]

[^2]:Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013

# <br>
## Cleaning the Data
The data is cleaned and organized using an R script, run_Analysis.R, that does the following:

* Downloads, unzips, and loads the accelerometer data into R
* Assembles and appropriately labels the accelerometer data into several dataframes for later use, including both the training and testing data.
  * The accdata dataframe includes the raw data for the means and standard deviations of each signal measurement taken for all subjects and all activities
  * The acc_averages dataframe gives the average for each mean and standard deveiation measurement variable, for each subject, for each activity type.

The acc_averages dataframe is exported to a space delimited text file in the working directory called "Accelerometer Avereages by Subject By Activity.txt"

In order for the script to work properly, the following packages must be installed in R: downloader, plyr, dplyr, and reshape2.

Following is a detailed description of the the how the script processes the data:

### Creating the accdata dataframe
##### 1. Download and unzip the datafiles
The script downloads and unzips the data file directly from the repo, in order to increase reproduceability. It deletes the zip file from the working directory after unzipping in order to minimize clutter.

##### 2. Read the relevant files into R
The train and test datasets are read into R, including the subject ID data (subject files), the activity ID data (y files), and the measurement variables (the 561 measurement variables produced in the X dataset). 

The second column of the features data table (names of the variables in the X datasets) are read into R as a vector (for easier usage later) as well.

The R default dataclasses for each are used. This is integer for the subject and y datasets, numeric for the X datasets, and character for the features dataset.

##### 3. Merge the test and train data for subject & activity IDs and measurement variables into a single dataframe
The cbind and rbind functions are used to paste these 6 chunks of related data into a single dataframe that displays all measurement datapoints, from both training and testing data, with the appropriate subject and activity IDs.

##### 4. Clean up names in features file
Before the column headings can be added to the dataframe, the names in the features file (containing the column headers for all of the measurement variables) needs to be cleaned up.

Gsub is used to globally make the following global corrections:

* "-" characters are changed to "_"
* "()" are removed
* The "BodyBody" word duplication error is changed, to bring the column headings inline with the published data featureinfo description.

##### 5. Assign column names to the datatable
The subject id data is named "SubjectID", the activity id data is named "Activity", and the 561 measurement variables are assigned the cleaned up names from the features file.

##### 6. Streamline measurement data to include only mean and standard deviation measurements.
Only mean and standard deviation measurements are of interest in this data. There is some ambiguity about which variables have means that are of interest. The best interepretation of mean data was considered to exclude the columns of angle data, and to exclude mean frequency data, which was a distinct parameter from the means themselves, as described in the researchers' orginial feature info file.

First, a group of columns with duplicate names (except for a numeric ID)was removed (none of these were of interest) to allow the select() command to run properly. The select command was then used to include all columns with the strings "mean" or "std" in their names, and append these back to the subject and activity ID data. Finally, the select command was used again to exclude columns with the strings "angle" or "meanFreq" in their names. This left 66 measurement variables, for a total of 68 columns in the dataframe.

##### 7. Replace activity ids with descriptive names
The activity id data was first reclassed from integer to factor data. The revalue() function was then used to replace the activity id numbers with the name of the activity represented, as found in the activity_labels document included with the downloaded data:

* 1 walking
* 2 walking_upstairs
* 3 walking_downstairs
* 4 sitting
* 5 standing
* 6 laying


### <br>
###Creating and exporting the acc_averages dataframe

#####  1. Create melted version of the acc_averages dataframe
The dataframe is first melted into a new data table called acc_melt, using the melt() command. The new table is a long and skinny version of accdata, in which each measurement for each variable is given its own line in the datatable, along with the subject and activity ID variables.

##### 2. Cast melted data into a datatable that gives the average for each variable, by suject by activity
The dcast() function is used to create a new table, called acc_averages, in which the average for each subject for each activity is calculated, for each variable.

Note that in order to keep column headings manageable, the column headings were not changed to reflect the fact that each column gives the mean of the measurements for that subject & activity, for that variable. It is assumed that the name of the dataframe and the name of the exported text file (see next step) imply that each measurement is a calculated data average.

##### 3. Export acc_averages dataframe to a space-delimited text file
The acc_averages dataframe is exported to a space-delimited text file in the working directory, called "Accelerometer Averages by Subject by Activity.txt"

#  <br>
## Data features (measurement variables)
The following is taken from the features_info document included with the downloaded data. I have edited the following only to change the feature identifiers to match syntax changes made to them in the R script (changing "-" to "_" and removing "()").

The retained measurement variables in this data cleaning project include the estimated mean and standard deviation for each of the signal variables, where applicable for x, y and z. All other measurement variables were excluded, including frequeny mean variabels, as well as teh additional mean variables calculated for the angle variables.

>Feature Selection 
>=================

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
><br>
>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
><br>
>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
><br>
>These signals were used to estimate variables of the feature vector for each pattern:  
>'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
><br>
>tBodyAcc_XYZ
>tGravityAcc_XYZ
>tBodyAccJerk_XYZ
>tBodyGyro_XYZ
>tBodyGyroJerk_XYZ
>tBodyAccMag
>tGravityAccMag
>tBodyAccJerkMag
>tBodyGyroMag
>tBodyGyroJerkMag
>fBodyAcc_XYZ
>fBodyAccJerk_XYZ
>fBodyGyro_XYZ
>fBodyAccMag
>fBodyAccJerkMag
>fBodyGyroMag
>fBodyGyroJerkMag
><br>
>The set of variables that were estimated from these signals are: 
><br>
>mean: Mean value
>std: Standard deviation
>mad: Median absolute deviation 
>max: Largest value in array
>min: Smallest value in array
>sma: Signal magnitude area
>energy: Energy measure. Sum of the squares divided by the number of values. 
>iqr: Interquartile range 
>entropy: Signal entropy
>arCoeff: Autorregresion coefficients with Burg order equal to 4
>correlation: correlation coefficient between two signals
>maxInds: index of the frequency component with largest magnitude
>meanFreq: Weighted average of the frequency components to obtain a mean frequency
>skewness: skewness of the frequency domain signal 
>kurtosis: kurtosis of the frequency domain signal 
>bandsEnergy: Energy of a frequency interval within the 64 bins of the FFT of each window.
>angle: Angle between to vectors.
><br>
>Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle variable:
><br>
>gravityMean
>tBodyAccMean
>tBodyAccJerkMean
>tBodyGyroMean
>tBodyGyroJerkMean
><br>
>The complete list of variables of each feature vector is available in 'features.txt'

The retained measurement variables in this data cleaning include the estimated mean and standard deviation for each of the signal variables, where applicable for x, y and z. All other measurement variables were excluded, including frequeny mean variabels, as well as teh additional mean variables calculated for the angle variables.

#  <br>
## Codebook
This is the codebook for the accdata and acc_averages dataframes prodeced by the R script.
###accdata dataframe
10,299 observations of 68 variables

###acc_averages dataframe
180 observations of the same 68 variables

###ID variables


|Column # | Column Name | Description | Values|
|:------: | :---------- | :---------- | :----:|
|1		| SubjectID   | Identification of which study subject measurement is from| 1 - 30|
|2|Activity|Identifies which of the six activities the subject was doing when the measurement was taken|walking, walking_upstairs, walking_downstairs, sitting, standing,laying

###Measurement variables
There are 66 measurement variables, each represented by a column in each datatable. The mean and standard deviation are given for each of 4 parameters (X,Y,Z or Mag) for each of the following signals:
   
**Time variables:**  

* Body acceleration
* Body acceleration jerk
* Body angular speed
* Body angular speed jerk
* Gravity acceleration

**Frequency variables:**  

* Body acceleration
* Body acceleration jerk
* Body angular speed
* Body angular speed jerk (Mag parameter only)


####Column names
Each measurement variabel is identified by a column heading taking the following form:

######**Signal_Measure_Parameter**
(Note that the preceding underscore is not present in the header names for the Mag parameters) 
<br>
<br>
They possible values for each is as follows:

Signal | Measure | Parameter
:-------: | :--------: | :----------:
tBodyAcc |mean| X
tBodyAccJerk| std |  Y
tBodyGyro | | Z  
tBodyGyroJerk| | Mag
tGravityAcc | | 
fBodyAcc | | 
fBodyAccJerk | | 
fBodyGyro | | 
fBodyGyroJerk | | 


	
	
**Signal definitions**

	't' = 'time'
	'f' = 'frequency'
	'BodyAcc' = 'body acceleration'
	'BodyGyro' = 'body angular speed'
	'GravityAcc' = 'gravity acceleration'
	'Jerk' = "jerk"

**Measure definitions**  

	mean = "mean"    
	std = "standard deviation"  
	
**Parameter definitions**

	X, Y and Z are the three axial signals regorded
	Mag is the euclidean magnitude calculated from the thre axial signals  

####Allowed values
Measurement variable values are normalized and bounded within [-1,1]