# Target var : AHD with two values Yes and No

library(rpart)
library(caret)
library(e1071)
library(tidyverse)
library(rpart.plot)

df<-read.csv('Part06_Practice2/Data/Heart.csv')
str(df)
head(df)
df$AHD <- as.factor(df$AHD)

# data partition

set.seed(10) # reproducability setting
intrain<-createDataPartition(y=df$AHD, p=0.7, list=FALSE) 
train<-df[intrain, ]
test<-df[-intrain, ]

# full tree model

rpartmod<-rpart(AHD~. , data=train, method="class")

# plot the tree 
windows()
rpart.plot(rpartmod)
readline('Enter to resume ')
dev.off() # close window

rpartpred<-predict(rpartmod, test, type='class')
confusionMatrix(rpartpred, factor(test$AHD))

printcp(rpartmod)
plotcp(rpartmod)
# -> 점선 밑에 있으면 대체로 괜찮다~
# 복잡도가 낮으면서 오분류율이 낮은 cp=0.041가 good

# choose the model (cp= 041) leftmost under the horizontal line 
# which xerror is within the range of standard error 
# from min xerror of the model with cp = 0.18

ptree<-prune(rpartmod, cp = 0.041)
# plot the tree 
windows()
rpart.plot(ptree)
readline('Enter to resume ')
dev.off() # close window

rpartpred<-predict(ptree, test, type='class')
confusionMatrix(rpartpred, test$AHD)
