# This code creates the 10,000 datasets for the "outcome linear" data structure. 
# We generate all 10,000 datasets at once such that each column is a different dataset 
# with 80,000 observations (i.e. 20,000 observations for each of our 4 variables),
# and then separate each column into a dataset in Stata. 

setwd("")
#install.packages('arm')
library(arm)
iter = 10000    # simulate 10,000 datasets
obs = 20000     # 20,000 observations in each data set

# coefficients to vary correlation & common support - values we used are presented in Appendix Table 7. 
b = 
c = 
d = 
e = 

# Generate confounders
x1 = rnorm(iter*obs)                        
x2 = x1 + b*rnorm(iter*obs)

# Generate exposure 
a_con = c*x1 + d*x2 + e*rnorm(iter*obs)
a = as.numeric(a_con>quantile(expd,.5))

# Generate outcome 
y = 0*a+10*x1+10*x2+rnorm(iter*obs)

x1 = matrix(x1,ncol=iter)
x2 = matrix(x2,ncol=iter)
a = matrix(a,ncol=iter)
y = matrix(y,ncol=iter)
cormat = diag(cor(x1,x2))

# write 10,000 datasets to csv file to import into Stata 
out_lin <- rbind(x1, x2, exp, out)
write.csv(out_lin, file = "sims.csv") 