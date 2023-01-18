//----------------------------------------------------------------------------//
//			Box Drive globals 									  			  //
//----------------------------------------------------------------------------//
global data_drive 
global root_drive 


//----------------------------------------------------------------------------//
//			Data Prep														  //
//----------------------------------------------------------------------------//

// Baseline descriptive file 
use "${data_drive}/HTE_Outcomes_CPP_Final_Jan2021.dta", clear 
capture drop _merge 

cap drop ma_study_num 
gen ma_study_num = 1 if ma_study == "Spring 2018"
replace ma_study_num = 2 if ma_study == "Fall 2018"
replace ma_study_num = 3 if ma_study == "Spring 2019"
replace ma_study_num = 4 if ma_study == "Fall 2019 TAP"
replace ma_study_num = 5 if ma_study == "Spring 2020"
replace ma_study_num = 6 if ma_study == "Fall 2017"
replace ma_study_num = 7 if ma_study == "Fall 2019"

tab ma_study ma_study_num

keep if ma_study_num == 1 | ma_study_num == 2 | ma_study_num == 3 | ///
ma_study_num == 4 | ma_study_num == 5 

gen female=1 if gender==2 
replace female=0 if gender==1
gen race_wh=1 if race==5
replace race_wh=0 if race!=5 & race!=.
tab hsloc, gen(hsloc_)
tab hsach, gen(hsach_)
tab hsses, gen(hsses_)
tab ma_study_num age
gen age_21ab=1 if age>=2
replace age_21ab=0 if age<2


// merge with final analytic file 
merge 1:1 ma_study_num email using "${data_drive}/Replication_Final_Analytic.dta"
keep if _merge == 3

cd $root_drive
//----------------------------------------------------------------------------//
//			Missing Data Imputation Programs 								  //
//----------------------------------------------------------------------------//

//--------------------------//
//Check Binary Subroutine 
//--------------------------//


cap program drop check_binary 
program check_binary, rclass

	syntax varlist(max = 1)
	
	su `varlist', mean
	if (`varlist' == r(min) | `varlist' == r(max) | `varlist' >= . ) & r(min) != r(max) {
		scalar b = 1
	}
	else {
		scalar b = 0
	}
	
	return scalar binary = b

end 

//--------------------------//
//Imputation 
//--------------------------//

// Imputes mean for missing covariates. Creates a dummy variable to indicate 
// that the observation has an imputed value for the variable. If the block
// option is used, the imputed mean is the block mean 
// If the variable is dichotomous, 0 is imputed 

cap program drop impute_mean
program impute_mean, nclass 

	syntax varlist(max=1) [if] [,BLOCK(varlist) TREATMENT(varlist) CONDITION(real 0)]
	
	if "`treatment'" != "" {
		if "`block'" != "" {
			local if_in_condition & `treatment' == `condition'
		}
		else {
			local if_in_condition if `treatment' == `condition'
		}
	}
	
	if "`block'" != "" {
		capture confirm string `block'
		qui levelsof `block' , local(levels)
		local i = 1
		foreach l of local levels {
			gen `varlist'_im_`i' = (`varlist' == .)
			if !_rc {
				check_binary `varlist'
				if r(binary) == 1 {
					local mu = 0
				}
				else {
					qui sum `varlist' if `block' == `"`l'"' `if_in_condition' 
					local mu = r(mean)
				}
				replace `varlist' = `mu' if `varlist' == . & `block' == `"`l'"'
			}
			else {
				check_binary `varlist'
				if r(binary) == 1 {
					local mu = 0
				}
				else {
					qui sum `varlist' if `block' == `l' `if_in_condition' 
					local mu = r(mean)
				}
				replace `varlist' = `mu' if `varlist' == . & `block' == `l'
			}
			local++i
		}
		egen `varlist'_im = rowmax(`varlist'_im_*) 
		drop `varlist'_im_*
	}
	else {
		gen `varlist'_im = (`varlist' == .)
		check_binary `varlist'
		if r(binary) == 1 {
			local mu = 0
		}
		else {
			qui sum `varlist' 
			local mu = r(mean) `if_in_condition' 
		}
		replace `varlist' = `mu' if `varlist' == . 
	}

end 



//----------------------------------------------------------------------------//
//			Check Missing outcomes											  //
//----------------------------------------------------------------------------//

//------------------------
// Check for missing outcomes 
//------------------------

gen missing_outcome1 = (score_dc_avg_z == .) 
levelsof ma_study_num, local(levels)
foreach l of local levels {
	di "Study `l'"
	tab missing_outcome1 if ma_study_num == `l'
}

gen missing_outcome2 = (score_dc_avg == .) 
levelsof ma_study_num, local(levels)
foreach l of local levels {
	di "Study `l'"
	tab missing_outcome2 if ma_study_num == `l'
}

//------------------------
// Remaking Z scores 
//------------------------

// Note : Uses control group mean STDev to calcuate Z-scores

capture drop score_dc_avg_z
capture drop beh_rating_z 

foreach var of varlist score_dc_avg beh_rating {
	levelsof ma_study_num, local(levels)
	foreach l of local levels {
		if `l' == 1 {
			local command gen 
		}
		else {
			local command replace 
		}
		sum `var' if ma_study_num == `l'
		scalar mu = r(mean)
		sum `var' if ra_coaching == 0 & ma_study_num == `l'
		scalar c_sd = r(sd)
		`command' `var'_z = (`var'-mu)/c_sd if ma_study_num == `l'
	}
}

gen missing_outcome3 = (score_dc_avg == .) 
levelsof ma_study_num, local(levels)
foreach l of local levels {
	di "Study `l'"
	tab missing_outcome3 if ma_study_num == `l'
}

drop missing_outcome* 

//----------------------------------------------------------------------------//
//    				 		            //
//			Missing Data Step			//
// 										//
//  Impute control means for missing covariates 
//  Impute 0 for binary variables 
//  Include dummy indicator for observations with a missing value 
//----------------------------------------------------------------------------//

//-------------------//
// Covariates used   //
//-------------------//

// All 
global covariates ///
female age_21ab race_wh hsloc_3 hsach_3 hsses_2 tses_total ///
tmas_total crtse_total tses_se tses_is tses_cm ccs_gpa ///
neo_n neo_e neo_o neo_a neo_c score_dc_avg_bs beh_rating_bs

// Continuous 
global covariates_cont ///
tses_total tmas_total crtse_total tses_se tses_is tses_cm ccs_gpa ///
neo_n neo_e neo_o neo_a neo_c score_dc_avg_bs beh_rating_bs

//-------------------//
// Impute 
//-------------------//
// Impute control group means or 0 for dichotomous in missing values //
// Also creates one dummy variable called imputed if obs. has an imputed 
// value for any variable 

foreach var of global covariates {
	impute_mean `var', block(ma_study_num) treatment(ra_coaching) condition(0)
}
egen imputed = rowmax(*_im)

// little extra work for beh_rating_bs
sum beh_rating_bs
local mu = r(mean)
recode beh_rating_bs (. = `mu')

//-------------------//
//		 Verify 	 //
//-------------------//
browse ra_coaching ma_study ma_study_num imputed tses_total if tses_total_im == 1 
sort ma_study_num

browse ra_coaching ma_study ma_study_num imputed female if female_im == 1 
sort ma_study_num

// Imputed means against control group means for study 3 
sum tses_total if tses_total_im == 1 & ma_study_num == 3 // Imputed 
sum tses_total if ra_coaching == 0 & ma_study_num == 3 // Control group

//----------------------------------------------------------------------------//
// Center Variables at control group mean 
//----------------------------------------------------------------------------//

levelsof ma_study_num, local(levels)
foreach var of global covariates_cont {
	local i = 1 
	foreach l of local levels {
		if `i' == 1 {
			qui sum `var' if ma_study_num == `l' & ra_coaching == 0 
			local mu = r(mean)
			gen `var'_c = `var' - `mu' if ma_study_num == `l' 
		}
		else {
			qui sum `var' if ma_study_num == `l' & ra_coaching == 0 
			local mu = r(mean)
			replace `var'_c = `var' - `mu' if ma_study_num == `l' 
		}
		local++i 
	}
}

save covariates_imputed_centered.dta, replace 

//------------------//
//Verify looping 
//------------------//

qui sum tses_total if ma_study_num == 1 & ra_coaching == 0 
local mu = r(mean)
gen tses_total_c2 = tses_total - `mu' if ma_study_num == 1 
gen tses_total_c3 = tses_total_c2 - tses_total_c

browse tses_total_c tses_total_c2 tses_total_c3 if ma_study_num == 1 
drop tses_total_c2 tses_total_c3

//------------------//
//Verify that imputed values foreach study are 0 
//rounding error causing values to be really small decimals
//------------------//

tab tses_total_c ma_study_num if tses_total_im == 1
tab female ma_study_num if female_im == 1
