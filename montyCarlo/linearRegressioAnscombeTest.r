library("car")  # load the 'car' package
data("Anscombe")  # load the data set
#?Anscombe  # read a description of the data
head(Anscombe)  # look at the first few lines of the data
 

# response = educational expenditure 
# predictors: income, young age, urban 

Xc = scale(Anscombe, center=TRUE, scale=TRUE)
str(Xc)

data_jags = as.list(data.frame(Xc))


library("rjags")

# edu likelyhood = normal dist, predict y given the mean calculated using the yuong, urban and income coefficents
# normal prior for income, young and urban coeficents with large 1m variance to reduce correlations
# prior on variance in an inverse gamma 
mod_string = " model {
    for (i in 1:length(education)) {
        education[i] ~ dnorm(mu[i], prec)
        mu[i] = b[1]*income[i] + b[2]*young[i] + b[3]*urban[i]
    }
    
    for (i in 1:3) {
        b[i] ~ dexp(1.0)
    }
    
    prec ~ dgamma(1.0, 1.0)
    	## Initial guess of variance based on overall
    	## variance of education variable. Uses low prior
    	## effective sample size. Technically, this is not
    	## a true 'prior', but it is not very informative.
    sig2 = 1.0 / prec
    sig = sqrt(sig2)
} "


set.seed(72)
#data1_jags = list(y=dat$loginfant, n=nrow(dat), log_income=dat$logincome)

# choose to monitor standard dev 
params = c("b", "sig")

inits = function() { 
    inits = list("b"=rexp(3, 1.0), "prec"=rgamma(1,1.0,1.0))
}

# run the model with 3 chains each starting with inits1 params
mod = jags.model(textConnection(mod_string), data=data_jags, inits=inits, n.chains=3)

dic.samples(mod, n.iter=100e3)

# burn in period 
update(mod, 1000)

mod_sim = coda.samples(model=mod, variable.names=params, n.iter=100e3)

# stack matrices vertically 
mod_csim = do.call(rbind, mod_sim)


### Convergence 
plot(mod_sim)
gelman.diag(mod_sim)
autocorr.diag(mod_sim)
effectiveSize(mod_sim)
summary(mod_sim)
