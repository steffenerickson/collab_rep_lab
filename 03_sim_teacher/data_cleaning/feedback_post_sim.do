*------------------------------------------------------------------------------*
* STEP (1)
*Name: Post SIM Feedback Data Cleaning
*File(s) cleaned: 2021-2022 Feedback Surveys for UVA and RGV/SMU
*Date: 7/06/22
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
log using ${results}/feedback.smcl, replace 
cd ${root_drive}


*Raw Data File - Write full import command and assign to global
global fe_uva_post import excel using ///
"${raw}/UVa Family Engagement Post-Simulation Survey.xlsx", ///
sheet("in") firstrow case(lower)  clear

global fe_rgv_smu_post import excel using ///
"${raw}/RGV SMU Family Engagement Post-Simulation Survey.xlsx", ///
sheet("in") firstrow case(lower)  clear 


foreach i in 1 2  {
	
	if `i' == 1 {
		local name = "UVA_FE_Post-Survey_clean.dta"
		local time = 2
		$fe_uva_post
	}
	if `i' == 2 {
		local name = "RGV_SMU_FE_Post-Survey_clean.dta"
		local time = 2
		$fe_rgv_smu_post

	}	
	
drop in 1/2

*------------------------------------------------------------------------------*
* STEP (3)  Rename Variables  
*------------------------------------------------------------------------------*
	
rename recipientemail	 email
rename progress          progress 
rename finished          finished
rename q1_firstclick	 firstclick
rename q1_lastclick	     lastclick
rename q1_pagesubmit	 pagesubmit
rename q1_clickcount	 clickcount
rename q3	             num_sim_completed_today
rename q4_1	             me_pre_coach
rename q4_2	             me_post_coach
rename q9_1	             rate_pre_coach
rename q9_2	             rate_post_coach
rename q10_1	         beh_redirect_inapp
rename q10_2	         beh_specific_lang
rename q10_3	         beh_positive_tone
rename q10_4	         beh_praise_contr
rename q10_5	         beh_follow_quest
rename q10_6	         beh_talk_min
rename q10_7	         beh_redirect_quick
rename q10_8	         beh_praise_app
rename q11	             sim_txt_cmsk
rename q12	             beh_desire_other_text
rename q13	             sim_txt_eth_behavior
rename q14	             sim_txt_eth_contribute
rename q16_1	         beh_fidgeting
rename q16_2	         beh_humming
rename q16_3	         beh_excitable
rename q16_4	         beh_inattentive
rename q16_5	         beh_short_attention
rename q16_6	         beh_quarrelsome
rename q16_7	         beh_acts_smart
rename q16_8	         beh_unpredictable
rename q16_9	         beh_defiant
rename q16_10	         beh_uncooperative
rename q16_11	         beh_easily_frustrated
rename q16_12	         beh_disturbs_others
rename q16_13	         beh_restless
rename q16_14	         beh_mood_changes
rename q17_1	         app_coach_stu
rename q17_2	         app_adjust_expect
rename q17_3	         app_guidance_couns
rename q17_4	         app_rec_sped
rename q17_5	         app_discp_refer
rename q17_6	         app_confer_stu
rename q17_7	         app_confer_parent
rename q18_1	         app_behavior_plan
rename q18_2	         app_challenge_work
rename q18_3	         app_spend_time
rename q18_4	         app_space_regroup
rename q18_5	         app_beh_manage_coach
rename q18_6	         app_beh_manage_teach
rename q38_1	         tse_01
rename q38_2	         tse_02
rename q38_3	         tse_05
rename q38_4	         tse_07
rename q38_5	         tse_08 
rename q38_6	         tse_10
rename q38_7	         tse_12
rename q38_8	         tse_14
rename q38_9	         tse_17
rename q38_10	         tse_19
rename q38_11	         tse_21
rename q38_12	         tse_24
rename q39_1	         tse_03
rename q39_2	         tse_04
rename q39_3	         tse_15
rename q39_4	         tse_09
rename q39_5	         tse_11
rename q39_6	         tse_13
rename q39_7	         tse_06
rename q39_8	         tse_16
rename q39_9	         tse_18
rename q39_10	         tse_20
rename q39_11	         tse_22
rename q39_12	         tse_23
rename q29	             se_post_sim_action
rename q30	             se_support_of_self_reflect
rename q31	             se_support_of_coach
rename q32	             se_rationale_for_support
rename q33_1	         se_suff_time
rename q33_2	         se_change
rename q33_3	         se_evaluate
rename q33_4	         se_corrections
rename q34_1	         se_friendly_coach
rename q34_2	         se_knowledge_coach
rename q34_3	         se_focused_coach
rename q34_4	         se_change_corrections2
rename q35_1	         se_recommend_reflect
rename q35_2	         se_practice_again
rename q36_1	         se_recommend_coach
rename q36_2	         se_recommend_practice
#rename q40	             se_timely
rename q41	             se_recommend_improvement

#delimit ;
	
keep email firstclick lastclick pagesubmit clickcount num_sim_completed_today 
     me_pre_coach me_post_coach rate_pre_coach rate_post_coach beh_redirect_inapp
	 beh_specific_lang beh_positive_tone beh_praise_contr beh_follow_quest
	 beh_talk_min beh_redirect_quick beh_praise_app sim_txt_cmsk 
	 beh_desire_other_text sim_txt_eth_behavior sim_txt_eth_contribute 
	 beh_fidgeting beh_humming beh_excitable beh_inattentive beh_short_attention 
	 beh_quarrelsome beh_acts_smart beh_unpredictable beh_defiant 
	 beh_uncooperative beh_easily_frustrated beh_disturbs_others beh_restless 
	 beh_mood_changes app_coach_stu app_adjust_expect app_guidance_couns 
	 app_rec_sped app_discp_refer app_confer_stu app_confer_parent 
	 app_behavior_plan app_challenge_work app_spend_time app_space_regroup 
	 app_beh_manage_coach app_beh_manage_teach tse_01 tse_02 tse_05 tse_07 
	 tse_08 tse_10 tse_12 tse_14 tse_17 tse_19 tse_21 tse_24 tse_03 tse_04 tse_15 
	 tse_09 tse_11 tse_13 tse_06 tse_16 tse_18 tse_20 tse_22 tse_23 
	 se_post_sim_action se_support_of_self_reflect se_support_of_coach 
	 se_rationale_for_support se_suff_time se_change se_evaluate 
	 se_corrections se_friendly_coach se_knowledge_coach se_focused_coach 
	 se_change_corrections2 se_recommend_reflect se_practice_again 
	 se_recommend_coach se_recommend_practice /* se_timely */ 
	 se_recommend_improvement progress finished ;
	
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


*---------------*
* tses_scale * 
*---------------*

* Creating scales for TSES
destring tse_*, replace
egen tses_se= rowmean(tse_01 tse_02 tse_04 tse_06 tse_09 tse_12 tse_14 tse_22)
egen tses_is= rowmean(tse_07 tse_10 tse_11 tse_17 tse_18 tse_20 tse_23 tse_24)
egen tses_cm= rowmean(tse_03 tse_05 tse_08 tse_13 tse_15 tse_16 tse_19 tse_21)
egen tses_overall=rowmean(tse_*)	
  
* Renaming TSES variables to match
rename tse_03 tses_3
rename tse_05 tses_5
rename tse_08 tses_8
rename tse_13 tses_13
rename tse_15 tses_15
rename tse_16 tses_16
rename tse_19 tses_19
rename tse_21 tses_21 	
  	
 
*--------------------------------------------*
*Generate time variable for appending surveys
*--------------------------------------------*
	
gen time = `time'

*--------------------------------------------*
*Mental Effort 
*--------------------------------------------*

* Destring variables for mental effort
destring me_pre_coach me_post_coach, replace
* Recoding Mental Effort values
replace me_pre_coach=1 if me_pre_coach==8
replace me_pre_coach=2 if me_pre_coach==9
replace me_pre_coach=3 if me_pre_coach==10
replace me_pre_coach=4 if me_pre_coach==28
replace me_pre_coach=5 if me_pre_coach==29
replace me_post_coach=1 if me_post_coach==8
replace me_post_coach=2 if me_post_coach==9
replace me_post_coach=3 if me_post_coach==10
replace me_post_coach=4 if me_post_coach==28
replace me_post_coach=5 if me_post_coach==29

*------------------------------------------------------------------------------*
* Step (5)  Label Variables
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Step (6)  Descriptive Statistics 
*------------------------------------------------------------------------------*


di "*--------------------------------------------------------------------------*"
di "data file `name'"
di "*--------------------------------------------------------------------------*"

sum manage_app_negative manage_app_positive manage_app_punitive ///
beh_rating_opdefiant beh_rating_impulsive beh_rating tses_se tses_is ///
tses_cm tses_overall
                                                     
di "*--------------------------------------------------------------------------*"

save "${clean}/`name'", replace


}

log close
log translate ${results}/feedback.smcl ${results}/feedback.txt, replace
