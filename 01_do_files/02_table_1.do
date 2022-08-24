********************************************************************************
		* Table 1 - Baseline descriptives across replication studies *
********************************************************************************
cd "${results}"

quietly {

*commands defined earlier 
${data}	
${exclude}

local i = 1 
local n : word count $demo
foreach cov of varlist $demo {
	
	
	regress `cov' ib3.ma_study_num `cov'_miss i.block_encoded, cluster(email)
	
	
	matrix M = r(table)
	
	scalar s18 = M[1,14] + M[1,1]
	scalar f18 = M[1,14] + M[1,2]
	scalar s19 = M[1,14] + M[1,3]
	scalar f19tap = M[1,14] + M[1,4]
	scalar s20 = M[1,14] + M[1,5]
	
	matrix row`i' = (s18,f18,s19,f19tap,s20)
	
	 
	if `i' == 1 { // * if loop 1, create a matrix called balance 
		matrix balance = row`i'
	}
	else {  // If loop 2..n,  append new row vector to matrix balance 
		matrix balance = balance\row`i'
	}
		local r = rowsof(balance) //count rows 
		local c = colsof(balance) //count columns 
		
		forvalues x = 1/`r' {
			forvalues j = 1/`c' {  // casewise manipulation of scalars 
				
				matrix balance[`x', `j'] = round(balance[`x', `j'],.01) //rounding
			}
		}
	
	local++i // local i becomes i+1
	
}
		*commands defined earlier
		$table1colnames
	    $table1rownames

	    *names are indexed. Rows [1..n, ] . Columns [, 1..n]
	
	
	
}
	*export 
	if k == 1 {
		esttab matrix(balance) 
		esttab matrix(balance) using ${table1}.csv,replace
	}
	if k != 1 {
		esttab matrix(balance) 
	}
		
	