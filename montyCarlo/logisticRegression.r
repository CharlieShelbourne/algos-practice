library("boot")
data("urine")


head(urine)

dat = na.omit(urine) # get rid f missing values 
dim(dat)

# avoid colinearity if we want to determin which variables relate to response
# colinearity phenomenon in which one predictor variable in a multiple regression model can be linearly predicted from the others with a substantial degree of accuracy.
# must deal wih colinearity, as makes it difficult for statistical inference 
# could use linear model that favours values near 0 therefore weak signal on these features 
# colinearity only good for predictions 
pairs(dat)

# minus mean and div by sd, standardise 
X = scale(dat[,-1], center=TRUE, scale=TRUE) # variable selection (only for non categorical)
colMeans(X) # means all close to zero 
apply(X, 2, sd) # sd are all 1 

# speacial prior to favour coefficients near zero, dobule exponential 


library("rjags")

# likelyhood observations come from bermuli distribution inputing a probability 
# linear model gives logit of p 
# non informative normal prior
# prior for beta terms double expinential prior, with variance 1 (favours values closer to 0) 
mod1_string = " model {
    for (i in 1:length(y)) {
        y[i] ~ dbern(p[i]) 
        logit(p[i]) = int + b[1]*gravity[i] + b[2]*ph[i] + b[3]*osmo[i] + b[4]*cond[i] + b[5]*urea[i] + b[6]*calc[i]
    }
    int ~ dnorm(0.0, 1.0/25.0)
    for (j in 1:6) {
        b[j] ~ ddexp(0.0, sqrt(2.0)) # has variance 1.0
    }
} "

set.seed(92)
head(X)

data_jags = list(y=dat$r, gravity=X[,"gravity"], ph=X[,"ph"], osmo=X[,"osmo"], cond=X[,"cond"], urea=X[,"urea"], calc=X[,"calc"])

params = c("int", "b")

mod1 = jags.model(textConnection(mod1_string), data=data_jags, n.chains=3)
update(mod1, 1e3)

mod1_sim = coda.samples(model=mod1,
                        variable.names=params,
                        n.iter=5e3)
mod1_csim = as.mcmc(do.call(rbind, mod1_sim))

## convergence diagnostics
plot(mod1_sim, ask=TRUE)

gelman.diag(mod1_sim)
autocorr.diag(mod1_sim)
autocorr.plot(mod1_sim)
effectiveSize(mod1_sim)

## calculate DIC
dic1 = dic.samples(mod1, n.iter=1e3)


par(mfrow=c(3,2))
densplot(mod1_csim[,1:6], xlim=c(-3.0,3.0)) # plot posterior distributions of coefficents looking for coefficents that differ from zero, these are strong predictors  
colnames(X)

# kept only strong predictors and switched coefficent prior to non informative prior

mod2_string = " model {
    for (i in 1:length(y)) {
        y[i] ~ dbern(p[i]) 
        logit(p[i]) = int + b[1]*gravity[i] + b[2]*cond[i] + b[3]*calc[i]
    }
    int ~ dnorm(0.0, 1.0/25.0)
    for (j in 1:3) {
        b[j] ~ dnorm(0.0, 1.0/25.0) # has variance 1.0
    }
} "

mod2 = jags.model(textConnection(mod2_string), data=data_jags, n.chains=3)

update(mod2, 1e3)

mod2_sim = coda.samples(model=mod2,
                        variable.names=params,
                        n.iter=5e3)
mod2_csim = as.mcmc(do.call(rbind, mod2_sim))

plot(mod2_sim, ask=TRUE)

gelman.diag(mod2_sim)
autocorr.diag(mod2_sim)
autocorr.plot(mod2_sim)
effectiveSize(mod2_sim)

dic2 = dic.samples(mod2, n.iter=1e3) # do not use dic to choose between priors 

summary(mod2_sim)

pm_coef = colMeans(mod2_csim) # as scaled 0 shows average values 

1.0 / (1.0 + exp(0.15)) # using posterior mean point estimates 

1.0 / (1.0 + exp(0.15 - 1.42*0.0 - -1.36*(-1.0) - 1.88*1.0)) # model was fit to stadardised values. Therefore must sue standardised value to make predictions 

pm_Xb = pm_coef["int"] + X[,c(1,4,6)] %*% pm_coef[1:3] # intercept + values of predictors matmul posterior means of coefficients

phat = 1.0 / (1.0 + exp(-pm_Xb))
head(phat)

plot(phat, jitter(dat%r))

tab.05 = table(phat > 0.5, dat$r)
tab.05

sum(diag(tab0.5)) / sum(tab0.5)


tab.03 = table(phat > 0.3, dat$r)
tab.03

sum(diag(tab0.3)) / sum(tab0.3)

