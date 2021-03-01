#estimae sigma^2 and mu

#mu: Normal
#sigma: Inverse Gamma

updateMu = function(n, yBar, sig2, mu_0, sig2_0){
    sig2_1 = 1.0/ (n / sig2 + 1.0 / sig2_0)
    mu_1 = sig2_1 * (n * yBar / sig2 + mu_0 / sig2_0)
    rnorm(n=1, mean=mu_1, sd=sqrt(sig2_1))
}


updateSig2 = function(n, y, nu, nu_0, beta_0){
    nu_1 = nu_0 + n / 2.0
    sumSq = sum( (y-nu)^2)
    beta_1 = beta_0 + sumSq / 2.0
    outGamma = rgamma(n=1, shape=nu_1, rate=beta_1)
    1.0 / outGamma # inverse must be down manually 
}

gibbs = function(y, nIter, init, prior){
    yBar = mean(y)
    n = length(y)

    muOut = numeric(nIter)
    sig2Out = numeric(nIter)
    
    muNow = init$mu

    # Gibs sampler 
    for (i in 1:nIter){
        sig2Now = updateSig2(n=n, y=y, nu=muNow, nu_0=prior$nu_0, beta_0=prior$beta_0)
        muNow = updateMu(n=n, yBar=yBar, sig2=sig2Now, mu_0=prior$mu_0, sig2_0=prior$sig2_0)

        sig2Out[i] = sig2Now
        muOut[i] = muNow[i]
    }
    cbind(mu=muOut, sig2=sig2Out)
}


y =  c(1.2, 1.4, -0.5, 0.3, 0.9, 2.3, 1.0, 0.1, 1.3, 1.9) 
n = length(y)
yBar = mean(y)

prior = list()

prior$mu_0 = 0.0
prior$sig2_0 = 1.0 #variance, prior confidence in mean 
prior$n_0 = 2.0
prior$s2_0 = 1.0
prior$nu_0 = prior$n_0 / 2.0
prior$beta_0 = prior$n_0 * prior$s2_0 / 2.0


hist(y, freq=FALSE, xlim=c(-1.0,3.0))
curve(dnorm(x=x, mean=prior$mu_0, sd=sqrt(prior$sig2_0)), lty=2, add=TRUE)
points(y, rep(0,n), pch=1)
points(yBar, 0, pch=19)

set.seed(53)

init = list()
init$mu = 0.0


post = gibbs(y=y,nIter=1000,init=init,prior=prior)
head(post)
tail(post)

library("coda")
plot(as.mcmc(post))