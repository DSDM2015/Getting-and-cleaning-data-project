# Coursera: Getting and Cleaning Data <h1> 
# Course project <h1>

The R file (run_analysis.R) is creating a tidy data set (tidy_data_means.txt), which contains the mean values for the mean and standard deviations of several body measurements.
The original data included 66 variables for mean and standard deviations for 30 subjects and 6 activities. These are aggregated (mean values) by subject and activity, yielding 180 observations (rows). 

In particular, run_analysis.R is
1. Merging the two parts of the original data set (test and training data)  
2. Subsetting data (only mean and standard deviations)
3. Replacing codes for activities with descriptive (string) variables
4. Creating descriptive variable names
5. Creates new data set with mean values aggregated by subject and activity

Please read the comments in run_analysis.R for further details.

The original data is available here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
