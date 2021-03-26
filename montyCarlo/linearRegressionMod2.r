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
mod2_string =" model {
    for (i in 1:n){
        y[i] ~ dnorm(mu[i], prec)
        mu[i] = b[1] + b[2]*log_income[i] + b[3]*is_oil[i]
    }

    for (j in 1:3){
        b[j] ~ dnorm(0.0, 1.0/1.0e6)
    }

    prec ~ dgamma(5.0/2.0, 5.0*10.0/2.0)
    sig2 = 1.0 / prec
    sig = sqrt(sig2)

} "

set.seed(75)
data2_jags = list(y=dat$loginfant, n=nrow(dat), log_income=dat$logincome, is_oil=as.numeric(dat$oil=="yes"))

data2_jags$is_oil

# choose to monitor standard dev 
params2 = c("b", "sig")

inits2 = function() { 
    inits = list("b"=rnorm(3, 0.0, 100.0), "prec"=rgamma(1,1.0,1.0))
}

# run the model with 3 chains each starting with inits1 params
mod2 = jags.model(textConnection(mod2_string), data=data2_jags, inits=inits2, n.chains=3)

dic.samples(mod1, n.iter=1e3)

# burn in period 
update(mod2, 1000)

mod2_sim = coda.samples(model=mod2, variable.names=params2, n.iter=5e3)

# stack matrices vertically 
mod2_csim = do.call(rbind, mod2_sim)


### Convergence 
plot(mod2_sim)
gelman.diag(mod2_sim)
autocorr.diag(mod2_sim)
effectiveSize(mod2_sim)
summary(mod2_sim)
summary(lmod)

### Residuals differece between response the actual obsevation and the models prediction for each value 
# very important as they revieal violations with our assumptions to specify mode
# looking for signs of non liniarity, not normally distributed, obsevation are not independent from one another 
lmod0 = lm(infant ~ income, data=Leinhardt)
plot(resid(lmod0)) # assume independence if no patterns seen
plot(predict(lomd0), resid(lmod0)) # want to see randomness 
qqnorm(resid(lmod0)) # check for normality, if nomal posint follow straight line, curves shows squew  

X = cbind(rep(1.0, dat2_jags$n), data2_jags$log_income, data2_jags$is_oil)

pm_params2 = colMeans(mod2_csim)

yhat = drop(X %*% pm_params2[1:3]) #vector of predicated values from model
resid2 = data2jags$y - yhat

plot(resid2)
plot(yhat, resid2)
qqnorm(resid2)

head(rownames(dat)[order(resid2, decreasing=TRUE)])



#tau = scale parameter 
# df= degrees of freedom, smaller give heavier tail
# for the model (likeylihood) to have a mea nand variance we force the df to be greater than 2 
mod3_string =" model {
    for (i in 1:n){
        y[i] ~ dt(mu[i], rau, df)
        mu[i] = b[1] + b[2]*log_income[i] + b[3]*is_oil[i]
    }

    for (j in 1:3){
        b[j] ~ dnorm(0.0, 1.0/1.0e6)
    }

    df = nu + 2.0
    nu ~ dexp(1.0)

    tau ~ dgamma(5.0/2.0, 5.0*10.0/2.0)
    sig = sqrt(1.0/tau * df/(df-2.0))
} "


