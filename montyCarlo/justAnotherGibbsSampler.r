
# Specify model 
library("rjags")

# model structure 
# normal likelyhood 
# prior on mean t distribution 

#must  write model as a string
mod_string = " model {
    for (i in 1:n){
        y[i] ~ dnorm(mu, 1.0/sig2)
    }
    mu ~ dt(0.0, 1.0/1.0, 1)
    sig2 = 1.0
} "

# model set up 
set.seed(50)
y =  c(1.2, 1.4, -0.5, 0.3, 0.9, 2.3, 1.0, 0.1, 1.3, 1.9) 
n = length(y)

data_jags = list(y=y, n=n)
params = c("mu")

inits = function(){
    inits = list("mu"=0.0) # could generate a random mu
}

mod = jags.model(textConnection(mod_string), data=data_jags, inits=inits)

# Run MCMC sampler 
update(mod, 500)

mod_sim = coda.samples(model=mod, variable.names=params, n.iter = 1000) #simulate markov chain

# Post processing, evaluate markov chain and use for inference 
library("coda")

plot(mod_sim)
summary(mod_sim)