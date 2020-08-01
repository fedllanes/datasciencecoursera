
#Let's start by downloading the neccesary data.
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- paste(getwd(), "/", "rawData.zip", sep = "")
download.file(url = url, destfile = dir )
dataDir <- paste(getwd(), "/", "data", sep = "")
unzip(zipfile = dir, exdir = dataDir)

#Put all the data on tables.

x_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/y_train.txt"))
s_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/subject_train.txt"))

x_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/y_test.txt"))
s_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/subject_test.txt"))

feature <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/features.txt"))

a_label <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

# merge 
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

#Find the columns related to the mean and the std.

selectedCols2 <- grep("(mean|std)", as.character(feature[,2])) #WE find the indexes of the colums that include std or mean
selectedColNames <- feature[selectedCols2, 2] #The names of the features

#We start the binding process

allData <- cbind(s_data, y_data, x_data) #WE combine the data
colnames(allData) <- c("Subject", "Activity", selectedColNames) #We select what we need
allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2]) #We replace the numers for the proper names
allData$Subject <- as.factor(allData$Subject)

meltedData <- melt(allData, id = c("Subject", "Activity")) #mELTING DOWN
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)
dataDir
write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)





