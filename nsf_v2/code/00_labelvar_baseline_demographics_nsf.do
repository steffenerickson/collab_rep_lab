//----------------------------------------------------------------------------//
// Variable Labels for NSF Baseline Survey
//----------------------------------------------------------------------------//



cap program drop label_baseline_demographics_nsf
program define label_baseline_demographics_nsf, nclass 

cap label variable d11_1    "First Name"                                              
cap label variable d11_2    "Last Name"                                               
cap label variable d11_3    "University Email Address"

cap label variable d91_1    "Content Question 1 Subquestion 1"
cap label variable d91_2    "Content Question 1 Subquestion 2"
cap label variable d91_3    "Content Question 1 Subquestion 3"
cap label variable d92      "Content Question 2 Subquestion 1"
cap label variable d93      "Content Question 3 Subquestion 1"
cap label variable d94      "Content Question 4 Subquestion 1"
cap label variable d95      "Content Question 5 Subquestion 1"
cap label variable d96_1    "Content Question 6 Subquestion 1"
cap label variable d96_2    "Content Question 6 Subquestion 2"
cap label variable d96_3    "Content Question 6 Subquestion 3"
cap label variable d96_4    "Content Question 6 Subquestion 4"
cap label variable d97      "Content Question 7 Subquestion 1"
cap label variable d98_1    "Content Question 8 Subquestion 1"
cap label variable d98_2    "Content Question 8 Subquestion 2"
cap label variable d98_3    "Content Question 8 Subquestion 3"
cap label variable d98_4    "Content Question 8 Subquestion 4"
cap label variable d99      "Content Question 9 Subquestion 1"
cap label variable d910     "Content Question 10 Subquestion 1"
cap label variable d911     "Content Question 11 Subquestion 1"
cap label variable d912     "Content Question 12 Subquestion 1"
cap label variable d913_1   "Content Question 13 Subquestion 1"
cap label variable d913_2   "Content Question 13 Subquestion 2"
cap label variable d913_3   "Content Question 13 Subquestion 3"
cap label variable d913_4   "Content Question 13 Subquestion 4"
cap label variable d914	    "Content Question 14 Subquestion 1"
cap label variable d915	    "Content Question 15 Subquestion 1"
cap label variable d916_1   "Content Question 16 Subquestion 1"
cap label variable d916_2   "Content Question 16 Subquestion 2"
cap label variable d916_3   "Content Question 16 Subquestion 3"
cap label variable d916_4   "Content Question 16 Subquestion 4"
cap label variable d917     "Content Question 17 Subquestion 1"
cap label variable d918     "Content Question 18 Subquestion 1"
cap label variable d919     "Content Question 19 Subquestion 1"
cap label variable d920_1   "Content Question 20 Subquestion 1"
cap label variable d920_2   "Content Question 20 Subquestion 2"
cap label variable d920_3   "Content Question 20 Subquestion 3"
cap label variable d920_4   "Content Question 20 Subquestion 4"

cap label variable d101_1   "Prior Question 1 Subquestion 1"
cap label variable d101_2   "Prior Question 1 Subquestion 2"
cap label variable d101_3   "Prior Question 1 Subquestion 3"
cap label variable d101_4   "Prior Question 1 Subquestion 4"
cap label variable d101_5   "Prior Question 1 Subquestion 5"
cap label variable d101_6   "Prior Question 1 Subquestion 6"
cap label variable d101_7   "Prior Question 1 Subquestion 7"
cap label variable d102     "Prior Question 2 Subquestion 1"
cap label variable d103     "Prior Question 3 Subquestion 1"
cap label variable d104_1   "Prior Question 4 Subquestion 1"
cap label variable d104_2   "Prior Question 4 Subquestion 2"
cap label variable d104_3   "Prior Question 4 Subquestion 3"
cap label variable d104_4   "Prior Question 4 Subquestion 4"
cap label variable d104_5   "Prior Question 4 Subquestion 5"
cap label variable d104_6   "Prior Question 4 Subquestion 6"
cap label variable d104_7   "Prior Question 4 Subquestion 7"
cap label variable d104_8   "Prior Question 4 Subquestion 8"
cap label variable d104_9   "Prior Question 4 Subquestion 9"
cap label variable d105_1   "Prior Question 5 Subquestion 1"
cap label variable d105_2   "Prior Question 5 Subquestion 2"
cap label variable d105_3   "Prior Question 5 Subquestion 3"
cap label variable d105_4   "Prior Question 5 Subquestion 4"
cap label variable d105_5   "Prior Question 5 Subquestion 5"
cap label variable d106_1   "Prior Question 6 Subquestion 1"
cap label variable d106_2   "Prior Question 6 Subquestion 2"
cap label variable d106_3   "Prior Question 6 Subquestion 3" 
cap label variable d106_4   "Prior Question 6 Subquestion 4"
cap label variable d106_5   "Prior Question 6 Subquestion 5"
cap label variable d106_6   "Prior Question 6 Subquestion 6"
cap label variable d106_7   "Prior Question 6 Subquestion 7"
cap label variable d106_8   "Prior Question 6 Subquestion 8"

**# Bookmark #5： rename q100 q101 q102 are uncommented and named as in codebook!
cap label variable d111     "Module-Related - Supporting SWDs" 
cap label variable d112     "Module-Related - Math Word Problems"
cap label variable d113     "Module-Related - Metacognitive Modeling"

cap label variable d121_1   "Efficacy Question 1 Subquestion 1"
cap label variable d121_2   "Efficacy Question 1 Subquestion 2"
cap label variable d121_3   "Efficacy Question 1 Subquestion 3"
cap label variable d121_4   "Efficacy Question 1 Subquestion 4"
cap label variable d121_5   "Efficacy Question 1 Subquestion 5"
cap label variable d122_1   "Efficacy Question 2 Subquestion 1"
cap label variable d122_2   "Efficacy Question 2 Subquestion 2"
cap label variable d122_3   "Efficacy Question 2 Subquestion 3"
cap label variable d122_4   "Efficacy Question 2 Subquestion 4"
cap label variable d122_5   "Efficacy Question 2 Subquestion 5"
cap label variable d123_1   "Efficacy Question 3 Subquestion 1"
cap label variable d123_2   "Efficacy Question 3 Subquestion 2"
cap label variable d123_3   "Efficacy Question 3 Subquestion 3"
cap label variable d124_1   "Efficacy Question 4 Subquestion 1"
cap label variable d124_2   "Efficacy Question 4 Subquestion 2"
cap label variable d124_3   "Efficacy Question 4 Subquestion 3"
cap label variable d125_1   "Efficacy Question 5 Subquestion 1"
cap label variable d125_2   "Efficacy Question 5 Subquestion 2"
cap label variable d125_3   "Efficacy Question 5 Subquestion 3"

cap label variable d131_1   "Beliefs Question 1 Subquestion 1"
cap label variable d131_2   "Beliefs Question 1 Subquestion 2"
cap label variable d131_3   "Beliefs Question 1 Subquestion 3"
cap label variable d131_4   "Beliefs Question 1 Subquestion 4"
cap label variable d131_5   "Beliefs Question 1 Subquestion 5"
cap label variable d131_6   "Beliefs Question 1 Subquestion 6"
cap label variable d131_7   "Beliefs Question 1 Subquestion 7"
cap label variable d131_8   "Beliefs Question 1 Subquestion 8"
cap label variable d131_9   "Beliefs Question 1 Subquestion 9"
cap label variable d131_10  "Beliefs Question 1 Subquestion 10"
cap label variable d131_11  "Beliefs Question 1 Subquestion 11"
cap label variable d131_12  "Beliefs Question 1 Subquestion 12"
cap label variable d131_13  "Beliefs Question 1 Subquestion 13"
cap label variable d131_14  "Beliefs Question 1 Subquestion 14"
cap label variable d131_15  "Beliefs Question 1 Subquestion 15"
cap label variable d131_16  "Beliefs Question 1 Subquestion 16"
cap label variable d131_17  "Beliefs Question 1 Subquestion 17"
cap label variable d131_18  "Beliefs Question 1 Subquestion 18"
cap label variable d131_19  "Beliefs Question 1 Subquestion 19"
cap label variable d131_20  "Beliefs Question 1 Subquestion 20"
cap label variable d131_21  "Beliefs Question 1 Subquestion 21"
cap label variable d141_1   "MTEB Question 1 Subquestion 1"
cap label variable d141_2   "MTEB Question 1 Subquestion 2"
cap label variable d141_3   "MTEB Question 1 Subquestion 3"
cap label variable d141_4   "MTEB Question 1 Subquestion 4"
cap label variable d141_5   "MTEB Question 1 Subquestion 5"
cap label variable d141_6   "MTEB Question 1 Subquestion 6"
cap label variable d141_7   "MTEB Question 1 Subquestion 7"
cap label variable d141_8   "MTEB Question 1 Subquestion 8"
cap label variable d141_9   "MTEB Question 1 Subquestion 9"
cap label variable d141_10  "MTEB Question 1 Subquestion 10"
cap label variable d141_11  "MTEB Question 1 Subquestion 11"
cap label variable d141_12  "MTEB Question 1 Subquestion 12"
cap label variable d141_13  "MTEB Question 1 Subquestion 13"
cap label variable d141_14  "MTEB Question 1 Subquestion 14"
cap label variable d141_15  "MTEB Question 1 Subquestion 15"
cap label variable d141_16  "MTEB Question 1 Subquestion 16"
cap label variable d141_17  "MTEB Question 1 Subquestion 17" 
cap label variable d141_18  "MTEB Question 1 Subquestion 18"
cap label variable d141_19  "MTEB Question 1 Subquestion 19"
cap label variable d141_20  "MTEB Question 1 Subquestion 20"
cap label variable d141_21  "MTEB Question 1 Subquestion 21"
cap label variable d151_1   "NEO Question 1 Subquestion 1"
cap label variable d152_1   "NEO Question 2 Subquestion 1"
cap label variable d153_1   "NEO Question 3 Subquestion 1"
cap label variable d154_1   "NEO Question 4 Subquestion 1"
cap label variable d155_1   "NEO Question 5 Subquestion 1"
cap label variable d151_2   "NEO Question 1 Subquestion 2"
cap label variable d152_2   "NEO Question 2 Subquestion 2"
cap label variable d153_2   "NEO Question 3 Subquestion 2"
cap label variable d154_2   "NEO Question 4 Subquestion 2"
cap label variable d155_2   "NEO Question 5 Subquestion 2"
cap label variable d151_3   "NEO Question 1 Subquestion 3"
cap label variable d152_3   "NEO Question 2 Subquestion 3"
cap label variable d153_3   "NEO Question 3 Subquestion 3"
cap label variable d154_3   "NEO Question 4 Subquestion 3"
cap label variable d155_3   "NEO Question 5 Subquestion 3"
cap label variable d151_4   "NEO Question 1 Subquestion 4" 
cap label variable d152_4   "NEO Question 2 Subquestion 4"
cap label variable d153_4   "NEO Question 3 Subquestion 4"
cap label variable d154_4   "NEO Question 4 Subquestion 4"
cap label variable d155_4   "NEO Question 5 Subquestion 4"
cap label variable d151_5   "NEO Question 1 Subquestion 5"
cap label variable d152_5   "NEO Question 2 Subquestion 5"
cap label variable d153_5   "NEO Question 3 Subquestion 5"
cap label variable d154_5   "NEO Question 4 Subquestion 5"
cap label variable d155_5   "NEO Question 5 Subquestion 5"
cap label variable d151_6   "NEO Question 1 Subquestion 6"
cap label variable d152_6   "NEO Question 2 Subquestion 6"
cap label variable d153_6   "NEO Question 3 Subquestion 6"
cap label variable d154_6   "NEO Question 4 Subquestion 6"
cap label variable d155_6   "NEO Question 5 Subquestion 6"
cap label variable d151_7   "NEO Question 1 Subquestion 7"
cap label variable d152_7   "NEO Question 2 Subquestion 7"
cap label variable d153_7   "NEO Question 3 Subquestion 7"
cap label variable d154_7   "NEO Question 4 Subquestion 7"
cap label variable d155_7   "NEO Question 5 Subquestion 7" 
cap label variable d151_8   "NEO Question 1 Subquestion 8"
cap label variable d152_8   "NEO Question 2 Subquestion 8" 
cap label variable d153_8   "NEO Question 3 Subquestion 8"
cap label variable d154_8   "NEO Question 4 Subquestion 8"
cap label variable d155_8   "NEO Question 5 Subquestion 8"
cap label variable d151_9   "NEO Question 1 Subquestion 9" 
cap label variable d152_9   "NEO Question 2 Subquestion 9"
cap label variable d153_9   "NEO Question 3 Subquestion 9"
cap label variable d154_9   "NEO Question 4 Subquestion 9"
cap label variable d155_9   "NEO Question 5 Subquestion 9"
cap label variable d151_10  "NEO Question 1 Subquestion 10"
cap label variable d152_10  "NEO Question 2 Subquestion 10"
cap label variable d153_10  "NEO Question 3 Subquestion 10"
cap label variable d154_10  "NEO Question 4 Subquestion 10"
cap label variable d155_10  "NEO Question 5 Subquestion 10"
cap label variable d151_11  "NEO Question 1 Subquestion 11"
cap label variable d152_11  "NEO Question 2 Subquestion 11"
cap label variable d153_11  "NEO Question 3 Subquestion 11"
cap label variable d154_11  "NEO Question 4 Subquestion 11"
cap label variable d155_11  "NEO Question 5 Subquestion 11"
cap label variable d151_12  "NEO Question 1 Subquestion 12"
cap label variable d152_12  "NEO Question 2 Subquestion 12"
cap label variable d153_12  "NEO Question 3 Subquestion 12"
cap label variable d154_12  "NEO Question 4 Subquestion 12"
cap label variable d155_12  "NEO Question 5 Subquestion 12"
cap label variable d161     "Gender"
cap label variable d162     "Age"
cap label variable d163     "Service type"
**# Bookmark #6 --- 165 not found
cap label variable d164     "Years in program"
cap label variable d166     "Transfer student"
cap label variable d167     "GPA"
cap label variable d168     "Parent teacher"
cap label variable d169     "Education mother"
cap label variable d1610    "Education father"
cap label variable d1611_1  "Race"
cap label variable d1611_2  "Race other" 
cap label variable d1612_1  "Home language"
cap label variable d1612_2  "Home language other"
cap label variable d1613    "Additional home language"
**# Bookmark #1 --- derived variables
cap label variable d107     "prior_overall_score"     //prior_overall_score
cap label variable d921     "content_overall_score"     //content_overall_score 
*cap label variable z_content_overall_score
cap label variable d132     "beliefs_overall_score"     //beliefs_overall_score
cap label variable d142     "mteb_overall_score"     //mteb_overall_score
cap label variable d156_1   "neo_neuroticism"   //neo_neuroticism
cap label variable d156_2   "neo_extraversion"   //neo_extraversion
cap label variable d156_3   "neo_openness"   //neo_openness
cap label variable d156_4   "neo_agreeableness"   //neo_agreeableness
cap label variable d156_5   "neo_conscientiousness"   //neo_conscientiousness
cap label variable d126_1   "Efficacy in instruction subscale" //efficacy_instruction 
cap label variable d126_2   "Efficacy in professionalism subscale" //efficacy_professionalism 
cap label variable d126_3   "Efficacy in teaching supports subscale" //efficacy_teach_support 
cap label variable d126_4   "Efficacy in classroom management subscale" //efficacy_class_manage 
cap label variable d126_5   "Efficacy in related duties subscale" //efficacy_related_duties 
cap label variable d126_6   "Efficacy overall score (mean of subscale scores)" //efficacy_overall 


end