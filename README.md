# getting-cleaning-data-project
Class project for Coursera Getting and Cleaning Data course, Feb 2015, by Erin Machell

The repo contains the following:

* An R script, run_Analysis.R
* A code boook, Code Book.md
* A readme file, README.md
  
##run_Analysis.R
The R script run_Analyis.R does the following:  

* Downloads, unzips, and loads the accelerometer data into R
* Assembles and appropriately labels the accelerometer data into several dataframes for later use, including both the training and testing data.
  * The accdata dataframe includes the raw data for the means and standard deviations of each signal measurement taken for all subjects and all activities
  * The acc_averages dataframe gives the average for each mean and standard deveiation measurement variable, for each subject, for each activity type.

The acc_averages dataframe is exported to a space delimited text file in the working directory called "Accelerometer Avereages by Subject By Activity.txt"  
  
In order for the script to work properly, the following packages must be installed in R: downloader, plyr, dplyr, and reshape2.  

##Code Book.md
The codebook is a markdown file that:

* Gives the background on the data and study it was drawn from
* Explains how and why the R script cleans the data in question
* Defines and explains the variables.

##README.md
This document, a markdown file explaining the files in this repo and how they relate to each other.