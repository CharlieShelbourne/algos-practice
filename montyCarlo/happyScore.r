data = read.csv(file="C:/Users/shcmpq/OneDrive - BP/Documents/GitHub/algos_practice/montyCarlo/world-happiness-report-2021V2.csv", header=TRUE)

colnames(data)[1] <- gsub('^...','',colnames(data)[1])

data$Regional.indicator = unclass(factor(data$Regional.indicator))

head(data)
pairs(data)

library("corrplot")
Cor = cor(data[,2:7])
corrplot(Cor, type="upper", method="ellipse", tl.pos="d")
corrplot(Cor, type="lower", method="number", col="black", 
         add=TRUE, diag=FALSE, tl.pos="n", cl.pos="n")


#data2 = data.frame(data$Logged.GDP.per.capita, data$Freedom.to.make.life.choices, data$Generosity)

#pairs(data2)
#hist(data2$Generosity)

# standardise features to avoid needing to tailor each prior 
X = scale(data[,-1], center=TRUE, scale=TRUE)

data_jags = list(generosity = data$Generosity, happiness = X[,'Ladder.score'], popWealth = X[,'Logged.GDP.per.capita'], social = X[,'Social.support'], health = X[,'Healthy.life.expectancy'], popFreedom = X[,'Freedom.to.make.life.choices'])

# use double exponential prior for b coeficients as it prefers numbers close to zero. Sharp spike at 0 
ddexp = function(x, mu, tau) {
  0.5*tau*exp(-tau*abs(x-mu)) 
}

library("rjags")

mod_string = " model {
    for (i in 1:length(generosity)) {
        generosity[i] ~ dnorm(mu[i], prec)
        mu[i] = int + b[1]*happiness[i] + b[2]*popWealth[i] + b[3]*social[i] + b[4]*health[i] + b[5]*popFreedom[i]
    }
    int ~ dnorm(0.0, 1.0/25.0)
    for (j in 1:5){
        b[j] ~  ddexp(0.0, sqrt(2.0))
    }

    prec ~ dgamma(5.0/2.0, 5.0*10.0/2.0)
    sig2 = 1.0 / prec
    sig = sqrt(sig2)

} "

set.seed(72) 

# choose to monitor standard dev 
params = c("b", "int", "sig")

#inits = function() { 
#    inits = list("b"=rnorm(2, 0.0, 100.0), "prec"=rgamma(1,1.0,1.0))
#}

mod = jags.model(textConnection(mod_string), data=data_jags, n.chains=3)

#posterior mean diviance -2*log(likelyhood)
#penalty ~= number of params in model 
#lower dic = better fit of model  
dic.samples(mod, n.iter=1e3)

# burn in period 
update(mod, 1000)

mod_sim = coda.samples(model=mod, variable.names=params, n.iter=5e4)

# stack matrices vertically 
mod_csim = do.call(rbind, mod_sim)


### Convergence 
plot(mod_sim)
gelman.diag(mod_sim)
autocorr.diag(mod_sim)
effectiveSize(mod_sim)
summary(mod_sim)

dic = dic.samples(mod, n.iter=1e3)

# Model 2 - remove social

mod2_string = " model {
    for (i in 1:length(generosity)) {
        generosity[i] ~ dnorm(mu[i], prec)
        mu[i] = int + b[1]*happiness[i] + b[2]*popWealth[i] + b[3]*health[i] + b[4]*popFreedom[i]
    }
    int ~ dnorm(0.0, 1.0/25.0)
    for (j in 1:4){
        b[j] ~  ddexp(0.0, sqrt(2.0))
    }

    prec ~ dgamma(5.0/2.0, 5.0*10.0/2.0)
    sig2 = 1.0 / prec
    sig = sqrt(sig2)

} "

 
# choose to monitor standard dev 
params = c("b", "int", "sig")


data_jags = list(generosity = data$Generosity, happiness = X[,'Ladder.score'], popWealth = X[,'Logged.GDP.per.capita'], health = X[,'Healthy.life.expectancy'], popFreedom = X[,'Freedom.to.make.life.choices'])


mod2 = jags.model(textConnection(mod2_string), data=data_jags, n.chains=3)

#posterior mean diviance -2*log(likelyhood)
#penalty ~= number of params in model 
#lower dic = better fit of model  
dic.samples(mod2, n.iter=1e3)

# burn in period 
update(mod2, 1000)

mod2_sim = coda.samples(model=mod2, variable.names=params, n.iter=5e4)

# stack matrices vertically 
mod2_csim = do.call(rbind, mod2_sim)


### Convergence 
gelman.diag(mod2_sim)
autocorr.diag(mod2_sim)
effectiveSize(mod2_sim)
summary(mod2_sim)

dic.samples(mod2, n.iter=1e3)


# Model 3 - remove happiness and health

mod3_string = " model {
    for (i in 1:length(generosity)) {
        generosity[i] ~ dnorm(mu[i], prec)
        mu[i] = int  + b[1]*popWealth[i] + b[2]*popFreedom[i]
    }
    int ~ dnorm(0.0, 1.0/25.0)
    for (j in 1:2){
        b[j] ~  ddexp(0.0, sqrt(2.0))
    }

    prec ~ dgamma(5.0/2.0, 5.0*10.0/2.0)
    sig2 = 1.0 / prec
    sig = sqrt(sig2)

} "

 

# choose to monitor standard dev 
params = c("b", "int", "sig")

#inits = function() { 
#    inits = list("b"=rnorm(2, 0.0, 100.0), "prec"=rgamma(1,1.0,1.0))
#}

data_jags = list(generosity = data$Generosity, popWealth = X[,'Logged.GDP.per.capita'], popFreedom = X[,'Freedom.to.make.life.choices'])


mod3 = jags.model(textConnection(mod3_string), data=data_jags, n.chains=3)

# burn in period 
update(mod3, 1000)

mod3_sim = coda.samples(model=mod3, variable.names=params, n.iter=5e4)

# stack matrices vertically 
mod3_csim = do.call(rbind, mod2_sim)


### Convergence 
gelman.diag(mod3_sim)
autocorr.diag(mod3_sim)
effectiveSize(mod3_sim)
summary(mod3_sim)


#posterior mean diviance -2*log(likelyhood)
#penalty ~= number of params in model 
#lower dic = better fit of model 
dic.samples(mod3, n.iter=1e3)


# prediction checks 

pm_coef = colMeans(mod3_csim)

pm_Xb = pm_coef["int"] + X[,c(2,5)] %*% pm_coef[1:2]

head(pm_Xb)

plot(pm_Xb, data$Generosity)

m2error = mean((pm_Xb - data$Generosity)^2)

resid = pm_Xb - data$Generosity

plot(resid)

mean_perc_error = mean((abs(resid)/abs(data$Generosity))*100)