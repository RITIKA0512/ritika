
women
nrow(women)
sample(1:10, size = .7*10)
.7*15
dhiraj=sample(1:nrow(women),size = .7*nrow(women))
dhiraj
women[1:5, ]
train=women[dhiraj,]
test = women[-dhiraj,]

fit1=lm(weight ~height, data=train)
summary(fit1)
p4=predict(fit1,newdata=test,type = 'response')
cbind(predicted=p4,actual=test$weight,height=test$height)
