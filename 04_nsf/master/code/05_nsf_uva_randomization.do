*------------------------------------------------------------------------------*  
/*
Title: NSF UVA SITE Randomization 
Authors: Steffen Erikson 
Date: 9/28/22
Purpose: Randomization Participants from the UVA site into coaching
non-coaching conditons
*/ 

*------------------------------------------------------------------------------*
* Merge Files 
*------------------------------------------------------------------------------*

${uva_tracker_data}
drop if ParticipantID == ""
rename EmailAddress recipientemail
merge 1:1 recipientemail using ${clean_data}/baseline_clean.dta
drop if _merge != 3
drop _merge 
rename *, lower

*------------------------------------------------------------------------------*
* Create Dummies to assess balance 
*------------------------------------------------------------------------------*
/*
tab gender, gen(gender_)
rename gender_1 female 

tab race, gen(race_)
rename race_2 white 

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

tempfile data1
save `data1'

*------------------------------------------------------------------------------*
* Randomization
*------------------------------------------------------------------------------*
/*
cd ${root_drive}/${results}
// Rewrote function so this code will not produce the same results 
randomize coaching, arms(2) seed(2348) /*genfile(ParticipantID) */ // Joint F is not rejected - one that we went with!!! 
*/

*getting around not randomizing again 
import delimited ${raw_data}/randomization_20220928.csv, clear
label define treat_condition 0 "Control" 1 "Treatment"
label values coaching treat_condition
gen str3 z = string(participantid,"%03.0f")
drop participantid
rename z participantid
save ${raw_data}/randomization_20220928.dta, replace
merge 1:1 participantid using `data1'
gen date = date(randomization_dt, "DMY")
drop randomization_dt
rename date randomization_dt
format randomization_dt %td 
drop _merge
recode neo* (0 = .)
save ${clean_data}/uva_randomize.dta, replace  

*------------------------------------------------------------------------------*
* Check Balance 
*------------------------------------------------------------------------------*
/*
cd ${root_drive}
do ${programs2}/randomize_balance.do
cd ${root_drive}/${results}


local covariates white parent_teacher college_m graduate_degree_m college_f ///
graduate_degree_f efficacy_overall_score prior_overall_score ///
content_overall_score beliefs_overall_score mteb_overall_score age gpa 

balance_check coaching `covariates' , plot("-.25 .25 .25 1") ///
/* export(nsf_uva_randomize) */ 


*------------------------------------------------------------------------------*
* Gut Check Performance Tasks 
*------------------------------------------------------------------------------*
cd ${root_drive}

rename participantid ParticipantID
merge 1:1 ParticipantID using ${data}/performance_task_gt.dta
rename ParticipantID participantid 
drop _merge 

save ${data}/gut_check_uva.dta, replace 


*------------------------------------------------------------------------------*
* Randomly pick two participants 
*------------------------------------------------------------------------------*
/*
set seed 2348
bysort coaching : gen rannum = uniform() 
sort coaching rannum
by coaching: gen order = _n
keep if order == 1 | order == 2
keep ParticipantID coaching randomization_dt
outsheet using ${results}/sample_2treat_2control.csv


*/ 





