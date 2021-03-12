library("coda")

# posterior distribution of converged chain 
set.seed(61)
post0 = mh(n=n, ybar=ybar, n_iter=10e3, mu_init=0.0, cand_sd=0.9)
traceplot(as.mcmc(post0$mu[-c(1:500)]))

# posterior distribution of wondering chain 
post1 = mh(n=n, ybar=ybar, n_iter=1e3, mu_init=0.0, cand_sd=0.04)
traceplot(as.mcmc(post1$mu[-c(1:500)]))

# posterior distribution wondering chain converged 
post2 = mh(n=n, ybar=ybar, n_iter=100e3, mu_init=0.0, cand_sd=0.04)
traceplot(as.mcmc(post2$mu))

# effective sample size - number of independent MC samples (more = greater information)

# effective sample size how many indipendent sampe needed to get the same information

# want chain with low auto correaltion - good converging properties - good chain 

# need to check the effective sample size - relyable estimates need a high number of effective sample size 

# a chain with high auto correaltion will lead to more sampling to get a good (significant) effective sample

# lesson - drawing from a population who are correlated will take longer to understand the entire distribution

autocorr.plot(as.mcmc(post0$mu))
autocorr.diag(as.mcmc(post0$mu))

autocorr.plot(as.mcmc(post1$mu))
autocorr.diag(as.mcmc(post1$mu))

str(post2)

effectiveSize(as.mcmc(post2$mu)) 

autocorr.plot(as.mcmc(post2$mu), lag.max=500)

thin_interval = 400 # how far apart the iterations are for autocorrelation to be essentially 0.
thin_indx = seq(from=thin_interval, to=length(post2$mu), by=thin_interval)
head(thin_indx)

post2mu_thin = post2$mu[thin_indx]
traceplot(as.mcmc(post2$mu))

traceplot(as.mcmc(post2mu_thin))

autocorr.plot(as.mcmc(post2mu_thin), lag.max=10)

effectiveSize(as.mcmc(post0$mu))

?effectiveSize

raftery.diag(as.mcmc(post0$mu))

raftery.diag(as.mcmc(post0$mu), q=0.005, r=0.001, s=0.95)