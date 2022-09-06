*------------------------------------------------------------------------------*
* Assigning Coders to Participant Videos
*------------------------------------------------------------------------------*
clear all 
cap log close 
global root_drive "/Users/steffenerickson/Desktop/summer_2022/nsf_project"
global data "data"
global programs "coders"
global results "results"

log using ${results}/assign_coders.smcl, replace 
cd ${root_drive}

do "${programs}/permin.do"

*------------------------------------------*
* 1) Generate all permutations of raters 
* 2) pull a random sample of n participants  
* 3) save in a data set 
*------------------------------------------*

matrix Coders = (1,2,3,4,5,6,7,8)'
matrix colnames Coders = "coder"
svmat Coders, names(col)

permin coder, k(3)
gen coder_comb = _n
set seed 3408
sample 21, count 

gen index = _n 

list coder_comb coder_1 coder_2 coder_3

save ${data}/coder_assign.dta, replace

*---------------------------------------------------*
*1) Randomly sort participants 
*2) Merge data file with code_assign based on index
*---------------------------------------------------*

#delimit ; 
import excel "${data}/UVA Data Tracker.xlsx"
, sheet("UVA Data Tracker") cellrange(A1:E61) firstrow clear;
#delimit cr
drop if ParticipantID == ""

set seed 3408
gen rannum = uniform() 
sort rannum
gen index = _n 

merge 1:1 index using ${data}/coder_assign.dta
drop _merge coder_comb index rannum

list ParticipantID coder_1 coder_2 coder_3

log close
log translate ${results}/assign_coders.smcl ${results}/assign_coders.txt, replace

