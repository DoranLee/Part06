library(tidyverse)
library(ggplot2)
library(caret)
library(Amelia)
library(mice)
library(GGally)

# library(caretEnsemble)
# library(psych)
# library(rpart)
# library(randomForest)

# 
# library(e1071)
# Reproducibility setting 
set.seed(100)

# Step 2: Import the data set
#Reading data into R
data<- read.csv("R/Part06_practice2/Data/diabetes.csv")
str(data)
#Setting outcome variables as categorical
data$Outcome <- factor(data$Outcome, levels = c(0,1), labels = c("False", "True"))

# Step 3: Studying the Data Set
#Studying the structure of the data
str(data)
head(data)

# Step 4: Data Cleaning
#Convert '0' values into NA
data[, 2:7][data[, 2:7] == 0] <- NA

#visualize the missing data
missmap(data)
#Use mice package to predict missing values
mice_mod <- mice(data[, c("Glucose","BloodPressure","SkinThickness","Insulin","BMI")], method='rf')
mice_complete <- complete(mice_mod)
missmap(mice_complete)

#Transfer the predicted missing values into the main data set
data$Glucose <- mice_complete$Glucose
data$BloodPressure <- mice_complete$BloodPressure
data$SkinThickness <- mice_complete$SkinThickness
data$Insulin<- mice_complete$Insulin
data$BMI <- mice_complete$BMI

# check again
missmap(data)

# Step 5: Exploratory Data Analysis

#Data Visualization
#Visual 1
ggplot(data, aes(Age, colour = Outcome)) +
  geom_freqpoly(binwidth = 1) + labs(title="Age Distribution by Outcome")

#visual 2
c <- ggplot(data, aes(x=Pregnancies, fill=Outcome, color=Outcome)) +
  geom_histogram(binwidth = 1) + labs(title="Pregnancy Distribution by Outcome")
c + theme_bw()

#visual 3
P <- ggplot(data, aes(x=BMI, fill=Outcome, color=Outcome)) +
  geom_histogram(binwidth = 1) + labs(title="BMI Distribution by Outcome")
P + theme_bw()

#visual 4
ggplot(data, aes(Glucose, colour = Outcome)) +
  geom_freqpoly(binwidth = 1) + labs(title="Glucose Distribution by Outcome")


#visual 5
ggpairs(data)

# Step 6: Data Modelling
#Building a model
#split data into training and test data sets
indxTrain <- createDataPartition(y = data$Outcome,p = 0.75,list = FALSE)
training <- data[indxTrain,]
testing <- data[-indxTrain,] #Check dimensions of the split > prop.table(table(data$Outcome)) * 100

# check the class ratioes
prop.table(table(training$Outcome)) * 100
prop.table(table(testing$Outcome)) * 100

#create objects x which holds the predictor variables and y which holds the response variables
x = training[,-9]
y = training$Outcome

# optimize model 
modelLookup("rpart2")

train.control <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats=  3,
  summaryFunction = twoClassSummary,
  classProbs = TRUE
)

# optimization
model = train(x,
              y,
              'rpart2',
              tuneLength = 6,
              trControl=train.control,
              
)
model
plot(model)
# Step 7: Model Evaluation

#Model Evaluation
#Predict testing set
Predict <- predict(model,newdata = testing ) 
Predict

#Get the confusion matrix to see accuracy value and other parameter values 
confusionMatrix(Predict, testing$Outcome)

#Plot Variable performance
X <- varImp(model) # Variable importance - RF
plot(X)

