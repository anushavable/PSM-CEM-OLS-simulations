# This code creates the 10,000 datasets for the "outcome quadratic" data structure. 
# We generate all 10,000 datasets at once such that each column is a different dataset 
# with 120,000 observations (i.e. 20,000 observations for each of our 6 variables),
# and then separate each column into a dataset in Stata. 

setwd("")
#install.packages('arm')
library(arm)
iter = 10000
obs = 20000

# coefficients to vary correlation & common support - values we used are presented in Appendix Table 8. 
b = 
c = 
d = 
e = 

# Generate x1 and x2 
x1 = rnorm(iter*obs,10,1.5)
x2 = x1 + b*rnorm(iter*obs,12,2)

# Generate exposure 
a_con = c*x1 + d*x2 + e*rnorm(iter*obs)
a = as.numeric(a_con>quantile(expd,.5))

# Generate x3 and x4 (used to generate outcome only)
x3 = rnorm(iter*obs,100,20)
x4 = 0.1*x3+2*rnorm(iter*obs,30,2.2)

# Generate outcome 
y = 0*exp + 1*x1 + 5*x1*x1 + 5*x2 + 0.1*x3 + 1*x4*x4 + 100*rnorm(iter*obs,100,10)

x1 = matrix(x1,ncol=iter)
x2 = matrix(x2,ncol=iter)
x3 = matrix(x3,ncol=iter)
x4 = matrix(x4,ncol=iter)

a = matrix(a,ncol=iter)
y = matrix(y,ncol=iter)
cormat = diag(cor(x1,x2))

# write 10,000 datasets to csv file to import into Stata 
out_quad <- rbind(x1, x2, x3, x4, exp, out)
write.csv(out_quad, file = "sims.csv") 
