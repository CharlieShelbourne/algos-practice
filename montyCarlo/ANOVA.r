data("PlantGrowth")
# Results compairing yeilds of plants grown under 2 different conditions 
# variables weight and group (explanitory variable) assigned (treatment 1, treatment 2) 

head(PlantGrowth)

boxplot(weight ~ group, data=PlantGrowth)

# assume each group has same modeling 

lmod = lm(weight ~ group, data=PlantGrowth)
summary(lmod) # intercept refers to control group, next 2 params give modification to mean of control group to give groups 1 and 2 

anova(lmod) # anova table, give analysis of variance table. Results of statistical test for each factor variabe show how it contributes to the varability in the data. Variability between and within factors, large ratio then factor vartiable does contribute

# Baysien model

library("rjags")

mod1_string = " model {
    for (i in 1:length(y)) {
        y[i] ~ dnorm(mu[grp[i]], prec)
    }
    
    for (j in 1:3) {
        mu[j] ~ dnorm(0.0, 1.0/1.0e6)
    }

    prec ~ dgamma(5/2.0, 5*1.0/2.0)
    sig = sqrt( 1.0 / prec )

} "

mod2_string = " model {
    for (i in 1:length(y)) {
        y[i] ~ dnorm(mu[grp[i]], prec[grp[i]])
    }
    
    for (j in 1:3) {
        mu[j] ~ dnorm(0.0, 1.0/1.0e6)
        prec[j] ~ dgamma(5/2.0, 5*1.0/2.0)
        sig[j] = sqrt( 1.0 / prec[j])
    }

} "

set.seed(82)
str(PlantGrowth)
data_jags = list(y=PlantGrowth$weight, 
              grp=as.numeric(PlantGrowth$group))

params = c("mu", "sig")

inits = function() {
    inits = list("mu"=rnorm(3,0.0,100.0), "prec"=rgamma(1,1.0,1.0))
}

mod1 = jags.model(textConnection(mod1_string), data=data_jags, inits=inits, n.chains=3)
update(mod1, 1e3)

mod2 = jags.model(textConnection(mod2_string), data=data_jags, inits=inits, n.chains=3)
update(mod2, 1e3)

mod1_sim = coda.samples(model=mod1,
                        variable.names=params,
                        n.iter=5e3)
mod1_csim = as.mcmc(do.call(rbind, mod1_sim)) # combined chains

mod2_sim = coda.samples(model=mod2,
                        variable.names=params,
                        n.iter=5e3)
mod2_csim = as.mcmc(do.call(rbind, mod2_sim)) # combined chains

HPDinterval(mod1_csim)

HPDinterval(mod2_csim)

dic1 = dic.samples(mod1,n.iter=5e3)
dic2 = dic.samples(mod2,n.iter=5e3)

dic1-dic2