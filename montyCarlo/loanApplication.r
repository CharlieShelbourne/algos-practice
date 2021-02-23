m = 10000
a = 5 
b = 3 

beta = rbeta(m, shape1=a, shape2=b)

success = beta/(1-beta)

mean(beta/(1-beta))

ind = success > 1 

mean(ind)


m = 100000
a = 0 
b = 1
norm = rnorm(m,a,b)

qnorm(0.3,mean=a,sd=b)

quantile(norm, prob=0.3)