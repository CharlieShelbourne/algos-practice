library("car")
data("Leinhardt")

head(Leinhardt)
str(Leinhardt)
pairs(Leinhardt)

plot(infant ~ income, data=Leinhardt)
hist(Leinhardt$infant)
hist(Leinhardt$income)


Leinhardt$loginfant = log(Leinhardt$infant)
Leinhardt$logincome = log(Leinhardt$income)

plot(loginfant ~ logincome, data=Leinhardt)

###Modeling 
lmod = lm(loginfant ~ logincome, data=Leinhardt)
summary(lmod) # estimates of coefficents very large in comparison to their standard error, showing statistical significance 
              #r-squared tells us how much of the variability is explained by model 

dat = na.omit(Leinhardt)
#Leinhardt

library("rjags")

# likelyhood is a normal distribution  p(y|mu)
# use a linearn model to draw mu
# prior on the leniar model coeficents is a normal distribution with 2 coefecients, mean =0 and a variance = 1m 
# sig^2: inverse gamma for the variance == gamma prior on precision
# lower the sample size of prior if we are not so confident in guess 
mod1_string =" model {
    for (i in 1:n){
        y[i] ~ dnorm(mu[i], prec)
        mu[i] = b[1] + b[2]*log_income[i]
    }

    for (j in 1:2){
        b[j] ~ dnorm(0.0, 1.0/1.0e6)
    }

    prec ~ dgamma(5.0/2.0, 5.0*10.0/2.0)
    sig2 = 1.0 / prec
    sig = sqrt(sig2)

} "

set.seed(72)
data1_jags = list(y=dat$loginfant, n=nrow(dat), log_income=dat$logincome)

# choose to monitor standard dev 
params1 = c("b", "sig")

inits1 = function() { 
    inits = list("b"=rnorm(2, 0.0, 100.0), "prec"=rgamma(1,1.0,1.0))
}

# run the model with 3 chains each starting with inits1 params
mod1 = jags.model(textConnection(mod1_string), data=data1_jags, inits=inits1, n.chains=3)

# burn in period 
update(mod1, 1000)

mod1_sim = coda.samples(model=mod1, variable.names=params1, n.iter=5e3)

# stack matrices vertically 
mod1_csim = do.call(rbind, mod1_sim)


### Convergence 
plot(mod1_sim)
gelman.diag(mod1_sim)
autocorr.diag(mod1_sim)
effectiveSize(mod1_sim)
summary(mod1_sim)
summary(lmod)

### Residuals differece between response the actual obsevation and the models prediction for each value 
# very important as they revieal violations with our assumptions to specify mode
# looking for signs of non liniarity, not normally distributed, obsevation are not independent from one another 
lmod0 = lm(infant ~ income, data=Leinhardt)
plot(resid(lmod0)) # assume independence if no patterns seen
plot(predict(lomd0), resid(lmod0)) # want to see randomness 
qqnorm(resid(lmod0)) # check for normality, if nomal posint follow straight line, curves shows squew  

X = cbind(rep(1.0, dat1_jags$n), data1_jags$log_income)

pm_params1 = colMeans(mod1_csim)

yhat = drop(X %*% pm_params1[1:2]) #vector of predicated values from model
resid1 = data1jags$y - yhat1
plot(resid1)
plot(yhat, resid1)
qqnorm(resid1)

head(rownames(dat)[order(resid1, decreasing=TRUE)])

