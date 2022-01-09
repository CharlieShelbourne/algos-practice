data = read.csv(file="C:/Users/shcmpq/OneDrive - BP/Documents/GitHub/algos_practice/montyCarlo/callers.csv", header=TRUE)

head(data)
pairs(data)


library("rjags")

mod_string =" model {
    for (i in 1:length(calls)) {
		calls[i] ~ dpois( days_active[i] * lam[i] )
		log(lam[i]) = b0  + b[1]*isgroup2[i] + b[2]*age[i]
	}

    b0 ~ dnorm(0.0, 1.0/1e2)

    for(j in 1:2) {
        b[j] ~ dnorm(0.0, 1.0/1e2)
    }

} "

set.seed(102)

data_jags = as.list(data)

params = c("b0", "b[1]", "b[2]")

mod = jags.model(textConnection(mod_string), data=data_jags, n.chains=3)
update(mod, 1e3)

mod_sim = coda.samples(model=mod,
                        variable.names=params,
                        n.iter=20e3)
mod_csim = as.mcmc(do.call(rbind, mod_sim))


## convergence diagnostics
#plot(mod_sim)

gelman.diag(mod_sim)
autocorr.diag(mod_sim)
autocorr.plot(mod_sim)
effectiveSize(mod_sim)

x = c(1,29)
loglam = mod_csim[,"b0"] + mod_csim[,c(2,3)] %*% x
lam = exp(loglam)

n_sim = length(lam)
y = rpois(n=n_sim, lambda=lam*30)
mean(y>2)

X = as.matrix(data[,3:4])
head(X)

pmed_coef = colMeans(mod_csim)

llam_hat = pmed_coef["b0"] + X %*% pmed_coef[c("b[1]", "b[2]")]
lam_hat = exp(llam_hat)



