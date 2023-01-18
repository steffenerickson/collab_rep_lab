//----------------------------------------------------------------------------//
		* Table 1 - Baseline descriptives across replication studies *
//----------------------------------------------------------------------------//

global data_drive 
global root_drive

use "${data_drive}/Replication_Final_Analytic.dta" , clear 
keep if ma_study_num == 1 | ma_study_num == 2 | ma_study_num == 3 | ///
ma_study_num == 4 | ma_study_num == 5 


local covariates ccs_gpa partch_either moedu_colab faedu_colab ///
gender_female age_21ab race_white hsloc_1 hsloc_2 hsloc_3 ///
hsses_1 hsses_2 hsses_3 hsrace_1 hsrace_2 hsrace_3 hsach_1 ///
hsach_2 hsach_3 


matrix balance = J(19,5,.)
local i = 1 
foreach cov of local covariates {

	regress `cov' ib3.ma_study_num `cov'_miss i.block_encoded, cluster(email)
	
	matrix M = r(table)
	scalar s18 = M[1,14] + M[1,1]
	scalar f18 = M[1,14] + M[1,2]
	scalar s19 = M[1,14] + M[1,3]
	scalar f19tap = M[1,14] + M[1,4]
	scalar s20 = M[1,14] + M[1,5]
	matrix row`i' = (s18,f18,s19,f19tap,s20)
	
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
			matrix balance[`x', `j'] = round(balance[`x', `j'],.01) 
		}
	}
	local++i 
	
}

#delimit ;
matrix colnames balance = "Spring 2018" 
						  "Fall 2018" 
						  "Spring 2019" 
						  "Fall 2019 Tap" 
						  "Spring 2020" ;

							
matrix rownames balance = "GPA"  
						  "% Either parent a teacher" 
						  "% Mother education"
						  "% Father education"
						  "% Female"
						  "% Over the age of 21"
						  "% White"
						  "% Rural"
						  "% Suburban"
						  "% Urban"
						  "% Low SES"
						  "% Middle SES"
						  "% High SES"
						  "% Primarily students of color"
						  "% Mixed"
						  "% Primarily white students"
						  "% Primarily low achieving"
						  "% Primarily middle"
						  "% Primarily high achieving" ;
#delimit cr

	esttab matrix(balance) 


		
	