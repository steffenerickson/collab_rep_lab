*------------------------------------------------------------------------------*  
*RANDOMIZE PROGRAM * 

*Authors: 

*Date: 

*Purpose: 


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

Random assignment: Participant level

Blocking factor: Sites

Blocking variable: Performance scores (continuous)

Number of treatment arms: 2

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

syntax namelist(max=1) [if] [in] [, BY(string) SEED(real 1) ARMS(real 1)]

* REQUIRED  
*------------------------------------------------------------------------------*                 
*treatment variable (namelist = 1) | SEED (real, defult of 1 will break program) |
*------------------------------------------------------------------------------*  

* OPTIONAL 
*------------------------------------------------------------------------------* 
* BY - blocking variable(s) (string or factor) | ARMS - treatment_arms (real, default is 2) 
*------------------------------------------------------------------------------* 
set trace on 

*Require seed number so replication is possible 

if `seed' == 1 {
	di "Please set seed number for randomization"
	exit
}

set seed `seed'

*Default is two treatment arms 
if "`1'" == "" {
	local 1 = 2 
}

*If there are blocking variables 
if "`by'" != "" {
	*Encode BY if BY are string variables (to create indicator variables) 
	*This step may or may not be necessary
	foreach v of varlist `by' {   
			capture confirm numeric variable `v'
				if _rc {
                       encode `v', gen(`v'_2)
					   drop `v'
					   rename `v'_2 `v'		   
                }
	}
	bysort `by': generate rannum = uniform()  
	sort `by' rannum
	tab `by', gen(strata_)
	by `by': gen `namelist' = mod(_n, `arms')
}

* If there are no blocking variables 
else {
	generate rannum = uniform()  
	sort rannum
	gen `namelist' = mod(_n, `arms')
}


end 

*------------------------------------------------------------------------------*  

*------------------------------------------------------------------------------*  
* EXAMPLE *

use "/Users/steffenerickson/Desktop/teach_sim/2021-2022/randomize/Robertson_Randomization_Practice_Data.dta", clear

randomize coaching, by(program) seed(3501) arms(2)

*------------------------------------------------------------------------------*  

********************
*Check balance Command







