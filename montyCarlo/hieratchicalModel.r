dat = read.table(file="cookies.dat", header=TRUE)

table(dat$location)

hist(dat$chips)

boxplot(chips ~ location, data=dat)


set.seed(112)
n_sim = 500 #number of monti carlo samples 
alpha_pri = rexp(n_sim, rate=1.0/2.0) # draw for alpha prior from exponential dist 
beta_pri = rexp(n_sim, rate=5.0) # draw beta prior from exp 
mu_pri = alpha_pri/beta_pri # simulate mean of lambda 
sig_pri = sqrt(alpha_pri/beta_pri^2) # standard dev 

summary(mu_pri) # shows lambda of gamma (gamma decides how correlated our groups are)

summary(sig_pri) # SD of gamma 

lam_pri = rgamma(n=n_sim, shape=alpha_pri, rate=beta_pri) # sample from gamma to get lambda distribution, to tighten values then we could modify prior to be gamma dists 
summary(lam_pri)

y_pri = rpois(n_sim, lam_pri)
summary(y_pri)

lam_pri = rgamma(n=5, shape=alpha_pri[1:5], rate=beta_pri[1:5])

y_pri = rpois(n=150, lambda=rep(lam_pri, each=30)) 


library("rjags")

# place priors on mean and SD of gamma distribution, using informative priors 

mod_string = " model {
for (i in 1:length(chips)) {
  chips[i] ~ dpois(lam[location[i]])
}

for (j in 1:max(location)) {
  lam[j] ~ dgamma(alpha, beta)
}

alpha = mu^2 / sig^2
beta = mu / sig^2

mu ~ dgamma(2.0, 1.0/5.0)
sig ~ dexp(1.0)

} "

set.seed(113)

data_jags = as.list(dat)

params = c("lam", "mu", "sig")

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

## observation level residuals
(pm_params = colMeans(mod_csim))

yhat = rep(pm_params[1:5], each=30)
resid = dat$chips - yhat          
plot(resid)

plot(jitter(yhat), resid)

var(resid[yhat<7])

var(resid[yhat>11])

## location level residuals
lam_resid = pm_params[1:5] - pm_params["mu"]  # mu is the global eatimate for lambda (number of chips in cookies globally) 
plot(lam_resid)
abline(h=0, lty=2)

summary(mod_sim)


n_sim = nrow(mod_csim)

lam_pred = rgamma(n=n_sim, shape=mod_csim[,"mu"]^2/mod_csim[,"sig"]^2, 
                  rate=mod_csim[,"mu"]/mod_csim[,"sig"]^2)
hist(lam_pred)# prediction of lambda for new locations

mean(lam_pred > 15) # probability the new location's lambda is > 15

y_pred = rpois(n=n_sim, lambda=lam_pred)
hist(y_pred) # posterior distribution of the number of chips per cookies of new lcations 

mean(y_pred > 15)

hist(dat$chips)

y_pred1 = rpois(n=n_sim, lambda=mod_csim[,"lam[1]"]) # use lambda for location 1 
hist(y_pred1) # posterior predictive dist for number of chips for a future cookie in location 1 

mean(y_pred1 < 7) # prob the next cookie will have less than 7 chips 
