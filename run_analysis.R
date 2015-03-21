library(dplyr)
library(reshape2)

# slurp in the train data
xtrain <- read.table("train/X_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
subjectTrain <- read.table("train/subject_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
ytrain <- read.table("train/y_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

# slurp in the test data
xtest = read.table("test/X_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
subjectTest <- read.table("test/subject_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
ytest = read.table("test/y_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

# slurp in the features
features <- read.table("features.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

# slurp in the labels
labels <- read.table("activity_labels.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

# keep the unique features
features <- unique(features$V2)

# grab the mean and std features
features <- grep("mean|std", features, ignore.case=TRUE, value=TRUE)

# filter out the freq features
features <- features[!grepl("[fF]req", features)]

# assign the features as column names
names(xtest) <- features
names(xtrain) <- features

# merge the test and train data
x <- rbind(xtest, xtrain)
y <- rbind(ytest, ytrain)
subject <- rbind(subjectTest, subjectTrain)

# name the Subject column
names(subject) <- c('Subject')

# filter down to the selected features
data <- x[,features]

# add the subject column
data$Subject <- subject$Subject

# name the Activity column
names(y) <- c('Activity')

# add the Activity column
data$Activity <- y$Activity

# lookup and apply the names
for(i in 1:length(data$Activity)) {
    data$ActivityLabeled[i] <- labels$V2[data$Activity[i]]
}

# group by Subject and ActivityLabeled and calculate the means
meltData <- melt(data, id=c("Subject", "ActivityLabeled"), measure.vars=features)
tidyData <- dcast(meltData, ActivityLabeled + Subject ~ variable, mean)

# write out the tidyData table
write.table(tidyData, file="tidyData.txt", row.name=FALSE)

# enjoy!
