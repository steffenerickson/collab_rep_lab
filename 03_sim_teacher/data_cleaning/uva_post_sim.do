*------------------------------------------------------------------------------*
* STEP (1)
*Name: TeachSim Baseline and Exit Post SIM Data Cleaning 
*File(s) cleaned: 2021-2022 TeachSIM Baseline Post-Simulation Survey
*			      2021-2022 TeachSIM Exit Post-Simulation Survey	 
*Date: 6/23/22
*Person: Steffen Erickson 
*------------------------------------------------------------------------------*


/* 
    -----------------------
	INSTRUCTIONS - READ ME! 
	-----------------------
	
	
	STEP (1) - Rename this do file and describe the file(s) you are cleaning  
	
	STEP (2) - Specify your directories and assign import commands to globals 

	STEP (3) - Rename the variables that you want to keep. Adjust 
	the keep command to keep only the variables that you renamed. Qualtrics variables 
	may change in name/order so adjust accordingly 
	
	STEP (4) - Cleaning and Creating Composite Variables
	
	STEP (5) - Label Variables 
	
	STEP (5) - Check descriptive tables
	

	
*/

*------------------------------------------------------------------------------*
* STEP (2)  Specify your directories and program set up 
*------------------------------------------------------------------------------*

clear all 
cap log close 

global root_drive "/Users/steffenerickson/Desktop/teach_sim/2021-2022/survey"
global raw "raw_data"
global clean "clean_data"
global results "results"

*Log file and change directory 
log using ${results}/uva_sim_survey.smcl, replace 
cd ${root_drive}


*Raw Data File - Write full import command and assign to global
global uva_base import excel using ///
"${raw}/2021-2022 TeachSIM Baseline Post-Simulation Survey_March 8, 2022_07.58 2.xlsx", ///
sheet("in") firstrow case(lower)  clear 

global uva_exit import excel using ///
"${raw}/2021-2022 TeachSIM Exit Post-Simulation Survey_June 20, 2022_11.02.xlsx", ///
sheet("in") firstrow case(lower) clear 
	
foreach x in 1 2  {
	
	
	if `x' == 1 {
		$uva_base // Imports file 
		local name = "UVA_Baseline_Post-Survey_clean.dta"
		local time = 0
		local g = 3
		local y = 4
		local b = 5
		local c = 5
		local d = 6
		local e = 7
		local f = 8
	}	
	if `x' == 2 {
		$uva_exit // Imports file 
		local name = "UVA_Exit_Post-Survey_clean.dta"
		local time = 1
		local g = 4
		local y = 5
		local b = 6
		local c = 4
		local d = 5
		local e = 6
		local f = 7
	}	

drop in 1/2	

*------------------------------------------------------------------------------*
* STEP (3)  Rename Variables  
*------------------------------------------------------------------------------*

rename progress           progress 
rename finished           finished
rename recipientfirstname firstname 
rename recipientlastname  lastname
rename recipientemail     email 
rename q1`y'_1        	  sim_rate_cmsk
rename q1`b'          	  sim_txt_cmsk
rename	q17				  sim_txt_eth_behavior
rename	q18				  sim_txt_eth_contribute
rename	q19_1			  beh_fidgeting
rename	q19_2			  beh_humming
rename	q19_3			  beh_excitable
rename	q19_4			  beh_inattentive
rename	q19_5			  beh_short_attention
rename	q19_6			  beh_quarrelsome
rename	q19_7			  beh_acts_smart
rename	q19_8			  beh_unpredictable
rename	q19_9			  beh_defiant
rename	q19_10			  beh_uncooperative
rename	q19_11			  beh_easily_frustrated
rename	q19_12			  beh_disturbs_others
rename	q19_13			  beh_restless
rename	q19_14			  beh_mood_changes
rename	q20_1			  app_coach_stu
rename	q21_1			  app_adjust_expect
rename	q22_1			  app_guidance_couns
rename	q23_1			  app_rec_sped
rename	q24_1			  app_discp_refer
rename	q25_1			  app_confer_stu
rename	q26_1			  app_confer_parent
rename	q27_1			  app_behavior_plan
rename	q28_1			  app_challenge_work
rename	q29_1			  app_spend_time
rename	q30_1			  app_space_regroup
rename	q31_1			  app_beh_manage_coach
rename	q32_1			  app_beh_manage_teach
rename	q33				  sim_txt_supports
rename	q3`c'_1			  sim_nervous
rename	q3`c'_2			  sim_beneficial
rename	q3`c'_3			  sim_worried_perform
rename	q3`c'_4			  sim_useful_tool
rename	q3`c'_5			  sim_relevant_studies
rename	q3`c'_6			  sim_relevant_prof
rename	q3`c'_7			  sim_like_use_again
rename	q3`c'_8			  sim_recommend
rename	q3`c'_9			  sim_sufficient_prep
rename	q3`c'_10		  sim_enough_time
rename	q3`d'			  sim_txt_beneficial
rename	q3`e'			  sim_txt_improve_exp
rename	q3`f'			  sim_txt_concerns
rename q`g'_1       	  base_post_fb_fu
rename q`g'_2       	  base_post_fb_directext
rename q`g'_3       	  base_post_fb_positive
rename q`g'_4       	  base_post_fb_grow
rename q`g'_5       	  base_post_fb_misunderstood
rename q`g'_6       	  base_post_fb_loops
rename q`g'_7       	  base_post_fb_txevidence
rename q`g'_8       	  base_post_fb_literacy
rename q`g'_9       	  base_post_fb_ptthink
rename q`g'_10      	  base_post_fb_didthink
rename q`y'         	  base_post_fb_notinclude
rename q`b'         	  base_post_fb_wtinclude           


*Keeping only the needed variables 

#delimit ; 
keep progress finished firstname lastname email 
	 sim_rate_cmsk sim_txt_cmsk sim_txt_eth_behavior 
     sim_txt_eth_contribute beh_fidgeting beh_humming beh_excitable 
	 beh_inattentive beh_short_attention beh_quarrelsome beh_acts_smart 
	 beh_unpredictable beh_defiant beh_uncooperative beh_easily_frustrated 
	 beh_disturbs_others beh_restless beh_mood_changes app_coach_stu 
	 app_adjust_expect app_guidance_couns app_rec_sped app_discp_refer 
	 app_confer_stu app_confer_parent app_behavior_plan app_challenge_work 
	 app_spend_time app_space_regroup app_beh_manage_coach app_beh_manage_teach 
	 sim_txt_supports sim_nervous sim_beneficial sim_worried_perform 
	 sim_useful_tool sim_relevant_studies sim_relevant_prof sim_like_use_again 
	 sim_recommend sim_sufficient_prep sim_enough_time sim_txt_beneficial 
	 sim_txt_improve_exp sim_txt_concerns base_post_fb_fu base_post_fb_directext 
	 base_post_fb_positive base_post_fb_grow base_post_fb_misunderstood 
	 base_post_fb_loops base_post_fb_txevidence base_post_fb_literacy 
	 base_post_fb_ptthink base_post_fb_didthink base_post_fb_notinclude 
	 base_post_fb_wtinclude;           
#delimit cr


*------------------------------------------------------------------------------*
* STEP (4)  Cleaning and Creating Composite Variables 
*------------------------------------------------------------------------------*

*----------------*
*Cleaning Emails
*----------------*

drop if email==""
replace email=lower(email)
replace email=strtrim(email)

destring progress, replace
gsort email -progress
quietly by email :  gen dup = cond(_N==1,0,_n)
drop if dup >1
drop progress dup

*Generate Composite Scores 

*----------------*
* manage_scale *
*----------------*

#delimit ; 
local varlist app_coach_stu app_adjust_expect app_guidance_couns 
app_rec_sped app_discp_refer app_confer_stu app_confer_parent 
app_behavior_plan app_challenge_work app_spend_time app_space_regroup 
app_beh_manage_coach app_beh_manage_teach;
#delimit cr	

foreach var of varlist `varlist'  {
	replace `var' = subinstr(`var', " ", "", .)
	destring `var', replace 
	} 
	
foreach var of varlist `varlist' { 	
	generate `var'_rc = `var'  
	recode `var'_rc (1=10) (2=9) (3=8) (4=7) (5=6) (6=5) (7=4) (8=3) (9=2) (10=1) 
	}	
	
*Creating scales for positive and negative management approaches
#delimit ;
egen manage_app_negative = rowmean(app_coach_stu app_adjust_expect 
app_guidance_couns app_rec_sped app_discp_refer); 

egen manage_app_positive = rowmean(app_confer_stu app_confer_parent 
app_behavior_plan app_challenge_work app_spend_time app_space_regroup 
app_beh_manage_coach app_beh_manage_teach);

egen manage_app_punitive=rowmean(app_discp_refer app_rec_sped);
#delimit cr

*----------------------*
* iowa_connors_scale * 
*----------------------*

foreach var of varlist beh* {
	replace `var' = subinstr(`var', " ", "", .)
	destring `var', replace 
} 

#delimit; 
*beh_rating_opdefiant;
egen beh_rating_opdefiant= rowmean(beh_quarrelsome beh_acts_smart 
beh_unpredictable beh_defiant beh_uncooperative); 

label var beh_rating_opdefiant "Iowa Connors Operational Defiant"; 

*impulsive;
egen beh_rating_impulsive=rowmean(beh_fidgeting beh_humming 
beh_excitable beh_inattentive beh_short_attention) ;

label var beh_rating_impulsive "Iowa Connors Impulsive"; 

*overall; 
egen beh_rating=rowmean(beh_quarrelsome beh_acts_smart 
beh_unpredictable beh_defiant beh_uncooperative beh_fidgeting 
beh_humming beh_excitable beh_inattentive beh_short_attention 
beh_easily_frustrated beh_disturbs_others beh_restless beh_mood_changes);  

label var beh_rating "Iowa Connors Overall"; 
#delimit cr 

*--------------------------------------------*
*Generate time variable for appending surveys
*--------------------------------------------*
	
gen time = `time'
	
*------------------------------------------------------------------------------*
* Step (5)  Label Variables
*------------------------------------------------------------------------------*
	

*------------------------------------------------------------------------------*
* Step (6)  Descriptive Statistics 
*------------------------------------------------------------------------------*



di "*--------------------------------------------------------------------------*"
di "data file : `name'"
di "*--------------------------------------------------------------------------*"

sum manage_app_negative manage_app_positive manage_app_punitive ///
beh_rating_opdefiant beh_rating_impulsive beh_rating


di "*--------------------------------------------------------------------------*"

save "${clean}/`name'", replace



}



log close
log translate ${results}/uva_sim_survey.smcl ${results}/uva_sim_survey.txt, replace


