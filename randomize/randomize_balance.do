*********************************************
** COVARIATE T-TEST and Balance Table *******
*********************************************
cap prog drop ttest_cov_unwt
set more off
program ttest_cov_unwt, rclass


*Treatment(varlist max=1) Covariates(varlist)

syntax varlist(min = 2) [if] [in][, Blocks(varlist) Table(string) Plot(numlist) Export(real 1)]
marksample touse

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



*Need to check if variable is categorical and then create indicator varibales 

preserve


	
	
if "`table'" != "" {
	
*local varlist "faedu1 faedu2 faedu3 faedu4 faedu5 moedu1 moedu2 moedu3 moedu4 moedu5"
*local blocks "strata2 strata3"


local n : word count `varlist'	
local i = 1 

forvalues v = 2/`n' {
	regress `:word `v' of `varlist'' `:word 1 of `varlist'' `blocks'	

	matrix M = r(table)
	
	local u = colsof(M)
	scalar control = M[1,`u']
	scalar diff = M[1,1]
	scalar se_diff = M[2,1]
	scalar p_diff = M[4,1]
	
	matrix row`i' = (control, diff, se_diff, p_diff)
	matrix rownames row`i' = "`:word `v' of `varlist''"
	
		if `i' == 1 { 
		matrix balance = row`i'
	}
	else {  
		matrix balance = balance\row`i'
	}
		local r = rowsof(balance) 
		local c = colsof(balance) 
		
		forvalues x = 1/`r' {
			forvalues j = 1/`c' {  
				
				matrix balance[`x', `j'] = round(balance[`x', `j'],.001) 
			}
		}
	
	local++i 
	
	} 

	matrix colnames balance = "Control" "Treatment Difference" "SE" "P-value"
	
	
	esttab matrix(balance) 
	esttab matrix(balance) using `table'.csv,replace

}
	
if "`plot'" != "" {		

local n : word count `varlist'	
local i = 1 
	
forvalues v = 2/`n' {
	tabstat `:word `v' of `varlist'', stat(mean var) by(`:word 1 of `varlist'') save
	return list
		
		matrix coachingstats1 = r(Stat2)
		scalar `:word `v' of `varlist''_tr_mean1 = coachingstats1[1,1]
			scalar `:word `v' of `varlist''_tr_var1 = coachingstats1[2,1] 
			
		matrix coachingstats= r(Stat1)
		scalar `:word `v' of `varlist''_co_mean = coachingstats[1,1]
			scalar `:word `v' of `varlist''_co_var =coachingstats[2,1] 

		reg `:word `v' of `varlist'' `:word 1 of `varlist'' `blocks'
			scalar diff1 = _b[`:word 1 of `varlist''] 


		scalar `:word `v' of `varlist''_coach_es1 =(`:word `v' of `varlist''_tr_mean1-`:word `v' of `varlist''_co_mean)/sqrt(`:word `v' of `varlist''_co_var)
		scalar `:word `v' of `varlist''_coach_var1 =(`:word `v' of `varlist''_tr_var1/`:word `v' of `varlist''_co_var)
		scalar `:word `v' of `varlist''_tr_sd1=sqrt(`:word `v' of `varlist''_tr_var1)
		scalar `:word `v' of `varlist''_co_sd=sqrt(`:word `v' of `varlist''_co_var)
			
							
	matrix row`i' = (`:word `v' of `varlist''_coach_es1,`:word `v' of `varlist''_coach_var1, `:word `v' of `varlist''_tr_sd1, `:word `v' of `varlist''_co_sd)
	matrix rownames row`i' = "`:word `v' of `varlist''"
	
	if `i' == 1 { 
		matrix M = row`i'
	}
	else {  
		matrix M = M\row`i'
	}

	local++i
}


	local r = rowsof(M) 
	local c = colsof(M) 
		
	forvalues x = 1/`r' {
		forvalues j = 1/`c' {  	
	      matrix M[`x', `j'] = round(M[`x', `j'],.00001) 
			
			}
		}


		*add confidence intervals? 
		
		
	matrix colnames M = "es" "variance" "tr_sd" "co_sd"
	
	local rownames: rowfullnames M
	local c : word count `rownames'
	
	
	clear 
	svmat M, names(col)
	
	gen variable = ""
	forvalues i = 1/`c' { 
		replace variable = "`:word `i' of `rownames''" in `i'
		
	}
	encode variable, gen(nvariable)
	
	tempfile data1

}
	
	*Create plot 

tokenize `plot'

#delimit ; 
	
graph twoway 
(scatter variance es if es <= `2'  & es >= -`1' & variance >`3' & variance <`4', 
mcolor(green) msymbol(circle_hollow) mlabel(nvariable) 
mlabs(tiny) mlabposition(12)) 

(scatter variance es if (es < -`1' | es > `2') | (variance <`4' | variance > `3'), 
mcolor(red) msymbol(circle_hollow) mlabel(nvariable) 
mlabs(tiny) mlabposition(12)) , 

xline(`2', lpattern(dot) lwidth(vthin)) 
xline(-`1', lpattern(dot) lwidth(vthin)) 
yline(`3', lpattern(dot) lwidth(vthin)) 
yline(`4', lpattern(dot) lwidth(vthin)) 
legend(off) xtitle(Effect Size Difference) ytitle(Variance Ratio) 
title(RCT Balance Plot);

	
#delimit cr 
	

	
restore 

esttab matrix(balance) 


if `export' == 2  {
	
	esttab matrix(balance) using `table'.csv,replace
	*export graph
	
}

		
return list 

end

	