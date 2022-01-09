import pymc3 as pm
import numpy as np
import matplotlib.pyplot as plt
from IPython.core.pylabtools import figsize

with pm.Model() as model:
    theta = pm.Uniform('theta', lower=0, upper=1)

occurrences = np.array([1,1,0])

with model:
    obs = pm.Bernoulli("obs", theta, observed=occurrences)
    step = pm.Metropolis()
    trace = pm.sample(18000, step=step)
    burned_trace=trace[1000:]


from IPython.core.pylabtools import figsize
p_true=0.5
figsize(12.5, 4)
plt.title(r"Posterior distribution of $\theta$")
plt.vlines(p_true,0, 2, linestyle='--', label=r"true $\theta$ (unknown)", color='red')
plt.hist(burned_trace["theta"], bins=25, histtype='stepfilled', density=True, color='#348ABD')
x=np.arange(0,1.04,0.04)
plt.plot(x, 12*x*x*(1-x), color='black')
plt.legend()
plt.show()