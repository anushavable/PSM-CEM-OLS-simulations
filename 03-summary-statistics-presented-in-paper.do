    
* Summary statistics presented in Table 1 
    
cd "" // File path 
    
    * All confounders measured 
            * point estimate 
                use no_confounding, clear 
                
                sum psm_b_cal01, d          // SD of the distribution of point estimates is the emperical standard error 
                sum CEM_B, d 
                sum OLS_B, d
                
            * Software standard error 
                sum psm_se_cal01, d
                sum CEM_SE, d 
                sum OLS_SE, d
            
            * type I error rate 
                gen tstat = psm_b_cal01 / psm_se_cal01
                    gen PSMreject_null = 0
                    replace PSMreject_null = 1 if tstat > 1.96
                    replace PSMreject_null = 1 if tstat < -1.96
                    
                tab PSMreject_null
                cou if CEM_P < 0.05 
                cou if OLS_P < 0.05
            
            * sample size 
                sum psm_n_wtd_cal01, d
                sum CEM_N, d 
                sum OLS_N, d
