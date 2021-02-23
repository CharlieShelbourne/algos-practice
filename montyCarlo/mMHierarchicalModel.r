# 1. Simulate phi_i from Beta(2,2)
# 2. Simulate y_i from Binom(10, phi_i)

m = 1e5

y = numeric(m)
phi = numeric(m)

#avoid using loops if possible
for (i in 1:m){
    phi[i] = rbeta(1, shape1=2.0, shape2=2.0)
    y[i] = rbinom(1, size=10, prob=phi[i])
}

#conditional on phi, y follows a binomial dist 
phi = rbeta(m, shape1=2.0, shape2=2.0)
y = rbinom(m, size=10, prob=phi)

table(y) / m
#approximation of marginal distribution of y = beta binomial 
plot(table(y)/m)

#estimation of the expectation
mean(y)
