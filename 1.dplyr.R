library(dplyr)
View(starwars)
sw1 <- starwars

anyNA(sw1)
dim(sw1)

# filtering
temp <- filter(sw1, skin_color=='light', eye_color=='brown')
temp2 <- sw1[sw1$skin_color=='light' & sw1$eye_color=='brown',]

temp3 <- filter(sw1, (skin_color=='light'|eye_color=='brown')&height>170)

# arrange
temp4 <- arrange(sw1, height, desc(mass))

# slice
temp5 <- slice(sw1, 5:10)
temp6 <- slice_head(sw1, n=3)
temp7 <- slice_sample(sw1, n=5)
temp8 <- slice_sample(sw1, prop = 0.1)  # prop - 내림(8.7 -> 8개)
temp9 <- slice_sample(sw1, n=10, replace=T)  # 중복 허용
temp10 <- slice_max(sw1, height, n=4)

# select
temp11 <- select(sw1, hair_color, skin_color, eye_color)
temp12 <- select(sw1, hair_color:eye_color)
temp13 <- select(sw1, ends_with('color'))
temp14 <- select(sw1, !(hair_color:eye_color))

# homeworld --> home_world | HomeWorld(카멜기법)
temp15 <- select(sw1, home_world=homeworld)  # 이름바꿔 가져오기
temp16 <- rename(sw1, home_world=homeworld)  # 이름 재설정하기

# mutate
# height의 단위를 cm에서 m로 바꿔 새로운 열 삽입
temp17 <- mutate(sw1, height_m=height/100)
# height_m, height, 나머지(everything()) 순서로 바꾸기
temp18 <- select(temp17, height_m, height, everything())

temp19 <- mutate(temp18, BMI=mass/(height_m^2))
temp20 <- select(temp19, BMI, everything())

# transmute : 계산값만 가져오기
temp21 <- transmute(temp18, BMI=mass/(height_m^2))

# relocate
temp22 <- relocate(sw1, sex:homeworld, .before=height)

# summarise
temp23 <- summarise(sw1, height=mean(height, na.rm=T))

# group_by
a1 <- group_by(sw1, species, sex)
a2 <- select(a1, height, mass)
a3 <- summarise(a2, height=mean(height, na.rm=T), mass=mean(mass, na.rm=T))

summarise(
  select(
    group_by(sw1, species, sex), height, mass
  ), height=mean(height, na.rm=T), mass=mean(mass, na.rm=T)
)

sw1 %>% group_by(species, sex) %>% select(height, mass) %>%
  summarise(height=mean(height,na.rm=T), mass=mean(mass,na.rm=T))

# distinct
temp24 <- rename(sw1, male_female=sex)
temp25 <- distinct(sw1, sex)
temp26 <- distinct(sw1, sex, species)

# sampling
temp27 <- sample_n(sw1, 10)
temp28 <- sample_n(sw1, 10, replace=T)

mean_height <- mean(sw1$height, na.rm=T)
sw1$height <- ifelse(is.na(sw1$height), mean_height, sw1$height)

# height 큰 애들 위주로
temp29 <- sample_n(sw1, 10, weight=height, replace=T)
temp30 <- sample_frac(sw1, 0.8, replace=T, weight=1/height)
