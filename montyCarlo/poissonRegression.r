library("COUNT")
data("badhealth")

head(badhealth)
any(is.na(badhealth))

library("rjags")

# could fit normal linear model to log of visits 

# draw back of taking the log - cannot take log of 0 (must add 0.1 to response) 

# instead we can choose poisson linear model, nw taking log of mean rather than response it's self 

# form of model included an interation coeficient (a person in good health gives 0, bad health will modify entire linear equation), someone who is older more likely to have bad health

mod_string = " model {
    for (i in 1:length(numvisit)) {
        numvisit[i] ~ dpois(lam[i])
        log(lam[i]) = int + b_badh*badh[i] + b_age*age[i] + b_intx*age[i]*badh[i]
    }
    
    int ~ dnorm(0.0, 1.0/1e6)
    b_badh ~ dnorm(0.0, 1.0/1e4)
    b_age ~ dnorm(0.0, 1.0/1e4)
    b_intx ~ dnorm(0.0, 1.0/1e4)
} "

set.seed(102)

data_jags = as.list(badhealth)

data_jags

params = c("int", "b_badh", "b_age", "b_intx")

mod = jags.model(textConnection(mod_string), data=data_jags, n.chains=3)
update(mod, 1e3)

mod_sim = coda.samples(model=mod,
                        variable.names=params,
                        n.iter=5e3)
mod_csim = as.mcmc(do.call(rbind, mod_sim))

## convergence diagnostics
plot(mod_sim)

gelman.diag(mod_sim)
autocorr.diag(mod_sim)
autocorr.plot(mod_sim)
effectiveSize(mod_sim)

## compute DIC
dic = dic.samples(mod, n.iter=1e3)

dic

# point estimates of coeficients, use posterior median as we will be taking expo (could have used mean) 

# possion mean == variance. A good predictor should predict the same mean and variance in residuals 

# if data is more variable than poisson likelyhood suggest (common issue with count data) we can switch to neg binomill dist

# nteration term is an adjustment for age with bad health. Therefore switches the corellation with age and health to negative 




## Question Answer 

dat = read.csv(file='C:/Users/shcmpq/OneDrive - BP/Desktop/callers.csv', header=TRUE)

mod_string = " model {
    	for (i in 1:length(calls)) {
		calls[i] ~ dpois( days_active[i] * lam[i] )
		log(lam[i]) = b0  + b[1]*age[i] + b[2]*isgroup2[i]
	}

    b0 ~ dnorm(0.0, 1.0/1e2)

    for(j in 1:2) {
        b[j] ~ dnorm(0.0, 1.0/1e2)
    }

} "

set.seed(102)

data_jags = as.list(dat)

params = c("b0", "b[1]", "b[2]")

mod = jags.model(textConnection(mod_string), data=data_jags, n.chains=3)
update(mod, 1e3)

mod_sim = coda.samples(model=mod,
                        variable.names=params,
                        n.iter=20e3)
mod_csim = as.mcmc(do.call(rbind, mod_sim))


## convergence diagnostics
plot(mod_sim)

gelman.diag(mod_sim)
autocorr.diag(mod_sim)
autocorr.plot(mod_sim)
effectiveSize(mod_sim)

X = as.matrix(dat[,3:4])
head(X)

pmed_coef = colMeans(mod_csim)

llam_hat = pmed_coef["b0"] + X %*% pmed_coef[c("b[2]", "b[1]")]
lam_hat = exp(llam_hat/data$days_active)