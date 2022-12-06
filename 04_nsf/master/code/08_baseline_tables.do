*------------------------------------------------------------------------------*  
/*
Title: Baseline Tables * 
Authors: Steffen Erikson
Date: 8/26/22
Purpose: Creates various baseline descriptive tables for the NSF study 

*/ 

*------------------------------------------------------------------------------*  


*------------------------------------------------------------------------------*
* Check randomization balance 
*------------------------------------------------------------------------------*

*local randomize_balance_table "no"
if "${randomize_balance_table}" == "yes" {
	
* UVA and UD randomization check 
use ${clean_data}/ud_randomize.dta, clear 
append using ${clean_data}/uva_randomize.dta
capture drop gender_2 female race_1 race_* white edm_* college_m graduate_degree_m edf_* college_f graduate_degree_f 
replace consent = "yes" if consent == ""
replace section = "Thomas" if section == ""
recode strata (. = 1) if site == "UVA"
encode site, gen(site2) 
drop site
rename site2 site 

*Generate dummies 
tab gender, gen(gender_)
rename gender_1 female 
tab race, gen(race_)
rename race_4 white 
tab education_mother, gen(edm_)
rename edm_1 college_m
rename edm_3 graduate_degree_m
tab education_father, gen(edf_)
rename edf_1 college_f
rename edf_3 graduate_degree_f

cd ${root_drive}/${results}

local covariates white parent_teacher college_m graduate_degree_m college_f ///
graduate_degree_f  prior_overall_score ///
content_overall_score beliefs_overall_score mteb_overall_score  gpa ///
neo_neuroticism neo_extraversion neo_openness neo_agreeableness neo_conscientiousness ///
female age  efficacy_instruction efficacy_professionalism efficacy_teach_support ///
efficacy_class_manage efficacy_related_duties efficacy_overall

balance_check coaching `covariates' , blocks(i.strata i.site)  plot("-.25 .25 .25 1") export(nsf_whole_sample_randomize) 
cd ${root_drive}
} 

*------------------------------------------------------------------------------*
*Check balance across sites 
*------------------------------------------------------------------------------*

if "${across_site_balance_table}" == "yes" {

preserve
forvalues x = 1/3 {	
	use ${clean_data}/nsf_full_sample.dta, clear
	tab gender, gen(gender_)
	rename gender_1 female 
	tab race, gen(race_)
	rename race_4 white 
	tab education_mother, gen(edm_)
	rename edm_1 college_m
	rename edm_3 graduate_degree_m
	tab education_father, gen(edf_)
	rename edf_1 college_f
	rename edf_3 graduate_degree_f
	
	if `x' == 1 {
		local school JMU
	}
	if `x' == 2 {
		local school UD
	}
	if `x' == 3 {
		local school UVA
	}
	keep if site == `x' 
	
	#delimit ; 
	local covariates 
	  white parent_teacher college_m graduate_degree_m college_f 
	  graduate_degree_f prior_overall_score
	  content_overall_score beliefs_overall_score mteb_overall_score  gpa 
	  neo_neuroticism neo_extraversion neo_openness neo_agreeableness 
	  neo_conscientiousness female age efficacy_instruction 
	  efficacy_professionalism efficacy_teach_support efficacy_class_manage 
	  efficacy_related_duties;
	#delimit cr 

	collapse (mean) `covariates' , by(coaching)
	xpose, varname clear 
	rename v1 `school'_control
	capture rename v2 `school'_treatment 
	tempfile data`x'
	save `data`x''
	
	if `x' == 1 {
		continue 
	}
	else if `x' == 2 {
		local b = `x' - 1 
		use `data`b'' , clear 
		merge 1:1 _varname using `data`x''	
		drop _merge 
		tempfile data`x'_merged
		save `data`x'_merged'
	}
	else {
		local b = `x' - 1 
		use `data`b'_merged', clear 
		merge 1:1 _varname using `data`x''
		drop _merge
		tempfile data`x'_merged
		save `data`x'_merged'
	}
}

use `data3_merged', clear
drop if _varname == "coaching"
order _varname 
mkmat JMU_control UD_control UD_treatment UVA_control  UVA_treatment, matrix(site_comparisons) rownames(_varname)
esttab matrix(site_comparisons)
esttab matrix(site_comparisons) using ${results}/site_comparisons.csv, replace 
restore 

} 

*------------------------------------------------------------------------------*
*JMU sample - materials/ no materials 
*------------------------------------------------------------------------------*
if "${jmu_materials_table}" == "yes" {
use  ${clean_data}/nsf_full_sample.dta, clear 
tab gender, gen(gender_)
rename gender_1 female 
tab race, gen(race_)
rename race_4 white 
tab education_mother, gen(edm_)
rename edm_1 college_m
rename edm_3 graduate_degree_m
tab education_father, gen(edf_)
rename edf_1 college_f
rename edf_3 graduate_degree_f

preserve // materials 
keep if site == 1
keep if participantid == "022" | participantid == "046" | participantid == "059" | participantid == "005" | participantid == "024" | participantid == "042" | participantid == "044" | participantid == "048" | participantid == "050" | participantid == "051" | participantid == "054" | participantid == "038" | participantid == "002" | participantid == "041" 
#delimit ; 
local covariates 
	  white parent_teacher college_m graduate_degree_m college_f 
	  graduate_degree_f prior_overall_score
	  content_overall_score beliefs_overall_score mteb_overall_score  gpa 
	  neo_neuroticism neo_extraversion neo_openness neo_agreeableness 
	  neo_conscientiousness female age efficacy_instruction 
	  efficacy_professionalism efficacy_teach_support efficacy_class_manage 
	  efficacy_related_duties efficacy_overall;
#delimit cr 
collapse (mean) `covariates' 
xpose, varname clear 
rename v1 pre_task_complete 
tempfile pre_task
save `pre_task'
restore 

preserve //no materials 
keep if site == 1
#delimit ;
local covariates 
	  white parent_teacher college_m graduate_degree_m college_f 
	  graduate_degree_f prior_overall_score
	  content_overall_score beliefs_overall_score mteb_overall_score  gpa 
	  neo_neuroticism neo_extraversion neo_openness neo_agreeableness 
	  neo_conscientiousness female age efficacy_instruction 
	  efficacy_professionalism efficacy_teach_support efficacy_class_manage 
	  efficacy_related_duties efficacy_overall;
#delimit cr 
collapse (mean) `covariates' 
xpose, varname clear 
rename v1 full_sample
merge 1:1 _varname using `pre_task'
mkmat full_sample pre_task, matrix(jmu_comparisons) rownames(_varname)
esttab matrix(jmu_comparisons) 
esttab matrix(jmu_comparisons) using ${clean_data}/jmu_comparisons.csv, replace 
restore 

}

*------------------------------------------------------------------------------*
*Low and High Efficacy Scores 
*------------------------------------------------------------------------------*

if "${classroom_efficacy_table}" == "yes" {
use  ${clean_data}/nsf_full_sample.dta, clear 

#delimit ; 
local list efficacy_1_1 efficacy_1_2 efficacy_1_3 efficacy_1_4 efficacy_1_5
efficacy_2_1 efficacy_2_2 efficacy_2_3 efficacy_2_4 efficacy_2_5 efficacy_3_1
efficacy_3_2 efficacy_3_3 efficacy_4_1 efficacy_4_2 efficacy_4_3 efficacy_5_1
efficacy_5_2 efficacy_5_3;
#delimit cr 

preserve 
encode section, gen(section_2)
drop section 
rename section_2 section 
forvalues x = 1/8 {	
	local i = 1 
	foreach var of varlist `list' {
		sum `var' if section == `x'
		scalar mu  = r(mean)
	
		matrix row`i' = mu
		matrix rownames row`i' = "`:word `i' of `list''"
		if `i' == 1 { 
			matrix M_`x' = row`i'
		}
		else {  
			matrix M_`x' = M_`x'\row`i'
		}
		local ++ i 
	}
	if `x' == 1 { 
		matrix M_full = M_`x'
	}
	else {  
		matrix M_full = M_full, M_`x'
	} 
	local r = rowsof(M_full) 
	local c = colsof(M_full) 
	forvalues x = 1/`r' {
		forvalues j = 1/`c' {  	
	      matrix M_full[`x', `j'] = round(M_full[`x', `j'],.01) 
		}
	}
}

matrix section_level = M_full
#delimit ; 
matrix colnames section_level = "JMU A Sawyer" 
								"JMU D Sawyer S5"
								"JMU D Sawyer S6"
								"UD Gibbons"
								"JMU Imbrescia AM"
								"JMU Imbrescia PM"
								"UD Sisofo"
								"UVA Thomas" ;
 #delimit cr
restore 

esttab matrix(section_level) 
esttab matrix(section_level) using ${results}/section_level_efficacy.csv, replace 

preserve
forvalues x = 1/3 {
	local i = 1 
	foreach var of varlist `list' {
		sum `var' if site == `x'
		scalar mu  = r(mean)
	
		matrix row`i' = mu
		matrix rownames row`i' = "`:word `i' of `list''"
		if `i' == 1 { 
			matrix M_`x' = row`i'
		}
		else {  
			matrix M_`x' = M_`x'\row`i'
		}
		local ++ i 
	}
	if `x' == 1 { 
		matrix M_full = M_`x'
	}
	else {  
		matrix M_full = M_full, M_`x'
	} 
	local r = rowsof(M_full) 
	local c = colsof(M_full) 
	forvalues x = 1/`r' {
		forvalues j = 1/`c' {  	
	      matrix M_full[`x', `j'] = round(M_full[`x', `j'],.01) 
		}
	}
}
matrix site_level = M_full
#delimit ; 
matrix colnames site_level =    "JMU"
								"UD"
								"UVA";
#delimit cr
restore 

esttab matrix(site_level)
esttab matrix(site_level) using ${results}/site_level_efficacy.csv, replace 
} 

