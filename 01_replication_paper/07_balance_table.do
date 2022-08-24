********************************************************************************
					**Baseline Balance Tables** 
********************************************************************************

quietly {
matrix drop _all 
estimates drop _all	

cd "${results}"

* Generating indicator variables for whether participant is in full sample or 
* analytic sample
bysort id: gen n_count= _N
gen full_sample=1 
gen analytic_sample=1 if n_count==3 
replace analytic_sample=0 if analytic_sample==.

/* 



Not totally sure how these results were presented


 - used the regress `d' coach_cond_combined i.block_encoded if time==0 to create 
 my tables 
 
 
* Locals for Dependent Variable
local outcomes_performance "score_dc_avg"  
local cov "ccs_gpa"

local samples "full_sample analytic_sample"
        foreach x of local samples {
			
* displaying means and SDS of control group (self-reflection) 
* examining differences across control group and coaching group at baseline for demographics
foreach o of varlist `cov' {
	sum `o' if time==0 & coach_cond_combined==0
	regress `o' coach_cond_combined i.block_encoded if time==0
	estat esize
	} 

* displaying means and SDS of control group (self-reflection) 
* examining differences across control group and coaching group at baseline for performance outcomes
foreach d of varlist `outcomes_performance' {
	sum `d' if time==0 & coach_cond_combined==0
	regress `d' coach_cond_combined i.block_encoded if time==0
	estat esize
	}
	}
*/


*full Sample 
local i = 1 
foreach cov of varlist $demo2 {
	regress `cov' coach_cond_combined i.block_encoded if time==0 
	
	matrix M = r(table)
	
	scalar diff = M[1,1]
	scalar se_diff = M[2,1]
	local u = colsof(M)
	scalar control = M[1,`u']
	scalar se_con = M[2,`u']
	matrix row`i' = (control, diff \ ., se_diff)
	
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
	

*Analytic Sample 
local i = 1 
foreach cov of varlist $demo2 {
	
	#delimit ;
	regress `cov' coach_cond_combined i.block_encoded 
	if time == 0 & analytic_sample == 1; 
	#delimit cr
	
	matrix M = r(table)
	
	scalar diff = M[1,1]
	scalar se_diff = M[2,1]
	local u = colsof(M)
	scalar control = M[1,`u']
	scalar se_con = M[2,`u']
	matrix row`i' = (control,diff \ ., se_diff)
	
		if `i' == 1 { 
		matrix balance2 = row`i'
	}
	else {  
		matrix balance2 = balance2\row`i'
	}
		local r = rowsof(balance2) 
		local c = colsof(balance2) 
		
		forvalues x = 1/`r' {
			forvalues j = 1/`c' {  
				
				matrix balance2[`x', `j'] = round(balance2[`x', `j'],.001) 
			}
		}
	
	local++i 
	
	} 
	

*combine 
matrix balance_full = (balance,balance2)

${balancecolnames}
${balancerownames}

}
	if k == 1 {
		esttab matrix(balance_full) 
		esttab matrix(balance_full) using ${balance}.csv,replace
	}
	if k != 1 {
		esttab matrix(balance_full) 
	}



		