*------------------------------------------------------------------------------*  
*RANDOMIZE PROGRAM * 

*Authors: Steffen Erikson, Qing Liu 

*Date: 8/26/22

*Purpose: Program to randomly assign participants into treatment conditions. 
* 		  The program can currently accept categorical blocking variables, 
*         level of randomization, and can limit the number of treatment
*		  conditions that are assigned


*------------------------------------------------------------------------------*  
* RANDOMIZE PROGRAM * 
*------------------------------------------------------------------------------*  
cap program drop randomize
program randomize , rclass 
version 17.0

* Program Syntax *

syntax namelist(max=1) [if] [, ID(varlist) BY(varlist) SEED(real 1) ARMS(real 2) CLUSTER(varlist) LIMIT(real 1) GENFILE(varlist) ]

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
*	limit(real, default is 1) - Can specify max number of treatment allocations for 
*	each treatment condition 

* IF - 

*------------------------------------------------------------------------------*  
set trace on 

// Controls 

if `seed' == 1 {
	di "Please set seed number for randomization"
	exit
}
if "`id'" == "" {
	di "Please specify an ID Variable"
	exit
}
if "`cluster'" != "" & `limit' !=1 {
	di " cluster() and  limit() options can't be used together"
	exit 
}
if "`cluster'" != "" {
	egen cluster_num=group(`cluster') 
}
if "`by'" != ""{	
	egen strata = group(`by') 
}


*----------------------*
set seed `seed'
*----------------------*

*------------------------------------------------------------------------------*
* Limit option - Keeps participants needed to assign limit(n) of arms(n) 
* treatments in each block or in the sample. Cannot be used with cluster option
* right now 
*------------------------------------------------------------------------------*

if `limit' !=1 {	
	if `arms' == 2 {
		local b = `limit' // b = number of treatments assigned to sample
	}					 // or each block 
	else {
		local b = (`arms' * `limit' ) - `limit' // if arms is bigger than 2 - multiply the limit by the number of treatment arms and because observations less than b will be equally split between
	}						// the # of arms - subtract the limit to get an equal number of treatments in each arm 
	if "`by'" != ""{		// limiting treatments within blocks 
		sort `by' `id'
		bysort `by': gen rannum = runiform() 
		sort  `by' rannum	// random sorting 
		bysort `by' : gen index = _n
		if "`if'" != "" {
			keep `if'	// subset data to only include observations in the [if statement]
		}
		preserve
			keep if index > `b'  // create dataset to assign control condtions 
			gen `namelist' `if' = 0
			drop rannum index 
			tempfile data
			save `data'
		restore 
		keep if index <= `b' // create dataset to assign treatment(s) condtions 
		drop rannum index
	}
	else { 			// limiting treatments within entire sample 
		sort `id'
		gen rannum = runiform() 
		sort  rannum		// random sorting 
		if "`if'" != "" {
			keep `if'  // subset data to only include observations in the [if statement]
			gen index = _n
		}
		else {
			gen index = _n
		}
		preserve	
			keep if index > `b'   // create dataset to assign control condtions 
			gen `namelist' `if' = 0 
			drop rannum index
			tempfile data
			save `data'		
		restore 
		keep if index <= `b'   // create dataset to assign treatment(s) condtions 
		drop rannum index
	}
	if `arms' == 2 {
		gen `namelist' `if' = 1 // if only two arms (treatment and control) assign everyone in the treatment datafile treatment 1 
	}
}
*------------------------------------------------------------------------------*
* If limit() is specified and arms() == 2 -> Assign the participants that
* were not dropped to the treatment condition. n in limit(n) will be 
* assigned treatment and the rest will be asssigned control 
*------------------------------------------------------------------------------*

if `limit' != 1 & `arms' == 2 {	
		append using `data', force	// if limit is specified and arms = 2, the next step can be skipped
}
*------------------------------------------------------------------------------*
* This routine is used if (1) limit is not specified and or arms > 2 and (2)
* limit is not specified
*------------------------------------------------------------------------------*
else {
	if "`by'" != "" {         	// blocks specified
		if "`cluster'" != "" {	// blocks and clusters specified
			sort strata cluster_num `id'
			bysort strata cluster_num: gen rannum = runiform() 
			bysort strata cluster_num: replace rannum = rannum[1]
			sort strata cluster_num rannum
			qui tab strata
			local n = r(r)
			forvalues i = 1/`n' {
				egen x_`i' = cut(rannum) if strata == `i' , ///
				group(`arms') icodes
			}
			egen `namelist' = rowmax(x_1-x_`n')
			drop x_*
		}
		else {  				// only blocks specified
			sort strata `id'
			bysort strata: generate rannum = runiform() 
			sort strata rannum
			qui tab strata
			local n = r(r)
			if `limit' == 1 { 	// blocks without limit specified
				forvalues i = 1/`n' {
					egen x_`i' = cut(rannum) if strata == `i' , ///
					group(`arms') icodes
				}
				egen `namelist' = rowmax(x_1-x_`n')
				drop x_*
			}
			else {				// blocks with limit specified
				local y = `arms' - 1
				forvalues i = 1/`n' {
					egen x_`i' = cut(rannum) if strata == `i' , ///
					group(`y') icodes
				}
				egen `namelist' = rowmax(x_1-x_`n') `if'
				gen `namelist'_2 = `namelist' + 1 
				drop `namelist'
				rename `namelist'_2 `namelist'
				drop x_*
			}
		}
	}
	else {						// blocks not specified
		if "`cluster'" != "" {	// clusters specified
			sort cluster_num `id'
			bysort cluster_num: gen rannum = runiform() 
			bysort cluster_num: replace rannum = rannum[1]
			sort rannum
			egen `namelist' = cut(rannum) `if', group(`arms') icodes
		}
		else {					// neither blocks nor clusters specified
			sort `id'			
			generate rannum = runiform()  
			sort rannum
			if `limit' == 1 {	// limit not specified
				egen `namelist' = cut(rannum) `if', group(`arms') icodes
			}
			else {				// limit specified
				local y = `arms' - 1
				egen `namelist' = cut(rannum) `if', group(`y') icodes 
				gen `namelist'_2 = `namelist' + 1 
				drop `namelist'
				rename `namelist'_2 `namelist'
			}
		}		
	}
}

*------------------------------------------------------------------------------*
* Appending data back together 
*------------------------------------------------------------------------------*

if `limit' !=1 & `arms' != 2 { 
	append using `data', force // append the treatment and control observations back together 
}

cap drop rannum
gen randomization_dt `if' = td(`c(current_date)') // Add randomization date 
format randomization_dt %td

if "`by'" != "" {  // create results table 
	global table1 table  `namelist' strata
}
else {
	global table1 table `namelist'
}
if "`genfile'" != "" { // generate csv file if genfile() option is selected
	local logdate : di %tdCYND daily("$S_DATE", "DMY")
	if "`by'" != "" {
		local strata strata* 	
	}
	#delimit ;
	outsheet  `id' `genfile' `by' `cluster' `namelist' `strata' randomization_dt
			  using "randomization_`logdate'.csv" `if'
			  ,
			  comma replace;
	#delimit cr
}
display c(current_date) //display date and table 
$table1

end 

*------------------------------------------------------------------------------*  


