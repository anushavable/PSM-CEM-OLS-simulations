/******************************************************************************************************************************************************

    This code performs the OLS, CEM, and PSM analyses for all data structures (i.e. the analysis code is the same regardless of data structure, 
    resulting in some models that were correctly specified, and a varity of different kinds of model misspecificaion). It is set up as follows: 
    
   Section 1, line 31:      Labels variables in the first row of excel an excel file using the "putexcel"  command
    
   Section 2, line 173:     Imports 10,000 datasets (CSV file outputted by R), saves it as a stata data set (it takes about 10 mins to import the CSV 
                            file and 1 min to import the stata file, so this is much faster). All 10,000 datasets (20,000 observations each) were created 
                            at one in R in 1 giant file such that each column is data set with either 80,000 rows (for data structures that have 4 variables) 
                            or 120,000 rows (for data structureswith 6 variables; only the "outcome quadratic data structures have 6 variables).
                            
    Section 3, line N:      Record "demographic" information from each simulated dataset, including ATE, ATT, and ATU.  The calculations of the ATE, ATT, 
                            and ATU vary for each data structure, so there are 7 different calculations.  You can comment out the equations you don't need. 
    
    Section 4, line N:      OLS, CEM, and PSM analyses when all confounders are measured
    
    Section 5, line N:      OLS, CEM, and PSM analyses when x1 is an unmeasured confounder

    Section 6, line N:      OLS, CEM, and PSM analyses when x2 is an unmeasured confounder

******************************************************************************************************************************************************/ 

# This code creates the 10,000 datasets for the "outcome linear" data structure. 
# We generate all 10,000 datasets at once such that each column is a different dataset 
# with 80,000 observations (i.e. 20,000 observations for each of our 4 variables),
# and then separate each column into a dataset in Stata. 


clear all

set more off, permanently
set maxvar 15000, permanently
    
cd "" //  FILE PATH 



/******************************************************************************************************************************************************
        
   Section 1: create and label excel files to record information from each simulation 
        
******************************************************************************************************************************************************/ 


/* Set up excel files to record resutls from each simulation */
    /* create excel file for info on simulations   */
        capture putexcel    A1 = ("x1 x2 corr")                 /// 
                            B1 = ("x1 exposed")                 ///
                            C1 = ("x1 unexposed")               ///
                            D1 = ("x2 exposed")                 ///
                            E1 = ("x2 unexposed")               ///
                            F1 = ("sim_num")                    ///
                            H1 = ("all_exp")                    ///
                            I1 = ("all_unexp")                  ///
                            J1 = ("ate")                        ///
                            K1 = ("att")                        /// 
                            L1 = ("atu")                        ///
                            M1 = ("x1exp")                      ///
                            N1 = ("x1unexp")                    ///
                            O1 = ("yexp")                       ///
                            P1 = ("yunexp")                     ///
                            using sim_info, replace 
        
        
    /* create excel file for distributions of covariates  */
        capture putexcel    A1 = ("x1_mean")                    ///     
                            B1 = ("x1_LL")                      ///
                            C1 = ("x1_UL")                      ///
                            D1 = ("x2_mean")                    ///
                            E1 = ("x2_LL")                      ///
                            F1 = ("x2_UL")                      ///
                            G1 = ("sim_num")                    ///
                            using dist, replace

                            
    /* create excel file for analysis with all confounders measured  */
        capture putexcel    A1 = ("OLS_N")                      ///     
                            B1 = ("OLS_L1_raw")                 ///
                            C1 = ("OLS_L1_coarse")              ///
                            D1 = ("OLS_B")                      ///
                            E1 = ("OLS_SE")                     ///
                            F1= ("OLS_LL")                      ///
                            G1 = ("OLS_UL")                     ///
                            H1 = ("OLS_P")                      ///
                            I1 = ("CEM_N")                      ///
                            J1 = ("CEM_L1")                     ///
                            K1 = ("CEM_LW")                     ///
                            L1 = ("CEM_UW")                     ///
                            M1 = ("CEM_B")                      ///
                            N1 = ("CEM_SE")                     ///
                            O1 = ("CEM_LL")                     ///
                            P1 = ("CEM_UL")                     ///
                            Q1 = ("CEM_P")                      ///
                            T1 = ("psm_n_exp_cal01")            ///
                            U1 = ("psm_n_unexp_cal01")          /// 
                            V1 = ("psm_lw_cal01")               ///
                            W1 = ("psm_uw_cal01")               ///
                            X1 = ("psm_n_wtd_cal01")            ///
                            Y1 = ("psm_b_cal01")                ///
                            Z1 = ("psm_se_cal01")               ///
                            AA1 = ("psm_l1_raw_cal01")          ///
                            AB1 = ("psm_l1_coarse_cal01")       ///             
                            AC1 = ("sim_num")                   ///
                            AD1 = ("cem_exp")                   ///
                            AE1 = ("cem_unexp")                 ///
                            AF1 = ("cem_d_exp")                 ///
                            AG1 = ("cem_d_unexp")               ///
                            using no_confounding, replace       
                    
                    
    /* create excel file for analysis when x1 is an unmeasured confounder */
        capture putexcel    A1 = ("OLS_N")                      ///     
                            B1 = ("OLS_L1_raw")                 ///
                            C1 = ("OLS_L1_coarse")              ///
                            D1 = ("OLS_B")                      ///
                            E1 = ("OLS_SE")                     ///
                            F1 = ("OLS_LL")                     ///
                            G1 = ("OLS_UL")                     ///
                            H1 = ("OLS_P")                      ///
                            I1 = ("CEM_N")                      ///
                            J1 = ("CEM_L1")                     ///
                            K1 = ("CEM_LW")                     ///
                            L1 = ("CEM_UW")                     ///
                            M1 = ("CEM_B")                      ///
                            N1 = ("CEM_SE")                     ///
                            O1 = ("CEM_LL")                     ///
                            P1 = ("CEM_UL")                     ///
                            Q1 = ("CEM_P")                      ///
                            T1 = ("psm_n_exp_cal01")            ///
                            U1 = ("psm_n_unexp_cal01")          ///
                            V1 = ("psm_lw_cal01")               ///
                            W1 = ("psm_uw_cal01")               ///
                            X1 = ("psm_n_wtd_cal01")            ///
                            Y1 = ("psm_b_cal01")                ///
                            Z1 = ("psm_se_cal01")               ///
                            AA1 = ("psm_l1_raw_cal01")          /// 
                            AB1 = ("psm_l1_coarse_cal01")       ///             
                            AC1 = ("sim_num")                   ///
                            AD1 = ("nox1_cem_exp")              ///
                            AE1 = ("nox1_cem_unexp")            ///
                            AF1 = ("nox1_cem_d_exp")            ///
                            AG1 = ("nox1_cem_d_unexp")          ///
                            using x1_unmeasured, replace  

    /* create excel file for analysis when x2 is an unmeasured confounder */
        capture putexcel    A1 = ("OLS_N")                      ///             
                            B1 = ("OLS_L1_raw")                 ///
                            C1 = ("OLS_L1_coarse")              ///
                            D1 = ("OLS_B")                      ///
                            E1 = ("OLS_SE")                     ///
                            F1 = ("OLS_LL")                     ///
                            G1 = ("OLS_UL")                     ///
                            H1 = ("OLS_P")                      ///
                            I1 = ("CEM_N")                      ///
                            J1 = ("CEM_L1")                     ///         
                            K1 = ("CEM_LW")                     ///
                            L1 = ("CEM_UW")                     ///
                            M1 = ("CEM_B")                      ///
                            N1 = ("CEM_SE")                     ///
                            O1 = ("CEM_LL")                     ///
                            P1 = ("CEM_UL")                     ///
                            Q1 = ("CEM_P")                      ///
                            T1 = ("psm_n_exp_cal01")            ///
                            U1 = ("psm_n_unexp_cal01")          ///
                            V1 = ("psm_lw_cal01")               ///
                            W1 = ("psm_uw_cal01")               ///
                            X1 = ("psm_n_wtd_cal01")            ///
                            Y1 = ("psm_b_cal01")                ///
                            Z1 = ("psm_se_cal01")               ///
                            AA1 = ("psm_l1_raw_cal01")          ///
                            AB1 = ("psm_l1_coarse_cal01")       ///             
                            AC1 = ("sim_num")                   ///
                            AD1 = ("nox2_cem_exp")              ///
                            AE1 = ("nox2_cem_unexp")            ///
                            AF1 = ("nox2_cem_d_exp")            ///
                            AG1 = ("nox2_cem_d_unexp")          ///
                            using x2_unmeasured, replace        
    
    
/******************************************************************************************************************************************************
        
        Section 2: import and subeset data 
        
******************************************************************************************************************************************************/     
    
            
* save sims as dta file -- just need to do this once, if have to restart code, should skip this step b/c it takes 10 mins 
 import delimited sims.csv, clear               
 save sims.dta, replace


* create master loop for each simulation 
forval x = 2 /10001 {           // goes from row 2 - row 10,001 to get 10,000 iterations
    clear all 
    set more off 
    
    * call data
    use sims.dta, clear
    
    
/******************************************************************************************************************************************************
        
        10,000 data sets were generated in R in 1 giant file, such that each column is a different data set, and there are 10,000 columns.  
        The code below takes one column (i.e. dataset) at a time, and reshapes the data so each variables is a different column for analysis in stata. 
        Below, there are two ways to separate out a single data set, one when there are 4 variables in the data structure (most simulated data structures), 
        and one when there are 6 variables in the data structure (outcome quadratic data structures only). 
        
******************************************************************************************************************************************************/ 


    * Code to subset individual data sets, for data sets with 4 variables (most) 
                * subset data - each column is 1 data set
                    keep v1 v`x' 
                
                * create "id" variable to reshape data from long to wide
                    gen id = 1 if _n < 20001
                    replace id = 2 if _n > 20000 & _n < 40001
                    replace id = 3 if _n > 40000 & _n < 60001
                    replace id = 4 if _n > 60000 & _n < 80001
                
                * create 20,000 "observations" per id 
                    replace v1 = v1 - 20000 if v1 > 20000
                    replace v1 = v1 - 20000 if v1 > 20000
                    replace v1 = v1 - 20000 if v1 > 20000
                

                * reshape and rename variables 
                    reshape wide v`x', i(v1) j(id)
                    rename v`x'1 x1 
                    rename v`x'2 x2 
                    rename v`x'3 a 
                    rename v`x'4 y
                
                * round x1 and x2 for L1 calculations
                    gen x1r = round(x1,1) 
                    gen x2r = round(x2,1) 
                    
                save simdata, replace 
                
                
                
                
                
            
    * Code to subset individual data sets, for data sets with 6 variables (outcome quadratic data sets only) 
                * subset data - each column is 1 data set - v1 is the number of observations in each 
                    keep v1 v`x' 
                
                * create "id" variable to reshape data from long to wide - each id is a different variable 
                    gen id = 1 if _n < 20001
                    replace id = 2 if _n >  20000 & _n <  40001
                    replace id = 3 if _n >  40000 & _n <  60001
                    replace id = 4 if _n >  60000 & _n <  80001
                    replace id = 5 if _n >  80000 & _n < 100001
                    replace id = 6 if _n > 100000 & _n < 120001
                

                * create 20,000 "observations" per id, so v1 goes from 1 - 20,000 for each variable in the column  
                    replace v1 = v1 - 20000 if _n > 20000   // 2nd variable 
                    replace v1 = v1 - 20000 if v1 > 20000   // 3rd variable 
                    replace v1 = v1 - 20000 if v1 > 20000   // 4th variable
                    replace v1 = v1 - 20000 if v1 > 20000   // 5th variable 
                    replace v1 = v1 - 20000 if v1 > 20000   // 6th variable 
                

                * reshape and rename variables 
                    reshape wide v`x', i(v1) j(id)
                    rename v`x'1 x1 
                    rename v`x'2 x2 
                    rename v`x'3 x3
                    rename v`x'4 x4 
                    rename v`x'5 a
                    rename v`x'6 y
                    
                * round x1 and x2 for CEM and L1 calculations
                    gen x1r = round(x1,1)
                    gen x2r = round(x2,1)
                
                save simdata, replace   

    
    
/******************************************************************************************************************************************************
        
        Section 3: record information on each simulation, and the distrubtion of covariates for each data set
        
******************************************************************************************************************************************************/ 
    
    
    
    * record correlation 
        corr x1 x2                                                      
            capture putexcel A`x'=(r(rho)) using sim_info, modify 
            
    * record common supoort 
        egen zx1 = std(x1)
        egen zx2 = std(x2)
        sum zx1 if a == 1
            capture putexcel B`x'=(r(mean)) using sim_info, modify 
        sum zx1 if a == 0
            capture putexcel C`x'=(r(mean)) using sim_info, modify 
        sum zx2 if a == 1
            capture putexcel D`x'=(r(mean)) using sim_info, modify 
        sum zx2 if a == 0
            capture putexcel E`x'=(r(mean)) using sim_info, modify 
            
    * record simulation number: 
        dis `x'
        capture putexcel F`x' = ("`x'") using sim_info, modify // put sim number into excel 
    
    * record number exposed and unexposed
        cou if a == 1   // number exposed
            capture putexcel H`x'=(r(N)) using sim_info, modify  // put number exposed into excel 
        
        cou if a == 0   // number unexposed
            capture putexcel I`x'=(r(N)) using sim_info, modify  // put number unexposed into excel 
    
    * record mean x1 for exposed and unexposed groups 
        sum x1 if a == 1
            capture putexcel M`x'= (r(mean)) using sim_info, modify  // put mean x1 in exposed into excel 
        sum x1 if a == 0
            capture putexcel N`x'= (r(mean)) using sim_info, modify  // put mean x1 in unexposed into excel 
    
    * record mean outcome for exposed and unexposed groups 
        sum y if a == 1
            capture putexcel O`x'= (r(mean)) using sim_info, modify  // put mean y in exposed into excel 
        sum y if a == 0
            capture putexcel P`x'= (r(mean)) using sim_info, modify  // put mean y in unexposed into excel 
            
    
/******************************************************************************************************************************************************
        
        Code to calculate ate, att, atu.  Because the generation of the exposure and the 
        outcome variable differ by data structure, there is different code for each data structure 
        
******************************************************************************************************************************************************/ 
        
        * data structure = outcome linear
                * get individual-level error 
                    gen y_no_err = 0*a + 10*x1 + 10*x2  // data generation equation for outcome w/o the error term 
                    gen resid = y - y_no_err            // error term (resid) is the y calculated w/ the error - y calculated w/o the error 
            
                * check that calculated correctly 
                    gen y_obs = 0*a + 10*x1 + 10*x2 + resid
                    gen check = y_obs - y           // calculating the outcome before and now is the same (check = 0) 
            
                * exposure if all unexposed / exposed 
                    gen a0 = 0              // exposure if everyone unexposed 
                    gen a1 = 1              // exposure if everyone treated 
            
                * gen y0, outcome if everyone untreated
                    gen y0 = 0*a0 + 10*x1 + 10*x2 + resid  
        
                * gen y1, outcome if everyone treated  
                    gen y1 = 0*a1 + 10*x1 + 10*x2 + resid   
        
        
        * data structure = outcome quadratic 
        
                * get individual-level error  
                    gen y_no_err = 0*a + x1 + 5*x12 + 5*x2 + 0.1*x3 + x42  // data generation equation for outcome w/o the error term 
                    gen resid = y - y_no_err            // error term (resid) is the y calculated w/ the error - y calculated w/o the error 
                
                * check that calculated correctly 
                    gen y_obs = 0*a + x1 + 5*x12 + 5*x2 + 0.1*x3 + x42 + resid
                    gen check = y_obs - y           // calculating the outcome before and now is the same (check = 0) 
                
                * exposure if all unexposed / exposed 
                    gen a0 = 0              // exposure if everyone unexposed 
                    gen a1 = 1              // exposure if everyone treated 
                
                * gen y0, outcome if everyone untreated
                    gen y0 = 0*a0 + x1 + 5*x12 + 5*x2 + 0.1*x3 + x42 + resid  
                
                * gen y1, outcome if everyone treated  
                    gen y1 = 0*a1 + x1 + 5*x12 + 5*x2 + 0.1*x3 + x42 + resid
        
        
        * data structure = exposure discontinuity 
        
                * get individual-level error  
                    gen y_no_err = 0*a + 110*x1 + 10*x2  // data generation equation for outcome w/o the error term 
                    gen resid = y - y_no_err            // error term (resid) is the y calculated w/ the error - y calculated w/o the error 
                    
                * check that calculated correctly 
                    gen y_obs = 0*a + 110*x1 + 10*x2 + resid
                    gen check = y_obs - y           // calculating the outcome before and now is the same (check = 0) 
                
                * exposure if all unexposed / exposed 
                    gen a0 = 0              // exposure if everyone unexposed 
                    gen a1 = 1              // exposure if everyone treated 
                
                * gen y0, outcome if everyone untreated
                    gen y0 = 0*a0 + 110*x1 + 10*x2  + resid  
            
                * gen y1, outcome if everyone treated  
                    gen y1 = 0*a1 + 110*x1 + 10*x2  + resid
        
        
        * data structure = outcome discontinuity 
        
                * get individual-level error 
                    gen     y_no_err = 0*a + 10*x1 + 10*x2  if x1 < 0   // data generation equation for outcome w/o the error term 
                    replace y_no_err = 0*a + 110*x1 + 10*x2 if x1 >= 0 // data generation equation for outcome w/o the error term 
                    gen resid = y - y_no_err // error term (resid) is the y calculated w/ the error - y calculated w/o the error
                    
                * check that calculated correctly 
                    gen y_obs = 0*a + 10*x1 + 10*x2 + resid if x1 < 0 
                    replace y_obs = 0*a + 110*x1 + 10*x2 + resid if x1 >= 0 
                    gen check = y_obs - y           // calculating the outcome before and now is the same (check = 0) 
                
                * exposure if all unexposed / exposed 
                    gen a0 = 0              // exposure if everyone unexposed 
                    gen a1 = 1              // exposure if everyone treated 
                
                * gen y0, outcome if everyone untreated
                    gen     y0 = 0*a0 + 10*x1 + 10*x2 + resid if x1 < 0 
                    replace y0 = 0*a0 + 110*x1 + 10*x2 + resid if x1 >= 0 
                
                * gen y1, outcome if everyone treated  
                    gen     y1 = 0*a1 + 10*x1 + 10*x2 + resid if x1 < 0 
                    replace y1 = 0*a1 + 110*x1 + 10*x2 + resid if x1 >= 0 
        
        
        * data structure = expousre outcome discontinuity 
        
                * get individual-level error 
                    gen     y_no_err = 0*a + 10*x1 + 10*x2  if x1 < 0   // data generation equation for outcome w/o the error term 
                    replace y_no_err = 0*a + 110*x1 + 10*x2 if x1 >= 0 // data generation equation for outcome w/o the error term 
                    gen resid = y - y_no_err // error term (resid) is the y calculated w/ the error - y calculated w/o the error
                    
                * check that calculated correctly 
                    gen y_obs = 0*a + 10*x1 + 10*x2 + resid if x1 < 0 
                    replace y_obs = 0*a + 110*x1 + 10*x2 + resid if x1 >= 0 
                    gen check = y_obs - y           // calculating the outcome before and now is the same (check = 0) 
        
                * exposure if all unexposed / exposed 
                    gen a0 = 0              // exposure if everyone unexposed 
                    gen a1 = 1              // exposure if everyone treated 
                
                * gen y0, outcome if everyone untreated
                    gen     y0 = 0*a0 + 10*x1 + 10*x2 + resid if x1 < 0 
                    replace y0 = 0*a0 + 110*x1 + 10*x2 + resid if x1 >= 0 
                
                * gen y1, outcome if everyone treated  
                    gen     y1 = 0*a1 + 10*x1 + 10*x2 + resid if x1 < 0 
                    replace y1 = 0*a1 + 110*x1 + 10*x2 + resid if x1 >= 0 
    
        

    * calculate ate, att, atu 
        gen ate = y0 - y1               // ate if everyone treated vs. untreated
        gen att = y0 - y1 if a == 1     // att if only the treated were treated
        gen atu = y0 - y1 if a == 0     // atu if only the untreated were treated 
    
        sum ate
            capture putexcel J`x'= (r(mean)) using sim_info, modify  // put ate into excel 
        sum att
            capture putexcel K`x'= (r(mean)) using sim_info, modify // put att into excel 
        sum atu
            capture putexcel L`x'= (r(mean)) using sim_info, modify // put atu into excel 
    
    
    

    * Get distribution of analysis covariates and put it into an excel file (1 row per iteration) 
        * x1 
            sum x1                                          // http://blog.stata.com/2013/09/25/export-tables-to-excel/
            putexcel A`x' = (r(mean)) using dist, modify 
            centile x1 
            putexcel B`x' = (r(lb_1)) C`x' = (r(ub_1)) using dist, modify 
            
        * s2
            sum x2
            putexcel D`x' = (r(mean)) using dist, modify 
            centile x2 
            putexcel E`x' = (r(lb_1)) F`x' = (r(ub_1)) using dist, modify 
            
        * sim number: 
            dis `x'
            capture putexcel G`x' = ("`x'") using dist, modify // put sim number into excel 
        

/******************************************************************************************************************************************************
        
        Section 4: Analysis when all confounders are measured 
        
******************************************************************************************************************************************************/
    
    * sim number: 
        dis `x'
        capture putexcel AC`x' = ("`x'") using no_confounding, modify // put sim number into excel as a character variable 

    /* OLS */
        use simdata, clear 
        imb x1 x2, treatment (a) // imbalance for raw variables
            capture putexcel B`x' = (r(L1)) using no_confounding, modify // put raw L1 into excel 
        imb x1r x2r, treatment (a) // imbalance for coarsened variables 
            capture putexcel C`x' = (r(L1)) using no_confounding, modify // put coarsened L1 into excel 
        reg y a x1 x2 
            * put OLS results into excel 
                capture putexcel A`x' = (e(N)) using no_confounding, modify  // put N into excel 
            parmest, saving(ols_all, replace) // export results to a new data set, will create scalars and then export to excel 
            use ols_all, clear 
                scalar ols_b = estimate
                scalar ols_se = stderr
                scalar ols_ll = min95
                scalar ols_ul = max95
                scalar ols_p = p
            capture putexcel D`x' = (ols_b) E`x' = (ols_se) F`x' = (ols_ll) G`x' = (ols_ul) H`x' = (ols_p) using no_confounding, modify // put beta, se, 95% CI,  and p into excel 
            
    * CEM
        use simdata, clear 
        * coarsened by rounding 
        
        cem x1r(#0) x2r(#0), treatment (a) // the #0 options means don't automatically coarsen into any additional bins, i.e. use the coarsening I've defined. 
            capture putexcel J`x' = (r(L1)) using no_confounding, modify // put L1 into excel 

            cou if a == 1 & cem_w > 0
                capture putexcel AD`x'=(r(N)) using no_confounding, modify  // put number exposed in CEM analytic sample into excel 
            cou if a == 0 & cem_w > 0
                capture putexcel AE`x'=(r(N)) using no_confounding, modify  // put number unexposed in CEM analytic sample into excel
            cou if a == 1 & cem_w == 0
                capture putexcel AF`x'=(r(N)) using no_confounding, modify  // put number exposed dropped to get CEM analytic sample into excel
            cou if a == 0 & cem_w == 0
                capture putexcel AG`x'=(r(N)) using no_confounding, modify  // put number unexposed dropped to get CEM analytic sample into excel
                    
        sum cem_w if cem_w > 0
            capture putexcel I`x'= (r(N)) K`x' = (r(min)) L`x' = (r(max)) using no_confounding, modify // put N, smallest weight, and largest weight into excel 
        
        * Put CEM results into excel 
            reg y a x1 x2 [iweight=cem_weights] // adjust for x1 and x2 because coarsened to facilitate matching 
            parmest, saving(cem_all, replace) // export results to a new data set, will create scalars and then export to excel 
            use cem_all, clear
                scalar cem_b = estimate
                scalar cem_se = stderr
                scalar cem_ll = min95
                scalar cem_ul = max95
                scalar cem_p = p
            capture putexcel M`x' = (cem_b) N`x' = (cem_se) O`x' = (cem_ll) P`x' = (cem_ul) Q`x' = (cem_p) using no_confounding, modify 
            
            
    * PSM: No confounding, caliper = 0.01
        * randomize data
        use simdata, clear 
        gen counter = rnormal()
        sort counter
        
        * run psmatch2 
        psmatch2 a x1 x2, logit out(y) nei(1) ties ai(1) cal(0.01) 
            capture putexcel Y`x' = (r(att)) Z`x' = (r(seatt)) using no_confounding, modify // put estimate and standard error into excel 
        
        tab a if _w < . & a == 1 
            capture putexcel T`x' = (r(N)) using no_confounding, modify // put number of exposed units in analysis into excel file 
        
        tab a if _w < . & a == 0 
            capture putexcel U`x' = (r(N)) using no_confounding, modify // put number of unexposed units in analysis into excel file 
            
        sum _weight 
            capture putexcel V`x' = (r(min)) W`x' = (r(max)) using no_confounding, modify // put N of included individuals, smallest weight and largest weight into excel file 
        
        reg y a [iweight=_weight]
            capture putexcel X`x' = (e(N)) using no_confounding, modify // put weighted N of the analytic sample into excel file 
            
        
        
            * Get weighted L1: need to expand the dataset by the weights to get the PSM L1, but if there are ties in the ps, the weights can be fractional, 
            * so, need to find the least common multiplier of the fractional denominators so we can expand the dataset. Can only expand by integers (otherwise stata rounds). 
            * the below code finds the least common multiplier to expand the data set
                tab _weight
                sum _weight
                gen wts = _weight 
                drop if wt == .                     // remove obs not matched upon 

                scalar multiplier = 1               // set  least common multiplier = 1 -- if there are no ties, no need to expland dataset by anything other than the frequency weights
                scalar i = 1                        // initial multiplier value for the loop 
                gen decimal = mod(wts, 1)           // get the decimal portion of the weights (there's only a decimal if there are ties)
                sum decimal                         // only need a multiplier > 1 if there are ties in the ps matching, so loop only starts if the decimal is > 0 
                
                gen numer = .                       // numerator of the ties fraction for the loop, intially set to .
                gen dec2 = .                        // set the decimal variable to ., will update in the loop 
                
                while `r(max)' > 0 {                // while the decimal is > 0 (i.e the numerator isn't an integer), do this loop 
                    scalar i = i +1                 // start loop at 2 becuase it doesn't make sense to multiply the fraction by 1 
                
                    replace numer = decimal*i       // numerator is the product of the decimal and i -- the first time the numerator is an integer, it's the least common multiplier 
                    replace dec2 = mod(numer, 1)    // get decimal portion of the numerator 
                    sum dec2
                        if `r(max)' == 0 {          // if the numerator is an integer, update the multiplier 
                            scalar multiplier = multiplier*i   
                        } 
                    }
                
                di multiplier                       // display the multiplier 
                gen new_wt = wts*multiplier         // create the new weight by multiplying the PSM weight by the multiplier 
                
                expand new_wt                       // expand dataset
                imb x1 x2, treatment(a)     // weighted imbalance for L1 with uncoarsened variables
                    capture putexcel AA`x' = (r(L1)) using no_confounding, modify // put raw L1 into excel 
                imb x1r x2r, treatment(a)   // weighted imbalance for L1 with coarsened variables 
                    capture putexcel AB`x' = (r(L1)) using no_confounding, modify // put coarsened L1 into excel 
    
    
    
    
/******************************************************************************************************************************************************
        
        Section 5: analysis  when x1 is an unmeasured confounder 
        
******************************************************************************************************************************************************/
    
    
    * sim number: 
        dis `x'
        capture putexcel AC`x' = ("`x'") using x1_unmeasured, modify // put sim number into excel 
        
    * OLS
        use simdata, clear 
        imb x2, treatment (a) // imbalance for raw variables
            capture putexcel B`x' = (r(L1)) using x1_unmeasured, modify // put raw L1 into excel 
        imb x2r, treatment (a) // imbalance for coarsened variables 
            capture putexcel C`x' = (r(L1)) using x1_unmeasured, modify // put coarsened L1 into excel 
        reg y a x2 
            * put OLS results into excel 
                capture putexcel A`x' = (e(N)) using x1_unmeasured, modify  // put N into excel 
            parmest, saving(ols_un, replace) // export results to a new data set, will create scalars and then export to excel 
            use ols_un, clear 
                scalar ols_b = estimate
                scalar ols_se = stderr
                scalar ols_ll = min95
                scalar ols_ul = max95
                scalar ols_p = p
            capture putexcel D`x' = (ols_b) E`x' = (ols_se) F`x' = (ols_ll) G`x' = (ols_ul) H`x' = (ols_p) using x1_unmeasured, modify // put beta, se, 95% CI,  and p into excel   
            
            
    * CEM
        use simdata, clear 
            
        * coarsened by rounding 
        cem x2r(#0), treatment (a) // the #0 options means don't automatically coarsen into any additional bins, i.e. use the coarsening I've defined. 
            capture putexcel J`x' = (r(L1)) using x1_unmeasured, modify // put L1 into excel 
            
            cou if a == 1 & cem_w > 0
                capture putexcel AD`x'=(r(N)) using x1_unmeasured, modify   // put number exposed in CEM analytic sample into excel 
            cou if a == 0 & cem_w > 0
                capture putexcel AE`x'=(r(N)) using x1_unmeasured, modify   // put number unexposed in CEM analytic sample into excel
            cou if a == 1 & cem_w == 0
                capture putexcel AF`x'=(r(N)) using x1_unmeasured, modify   // put number exposed dropped to get CEM analytic sample into excel
            cou if a == 0 & cem_w == 0
                capture putexcel AG`x'=(r(N)) using x1_unmeasured, modify   // put number unexposed dropped to get CEM analytic sample into excel
                
        sum cem_w if cem_w > 0
            capture putexcel I`x'= (r(N)) K`x' = (r(min)) L`x' = (r(max)) using x1_unmeasured, modify // put N, smallest weight, and largest weight into excel 
        
        * Put CEM results into excel 
            reg y a x2 [iweight=cem_weights]    
            parmest, saving(cem_un, replace) // export results to a new data set, will create scalars and then export to excel 
            use cem_un, clear
                scalar cem_b = estimate
                scalar cem_se = stderr
                scalar cem_ll = min95
                scalar cem_ul = max95
                scalar cem_p = p
            capture putexcel M`x' = (cem_b) N`x' = (cem_se) O`x' = (cem_ll) P`x' = (cem_ul) Q`x' = (cem_p) using x1_unmeasured, modify 
            
            
    * PSM: x1 unmeasured, caliper = 0.01
        * randomize data
        use simdata, clear 
        gen counter = rnormal()
        sort counter
        
        * run psmatch2 
        psmatch2 a x2, logit out(y) nei(1) ties ai(1) cal(0.01) 
            capture putexcel Y`x' = (r(att)) Z`x' = (r(seatt)) using x1_unmeasured, modify // put estimate and standard error into excel 
        
        tab a if _w < . & a == 1 
            capture putexcel T`x' = (r(N)) using x1_unmeasured, modify // put number of exposed units in analysis into excel file 
        
        tab a if _w < . & a == 0 
            capture putexcel U`x' = (r(N)) using x1_unmeasured, modify // put number of unexposed units in analysis into excel file 
            
        sum _weight 
            capture putexcel V`x' = (r(min)) W`x' = (r(max)) using x1_unmeasured, modify // put N of included individuals, smallest weight and largest weight into excel file 
        
        reg y a [iweight=_weight]
            capture putexcel X`x' = (e(N)) using x1_unmeasured, modify // put weighted N of the analytic sample into excel file 
            
        
        
            * Get weighted L1: need to expand the dataset by the weights to get the PSM L1, but if there are ties in the ps, the weights can be fractional, 
            * so, need to find the least common multiplier of the fractional denominators so we can expand the dataset. Can only expand by integers (otherwise stata rounds). 
            * the below code finds the least common multiplier to expand the data set
                tab _weight
                sum _weight
                gen wts = _weight 
                drop if wt == .                     // remove obs not matched upon 

                scalar multiplier = 1               // set  least common multiplier = 1 -- if there are no ties, no need to expland dataset by anything other than the frequency weights
                scalar i = 1                        // initial multiplier value for the loop 
                gen decimal = mod(wts, 1)           // get the decimal portion of the weights (there's only a decimal if there are ties)
                sum decimal                         // only need a multiplier > 1 if there are ties in the ps matching, so loop only starts if the decimal is > 0 
                
                gen numer = .                       // numerator of the ties fraction for the loop, intially set to .
                gen dec2 = .                        // set the decimal variable to ., will update in the loop 
                
                while `r(max)' > 0 {                // while the decimal is > 0 (i.e the numerator isn't an integer), do this loop 
                    scalar i = i +1                 // start loop at 2 becuase it doesn't make sense to multiply the fraction by 1 
                
                    replace numer = decimal*i       // numerator is the product of the decimal and i -- the first time the numerator is an integer, it's the least common multiplier 
                    replace dec2 = mod(numer, 1)    // get decimal portion of the numerator 
                    sum dec2
                        if `r(max)' == 0 {          // if the numerator is an integer, update the multiplier 
                            scalar multiplier = multiplier*i   
                        } 
                    }
                
                di multiplier                       // display the multiplier 
                gen new_wt = wts*multiplier         // create the new weight by multiplying the PSM weight by the multiplier 
                
                expand new_wt                       // expand dataset
                imb x2, treatment(a)    // weighted imbalance for L1 with uncoarsened variables
                    capture putexcel AA`x' = (r(L1)) using x1_unmeasured, modify // put raw L1 into excel 
                imb x2r, treatment(a)   // weighted imbalance for L1 with coarsened variables 
                    capture putexcel AB`x' = (r(L1)) using x1_unmeasured, modify // put coarsened L1 into excel 
            
            
/******************************************************************************************************************************************************
        
        Section 6: analysis when x2 is an unmeasured confounder 
        
******************************************************************************************************************************************************/

    * sim number: 
        dis `x'
        capture putexcel AC`x' = ("`x'") using x2_unmeasured, modify // put sim number into excel 
        
    * OLS
        use simdata, clear 
        imb x1, treatment (a) // imbalance for raw variables
            capture putexcel B`x' = (r(L1)) using x2_unmeasured, modify // put raw L1 into excel 
        imb x1r, treatment (a) // imbalance for coarsened variables 
            capture putexcel C`x' = (r(L1)) using x2_unmeasured, modify // put coarsened L1 into excel 
        reg y a x1
            * put OLS results into excel 
                capture putexcel A`x' = (e(N)) using x2_unmeasured, modify  // put N into excel 
            parmest, saving(ols_un, replace) // export results to a new data set, will create scalars and then export to excel 
            use ols_un, clear 
                scalar ols_b = estimate
                scalar ols_se = stderr
                scalar ols_ll = min95
                scalar ols_ul = max95
                scalar ols_p = p
            capture putexcel D`x' = (ols_b) E`x' = (ols_se) F`x' = (ols_ll) G`x' = (ols_ul) H`x' = (ols_p) using x2_unmeasured, modify // put beta, se, 95% CI,  and p into excel 
    
            
    * CEM
        use simdata, clear 
        * coarsened by rounding 
        cem x1r(#0), treatment (a) // the #0 options means don't automatically coarsen into any additional bins, i.e. use the coarsening I've defined. 
            capture putexcel J`x' = (r(L1)) using x2_unmeasured, modify // put L1 into excel 
        
            cou if a == 1 & cem_w > 0
                capture putexcel AD`x'=(r(N)) using x2_unmeasured, modify   // put number exposed in CEM analytic sample into excel 
            cou if a == 0 & cem_w > 0
                capture putexcel AE`x'=(r(N)) using x2_unmeasured, modify   // put number unexposed in CEM analytic sample into excel
            cou if a == 1 & cem_w == 0
                capture putexcel AF`x'=(r(N)) using x2_unmeasured, modify   // put number exposed dropped to get CEM analytic sample into excel
            cou if a == 0 & cem_w == 0
                capture putexcel AG`x'=(r(N)) using x2_unmeasured, modify   // put number unexposed dropped to get CEM analytic sample into excel
        
        sum cem_w if cem_w > 0
            capture putexcel I`x'= (r(N)) K`x' = (r(min)) L`x' = (r(max)) using x2_unmeasured, modify // put N, smallest weight, and largest weight into excel 
        
        * Put CEM results into excel 
            reg y a x1 [iweight=cem_weights]    
            parmest, saving(cem_un, replace) // export results to a new data set, will create scalars and then export to excel 
            use cem_un, clear
                scalar cem_b = estimate
                scalar cem_se = stderr
                scalar cem_ll = min95
                scalar cem_ul = max95
                scalar cem_p = p
            capture putexcel M`x' = (cem_b) N`x' = (cem_se) O`x' = (cem_ll) P`x' = (cem_ul) Q`x' = (cem_p) using x2_unmeasured, modify 
            
            
    * PSM: x2 unmeasured, caliper = 0.01
        * randomize data
        use simdata, clear 
        gen counter = rnormal()
        sort counter
        
        * run psmatch2 
        psmatch2 a x1, logit out(y) nei(1) ties ai(1) cal(0.01) 
            capture putexcel Y`x' = (r(att)) Z`x' = (r(seatt)) using x2_unmeasured, modify // put estimate and standard error into excel 
        
        tab a if _w < . & a == 1 
            capture putexcel T`x' = (r(N)) using x2_unmeasured, modify // put number of exposed units in analysis into excel file 
        
        tab a if _w < . & a == 0 
            capture putexcel U`x' = (r(N)) using x2_unmeasured, modify // put number of unexposed units in analysis into excel file 
            
        sum _weight 
            capture putexcel V`x' = (r(min)) W`x' = (r(max)) using x2_unmeasured, modify // put N of included individuals, smallest weight and largest weight into excel file 
        
        reg y a [iweight=_weight]
            capture putexcel X`x' = (e(N)) using x2_unmeasured, modify // put weighted N of the analytic sample into excel file 
            
        
        
            * Get weighted L1: need to expand the dataset by the weights to get the PSM L1, but if there are ties in the ps, the weights can be fractional, 
            * so, need to find the least common multiplier of the fractional denominators so we can expand the dataset. Can only expand by integers (otherwise stata rounds). 
            * the below code finds the least common multiplier to expand the data set
                tab _weight
                sum _weight
                gen wts = _weight 
                drop if wt == .                     // remove obs not matched upon 

                scalar multiplier = 1               // set  least common multiplier = 1 -- if there are no ties, no need to expland dataset by anything other than the frequency weights
                scalar i = 1                        // initial multiplier value for the loop 
                gen decimal = mod(wts, 1)           // get the decimal portion of the weights (there's only a decimal if there are ties)
                sum decimal                         // only need a multiplier > 1 if there are ties in the ps matching, so loop only starts if the decimal is > 0 
                
                gen numer = .                       // numerator of the ties fraction for the loop, intially set to .
                gen dec2 = .                        // set the decimal variable to ., will update in the loop 
                
                while `r(max)' > 0 {                // while the decimal is > 0 (i.e the numerator isn't an integer), do this loop 
                    scalar i = i +1                 // start loop at 2 becuase it doesn't make sense to multiply the fraction by 1 
                
                    replace numer = decimal*i       // numerator is the product of the decimal and i -- the first time the numerator is an integer, it's the least common multiplier 
                    replace dec2 = mod(numer, 1)    // get decimal portion of the numerator 
                    sum dec2
                        if `r(max)' == 0 {          // if the numerator is an integer, update the multiplier 
                            scalar multiplier = multiplier*i   
                        } 
                    }
                
                di multiplier                       // display the multiplier 
                gen new_wt = wts*multiplier         // create the new weight by multiplying the PSM weight by the multiplier 
                
                expand new_wt                       // expand dataset
                imb x1, treatment(a)    // weighted imbalance for L1 with uncoarsened variables
                    capture putexcel AA`x' = (r(L1)) using x2_unmeasured, modify // put raw L1 into excel 
                imb x1r, treatment(a)   // weighted imbalance for L1 with coarsened variables 
                    capture putexcel AB`x' = (r(L1)) using x2_unmeasured, modify // put coarsened L1 into excel
        }
