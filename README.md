# PSM-CEM-OLS-simulations

Includes all code for our paper entitled "Inferences from matching methods for statistical regression under constant null effects".  

There are 3 types of code in 3 sections: 1. Data generating functions, 2. PSM, CEM, OLS analysis implementation, and 3. Descriptive statistics presented in paper.

First are the data generating functions; the data generation was performed in R.  There are 7 simulated data structures: Outcome Linear (good and poor common support), Outcome quadratic (good and poor common support), Exposure discontinuity, Outcome discontinuity, and Exposure-outcome discontinuity.
We simulated all 10,000 datasets at once, where each column was a dataset (we separated each column into a single dataset in stata). 

Second, is the analysis implementation. 

