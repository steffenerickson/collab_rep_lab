*------------------------------------------------------------------------------*
* Purpose: Data Cleaning - NSF Performance Task (dummy code)
* Person:  Steffen Erickson 
* Date:    9/2/22 
*------------------------------------------------------------------------------*
clear all 
cap log close 
global root_drive "/Users/steffenerickson/Desktop/summer_2022/nsf_project"
global data "data"
global programs "coders"
global results "results"

log using ${results}/perform_task_clean.smcl, replace 
cd ${root_drive}

#delimit ; 
import excel 
"${data}/F22: NSF Performance Task Coding_September 2, 2022_12.10.xlsx"
, sheet("Sheet0") cellrange(A1:AO8) firstrow case(lower) ;

drop in 1;

drop startdate 
	 enddate 
	 status
	 durationinseconds
	 ipaddress 
	 externalreference 
	 locationlatitude 
	 locationlongitude 
	 distributionchannel 
	 userlanguage 
	 q2_firstclick 
	 q2_lastclick 
	 q2_pagesubmit 
	 q2_clickcount;
#delimit cr

*------------------------------------------------------------------------------*
* Rename Variables  
*------------------------------------------------------------------------------*
rename q31   rater 
rename q9    id
rename q10   task
rename q32_1 up_context
rename q32_2 up_quant
rename q32_3 up_math_relation
rename q35_1 si_general
rename q35_2 si_curr_task
rename q35_3 si_justify
rename q35_4 si_self_reg
rename q42_1 rs_meta_model
rename q42_2 rs_unpack_wp
rename q42_3 rs_self_instruct
rename q42_4 rs_self_reg
rename q42_5 rs_end_model
rename q42_6 rs_accurate_clear
rename q39   os_categorical
rename q19   use_visual
rename q11   student_participation
rename sc0   os_rubric_sum

*------------------------------------------------------------------------------*
* Convert strings to encoded factor variables or numeric variables 
*------------------------------------------------------------------------------*

# delimit ;
local varlist "rater 
			   task
			   up_context
			   up_quant
			   up_math_relation
			   si_general
			   si_curr_task
			   si_justify
			   si_self_reg
			   rs_meta_model
			   rs_unpack_wp
			   rs_self_instruct
			   rs_self_reg
			   rs_end_model
			   rs_accurate_clear
			   os_categorical
			   use_visual
			   student_participation" ; 		   
# delimit cr 

foreach var in `varlist' {
	
	encode `var', gen(`var'2)
	drop `var'
	rename `var'2 `var'
}

destring os_rubric_sum, gen(os_rubric_sum2) 
drop os_rubric_sum
rename os_rubric_sum2 os_rubric_sum


*------------------------------------------------------------------------------*
* Label Variables
*------------------------------------------------------------------------------*

label var rater "Assigned Rater"
label var id "Participant ID"
label var task "Content Task"
label var up_context "Presence of Unpacking - Context of the problem"
label var up_quant "Presence of Unpacking - quantities of math"
label var up_math_relation "Presence of Unpacking - mathematical relationships"
label var si_general "Presence of Self Instruction - general"
label var si_curr_task "Presence of Self Instruction - current task"
label var si_justify "Presence of Self Instruction - justifications"
label var si_self_reg "Presence of Self Instruction - self-regulation"
label var rs_meta_model "Rubric Score - Objective for Metacognitive Model"
label var rs_unpack_wp "Rubric Score - Quality of Unpacking the Word Problem"
label var rs_self_instruct "Rubric Score - Quality of Self-Instruction"
label var rs_self_reg "Rubric Score - Quality of Self-Regulation"
label var rs_end_model  "Rubric Score - Quality of Self-Regulation"
label var rs_accurate_clear "Rubric Score - Accuracy and Clarity"
label var os_categorical "Overall Score - Categorical"
label var use_visual "The teacher used a visual"
label var student_participation "Student Participation (Classroom Videos Only)"
label var os_rubric_sum "Simple sum of rubric scores" //do not use this variable 
											   //- not actually rubric score sum 

*------------------------------------------------------------------------------*
* Create Strata On os_rubric_sum 
*------------------------------------------------------------------------------*



list id os_rubric_sum rs* in 1/5, nolabel

log close
log translate ${results}/perform_task_clean.smcl ${results}/perform_task_clean.txt, replace

