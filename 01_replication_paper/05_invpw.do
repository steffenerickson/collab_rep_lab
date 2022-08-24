********************************************************************************
           
		   
		   
		   
		   
		   
		   *Description  *
********************************************************************************

${data2}
********************************************************************************
           *Data cleaning *
********************************************************************************


cap drop ma_study_num 
gen ma_study_num = 1 if ma_study == "Spring 2018"
replace ma_study_num = 2 if ma_study == "Fall 2018"
replace ma_study_num = 3 if ma_study == "Spring 2019"
replace ma_study_num = 4 if ma_study == "Fall 2019 TAP"
replace ma_study_num = 5 if ma_study == "Spring 2020"
replace ma_study_num = 6 if ma_study == "Fall 2017"
replace ma_study_num = 7 if ma_study == "Fall 2019"

tab ma_study ma_study_num


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


********************************************************************************
       * Create IVPW for each study comparsison and save in a new data file *
********************************************************************************

local ref 3
local j = 1
foreach i in 1 2 4 5 {
	
preserve


	keep if ma_study_num == `i' | ma_study_num == `ref'


	* Generating variable for four groups *
	gen ipw_group_`i'_`ref'=1 if ma_study_num==`i' & ra_coaching==0
	replace ipw_group_`i'_`ref'=2 if ma_study_num==`i' & ra_coaching==1
	replace ipw_group_`i'_`ref'=3 if ma_study_num==`ref' & ra_coaching==0
	replace ipw_group_`i'_`ref'=4 if ma_study_num==`ref' & ra_coaching==1

	* Generating propensity scores using demographic variables, TSES scale, 
	*Teacher Multicultural Attitudes scale and Culturally 
	*Responsive Teaching Self-efficacy scale *

	mlogit female age_21ab race_wh hsloc_3 hsach_3 hsses_2 tses_total ///
	tses_cm tmas_total crtse_total score_dc_avg_bs
 
	* Predicting IPW by group * 
	predict prob_tap_c_`i'_`ref' if ipw_group_`i'_`ref'==1, pr 
	predict prob_tap_t_`i'_`ref' if ipw_group_`i'_`ref'==2, pr 
	predict prob_tc_c_`i'_`ref' if ipw_group_`i'_`ref'==3, pr 
	predict prob_tc_t_`i'_`ref' if ipw_group_`i'_`ref'==4, pr 

   * Calculate weights =  1/probability *
	gen weight_`i'_`ref'=.
	replace weight_`i'_`ref'=1/prob_tap_c_`i'_`ref' if ipw_group_`i'_`ref'==1 
	replace weight_`i'_`ref'=1/prob_tap_t_`i'_`ref' if ipw_group_`i'_`ref'==2
	replace weight_`i'_`ref'=1/prob_tc_c_`i'_`ref' if ipw_group_`i'_`ref'==3
	replace weight_`i'_`ref'=1/prob_tc_t_`i'_`ref' if ipw_group_`i'_`ref'==4

	tempfile data`j'
	save data`j',replace
	restore
	local ++ j

}

********************************************************************************
                            * Append Data *
********************************************************************************

use data1, clear
append using data2 data3 data4 
egen weight = rowtotal(weight_*)
recode weight (0=.)
drop weight_* ipw* prob*

********************************************************************************
            * obtain sample correction summaries*
********************************************************************************



local ref 3
foreach i in 1 2 4 5 {
	
	
	#delimit ;

	teffects ipwra (score_dc_avg_z ) 
	(ra_coaching female age_21ab race_wh hsloc_3 
	hsach_3 hsses_2 tses_total tses_cm tmas_total 
	crtse_total score_dc_avg_bs, logit) 
	if ma_study_num == `i' | ma_study_num == `ref' 
	, 
	aequations ate  ;
	
	#delimit cr

	tebalance summarize
	matrix adj_balance = r(table)
	esttab matrix(adj_balance) using adj_bal_table_`i'_`ref'.csv,replace

}


********************************************************************************
            * Run Regression Model(s) and obtain Adjusted TE estimates  *
********************************************************************************




/*
*Model 2 
local ref 3
foreach i in 1 2 4 5{
	
	#delimit ;
	
	regress score_dc_avg_z i.ra_coaching##ib3.ma_study_num i.id_section 
	ccs_gpa moedu female race_wh score_dc_avg_bs id_interact id_coach
	[pweight=weight] if ma_study_num == `i' | ma_study_num == `ref' ;
	
		#delimit cr


	display "Study `i'"
	lincom ( _b[1.ra_coaching]) + _b[1.ra_coaching#1.ma_study_num]


	display "Study `ref'"
	lincom ( _b[1.ra_coaching]) 

} 
*/ 






