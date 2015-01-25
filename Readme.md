# This is the course Project for Coursera Course "Getting and Cleaning Data"

## Repository content and File Descriptions 

1. run_analysis.R:  R script that performs the required analythis
2. [CodeBook.md](CodeBook.md): Short description of the variables in the tidy.txt file created by run_analysis.R
3. Readme.md: This file

## Requirements

The dplyr library is required.

## Usage

Run run_analysis.R by typing:
```
Rscript run_analysis.R
```
on the command line.

Running run_analysis.R will download the source data from the internet and unpack it. This will create a data directory calles "UCI HAR Dataset".
Then the steps 1-4 are performed on the data and the result is cached to "UCI HAR Dataset/dataset.RData"

Downloading the data is only performed when the folder "UCI HAR Dataset" does not exist.

The preparing steps 1-4 are only performed when "UCI HAR Dataset/dataset.RData" does not exist.

## Results ( not included in repository )

1. tidy.txt: File containing the tidy data set
2. tidy_featurs.txt: file containing the column names of the tidy data set.

## Credits

 run_analysis.R is based on an  [Rpubs Article](http://rstudio-pubs-static.s3.amazonaws.com/10696_c676703d98c84553b9e3510b095153b9.html) of Syrus Nemat-Nasser (R [at] syrus [dot] us).



