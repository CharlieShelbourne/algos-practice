set.seed(32)

m = 10000
a = 2.0
b = 1.0 / 3.0

theta = rgamma(n=m, shape=a, rate=b)

se = sd(theta) / sqrt(m)

hist(theta, freq=FALSE)
curve(dgamma(x,shape=a, rate=b),col="blue",add=TRUE)

# 2 standard errors
mean(theta) + (2 * se)
mean(theta) - (2 * se)


#indicator
ind = theta < 5
mean(ind)
pgamma(5.0, shape=a, rate=b)

se = sd(ind) / sqrt(m)

2*se