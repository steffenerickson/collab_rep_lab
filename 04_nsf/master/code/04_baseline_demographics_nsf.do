*------------------------------------------------------------------------------*
/*
Title:   NSF Baseline Survey 
Author:  Steffen Erickson 
Date:    9/18/22 
Purpose: Data Cleaning - NSF Baseline Survey 

*/
*------------------------------------------------------------------------------*
${bs_data} // Imports data with command written in the master file 
#delimit ;
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
	 userlanguage ;
#delimit cr

*------------------------------------------------------------------------------*
* Rename Variables  
*------------------------------------------------------------------------------*

ds

*rename progress                                              
*rename finished                                              
*rename recordeddate                                          
*rename responseid                                            
*rename recipientl~e                                          
*rename recipientf~e                                          
*rename recipiente~l                                          
*rename q98_1                                                 
*rename q98_2                                                 
*rename q98_4                                                 
*rename q3					consent                                              
*rename q5_id                                                 
*rename q5_name                                               
*rename q5_size                                               
*rename q5_type                                               
*rename q8                                                    
*rename q9_1                                                  
*rename q9_2                                                  
*rename q10_id                                                
*rename q10_name                                              
*rename q10_size                                              
*rename q10_type                                              
*rename q92                                                   
*rename q94_id                                                
*rename q94_name                                              
*rename q94_size                                              
*rename q94_type                                              
*rename q103                                                  
*rename q12                                            
*rename q13                                            
*rename q14       
rename q17_1		    content_1_1  
rename q17_2            content_1_2 	
rename q17_3            content_1_3
rename q18              content_2
rename q19              content_3
rename q20              content_4
rename q21              content_5
rename q22_1            content_6_1
rename q22_2            content_6_2
rename q22_3            content_6_3
rename q22_4            content_6_4
rename q23              content_7
rename q24_1            content_8_1
rename q24_2            content_8_2
rename q24_3            content_8_3
rename q24_4            content_8_4
rename q25              content_9
rename q26       		content_10
rename q27       		content_11
rename q28       		content_12
rename q29_1     		content_13_1
rename q29_2            content_13_2
rename q29_3            content_13_3
rename q29_4            content_13_4
rename q30       		content_14
rename q31       		content_15
rename q32_1     		content_16_1
rename q32_2            content_16_2
rename q32_3            content_16_3
rename q32_4            content_16_4
rename q33  			content_17
rename q34  			content_18
rename q35  			content_19
rename q36_1			content_20_1
rename q36_2            content_20_2
rename q36_3            content_20_3
rename q36_4            content_20_4
rename q38_1			prior_1_1
rename q38_2			prior_1_2
rename q38_3			prior_1_3
rename q38_4			prior_1_4
rename q38_5			prior_1_5
rename q38_6			prior_1_6
rename q38_7			prior_1_7
rename q39_1			prior_2
rename q40  			prior_3
rename q41_1			prior_4_1
rename q41_2			prior_4_2
rename q41_3			prior_4_3
rename q41_4			prior_4_4
rename q41_5			prior_4_5
rename q41_6			prior_4_6
rename q41_7			prior_4_7
rename q41_8			prior_4_8
rename q41_9			prior_4_9
rename q42_1			prior_5_1
rename q42_2            prior_5_2
rename q42_3            prior_5_3
rename q42_4            prior_5_4
rename q42_5            prior_5_5
rename q43_1 			prior_6_1
rename q43_2            prior_6_2
rename q43_3            prior_6_3 
rename q43_4            prior_6_4
rename q43_5            prior_6_5
rename q43_6            prior_6_6
rename q43_7            prior_6_7
rename q43_8            prior_6_8
*rename q100  			 
*rename q101  
*rename q102  
rename q45_1 			efficacy_1_1   
rename q45_2            efficacy_1_2
rename q45_3            efficacy_1_3
rename q45_4            efficacy_1_4
rename q45_5            efficacy_1_5
rename q45_6            efficacy_2_1
rename q45_7            efficacy_2_2
rename q45_8            efficacy_2_3
rename q45_9            efficacy_2_4
rename q45_10           efficacy_2_5
rename q45_11           efficacy_3_1
rename q45_12           efficacy_3_2
rename q45_13           efficacy_3_3
rename q45_14           efficacy_4_1
rename q45_15           efficacy_4_2
rename q45_16           efficacy_4_3
rename q45_17           efficacy_5_1
rename q45_18           efficacy_5_2
rename q45_19           efficacy_5_3
rename q46_1  			beliefs_1_1
rename q46_2            beliefs_1_2
rename q46_3            beliefs_1_3
rename q46_4            beliefs_1_4
rename q46_5            beliefs_1_5
rename q46_6            beliefs_1_6
rename q46_7            beliefs_1_7
rename q46_8            beliefs_1_8
rename q46_9            beliefs_1_9
rename q46_10           beliefs_1_10
rename q46_11           beliefs_1_11
rename q46_12           beliefs_1_12
rename q46_13           beliefs_1_13
rename q46_14           beliefs_1_14
rename q46_15           beliefs_1_15
rename q46_16           beliefs_1_16
rename q46_17           beliefs_1_17
rename q46_18           beliefs_1_18
rename q46_19           beliefs_1_19
rename q46_20 			beliefs_1_20
rename q46_21 			beliefs_1_21
rename q47_1  			mteb_1_1
rename q47_2            mteb_1_2
rename q47_3            mteb_1_3
rename q47_4            mteb_1_4
rename q47_5            mteb_1_5
rename q47_6            mteb_1_6
rename q47_7            mteb_1_7
rename q47_8            mteb_1_8
rename q47_9            mteb_1_9
rename q47_10           mteb_1_10
rename q47_11           mteb_1_11
rename q47_12           mteb_1_12
rename q47_13           mteb_1_13
rename q47_14           mteb_1_14
rename q47_15           mteb_1_15
rename q47_16           mteb_1_16
rename q47_17           mteb_1_17
rename q47_18           mteb_1_18
rename q47_19           mteb_1_19
rename q47_20           mteb_1_20
rename q47_21           mteb_1_21
rename q50_1  			neo_1
rename q50_2            neo_2
rename q50_3            neo_3
rename q50_4            neo_4
rename q50_5            neo_5
rename q50_6            neo_6
rename q50_7            neo_7
rename q50_8            neo_8
rename q50_9            neo_9
rename q50_10           neo_10
rename q51_1  			neo_11
rename q51_2            neo_12
rename q51_3            neo_13
rename q51_4            neo_14
rename q51_5            neo_15
rename q51_6            neo_16
rename q51_7            neo_17
rename q51_8            neo_18
rename q51_9            neo_19
rename q51_10           neo_20
rename q52_1  			neo_21
rename q52_2            neo_22
rename q52_3            neo_23
rename q52_4            neo_24
rename q52_5            neo_25
rename q52_6            neo_26
rename q52_7            neo_27
rename q52_8            neo_28
rename q52_9            neo_29
rename q52_10           neo_30
rename q53_1  			neo_31
rename q53_2            neo_32
rename q53_3            neo_33
rename q53_4            neo_34
rename q53_5            neo_35
rename q53_6            neo_36
rename q53_7            neo_37
rename q53_8            neo_38
rename q53_9            neo_39
rename q53_10           neo_40
rename q54_1  			neo_41
rename q54_2            neo_42
rename q54_3            neo_43
rename q54_4            neo_44
rename q54_5            neo_45
rename q54_6            neo_46
rename q54_7            neo_47
rename q54_8            neo_48
rename q54_9            neo_49
rename q54_10           neo_50
rename q55_1			neo_51
rename q55_2            neo_52
rename q55_3            neo_53
rename q55_4            neo_54
rename q55_5            neo_55
rename q55_6            neo_56
rename q55_7            neo_57
rename q55_8            neo_58
rename q55_9            neo_59
rename q55_10           neo_60
rename q64				gender
rename q65				age
rename q66				service_type
rename q67				years_in_program
rename q68				transfer_student
rename q69				gpa
rename q70				parent_teacher
rename q71				education_mother
rename q72				education_father
rename q73				race
rename q73_7_text		race_other
rename q74				home_lang
rename q74_6_text		home_lang_other
rename q75				alt_home_lang
*rename q75_2_text		alt home_lang_list


*------------------------------------------------------------------------------*
* Scoring
*------------------------------------------------------------------------------*

*Recovering Lost Scores 

egen dupes = tag(recipientemail)
drop if dupes ! = 1
drop dupes 

preserve
${num_bs_data} // Imports data with command written in the master file 
drop in 1
drop if finished == "False"
keep q35 q25 recipientemail
egen dupes = tag(recipientemail)
drop if dupes ! = 1
drop dupes 
rename q35 content_19 
rename q25 content_9
tempfile data1
save `data1'
describe
restore

drop content_19 content_9
merge 1:1 recipientemail using `data1'
drop if _merge ==2 

*-----------------*
*   Content	      *
*-----------------*

label define correctness 0 "Incorrect" 1 "Correct" 

foreach var of varlist content* {
	encode `var' , gen(`var'_2)
	drop `var'
	rename `var'_2 `var'
}


recode content_1_1  (1 3 = 0) (2 = 1) 
recode content_1_2  (1 3 = 0) (2 = 1) 
recode content_1_3  (2 3 = 0) (1 = 1) 
recode content_2    (1 2 4 5 = 0) (3 = 1) 
recode content_3    (2 3 4 = 0) (1 = 1) 
recode content_4    (1 3 4 = 0) (2 = 1) 
recode content_5    (1 3 4 = 0) (2 = 1) 
recode content_6_1  (1 3 4 = 0) (2 = 1) 
recode content_6_2  (1 2 3 = 0) (4 = 1) 
recode content_6_3  (1 3 4 = 0) (2 = 1) 
recode content_6_4  (1 2 4 = 0) (3 = 1) 
recode content_7    (1 3 4 = 0) (2 = 1) 
recode content_8_1  (1 3  = 0) (2 = 1) 
recode content_8_2  (1 3  = 0) (2 = 1) 
recode content_8_3  (1 3  = 0) (2 = 1) 
recode content_8_4  (1 2  = 0) (3 = 1) 
recode content_9    (1 2 4 = 0) (3 = 1)
recode content_10   (1 2 3 5 = 0) (4 = 1)
recode content_11   (1 2 4 = 0) (3 = 1)
recode content_12   (1 2 4 5 = 0) (3 = 1)
recode content_13_1 (1 2  = 0) (3 = 1) 
recode content_13_2 (2 3  = 0) (1 = 1) 
recode content_13_3 (1 2  = 0) (3 = 1) 
recode content_13_4 (2 3  = 0) (1 = 1) 
recode content_14	(2 3 4  = 0) (1 = 1) 
recode content_15	(1 2 3  = 0) (4 = 1) 
recode content_16_1 (1 3  = 0) (2 = 1) 
recode content_16_2 (1 3  = 0) (2 = 1) 
recode content_16_3 (1 3  = 0) (2 = 1) 
recode content_16_4 (1 2  = 0) (3 = 1)
recode content_17 	(2 3 4 = 0) (1 = 1)
recode content_18 	(2 3 4 = 0) (1 = 1)
recode content_19   (1 2 4 = 0) (3 = 1)
recode content_20_1 (1 2  = 0) (3 = 1)
recode content_20_2 (1 2  = 0) (3 = 1)
recode content_20_3 (1 2  = 0) (3 = 1)
recode content_20_4 (2 3  = 0) (1 = 1)

label variable content_1_1 "Mrs. Robbins assigned the problem 350 ÷ 50 to her class"
label variable content_1_2 "Mrs. Robbins assigned the problem 350 ÷ 50 to her class"
label variable content_1_3 "Mrs. Robbins assigned the problem 350 ÷ 50 to her class"
label variable content_2   "Ms. Wade asks her students to draw a diagram to represent the expression 2/3"
label variable content_3   "Mrs. Langer asked her class to decompose the number 4,443 into thousands"
label variable content_4   "Mrs. Ewing asked her students whether the equation a + b -b = a was true or false"
label variable content_5   "For homework, Maya worked on the following problem..."
label variable content_6_1 "During a unit on the distributive property, Ms. Dixon's students encountered a - (b + c) = a - b - c"
label variable content_6_2 "During a unit on the distributive property, Ms. Dixon's students encountered a - (b + c) = a - b - c"
label variable content_6_3 "During a unit on the distributive property, Ms. Dixon's students encountered a - (b + c) = a - b - c"
label variable content_6_4 "During a unit on the distributive property, Ms. Dixon's students encountered a - (b + c) = a - b - c"
label variable content_7   "Ms. Dubois's attention was caught by the following item on the state test:"
label variable content_8_1 "Mrs. James is teaching subtraction to her students."
label variable content_8_2 "Mrs. James is teaching subtraction to her students."
label variable content_8_3 "Mrs. James is teaching subtraction to her students."
label variable content_8_4 "Mrs. James is teaching subtraction to her students."
label variable content_9   "A student in Mrs. Reed's class explains that he counted up by tens and then added the rest"
label variable content_10  "After teaching a lesson on subtraction with three-digit numbers"
label variable content_11  "Mr. Sandoval asks Oliver, What fraction of the rectangles are shaded?"
label variable content_12  "Ms. Cox's students were working on the following problem:"
label variable content_13_1 "Mrs. Afua's students are converting between inches and feet."
label variable content_13_2 "Mrs. Afua's students are converting between inches and feet."
label variable content_13_3 "Mrs. Afua's students are converting between inches and feet."
label variable content_13_4 "Mrs. Afua's students are converting between inches and feet."
label variable content_14	"Patrick created the following diagram to help him subtract 137 from 316:"
label variable content_15	"Mr. Reid wants to select division problems that require his students"
label variable content_16_1 "A student looked at the diagram, touched each of the circles except the fourth one, and said:"
label variable content_16_2 "A student looked at the diagram, touched each of the circles except the fourth one, and said:"
label variable content_16_3 "A student looked at the diagram, touched each of the circles except the fourth one, and said:"
label variable content_16_4 "A student looked at the diagram, touched each of the circles except the fourth one, and said:"
label variable content_17  "While solving 23 + 59, Gregory wrote the following in his notebook:"
label variable content_18  "Mr. Delgado's class has been working on comparing decimals."
label variable content_19  "Which of these sets of equations is best for demonstrating the meaning of the equals sign?"
label variable content_20_1 "Mrs. Munoz is about to teach division of fractions to her students "
label variable content_20_2 "Mrs. Munoz is about to teach division of fractions to her students "
label variable content_20_3 "Mrs. Munoz is about to teach division of fractions to her students "
label variable content_20_4 "Mrs. Munoz is about to teach division of fractions to her students "


label values content* correctness 

*Weights 

/*
gen content_1 = ((1/3)*content_1_1)+((1/3)*content_1_2)+((1/3)*content_1_3) 
gen content_6 = ((1/4)*content_6_1)+((1/4)*content_6_2)+((1/4)*content_6_3)+((1/4)*content_6_4) 
gen content_8 = ((1/4)*content_8_1)+((1/4)*content_8_2)+((1/4)*content_8_3)+((1/4)*content_8_4) 
gen content_13 = ((1/4)*content_13_1)+((1/4)*content_13_2)+((1/4)*content_13_3)+((1/4)*content_13_4) 
gen content_16 = ((1/4)*content_16_1)+((1/4)*content_16_2)+((1/4)*content_16_3)+((1/4)*content_16_4)
gen content_20 = ((1/4)*content_20_1)+((1/4)*content_20_2)+((1/4)*content_20_3)+((1/4)*content_20_4)
*/

egen content_overall_score_total = rowtotal(content_*)
gen content_overall_score  = content_overall_score_total / 38
qui sum content_overall_score
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_content_overall_score = (content_overall_score - mu) / sd


*gen content_overall_score = round((content_overall_score*100),4)
*drop score 


*-----------------*
*Prior Experience *
*-----------------*

foreach var of varlist prior* {
	encode `var' , gen(`var'_2)
	drop `var'
	rename `var'_2 `var'
}
/*
* Scale 1 Prior experience working with SWDs

recode prior_1* (5 = 0) (4 = 1) (1 = 2) (2 = 3) (3 = 4)

label define exp 0 "Not at all" 1 "Less than 1 year" 2 "1 - 2 years" 3 "3 - 5 years " 4 "6 or more years"
label values prior_1* exp
egen prior_scale_1_total = rowtotal(prior_1*)
gen prior_scale_1 = prior_scale_1_total / 28
qui sum prior_scale_1
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_prior_scale_1 = (prior_scale_1 - mu) / sd

* Scale 2 Prior opportunities in TE related to SWDs

recode prior_4* (2 = 0) (5 = 1) (4 = 2) (3 = 3) (1 = 4)
label define exp2 0 "None" 1 "Touched on it briefly" 2 "Spent time discussing it" 3 "Spent time discussing and doing it " 4 "Extensive opportunity to practice"
label values prior_4* exp2
egen prior_scale_2_total = rowtotal(prior_4*)
gen prior_scale_2 = prior_scale_2_total / 36
qui sum prior_scale_2
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_prior_scale_2 = (prior_scale_2 - mu) / sd

* Scale 3 Prior opportunities in TE related to mathematics

recode prior_5* prior_6* (2 = 0) (5 = 1) (4 = 2) (3 = 3) (1 = 4)
label values prior_5* prior_6* exp2
egen prior_scale_3_total = rowtotal( prior_5* prior_6*)
gen prior_scale_3 = prior_scale_3_total / 52
qui sum prior_scale_3
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_prior_scale_3 = (prior_scale_3 - mu) / sd

*Overall score 

factor prior_scale_1 prior_scale_2 prior_scale_3
egen prior_overall_score = rowmean(prior_scale_1 prior_scale_2 prior_scale_3)
qui sum prior_overall_score
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_prior_overall_score = (prior_overall_score - mu) / sd
*/
label define exp 0 "Not at all" 1 "Less than 1 year" 2 "1 - 2 years" 3 "3 - 5 years " 4 "6 or more years"
label define exp2 0 "None" 1 "Touched on it briefly" 2 "Spent time discussing it" 3 "Spent time discussing and doing it " 4 "Extensive opportunity to practice"
label values prior_1* exp
recode prior_5* prior_6* (2 = 0) (5 = 1) (4 = 2) (3 = 3) (1 = 4)
label values prior_5* prior_6* exp2

egen prior_scale_1 = rowmean(prior_1*)
egen prior_scale_2 = rowmean(prior_4*)
egen prior_scale_3 = rowmean(prior_5* prior_6*)
egen prior_overall_score = rowmean(prior_scale_1 prior_scale_2 prior_scale_3)





*-----------------*
* Efficacy *
*-----------------*

foreach var of varlist efficacy* {
	encode `var' , gen(`var'_2)
	drop `var'
	rename `var'_2 `var'
}


/*
*label define likert 0 "Strongly Disagree " 1 "Disagree" 2 "Somewhat Disagree" 3 "Neutral " 4 "Agree" 5 "Strongly Agree"
*label values efficacy* likert
egen efficacy_overall_score_total = rowtotal(efficacy_*) 
gen efficacy_overall_score = efficacy_overall_score_total  / 171
qui sum efficacy_overall_score
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_efficacy_overall_score = (efficacy_overall_score - mu) / sd

*/

*Instruction 
/*
x1 = intercepts + factor_loadings*Instruction
est store m1

sem (L1@1 -> efficacy_1_1, ) (L1 -> efficacy_1_2, ) (L1 -> efficacy_1_3, )  ///
(L1 -> efficacy_1_4, ) (L1 -> efficacy_1_5, ) ///
(efficacy_1_1 <- _cons@0, ), latent(L1 ) means( L1) nocapslatent


est store m1

sem (L1@1 -> efficacy_1_1, ) (L1@.743 -> efficacy_1_2, ) (L1@.732 -> efficacy_1_3, )  ///
(L1@.712 -> efficacy_1_4, ) (L1@.642 -> efficacy_1_5, ) ///
(efficacy_1_1 <- _cons@0, ), latent(L1 ) means( L1) nocapslatent
predict efficacy_instruction, latent

est store m2 
lrtest m1 m2, st
*/ 

*Professionalism

egen efficacy_instruction = rowmean(efficacy_1*)
egen efficacy_professionalism = rowmean(efficacy_2*)
egen efficacy_teach_support = rowmean(efficacy_3*)
egen efficacy_class_manage = rowmean(efficacy_4*)
egen efficacy_related_duties = rowmean(efficacy_5*)
egen efficacy_overall= rowmean(efficacy_instruction efficacy_professionalism efficacy_teach_support efficacy_class_manage efficacy_related_duties)


#delimit ;
local variables efficacy_instruction efficacy_professionalism 
efficacy_teach_support efficacy_class_manage efficacy_related_duties;
#delimit cr


local j = 1
foreach i of varlist `variables' {

	#delimit ;
	unab vars : efficacy_instruction efficacy_professionalism 
	efficacy_teach_support efficacy_class_manage efficacy_related_duties;
	#delimit cr
	tokenize `vars'

	local remove ``j''
	local vars : list vars - remove
	tokenize `vars'

	if `j' == 1 {

		gen efficacy_weakness = `j' if `i' < `1' &  `i' < `2' &  `i' < `3' &  `i' < `4' 
		gen efficacy_strength = `j' if `i' > `1' &  `i' > `2' &  `i' > `3' &  `i' > `4' 

	}
	else {
		replace efficacy_weakness = `j' if `i' < `1' &  `i' < `2' &  `i' < `3' &  `i' < `4' 
		replace efficacy_strength = `j' if `i' > `1' &  `i' > `2' &  `i' > `3' &  `i' > `4' 
	}
	local ++j
}


label define strong_weak 1 "instruction" 2 "professionalism" 3 "teach_support" 4 "class_manage" 5 "related_duties" 
label values efficacy_strength strong_weak
label values efficacy_weakness strong_weak



label variable efficacy_1_1 "I can adapt the curriculum to help meet the needs of a student with disabilities in my classroom."
label variable efficacy_1_2 "I can adjust the curriculum to meet the needs of high-achieving students andlow-achieving students simultaneously."
label variable efficacy_1_3 "I can use a wide variety of strategies for teaching the curriculum to enhance understanding for all of my students, especially those with disabilities."
label variable efficacy_1_4 "I can adjust my lesson plans to meet the needs of all of my students,regardless of their ability level."
label variable efficacy_1_5 "I can break down a skill into its component parts to facilitate learning for students with disabilities."
label variable efficacy_2_1 "I can be an effective team member and work collaboratively with otherteachers, paraprofessionals, and administrators to help my students with disabilities reach their goals."
label variable efficacy_2_2 "I can model positive behavior for all students with or without disabilities."
label variable efficacy_2_3 "I can consult with an intervention specialist or other specialist when I need help, without harming my own morale."
label variable efficacy_2_4 "I can give consistent praise for students with disabilities, regardless of how small or slow the progress is."
label variable efficacy_2_5 "I can encourage students in my class to be good role models for students with disabilities."
label variable efficacy_3_1 "I can effectively encourage all of my students to accept those with disabilities in my classroom"
label variable efficacy_3_2 "I can create an environment that is open and welcoming for students with disabilities in my classroom."
label variable efficacy_3_3 "I can establish meaningful relationships with my students with disabilities."
label variable efficacy_4_1 "I can effectively deal with disruptive behaviors in the classroom, such as tantrums"
label variable efficacy_4_2 "I can remain in control of a situation that involves a major temper tantrum in my classroom."
label variable efficacy_4_3 "I can manage a classroom that includes students with disabilities"
label variable efficacy_5_1 "I can effectively transport students with physical disabilities from vehicles to wheelchairs, from wheelchairs to desks, and to the restroom without becoming intimidated."
label variable efficacy_5_2 "I can administer medication to students with disabilities if I am asked to and have the proper certifications."
label variable efficacy_5_3 "I can assist students with disabilities with daily tasks such as restroom use and feeding."
label variable efficacy_instruction "Efficacy in instruction subscale"
label variable efficacy_professionalism "Efficacy in professionalism subscale"
label variable efficacy_teach_support "Efficacy in teaching supports subscale"
label variable efficacy_class_manage "Efficacy in classroom management subscale"
label variable efficacy_related_duties "Efficacy in related duties subscale"
label variable efficacy_overall "Efficacy overall score (mean of subscale scores)"

*-----------------*
* Beliefs *
*-----------------*

foreach var of varlist beliefs* {
	encode `var' , gen(`var'_2)
	drop `var'
	rename `var'_2 `var'
}

recode beliefs* (6 = 0) (5 = 5) (4 = 2) (3 = 3) (2 = 1) (1 = 4)
recode beliefs_1_7-beliefs_1_13 (0 = 5) (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0)
label define likert 0 "Strongly Disagree " 1 "Disagree" 2 "Somewhat Disagree" 3 "Neutral " 4 "Agree" 5 "Strongly Agree"
label values beliefs* likert
/*
egen beliefs_overall_score_total = rowtotal(beliefs*) 
gen beliefs_overall_score = beliefs_overall_score_total  / 105
qui sum beliefs_overall_score
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_beliefs_overall_score = (beliefs_overall_score - mu) / sd
*/ 
egen beliefs_overall_score = rowmean(beliefs*)

*-----------------*
* mteb *
*-----------------*

foreach var of varlist mteb* {
	encode `var' , gen(`var'_2)
	drop `var'
	rename `var'_2 `var'
}

recode mteb* (1 = 3) (2 = 1) (3 = 4) (4 = 0) (5 = 3) 
foreach x in 3 6 15 17 18 19 21 {
	recode mteb_1_`x' (0 = 4) (1 = 3) (2 = 2) (3 = 1) (4 = 0) 
}

label define likert2 0 "Strongly Disagree " 1 "Disagree" 2 "Uncertain" 3 "Agree" 4 "Strongly Agree"
/*

egen mteb_overall_score_total = rowtotal(mteb*) 
gen mteb_overall_score = mteb_overall_score_total  / 84
qui sum mteb_overall_score
scalar mu = r(mean) 
scalar sd = r(sd)
gen z_mteb_overall_score = (mteb_overall_score - mu) / sd
*/

egen mteb_overall_score = rowmean(mteb*)


*-----------------*
* NEO *
*-----------------*

label define likert3 0 "Strongly Disagree " 1 "Disagree" 2 "Neutral" 3 "Agree" 4 "Strongly Agree"


foreach var of varlist neo* {
	encode `var' , gen(`var'_2)
	drop `var'
	rename `var'_2 `var'
}

recode neo* (5 = 0) (2 = 1) (3 = 2) (4 = 4) (1 = 3) 
label values neo* likert3

local reverse_code 1 16 31 46 12 27 42 57 3 8 18 23 33 38 48 9 14 24 29 39 44 54 59 15 30 45 55
foreach x in  `reverse_code' {
	recode neo_`x' (0 = 4) (1 = 3) (2 = 2) (3 = 1) (4 = 0) 
}

*Neuroticism
	*1 6 11 16 21 26 31 36 41 46 51 56 
	*Reverse coded 1 16 31 46
	
	local neuroticism 1 6 11 16 21 26 31 36 41 46 51 56 
	foreach x in `neuroticism' {
		rename neo_`x' neo_neuroticism_`x'
	}
	/*
	egen neo_neuroticism_total = rowtotal(neo_neuroticism_*) 
	gen neo_neuroticism = neo_neuroticism_total  / 48
	qui sum neo_neuroticism
	scalar mu = r(mean) 
	scalar sd = r(sd)
	gen z_neo_neuroticism = (neo_neuroticism - mu) / sd
	*/ 
	egen neo_neuroticism = rowmean(neo_neuroticism_*)
 
*Extraversion
	*2 7 12 17 22 27 32 37 42 47 52 57 
	*reverse coded 12 27 42 57 
	
	local extraversion 2 7 12 17 22 27 32 37 42 47 52 57 
	foreach x in `extraversion' {
		rename neo_`x' neo_extraversion_`x'
	}
	
	/*
	egen neo_extraversion_total = rowtotal(neo_extraversion_*) 
	gen neo_extraversion = neo_extraversion_total  / 48
	qui sum neo_extraversion
	scalar mu = r(mean) 
	scalar sd = r(sd)
	gen z_neo_extraversion = (neo_extraversion - mu) / sd
	*/
	
	egen neo_extraversion = rowmean(neo_extraversion_*)
	
* Openness to Experience
	*3 8 13 18 23 28 33 38 43 48 53 58 
	*reverse coded 3 8 18 23 33 38 48 
	
	local openness 3 8 13 18 23 28 33 38 43 48 53 58 
	foreach x in `openness' {
		rename neo_`x' neo_openness_`x'
	}
	
	/*
	egen neo_openness_total = rowtotal(neo_openness*) 
	gen neo_openness = neo_openness_total  / 48
	qui sum neo_openness
	scalar mu = r(mean) 
	scalar sd = r(sd)
	gen z_neo_openness = (neo_openness - mu) / sd
	*/
	
	egen neo_openness = rowmean(neo_openness_*)
* Agreeableness
	*4 9 14 19 24 29 34 39 44 49 54 59 
	*reverse coded 9 14 24 29 39 44 54 59 
	
	local agreeableness 4 9 14 19 24 29 34 39 44 49 54 59 
	foreach x in `agreeableness' {
		rename neo_`x' neo_agreeableness_`x'
	}
	/*
	egen neo_agreeableness_total = rowtotal(neo_agreeableness*) 
	gen neo_agreeableness = neo_agreeableness_total  / 48
	qui sum neo_agreeableness
	scalar mu = r(mean) 
	scalar sd = r(sd)
	gen z_neo_agreeableness = (neo_agreeableness - mu) / sd
	*/
	
	egen neo_agreeableness = rowmean(neo_agreeableness_*)
	
* Conscientiousness
	*5 10 15 20 25 30 35 40 45 50 55 60 
	*reverse coded 15 30 45 55 
 
	local conscientiousness 5 10 15 20 25 30 35 40 45 50 55 60 
	foreach x in `conscientiousness' {
		rename neo_`x' neo_conscientiousness_`x'
	}
	/*
	egen neo_conscientiousness_total = rowtotal(neo_conscientiousness*) 
	gen neo_conscientiousness = neo_conscientiousness_total  / 48
	qui sum neo_conscientiousness
	scalar mu = r(mean) 
	scalar sd = r(sd)
	gen z_neo_conscientiousness = (neo_conscientiousness - mu) / sd
	*/
	
	egen neo_conscientiousness = rowmean(neo_conscientiousness_*)

*1


*-----------------*
* Demographics *
*-----------------*


*Cleaning Up Strings 
*gender 
replace gender=lower(gender)
replace gender=strtrim(gender)
replace gender=subinstr(gender, "cisgender","",.)
replace gender=subinstr(gender, "cis","",.)
replace gender=subinstr(gender, "woman","female",.)
replace gender=subinstr(gender, "femalw","female",.)
replace gender=subinstr(gender, "(she/her)","",.)
replace gender=strtrim(gender)

*age 
replace age=subinstr(age, "`","",.)
replace age=strtrim(age)
destring age, replace 

*encoding categorical 
local varlist race gender transfer_student parent_teacher education_mother education_father home_lang service_type

foreach var of varlist `varlist' {
	encode `var' , gen(`var'_2)
	drop `var'
	rename `var'_2 `var'
}

*destring numeric 
destring age gpa years_in_program, replace force

*------------------------------------------------------------------------------*
*
*------------------------------------------------------------------------------*

keep recipientemail  prior_overall_score content_overall_score beliefs_overall_score mteb_overall_score gender age service_type years_in_program transfer_student gpa parent_teacher education_mother education_father race home_lang neo_neuroticism neo_extraversion neo_openness neo_agreeableness neo_conscientiousness finished content* efficacy_instruction efficacy_professionalism efficacy_teach_support efficacy*
                                                                                        
                                                                                        
save ${clean_data}/baseline_clean.dta, replace                                                
                                                                                       