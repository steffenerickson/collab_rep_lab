*------------------------------------------------------------------------------*  
/*
Title: NSF UD SITE Randomization 
Authors: Steffen Erikson 
Date: 9/28/22
Purpose: Randomization Participants from the UD site into coaching non-coaching 
conditons

*/ 
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Merge Files 
*------------------------------------------------------------------------------*

${ud_tracker_data}
drop if ParticipantID == ""
rename EmailAddress recipientemail
merge 1:1 recipientemail using ${clean_data}/baseline_clean.dta
drop if _merge != 3
drop _merge 
rename *, lower

*------------------------------------------------------------------------------*
** Validation checks & data management **
*------------------------------------------------------------------------------*

*Removing non-consenters for randomization 
tab consent 
list participantid recipientemail consent if consent == "No"
drop if consent == "No"
 
tab participantid  // check frequency matches above

*------------------------------------------------------------------------------*
* Create Dummies to assess balance 
*------------------------------------------------------------------------------*
/*
tab gender, gen(gender_)
rename gender_1 female 

tab race, gen(race_)
rename race_4 white 

label define yesno 0 "no" 1 "yes"
tab parent_teacher 
recode parent_teacher (2 3 = 1) (4 = 0)
label values parent_teacher yesno  

tab education_mother, gen(edm_)
rename edm_1 college_m
rename edm_3 graduate_degree_m

tab education_father, gen(edf_)
rename edf_1 college_f
rename edf_3 graduate_degree_f

*/

*------------------------------------------------------------------------------*
* Randomization
*------------------------------------------------------------------------------*

// Rewrote function so this code will not produce the same results 
// randomize coaching, id(participantid) arms(2) seed(0982) by(section) //genfile(firstname lastname site recipientemail)  
//


preserve
import delimited ${raw_data}/randomization_20221010.csv, clear
gen coaching2 = 1 if coaching =="Treatment"
replace coaching2 = 0 if coaching == "Control"
drop coaching 
rename coaching2 coaching
gen str3 z = string(participantid,"%03.0f")
drop participantid
rename z participantid
gen date = date(randomization_dt, "DMY")
drop randomization_dt
rename date randomization_dt
format randomization_dt %td 
label define treat_condition 0 "Control" 1 "Treatment"
label values coaching treat_condition
drop if participantid == ""
keep coaching participantid randomization_dt strata 
tempfile data_backup
save `data_backup'

restore 

merge 1:1 participantid using `data_backup'
drop _merge

cap drop if participantid == "030"
save ${clean_data}/ud_randomize.dta, replace  

* Cut participant 030 out - appending back on and assigning to the treatment
preserve 
${ud_tracker_data}
drop if ParticipantID == ""
rename EmailAddress recipientemail
merge 1:1 recipientemail using ${clean_data}/baseline_clean.dta
drop if _merge !=1
drop if Consent != "Yes"
drop _merge 
rename *, lower 
tempfile data_missing_person
save `data_missing_person'
restore 
append using `data_missing_person'
recode coaching (. = 0) if participantid == "030"
recode strata (. = 2) if participantid == "030"
egen dupes = tag(participantid)
drop if dupes != 1
drop dupes 
save ${clean_data}/ud_randomize.dta, replace  

*------------------------------------------------------------------------------*
* Check Balance 
*------------------------------------------------------------------------------*
/*
cd ${root_drive}
do ${programs2}/randomize_balance.do
cd ${root_drive}/${results}


local covariates white parent_teacher college_m graduate_degree_m college_f ///
graduate_degree_f efficacy_overall_score prior_overall_score ///
content_overall_score beliefs_overall_score mteb_overall_score  gpa ///
neo_neuroticism neo_extraversion neo_openness neo_agreeableness neo_conscientiousness

balance_check coaching `covariates' , blocks(i.strata)  plot("-.25 .25 .25 1") // export(nsf_ud_randomize) 

*off on variance ratios 
histogram  neo_agreeableness, by(coaching)

*off on effect size differences
histogram neo_openness, by(coaching)
histogram  efficacy_overall_score, by(coaching)


*------------------------------------------------------------------------------*
* Gut Check Performance Tasks 
*------------------------------------------------------------------------------*
cd ${root_drive}
use ${data}/ud_randomize.dta, clear

merge 1:1 participantid using ${data}/performance_task_gt_ud.dta
list participantid recipientemail if _merge == 2
list participantid recipientemail if _merge == 1
drop if _merge != 3
drop _merge 


preserve 
	gen num = 1 
	collapse (count) num, by(coaching rs_self_instruct)
	reshape wide num, i(coaching) j(rs_self_instruct)
	order coaching num2 num1 
	egen total = rowtotal(num*)
	mkmat num* total ,matrix(rs_self_instruct)
	
	#delimit ; 
	matrix rownames rs_self_instruct =  "Control"
								    "Treatment";
	matrix colnames rs_self_instruct = "Off-Target"
										"Approaching"
										"Total" ;
	#delimit cr
restore 
esttab matrix(rs_self_instruct)
esttab matrix(rs_self_instruct) using ${results}/self_instruction.csv, replace


preserve 
	gen num = 1 
	collapse (count) num, by(coaching rs_unpack_wp)
	reshape wide num, i(coaching) j(rs_unpack_wp)
	order coaching num2 num1 num3
	egen total = rowtotal(num*)
	mkmat num* total ,matrix(rs_unpack_wp)
	
		#delimit ; 
	matrix rownames rs_unpack_wp =  "Control"
								    "Treatment";
	matrix colnames rs_unpack_wp = "Off-Target"
									"Approaching"
									"On Target"
									"Total" ;
	
		#delimit cr
restore 
esttab matrix(rs_unpack_wp)
esttab matrix(rs_unpack_wp) using ${results}/unpack_word_problem.csv, replace

save ${data}/gut_check_ud.dta, replace 
*------------------------------------------------------------------------------*
* Randomly pick two participants 
*------------------------------------------------------------------------------*
/*
set seed 2348
sort strata coaching participantid 
bysort strata coaching : gen rannum = uniform() 
sort strata coaching rannum
bysort  strata coaching: gen order = _n

preserve 
keep if strata == 2
keep if order == 1 | order == 2 | order == 3 
keep participantid coaching randomization_dt firstname lastname site recipientemail section 
tempfile data1
save `data1'
restore 

preserve 
keep if strata == 1
keep if order == 1 | order == 2 
keep participantid coaching randomization_dt firstname lastname site recipientemail section 
tempfile data2
save `data2'
restore 


use `data2' , clear 
append using `data1'

outsheet using ${results}/sample_5treat_5control_ud.csv

*/






