
#acceptance ratio = g(u)/q(u*|ui-1) / g(ui-1)/q(ui-1|u*)

#q = candidate drawing function 

# g(u) = posterior distribution 
#log(g(u)) = likeyhood*prior  
lg = function(yBar,n,mu){
    mu2 = mu^2
    n*(yBar*mu - mu2/2) - log (1+mu2)
}


mh = function(n, yBar, nIter, muInit, candSd){
    muOut = numeric(nIter)
    accept = 0 
    muNow = muInit
    lgNow = lg(mu=muNow, n=n, yBar=yBar)


    for (i in 1:nIter){
        #draw candidate from proposal distribution 
        #q(u*|ui-1), using a normal distribution
        muCand = rnorm(1,mean=muNow,sd=candSd)

        #norm(mean=muNow,sd=candSd)/#norm(mean=muCand|sd=nowSd) -> cancles
        lgCand = lg(yBar=yBar,n=n,mu=muCand)
        lgNow = lg(yBar=yBar,n=n,mu=muNow)

        logAlpha = lgCand - lgNow

        alpha = exp(logAlpha)

        u = runif(1)
        #accept wiht proability alpha, rejects with probability 1-alpha
        if (u < alpha){
            muNow = muCand
            accept = accept + 1
            lgNow = lgCand
        }
        
        muOut[i] = muNow

    }
    list(mu=muOut,acceptRate=accept/nIter)
}


## Set up
# y = c(1.2, 1.4, -0.5, 0.3, 0.9, 2.3, 1.0, 0.1, 1.3, 1.9)
y = c(-0.2, -1.5, -5.3, 0.3, -0.8, -2.2)


yBar = mean(y)
n= length(y)

hist(y, freq=FALSE, xlim=c(-1.0, 3.0))
points(y, rep(0.0, n))
points(yBar, 0.0, pch=19)
curve(dt(x, df=1), lty=2, add=TRUE)

### posterior sampling 
set.seed(43)
#want acceptance rate between .23 and .5 with randomwalk MH
post = mh(n=n, yBar=yBar, nIter=1e3, muInit=1, candSd=1.5)
str(post) #find what's in object

library("coda")

traceplot(as.mcmc(post$mu))


### post analysis 
post$muKeep = post$mu[-c(1:100)]
plot(density(post$muKeep), xlim=c(-1.0,3.0))
mean(post$mu)
plot(density(post$mu))