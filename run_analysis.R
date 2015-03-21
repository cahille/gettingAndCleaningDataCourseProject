library(dplyr)
library(reshape2)

xtrain <- read.table("train/X_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
subjectTrain <- read.table("train/subject_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
ytrain <- read.table("train/y_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

xtest = read.table("test/X_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
subjectTest <- read.table("test/subject_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
ytest = read.table("test/y_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

features <- read.table("features.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
features <- unique(features$V2)
features <- grep("mean|std", features, ignore.case=TRUE, value=TRUE)
features <- features[!grepl("[fF]req", features)]

names(xtest) <- features
names(xtrain) <- features
x <- rbind(xtest, xtrain)
y <- rbind(ytest, ytrain)
subject <- rbind(subjectTest, subjectTrain)
names(subject) <- c('Subject')

data <- x[,features]
data$Subject <- subject$Subject

names(y) <- c('Activity')
data$Activity <- y$Activity

labels <- read.table("activity_labels.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

for(i in 1:length(data$Activity)) {
    data$ActivityLabeled[i] <- labels$V2[data$Activity[i]]
}

meltData <- melt(data, id=c("Subject", "ActivityLabeled"), measure.vars=features)
tidyData <- dcast(meltData, ActivityLabeled + Subject ~ variable, mean)

write.table(tidyData, file="tidyData.txt", row.name=FALSE)
