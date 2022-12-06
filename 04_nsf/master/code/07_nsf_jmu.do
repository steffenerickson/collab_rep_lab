*------------------------------------------------------------------------------*  
/*
Title: NSF JMU SITE Cleaning 
Authors: Steffen Erikson 
Date: 9/28/22
Purpose: Cleaning the JMU data file 
*/ 
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Merge Files 
*------------------------------------------------------------------------------*

${jmu_tracker_data}
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
save ${clean_data}/jmu_norandomize.dta, replace  
export excel using ${clean_data}/jmu_sample.xlsx , firstrow(variables) replace




