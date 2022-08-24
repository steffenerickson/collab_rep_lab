* SPECIFICATIONS * 
/*

I. Function capabilities

Level of randomization: student, teachers (classrooms), schools
Blocking factors:
Blocking variable: (continuous/categorical)
Number of treatment arms:
Label of treatment conditions:
Create output as a .csv file
R / STATA
Check for balance on key covariates
 

Circumstances

** Uneven participants within blocks

** Waves of randomization -- rolling admission, block randomization

 
II. NSF Project

Random assignment: Participant level

Blocking factor: Sites

Blocking variable: Performance scores (continuous)

Number of treatment arms: 2

Label of treatment conditions: "Treatment" "Control"

Randomization could occur at different intervals, but one randomization interval per site

Time sensitive

*/


global programs "file_path_here"

********************************************************************************
*------------------------------------------------------------------------------*  
*Randomize Function
*------------------------------------------------------------------------------*  


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
*------------------------------------------------------------------------------*  
*balance checking 
*------------------------------------------------------------------------------*  
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
*------------------------------------------------------------------------------* 
*Example 
*------------------------------------------------------------------------------* 

use "/Users/steffenerickson/Desktop/collab_rep_lab/2021-2022/randomize/Robertson_Randomization_Practice_Data.dta", clear

randomize coaching, by(program) seed(3501) arms(2) //randomize function 


*Data Managment - get rid of or necessary evil? 
local covariates futeaach futearace futeases ///
	                 fustuach fusturace fustuses ///
					 hsach hsrace hsses hsloc ///
					 hstypeother hstype holangother ///
					 holang faedu moedu partch	

* Generating variables
foreach cov in `covariates' {
destring `cov', replace
tab `cov', gen(`cov')
}


*Balance Checking Fuction 
local covariates "faedu1 faedu2 faedu3 faedu4 faedu5 moedu1 moedu2 moedu3 moedu4 moedu5"
local blocks 

ttest_cov_unwt coaching `covariates',b(`blocks') t(balance_table) p(".1 .1 .1 .1")







