*------------------------------------------------------------------------------*  
*RANDOMIZE PROGRAM * 

*Authors: Steffen Erikson, Qing Liu 

*Date: 8/26/22

*Purpose: Program to randomly assign participants into treatment conditions. 
* 		  The program can currently accept categorical blocking variables, 
*         level of randomization, and can limit the number of treatment
*		  conditions that are assigned

*To Do:  The new code works if the the limit is less than half of the sample
*		 A better way to complete this task is to change the proportion that 
*		 is assigned to each condtion. Right now we are changing the number of 
* 		 treatment and control condtions which seems less flexible 

*------------------------------------------------------------------------------*  
* RANDOMIZE PROGRAM * 
*------------------------------------------------------------------------------*  
cap program drop randomize
program randomize , rclass 
version 17.0

* Program Syntax *

syntax namelist(max=1) [if] [in] [, ID(varlist) BY(varlist) SEED(real 1) ARMS(real 2) CLUSTER(varlist) GENFILE(varlist) LIMIT(real 1) LCONDITION(real 1)]

* REQUIRED                
* 	namelist(max=1)  - treatment variable program will generate  
* 	seed (real, default of 1 will break program) - seed for randomization
*  	id(max =1) - unique identifier for an observation
* OPTIONAL 
* 	by (varlist) - blocking variable(s) 
* 	arms (real, default is 2) - treatment_arms 
* 	cluster (cluster_var) - will assign treatment conditions to whole cluster
*	genfile(varlist) -creates .csv with variables included in varlist 
*   namelist, id, by, and cluster are kept by default
*	limit(real, default is 1) -Can specify max number of tretment allocations
* 	lcondtion - conditon that you are restricting. 1 is default and will limit
*	the number of treatment conditions assigned. 0 will limit the number of
*   control conditions assigned. 
*------------------------------------------------------------------------------*  


if `seed' == 1 {
	di "Please set seed number for randomization"
	exit
}

if "`id'" == "" {
	di "Please specify an ID Variable"
	exit
}

*------------------------------------------------------------------------------*
*New code - should be written as a subrountine 
if `limit' !=1 {	
	
	if `lcondition' == 1 {
		scalar l = 0
	}
	if `lcondition' == 0 {
		scalar l = 1
	}
	
	if "`by'" != ""{
		local a : word count `by'
		tokenize `by'
		forvalues  y = 1/`a' {
			preserve
				bysort `by' : gen counter = 1 if _n == 1
				replace counter = sum(counter)
				scalar factor_level_`y' = counter[_N]
				di factor_level_`y'
			restore	
		}
		forvalues y = 1/`a' {	
			if `y' == 1 {
				scalar factor_combinations = factor_level_`y'
			}
			else {
				scalar factor_combinations = factor_combinations * factor_level_`y'
			}
		}
		
		
		scalar b = (2 * `limit') / factor_combinations
		if mod(b,1) > 0 {
			scalar b = floor(b)
			di b
		}

		if b < factor_combinations {
			di "At least 1 observation per block needs to be assigned to the treatment condition"
			exit
		}

		local b b 
		preserve
			bysort `by': gen rannum = uniform() 
			sort  `by' rannum
			bysort `by' : gen index = _n
			drop if index <= `b'
			egen strata=group(`by')
			tab strata, gen(strata_)
			gen `namelist' = l 
			drop rannum index
			tempfile data2
			save `data2'
		restore 
		preserve
			bysort `by': gen rannum = uniform() 
			sort  `by' rannum
			bysort `by' : gen index = _n
			keep if index <= `b'
			drop rannum index
			tempfile data1
			save `data1'
		restore 
	}
	else {
		preserve
			local b = 2 * `limit'
			gen rannum = uniform() 
			sort  rannum
			drop  in 1/`b'
			gen `namelist' = l 
			drop rannum 
			tempfile data2
			save `data2'		
		restore 
		preserve
			local b = 2 * `limit'
			gen rannum = uniform() 
			sort  rannum
			keep in 1/`b'
			drop rannum 
			tempfile data1
			save `data1'
		restore 
	}
	use `data1' , clear 
}


*------------------------------------------------------------------------------*
if "`cluster'" != "" {
	egen cluster_num=group(`cluster')
}

if "`by'" != "" {
	set seed `seed'
	egen strata=group(`by')
	tab strata, gen(strata_)
	if "`cluster'" != "" {	
		sort strata cluster_num `id'
		bysort strata cluster_num: gen rannum = runiform() 
		bysort strata cluster_num: replace rannum = rannum[1]
		sort strata cluster_num rannum
		by strata: gen `namelist' = mod(cluster_num, `arms')
	}
	else {
		sort strata `id'
		bysort strata: generate rannum = runiform() 
		sort strata rannum
		by strata: gen `namelist' = mod(_n, `arms')
	}
}
else {
	if "`cluster'" != "" {	
		sort cluster_num `id'
		bysort cluster_num: gen rannum = runiform() 
		bysort cluster_num: replace rannum = rannum[1]
		sort cluster_num rannum
		gen `namelist' = mod(cluster_num, `arms')
	}
	else {
		sort `id'
		generate rannum = runiform()  
		sort rannum
		gen `namelist' = mod(_n, `arms')
	}		
}


if `limit' !=1 { 
	append using `data2', force
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

if "`genfile'" != "" {
	local logdate : di %tdCYND daily("$S_DATE", "DMY")
	if "`by'" != "" {
		local strata strata* 	
	}
	#delimit ;
	outsheet  `id' `genfile' `by' `cluster' `namelist' `strata' randomization_dt
			  using "randomization_`logdate'.csv" 
			  ,
			  comma replace;
	#delimit cr
}
display c(current_date)
$table1

end 

*------------------------------------------------------------------------------*  






