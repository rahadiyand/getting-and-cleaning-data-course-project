# Getting and Cleaning Data Course Project
This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

1. Downloads the dataset zip file into defined directory.
2. Loads both the training and test datasets and merge those two datasets into one
3. Joins subject, activity, and measures datasets
4. Filters desired measures and converts measures code into measure names
5. Converts activity code into activity name
6. Aggregates the datasets and return the mean of each subject and each activity into new tidy data set
7. The end result is shown in the file tidy_data.txt.
