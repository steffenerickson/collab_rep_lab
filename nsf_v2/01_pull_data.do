*------------------------------------------------------------------------------*
* Title: NSF data pull do file 
* Author: Steffen Erickson
* Date: 08/25/23
*------------------------------------------------------------------------------*

* ssc install egenmore //uncomment if you do not have egenmore installed 
global root_drive "/Users/steffenerickson/Desktop/repos/collab_rep_lab/nsf_v2"  // Change file path to master folder 
global data_drive "/Users/steffenerickson/Desktop"

cd $root_drive
do ${root_drive}/code/01_master.do

frame dir 

* unique ID for all datasets are participantid site semester 
* all outcome data files are linked to the baseline data with participantid site semester 
* baseline data contains treatment assignments, randomization blocks, and baseline survey info


* run [ frame change .... ] to access data 

//----------------------------------------------------------------------------//
*baseline data 
frame change nsf_baseline_data  
*save ${data_drive}/nsf_baseline_data.dta, replace  // uncomment to save 
*export excel ${data_drive}/nsf_baseline_data.xlsx, replace firstrow(variables) // uncomment to save 
//----------------------------------------------------------------------------//
*performance tasks and baseline data 
frame change performancetask_and_baseline 
frlink describe link1
*save ${data_drive}/performancetask_and_baseline.dta, replace // uncomment to save 
*export excel ${data_drive}/performancetask_and_baseline.xlsx, replace firstrow(variables) // uncomment to save 
//----------------------------------------------------------------------------//
*mqi and baseline data 
frame change mqi_and_baseline  
frlink describe link2
*save ${data_drive}/mqi_and_baseline.dta, replace // uncomment to save 
*export excel ${data_drive}/mqi_and_baseline.xlsx, replace firstrow(variables) // uncomment to save 
//----------------------------------------------------------------------------//
*costi and baseline data
frame change costi_and_baseline
frlink describe link3
*save ${data_drive}/costi_and_baseline.dta, replace // uncomment to save 
*export excel ${data_drive}/costi_and_baseline.xlsx, replace firstrow(variables) // uncomment to save   
//----------------------------------------------------------------------------//
*final survey and baseline data 
frame change finalsurvey_and_baseline
frlink describe link4
*save ${data_drive}/finalsurvey_and_baseline.dta, replace // uncomment to save 
*export excel ${data_drive}/finalsurvey_and_baseline.xlsx, replace firstrow(variables) // uncomment to save  
//----------------------------------------------------------------------------//


	


