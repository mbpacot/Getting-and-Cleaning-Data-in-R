## Defining the file location address and needed libraries
setwd("UCI HAR Dataset")
global_address <- getwd()
library(reshape2)

## Load Activity labels
Activity_Labels <- read.table(paste(global_address,"activity_labels.txt",sep = "/"))
Activity_Labels[,2] <- as.character(Activity_Labels[,2])
Get_Activity_Labels <- Activity_Labels[,2]
## Get_Activity_Labels

## Load Feature labels
Features_Labels <- read.table(paste(global_address,"features.txt",sep = "/"))
Features_Labels[,2] <- as.character(Features_Labels[,2])
Get_Features_Labels1 <- Features_Labels[,2]
## Get_Features_Labels1

## Extract Feauture Labels and returning the true location value for "mean" and "std" features
Get_Features_Labels2 <- grep("mean|std", Get_Features_Labels1,ignore.case = FALSE) ## grep = return the valid index for seach string "mean" and "std"
Get_Features_Labels2_Names <- grep("mean|std", Get_Features_Labels1,value = TRUE, ignore.case = FALSE)
global_names <- c("Subject", "Activity", Get_Features_Labels2_Names)

## Load the Training Data (subjects (30 people), activities, values)
Train_Subjects <- read.table(paste(global_address,"train/subject_train.txt",sep = "/"))
Train_Activities <- read.table(paste(global_address,"train/Y_train.txt",sep = "/"))
Train_Values <- read.table(paste(global_address,"train/X_train.txt",sep = "/"))[Get_Features_Labels2]
colnames(Train_Values) <- Get_Features_Labels2_Names ## Assigning appropriate variable using this variable named "Get_Features_Labels2_Names"
Train_Dataset <- cbind(Train_Subjects, Train_Activities, Train_Values)
## head(Train_Values)

## Load the Testing Data (subjects (30 people), activities, values)
Test_Subjects <- read.table(paste(global_address,"test/subject_test.txt",sep = "/"))
Test_Activities <- read.table(paste(global_address,"test/Y_test.txt",sep = "/"))
Test_Values <- read.table(paste(global_address,"test/X_test.txt",sep = "/"))[Get_Features_Labels2]
colnames(Test_Values) <- Get_Features_Labels2_Names ## Assigning appropriate variable using this variable named "Get_Features_Labels2_Names"
Test_Dataset <- cbind(Train_Subjects, Train_Activities, Train_Values)
## head(Test_Values)

## Merge the Train and Test Datasets with appropriate Label (Get_Features_Labels2_Names)
Merge_Datasets <- rbind(Train_Dataset, Test_Dataset)
colnames(Merge_Datasets) <- global_names
## head(Merge_Datasets)

## Categorize the Activity and Subject Column variable by turning them into FACTORS (a built-in function in R)
Merge_Datasets$Subject <- as.factor(paste("Person",Merge_Datasets$Subject,sep = "-"))
Merge_Datasets$Activity <- factor(Merge_Datasets$Activity, levels = Activity_Labels[,1], labels = Activity_Labels[,2])
## head(Merge_Datasets)

## Preparing data to store a tidy data using "melt" built-in function in R
Merge_Datasets.Melt <- reshape2::melt(Merge_Datasets, id = c("Subject", "Activity"))
Merge_Datasets.Mean <- reshape2::dcast(Merge_Datasets.Melt, Subject + Activity ~ variable, mean)
write.table(Merge_Datasets.Mean, "Tidy.txt", row.names = FALSE, quote = FALSE)                                     
