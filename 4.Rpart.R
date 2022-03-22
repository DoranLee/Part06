# install.packages('rpart')
library(rpart)
library(e1071)  # 통계기능, 확률 이론 패키지
library(caret)
# install.packages('tidyverse')
library(tidyverse) # 주요패키지모음(ggplot2, dplyr, tidyr, readr,
#                   purr, tibble, stingr, forcats)
# install.packages('rattle')
library(rattle) # R에서 라이브러리로 지원하는 마이닝 툴, GUI형태
library(rpart.plot)

Golf_ds <- read.csv('Part06_Practice2/Data/Golf-All.csv')
str(Golf_ds)

ds <- data.frame(Outlook=Golf_ds$Outlook,
                 Temperature=Golf_ds$Temperature,
                 Humidity=Golf_ds$Humidity,
                 Play=as.factor(Golf_ds$Play))
View(ds)

indexes <- createDataPartition(ds$Play, p=0.6, list=F)
train <- ds[indexes,]
test <- ds[-indexes,]

# rpart : 의사결정나무
fit <- rpart(Play~., data=ds, cp=-1, minsplit=2, minbucket=1)
# . : 모두
# fit <- rpart(Play~Wind+Humidity ... )
# target_var~pred_var_1 + pred_var_2 + ... 
# target_var~. - . means other variables

# minbucket : 하위노드 생성 위한 오분류 데이터의 최소기준
#   ex. 오분류 데이터가 7미만일 경우 더이상 분류 X
#   값이 작을수록 모델 복잡도 커진다

# minsplit
# minbucket = round(minsplit/3)

# cp : 모델의 복잡도를 제어. 0~1
#   복잡도가 높을수록 test data 더 잘 fit.. but overfit될 수 도


windows()
rpart.plot(fit)

pred <- predict(fit, test, type='class')
pred
print(data.frame(test, pred))

# 얼마나 맞췄나-혼동행렬
confusionMatrix(test$Play, pred)
