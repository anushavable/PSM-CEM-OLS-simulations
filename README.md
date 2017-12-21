# PSM-CEM-OLS-simulations

Includes all code for our paper entitled "Inferences from matching methods for statistical regression under constant null effects".  

There are 3 types of code in 3 sections: 1. Data generating functions, 2. PSM, CEM, OLS analysis implementation, and 3. Descriptive statistics presented in the paper.

First, are the data generating functions; the data generation was performed in R.  There are 7 simulated data structures: Outcome Linear (good and poor common support), Outcome quadratic (good and poor common support), Exposure discontinuity, Outcome discontinuity, and Exposure-outcome discontinuity.  We simulated all 10,000 datasets at once, where each column was a dataset (we separated each column into a single dataset in stata). 

Second, is the analysis implementation. The analysis was implemented using Stata 13.  To record information on the each dataset and each run of the analysis, we used the putexcel command.  This allowed up to create excel files where the relevant information (i.e. point estimate, standard error, p-value, sample size, range of weights, etc.) was recorded from each dataset such that each row of the excel file contained the information from one dataset. 

Third, we pulled the excel files that recorded the point estimates, etc. into stata and ran descriptive statistics, which are presented in the paper.  
