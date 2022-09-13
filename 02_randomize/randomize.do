*------------------------------------------------------------------------------*  
*RANDOMIZE PROGRAM * 

*Authors: Steffen Erikson, Qing Liu 

*Date: 8/26/22

*Purpose: Program to randomly assign participants into treatment conditions. 
* 		  The program can currently accept categorical blocking variables, 
*         and level of randomization. 

*------------------------------------------------------------------------------*  
* RANDOMIZE PROGRAM * 
*------------------------------------------------------------------------------*  
cap program drop randomize
program randomize , rclass 
version 17.0

* Program Syntax *

syntax namelist(max=1) [if] [in] [, BY(varlist) SEED(real 1) ARMS(real 2) CLUSTER(varlist) GENFILE(varlist)]

* REQUIRED                
* 	namelist(max=1)  - treatment variable program will generate  
* 	seed (real, default of 1 will break program) - seed for randomization
* OPTIONAL 
* 	by (varlist) - blocking variable(s) 
* 	arms (real, default is 2) - treatment_arms 
* 	cluster (cluster_var) - will assign treatment conditions to whole cluster
*	genfile(unique participant id)	-creates .csv with randomization information 
*------------------------------------------------------------------------------*  
quietly {

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

drop rannum
gen randomization_dt = td(`c(current_date)')
format randomization_dt %td

if "`by'" != "" {
	global table1 table strata `namelist'
}
else {
	global table1 table `namelist'
}

if "`genfile'" ! = "" {
	
	#delimit ;
	local logdate : di %tdCYND daily("$S_DATE", "DMY");
	
	outsheet `genfile' 
			 `by' 
			 `cluster' 
			 `namelist' 
			 strata*
			 randomization_dt
			 using "randomization_`logdate'.csv" 
			 ,comma replace;
	#delimit cr
}

}

display c(current_date)
$table1

end 

*------------------------------------------------------------------------------*  






