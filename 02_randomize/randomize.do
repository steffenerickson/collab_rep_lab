*------------------------------------------------------------------------------*  
*RANDOMIZE PROGRAM * 

*Authors: Steffen Erikson, Qing Liu 

*Date: 8/26/22

*Purpose: Program to randomly assign participants into treatment conditions. 
* 		  The program can currently accept categorical blocking variables, 
*         and level of randomization. 


*------------------------------------------------------------------------------*  

*------------------------------------------------------------------------------*  
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

Random assignment: Participant level done 

Blocking factor: Sites done 

Blocking variable: Performance scores (continuous) new function

Number of treatment arms: 2 eh

Label of treatment conditions: "Treatment" "Control" 

Randomization could occur at different intervals, but one randomization interval per site

Time sensitive

*/


*------------------------------------------------------------------------------*  

*------------------------------------------------------------------------------*  
* RANDOMIZE PROGRAM * 

cap program drop randomize
program randomize
version 17.0

* Program Syntax *

syntax namelist(max=1) [if] [in] [, BY(varlist) SEED(real 1) ARMS(real 2) CLUSTER(varlist)]
* REQUIRED  
*------------------------------------------------------------------------------*                 
*treatment variable (namelist = 1) | SEED (real, defult of 1 will break program) |
*------------------------------------------------------------------------------*  

* OPTIONAL 
*------------------------------------------------------------------------------* 
* BY - blocking variable(s) (string or factor) | ARMS - treatment_arms (real, default is 2) 
*------------------------------------------------------------------------------* 
*------------------------------------------------------------------------------* 
* CLUSTER (cluster_var)
*------------------------------------------------------------------------------* 

set trace on 

if `seed' == 1 {
	di "Please set seed number for randomization"
	exit
}
set seed `seed'

if "`cluster'" != "" {
	egen cluster_num=group(`cluster')
}

*If there are blocking variables 
if "`by'" != "" {
	
	egen strata=group(`by')
	tab strata, gen(strata_)
	
	if "`cluster'" != "" {	
	
		bysort strata cluster_num: gen rannum = uniform() 
		bysort strata cluster_num: replace rannum = rannum[1]
		sort strata cluster_num rannum
		by strata: gen `namelist' = mod(cluster_num, `arms')
	
	}
	
	else {
		
		bysort strata: generate rannum = uniform() 
		sort strata rannum
		by strata: gen `namelist' = mod(_n, `arms')
	
	}
}

* If there are no blocking variables 
else {
	
	if "`cluster'" != "" {	
		
		bysort cluster_num: gen rannum = uniform() 
		bysort cluster_num: replace rannum = rannum[1]
		sort cluster_num rannum
		gen `namelist' = mod(cluster_num, `arms')
	
	}
	
	else {
		
		generate rannum = uniform()  
		sort rannum
		gen `namelist' = mod(_n, `arms')
	
	}		
}

*add randomization date
gen randomization_dt = td(`c(current_date)')
format randomization_dt %td

end 

*------------------------------------------------------------------------------*  

*------------------------------------------------------------------------------*  
* EXAMPLE *
/*
use "/Users/steffenerickson/Desktop/teach_sim/2021-2022/randomize/Robertson_Randomization_Practice_Data.dta", clear

bysort program: gen cluster_name = mod(_n, 4)
randomize coaching, by(program) seed(3501) arms(2) cluster(cluster_name)
*/

*------------------------------------------------------------------------------*  

********************
*Check balance Command







