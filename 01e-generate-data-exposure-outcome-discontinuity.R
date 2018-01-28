# This code creates the 10,000 datasets for the "exposure discontinuity" data 
# structure. We generate all 10,000 datasets at once such that each column is 
# a different dataset with 80,000 observations (i.e. 20,000 observations for 
# each of our 4 variables), and then separate each column into a dataset 
# in Stata.

setwd("")
# install.packages('arm')

library(arm)
iter <- 10000
obs  <- 20000

# generate confounders
x1 <- rnorm(iter * obs)
x2 <- x1 + 3.85 * rnorm(iter * obs)

# generate exposure
a <- NA # creates vector
# when x1 < 0.5, samples from binomial dist with pr(1=0.5)
a[x1 < 0.5] <- rbinom(length(a[x1 < 0.5]), 1, 0.5) 

# when x1 >=0.5, samples from binomial dist with pr(1=0.95)
a[x1 >= 0.5] <- rbinom(length(a[x1 >= 0.5]), 1, 0.95) 

mean(a[x1 < 0.5])   # should be around 0.5
mean(a[x1 >= 0.5])  # should be around 0.95

# generate outcome
y <- NA

# if x1 < 0 coefficient for x1 = 10
y[x1 < 0] <- 0 * a[x1 < 0] + 10 * x1[x1 < 0] + 10 * x2[x1 < 0]

# if x1 >=0 coefficient for x1 = 110
y[x1 >= 0] <- 0 * a[x1 >= 0] + 110 * x1[x1 >= 0] + 10 * x2[x1 >= 0]
y <- y + rnorm(iter * obs)

x1 <- matrix(x1, ncol = iter)
x2 <- matrix(x2, ncol = iter)
a  <- matrix(a, ncol = iter)
y  <- matrix(y, ncol = iter)
cormat <- diag(cor(x1, x2))

# write 10,000 datasets to csv file to import into Stata
exp_out_discon <- rbind(x1, x2, a, y)
write.csv(exp_out_discon, file = "sims.csv")