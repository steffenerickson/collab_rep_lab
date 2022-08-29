
global programs "/Users/steffenerickson/Desktop/repos/collab_rep_lab/02_randomize"

********************************************************************************  
*Randomize Function
********************************************************************************  

*syntax namelist(max=1) [if] [in] [, BY(string) SEED(real 1) ARMS(real 1)]

* REQUIRED  
*------------------------------------------------------------------------------*                 
*treatment variable (namelist = 1) | SEED (real, defult of 1 will break program) |
*------------------------------------------------------------------------------*  

* OPTIONAL 
*------------------------------------------------------------------------------* 
* BY - blocking variable(s) (string or factor) | ARMS - treatment_arms (real, default is 2) 
*------------------------------------------------------------------------------* 

do "${programs}/randomize.do" 


********************************************************************************  
*Balance Checking Function 
********************************************************************************   
*Check for balance on key covariates

*syntax varlist(min = 2) [if] [in][, Blocks(varlist) Table(string) Plot(numlist) Export(real 1)]

* REQUIRED  
*------------------------------------------------------------------------------*                 
* varlist (1st position is treatment variable, 2..n are covariates)
*------------------------------------------------------------------------------*  
*------------------------------------------------------------------------------*                 
*Table or Plot or both 
*table("table name") to create balance table
*plot(upper and lower bounds for variance and effect size cutoffs)
*------------------------------------------------------------------------------* 

* OPTIONAL 
*------------------------------------------------------------------------------* 
* BY - blocking variable(s) (string or factor) | Export(2) to export csv table or plot 
*------------------------------------------------------------------------------* 

do "${programs}/randomize_balance.do"

********************************************************************************
*Example 
********************************************************************************

use "/Users/steffenerickson/Desktop/teach_sim/2021-2022/randomize/Robertson_Randomization_Practice_Data.dta", clear


bysort program: gen cluster_name = mod(_n, 4) //creating clusters for randomization
randomize coaching, by(program) seed(3501) arms(2) 

*Data Managment 
local covariates futeaach futearace futeases ///
	                 fustuach fusturace fustuses ///
					 hsach hsrace hsses hsloc ///
					 hstypeother hstype holangother ///
					 holang faedu moedu partch gender

* Generating variables
foreach cov in `covariates' {
destring `cov', replace
tab `cov', gen(`cov')
}


*Balance Checking Fuction 
local covariates moedu1 gender1 partch1 hstype1 hsses1 hsrace1

balance_check coaching `covariates',b(i.strata) t(balance_table) p("-.1 .1 .8 1.2")  // export(2)







