library("car")  # load the 'car' package
data("Anscombe")  # load the data set
#?Anscombe  # read a description of the data
head(Anscombe)  # look at the first few lines of the data
pairs(Anscombe)  

# response = educational expenditure 
# predictors: income, young age, urban 

data = list(edu=Anscombe$education, income=Anscombe$income, young=Anscombe$young, urban=Anscombe$urban)

lmod = lm(Anscombe$education ~ Anscombe$income + Anscombe$young + Anscombe$urban, data=Anscombe)
summary(lmod)

plot(predict(lmod), resid(lmod))


library("rjags")

# edu likelyhood = normal dist, predict y given the mean calculated using the yuong, urban and income coefficents
# normal prior for income, young and urban coeficents with large 1m variance to reduce correlations
# prior on variance in an inverse gamma 
mod1_string = " model {
    for (i in 1:length(education)) {
        education[i] ~ dnorm(mu[i], prec)
        mu[i] = b0 + b[1]*income[i] + b[2]*young[i] + b[3]*urban[i]
    }
    
    b0 ~ dnorm(0.0, 1.0/1.0e6)
    for (i in 1:3) {
        b[i] ~ dnorm(0.0, 1.0/1.0e6)
    }
    
    prec ~ dgamma(1.0/2.0, 1.0*1500.0/2.0)
    	## Initial guess of variance based on overall
    	## variance of education variable. Uses low prior
    	## effective sample size. Technically, this is not
    	## a true 'prior', but it is not very informative.
    sig2 = 1.0 / prec
    sig = sqrt(sig2)
} "

data1_jags = as.list(Anscombe)


set.seed(72)
#data1_jags = list(y=dat$loginfant, n=nrow(dat), log_income=dat$logincome)

# choose to monitor standard dev 
params1 = c("b", "sig")

inits1 = function() { 
    inits = list("b"=rnorm(3, 0.0, 100.0), "prec"=rgamma(1,1.0,1.0))
}

# run the model with 3 chains each starting with inits1 params
mod1 = jags.model(textConnection(mod1_string), data=data1_jags, inits=inits1, n.chains=3)

dic.samples(mod1, n.iter=100e3)

# burn in period 
update(mod1, 1000)

mod1_sim = coda.samples(model=mod1, variable.names=params1, n.iter=100e3)

# stack matrices vertically 
mod1_csim = do.call(rbind, mod1_sim)


### Convergence 
plot(mod1_sim)
gelman.diag(mod1_sim)
autocorr.diag(mod1_sim)
effectiveSize(mod1_sim)
#summary(mod1_sim)
