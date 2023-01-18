//----------------------------------------------------------------------------//              
						  ** Table 3  **					
				   *Correspondence Test Tables *							
//----------------------------------------------------------------------------//
capture program drop table3 
program define table3, nclass 
	args tau1 se1 tau2 se2 alpha e_th 

// --------------------------- //
// 		Un-adjusted
// --------------------------- //

// correspondence and results 
correspondence `tau1' `se1' `alpha' `e_th' 3
mat effect = r(E)
mat diff = r(D)
mat	equiv = r(EQ)
mat	corres = r(C)

// Treatment effects 
mat compare = (effect[1..2,1...]\effect[4..5,1...])
foreach i in 1 2 4 5  {
	mat c`i'	= (effect[3,1...]\effect[`i',1...])
	mat rowname c`i' = "`i'_vs_3" "`i'_vs_3" 
	if `i' == 1 {
		mat base_te = c`i'
	} 
	else {
		mat base_te = base_te\c`i'
	}	
}

mat base_te  = (base_te[1...,1..2],base_te[1...,6])
mat colnames base_te = "te" "se" "sig"
local rownames: rowfullnames base_te 
local c : word count `rownames'
clear 
svmat base_te  , names(col)
gen studies = ""
forvalues i = 1/`c' { 
	replace studies = "`:word `i' of `rownames''" in `i'
}
sort studies 
by studies: gen index = _n
tempfile base_te
save `base_te'
list

// Correspondence Test
mat base = (diff[1...,1],diff[1...,3],corres[1...,1])
mat rownames base =  "1_vs_3" "2_vs_3" "4_vs_3" "5_vs_3" 
mat base = (base\base)
mat li base 
mat colnames base = "difference" "p_value" "correspondence"
local rownames: rowfullnames base
local c : word count `rownames'
clear 
svmat base , names(col)
gen studies = ""
forvalues i = 1/`c' { 
	replace studies = "`:word `i' of `rownames''" in `i'
	
}
sort studies 
by studies: gen index = _n
tempfile base_corr
save `base_corr'
use `base_te',clear 
merge 1:1 studies index using `base_corr'
gen type = "base"
drop _merge 
tempfile base_full
save `base_full'
use `base_full', clear 
list

// --------------------------- //
// 		Adjusted 
// --------------------------- //


// Correspondence and results 
correspondence `tau2' `se2' `alpha' `e_th' 3
mat effect = r(E)
mat diff = r(D)
mat	equiv = r(EQ)
mat	corres = r(C)

// Treatment Effects 
mat adj_effect = (effect[1..2,1...]\effect[4..5,1...])
foreach i in 1 2 4 5  {
	mat c`i'	= (effect[3,1...]\effect[`i',1...])
	mat rowname c`i' = "`i'_vs_3" "`i'_vs_3" 
	if `i' == 1 {
		mat base_te = c`i'
	} 
	else {
		mat base_te = base_te\c`i'
	}	
}

mat adjust_te  = (base_te[1...,1..2],base_te[1...,6])
mat colnames adjust_te = "te" "se" "sig"
local rownames: rowfullnames base_te 
local c : word count `rownames'
clear 
svmat adjust_te  , names(col)
gen studies = ""
forvalues i = 1/`c' { 
	replace studies = "`:word `i' of `rownames''" in `i'
}
sort studies 
by studies: gen index = _n
tempfile adjust_te
save `adjust_te'

// Correspondence Test
mat adjust = (diff[1...,1],diff[1...,3],corres[1...,1])
mat rownames adjust =  "1_vs_3" "2_vs_3" "4_vs_3" "5_vs_3" 
mat adjust = (adjust\adjust)
mat colnames adjust = "difference" "p_value" "correspondence"
local rownames: rowfullnames adjust
local c : word count `rownames'
clear 
svmat adjust , names(col)
gen studies = ""
forvalues i = 1/`c' { 
	replace studies = "`:word `i' of `rownames''" in `i'
	
}
sort studies 
by studies: gen index = _n
tempfile adjust_corr
save `adjust_corr'
use `adjust_te',clear 
merge 1:1 studies index using `adjust_corr'
gen type = "adjust"
drop _merge 
tempfile adjust_full
save `adjust_full'
use `adjust_full', clear 
list

use `base_full' , clear
append using `adjust_full'

// --------------------------- //
// 	* Final Data cleaning *
// --------------------------- //

cap drop study_num
gen study_num = substr(studies,1,1) if index == 2
replace study_num = substr(studies,6,1) if index == 1
destring study_num, replace
label define corr_test 1 "Trivial Difference " 2 "Difference" 3 "Equivalence " 4 "Indeterminacy"
label values correspondence corr_test 
encode type, gen(type_2)
recode type_2 (2 = 0)
drop type
rename type_2 type 
label define method 0 "Un-adjusted" 1 "Adjusted"
label values type method
encode studies, gen(source_of_variation)
encode studies, gen(study_comparison)
label define pairwise 1 "Study 1 vs Study 3" 2 "Study 2 vs Study 3" 3 "Study 4 vs Study 3" 4 "Study 5 vs Study 3" 
label values study_comparison pairwise
label define study_type 1 "Timing of Study" 2 "Teaching Task" 3 "Participant characteristics and concurrent coursework" 4 "Delivery"
label values source_of_variation study_type
sort studies type index
drop index studies 
rename study_num study 
order type study_comparison source_of_variation study 
list 

end 


  
