library(dplyr)
tc_data <- read.csv('Part06_Practice2/Data/ToyotaCorolla.csv')
head(tc_data)
# tibble이 좋다면 tibble로 바꾸기
tc <- as_tibble(tc_data)
tc
# factor화 할 수 있는 요소 찾기(자료형 변환)
temp <- lapply(tc, unique)   # unique로 안 겹치는 값만 남기기
lapply(temp, length)

tc1 <- data.frame(Price=tc$Price, Age=tc$Age, KM=tc$KM,
                  Fueltype=as.factor(tc$FuelType), HP=tc$HP,
                  MetColor=as.factor(tc$MetColor), Automatic=as.factor(tc$Automatic),
                  CC=tc$CC, Doors=as.factor(tc$Doors), Weight=tc$Weight)
str(tc1)

# 결측치 확인
anyNA(tc1)

min(tc1$Age) # --> 1
max(tc1$Age) # --> 80

tc1$Age_1 <- factor(1436, level=c('old','medium','new'))
tc1$Age_1[tc1$Age>=60] <- 'old'
tc1$Age_1[tc1$Age>=20 & tc1$Age<60] <- 'medium'
tc1$Age_1[tc1$Age<20] <- 'new'

table(tc1$Age_1)

# 컴퓨터는 old, medium, new가 무엇을 의미하는 지 모른다.
# 따라서 각 열을 만들어 T/F로 알려주기
tc1$Old <- tc1$Age_1=='old'
tc1$Medium <- tc1$Age_1=='medium'
tc1$New <- tc1$Age_1=='new'
# 값이 모두 잘 들어갔는 지 확인
sum(tc1$Old) + sum(tc1$Medium) + sum(tc1$New)

# 표준화 : 평균 0 표준편차 1
# 정규화 : 최소값 0 최대값 1
KM_m <- mean(tc1$KM)
KM_sd <- sd(tc1$KM)
# 표준화
temp <- (tc1$KM - KM_m)/KM_sd
plot(temp)
plot(tc1$KM) # 그래프 모양은 동일, scale만 다름
# 정규화
KM_min <- min(tc1$KM)
KM_max <- max(tc1$KM)
temp <- (tc1$KM - KM_min)/(KM_max-KM_min)
plot(temp)

# 샘플링
tc1[sample(1:nrow(tc1), 10, replace=T),]
