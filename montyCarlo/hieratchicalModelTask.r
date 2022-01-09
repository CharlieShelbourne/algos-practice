dat = read.csv(file="pctgrowth.csv", header=TRUE)


boxplot(y ~ grp, data=dat)

library("rjags")

# place priors on mean and SD of gamma distribution, using informative priors 

mod_string = " model {
for (i in 1:length(y)) {
  y[i] ~ dnorm(pheta[grp[i]], prec)
}

for (j in 1:max(grp)) {
  pheta[j] ~ dnorm(mu, prec_tau)
}

mu ~ dnorm(0.0, 1.0/1.0e6)
prec ~ dgamma(1.0, 1.0)
prec_tau ~ dgamma(0.5, 3.0/2.0)

sig = 1.0 / prec
tau = 1.0 / prec_tau

} "


set.seed(113)

data_jags = as.list(dat)

params = c("pheta","tau", "mu", "sig")

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
resid = dat$y - yhat          
plot(resid)

means_anova = tapply(dat$y, INDEX=dat$grp, FUN=mean)

means_anova

