str(iris)
indexes <- createDataPartition(iris$Species, p=0.6, list=F)
train <- iris[indexes,]
test <- iris[-indexes,]
fit <- rpart(Species~., data=iris, cp=-1, minsplit=4, minbucket=2)
windows()
rpart.plot(fit)
pred <- predict(fit, test, type='class')
print(data.frame(test,pred))
confusionMatrix(test$Species, pred)
