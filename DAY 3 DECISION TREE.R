
knitr::opts_chunk$set(echo = TRUE)



## Required libraries
library(rpart)
library(rpart.plot)
library(caret)
library(randomForest)

## Read in the data


path = 'https://raw.githubusercontent.com/nikhlesh17/Training/master/titanic.csv'
titanic <- read.csv(path)
str(titanic)
## Data subset and train-test split

data = titanic[,c(2,3,5,6)]
table(data$survived)
# the response variable needs to be a categorical variable for classification
data$survived <- as.factor(data$survived)

data$pclass <- as.factor(data$pclass)
set.seed(123)
indx <- createDataPartition(y = data$survived,
                            p = 0.8,
                            list = FALSE)
train <- data[ indx,]
test <- data[-indx,]
# Counts for suvived column
### Prepruning parameters

rpart.control(minsplit = 20, minbucket = round(minsplit/3), cp = 0.01, 
              maxcompete = 4, maxsurrogate = 5, usesurrogate = 2, xval = 10,
              surrogatestyle = 0, maxdepth = 30, ...)

set.seed(123)
fit <- rpart(survived ~ ., data = train, method = 'class',control = rpart.control(cp = .0001))
fit
rpart.plot(fit,cex=.8,nn=T, extra=104)
printcp(fit)
test$pred <- predict(fit, test, type = "class")
table(test$pred,test$survived)
accuracy1 <- mean(test$pred == test$survived)
plotcp(fit)

prunetree2 = prune

printcp(prunetree2)
rpart.plot(prunetree2, cex=.8,nn=T, extra=104)
test$pred <- predict(prunetree2, test, type = "class")
accuracy1 <- mean(test$pred == test$survived)
table(test$pred,test$survived)

install.packages("CHAID", repos="http://R-Forge.R-project.org")
#you may need partykit from CRAN also
library(CHAID)  #library for performing CHAID decision tree
data(USvote)  #from lib CHAID
head(USvote)
str(USvote)
#Quick CHAID analysis
set.seed(101)
sample1 = USvote[sample(1:nrow(USvote), 1000),]
head(sample1)
str(sample1)
chaidModel <- chaid(vote3 ~ ., data = sample1, control=chaid_control(minbucket = 10, minsplit=20, minprob=0))
print(chaidModel)
plot(chaidModel)

## Random forest

fit <- randomForest(survived ~ ., data = train,ntree=500,na.action = na.omit)
predicted= predict(fit,test)
table(predicted,test$survived)
varImpPlot(fit)
