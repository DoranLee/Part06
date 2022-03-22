library(dplyr)
# install.packages('caret')
library(caret)

data('Titanic')
t1 <- Titanic %>% as_tibble

anyNA(t1)
set.seed(123)
t1$Survived <- factor(t1$Survived)  # 범주화

# y= 종속변수, 타겟변수, 예측할 변수
# p : 훈련데이터셋으로 줄 분량, 대체로 3:1로
# list= : 리스트로 출력?
tr_row <- createDataPartition(y=t1$Survived, p=3/4, list=F)
tr_data <- t1[tr_row,]
# 테스트 데이터 <- 훈련 데이터 아닌 것으로
# 훈련 데이터로 예측한 것을 시험해 볼 데이터
ts_data <- t1[-tr_row,]

# check
table(t1$Survived)
table(tr_data$Survived)
table(ts_data$Survived)
