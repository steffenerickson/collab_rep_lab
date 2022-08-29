*------------------------------------------------------------------------------*  
*COVARIATE T-TEST and Balance Table * 

*Authors: Steffen Erikson, Qing Liu 

*Date: 8/27/22

*Purpose: Program to check balance after randomization. 


*------------------------------------------------------------------------------*  

*------------------------------------------------------------------------------*  
* SPECIFICATIONS * 
/* 

	The program currently produces a balance table and/or an 
	effect size/variance plot
	We still need to add joint F-test 

*/ 
*------------------------------------------------------------------------------*  

*------------------------------------------------------------------------------*  

cap prog drop balance_check
set more off
program balance_check, rclass


syntax varlist(min = 2) [if] [in][, Blocks(varlist fv) Table(string) Plot(numlist) Export(real 1)]
marksample touse

* REQUIRED  
*------------------------------------------------------------------------------*                 
* varlist (1st position is treatment variable, 2..n are covariates)
*------------------------------------------------------------------------------*  
*------------------------------------------------------------------------------*                 
*table or plot or both 
*table("table name") to create balance table
*plot("std_es_lowerbound std_es_upperbound variance_lowerbound variance_upperbound")
*------------------------------------------------------------------------------* 

* OPTIONAL 
*------------------------------------------------------------------------------* 
* BY - blocking variable(s) (string or factor) | Export(2) to export csv table or plot 
*------------------------------------------------------------------------------* 



tokenize `varlist'
local n : word count `varlist'	
local i = 1 
forvalues v = 2/`n' {
	
	regress `:word `v' of `varlist'' `1' `blocks'	

	matrix M = r(table)
	local u = colsof(M)
	scalar control = M[1,`u']
	scalar diff = M[1,1]
	scalar se_diff = M[2,1]
	scalar p_diff = M[4,1]
	
	matrix row`i' = (control, diff, se_diff, p_diff)
	matrix rownames row`i' = "`:word `v' of `varlist''"
	
	if `i' == 1 { 
		matrix Balance1 = row`i'
	}
	else {  
		matrix Balance1= Balance1\row`i'
	}
	
	local++i 
	
	} 

	matrix colnames Balance1 = "Control" "Treatment Difference" "SE" "P-value"
	
local i = 1 
forvalues v = 2/`n' {
	
	tabstat `:word `v' of `varlist'', stat(mean var) by(`1') save
		
	matrix coachingstats1 = r(Stat2)
	scalar tr_mean = coachingstats1[1,1]
	scalar tr_var = coachingstats1[2,1] 
	
	matrix coachingstats= r(Stat1)
	scalar co_mean = coachingstats[1,1]
	scalar co_var =coachingstats[2,1] 

	reg `:word `v' of `varlist'' `1' `blocks'
	
	scalar diff1 = _b[`1'] 
	scalar coach_es =(tr_mean-co_mean)/sqrt(co_var) //standardized es
	scalar coach_var =(tr_var/co_var) //ratio of the variances 
	scalar tr_sd=sqrt(tr_var)
	scalar co_sd=sqrt(co_var)
			
							
	matrix row`i' = (coach_es,coach_var,tr_sd,co_sd)
	matrix rownames row`i' = "`:word `v' of `varlist''"
	
	if `i' == 1 { 
		matrix Balance2 = row`i'
	}
	else {  
		matrix Balance2 = Balance2\row`i'
	}

	local++i
}
	
	matrix colnames Balance2 = "std_es" "variance" "tr_sd" "co_sd"
	
	matrix Balance3 = (Balance1,Balance2)
	
	local r = rowsof(Balance3) 
	local c = colsof(Balance3) 
		
	forvalues x = 1/`r' {
		forvalues j = 1/`c' {  	
	      matrix Balance3[`x', `j'] = round(Balance3[`x', `j'],.00001) 
			
			}
		}


	
	#delimit ; 
	matrix colnames Balance3 = "Control" 
							   "Treatment Difference" 
							   "SE" 
							   "P-value"
							   "STD Effect Size"
							   "Variance Ratio (Tr/Co)"
							   "Treatment SE"
							   "Control SE";
	#delimit cr

if "`table'" != "" {
	esttab matrix(Balance3) 
}
	

if "`plot'" != "" {			
	
	preserve
	
	local rownames: rowfullnames Balance2 // This block of code coverts the 
	local c : word count `rownames'       // matrix, Balance2, into a stata
	clear                                 // dataset 
	svmat Balance2, names(col)
	
	gen variable = ""
	forvalues i = 1/`c' { 
		replace variable = "`:word `i' of `rownames''" in `i'
	}
	
	encode variable, gen(nvariable)
	tempfile data1
	
	tokenize `plot'
	
	#delimit ; 
	graph twoway 
	(scatter variance std_es if std_es <= `2'  & std_es >= `1' & variance >`3' 
	& variance <`4', 
	mcolor(green) msymbol(circle_hollow) mlabel(nvariable) 
	mlabs(tiny) mlabposition(12)) 

	(scatter variance std_es if (std_es < `1' | std_es > `2') | 
	(variance <`4' | variance > `3'), 
	mcolor(red) msymbol(circle_hollow) mlabel(nvariable) 
	mlabs(tiny) mlabposition(12)) , 

	xline(`2', lpattern(dot) lwidth(vthin)) 
	xline(`1', lpattern(dot) lwidth(vthin)) 
	yline(`3', lpattern(dot) lwidth(vthin)) 
	yline(`4', lpattern(dot) lwidth(vthin)) 
	legend(off) xtitle(Effect Size Difference) ytitle(Variance Ratio) 
	title(RCT Balance Plot);	
	#delimit cr 


	restore 
	
}
	
if `export' == 2  {
	
	if "`table'" != "" {
		esttab matrix(Balance3) using `table'.csv,replace
	}
	if "`plot'" != "" {	
		graph export balance_plot.pdf
	}
	else {
		di "Neither table or plot option specified"
	}
	
}

		
return list 

end




	