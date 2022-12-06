*------------------------------------------------------------------------------*  
/*
Title: Assign Coders 
*Authors: Steffen Erikson 
*Date: 11/15/22
*Purpose: Assign coders to rate participant videos 
*/ 
*------------------------------------------------------------------------------*



*------------------------------------------------------------------------------*
* Assigning Coders to Participant Videos
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Rater Assignment 
* 1) Generate all permutations of raters 
* 2) pull 2 random samples of n participants  
* 3) save in a `data1' `data2' 
*------------------------------------------------------------------------------*
frames reset 
clear 
matrix Coders = (1,2,3,4,5,6)'
matrix colnames Coders = "video"
svmat Coders, names(col)
permin_2 video, k(6)

*---------------------------------------------------*
* Validate that all permutations are unique 
*---------------------------------------------------*
preserve
gen id = _n
reshape long video_, i(id) j(coder)
egen uniq = nvals(video_), by(id) 
tab uniq
restore 

*---------------------------------------------------*
* Create two samples of rater permutations
*---------------------------------------------------*

local n_s  = 149   // n of sample 
gen coder_comb = _n
sort coder_comb
set seed 3408
generate rannum = runiform()  
sort rannum
generate insample = _n <= `n_s' // first n_s
generate insample2 = (_N - _n) < `n_s' //last n_s
preserve
	keep if insample == 1 
	gen index = _n
	tempfile data1
	save `data1'
	save ${clean_data}/coder_assign_2_pre.dta, replace
restore 

preserve
	keep if insample2 == 1
	gen index = _n
	tempfile data2
	save `data2'
	save ${clean_data}/coder_assign_2_post.dta, replace
restore 

use `data1' , clear 

*---------------------------------------------------*
*1) Randomly sort participants 
*2) Merge data file with code_assign based on index
*---------------------------------------------------*
local i = 1 
forvalues x = 1/2 {
	use ${clean_data}/nsf_full_sample.dta, clear 
	tostring site, gen(site_2)
	gen id_site = site_2 + participantid 
	keep id_site site participantid 
	gen index = _n 
	merge 1:1 index using `data`x''
	drop _merge coder_comb index 
	#delimit ; 
	label define coder 	1 "Coder 1" 
						2 "Coder 2" 
						3 "Coder 3" 
						4 "Coder 4" 
						5 "Coder 5"
						6 "Coder 6";
	#delimit cr
	label values video* coder 		
	sort id_site 
	list id_site video_1 video_2 video_3 video_4 video_5 video_6 
	
*---------------------------------------------------*
*1) Coder balance across videos 
*---------------------------------------------------*

	forvalues x = 1/6 {
		qui tab video_`x' , matcell(x_`x')
		matrix colnames x_`x' = "video_`x'"
		if `x' == 1 {
			matrix x_full = x_`x'
		}
		else {
			matrix x_full = (x_full, x_`x')
		}
	}
	#delimit ; 
	matrix rownames x_full = 	"Coder 1"
								"Coder 2"
								"Coder 3"
								"Coder 4"
								"Coder 5"
								"Coder 6";
	#delimit cr
	mata : st_matrix("Total", rowsum(st_matrix("x_full")))
	matrix colnames Total = "Total"
	matrix FULL_`i' = x_full, Total 
	tempfile data_2`i'
	save `data_2`i''
	local++i
}
	esttab matrix(FULL_1)
	esttab matrix(FULL_2)
	
*------------------------------------------*
* Splitting Rater 1 and 2 Rater allocations 	
*------------------------------------------*

local i = 1 
forvalues x = 1/2 {
use `data_2`x'' , clear 
drop rannum insample insample2
reshape long video_, i(participantid site id_site) j(coder)
tab video_ ,  matcell(M)
scalar a = floor(M[1,1]/2)
scalar b = floor(M[2,1]/2)
set seed 3408
bysort video_ : generate rannum = runiform()  
sort video_ rannum
by video_ : gen index = _n
generate insample = 1 if index <= a & video_ == 1
replace insample = 2 if index <= b & video_ == 2
recode video (1 = 7) if insample == 1
recode video (2 = 8) if insample == 2 
label define coder 	7 "Coder 7" 8 "Coder 8" , add 
drop index insample rannum 
reshape wide video_ , i(participantid site id_site) j(coder) 

forvalues x = 1/6 {
	qui tab video_`x' , matcell(x_`x')
	matrix colnames x_`x' = "video_`x'"
	if `x' == 1 {
		matrix x_full = x_`x'
	}
	else {
		matrix x_full = (x_full, x_`x')
	}
}
#delimit ; 
matrix rownames x_full = 	"Coder 1"
							"Coder 2"
							"Coder 3"
							"Coder 4"
							"Coder 5"
							"Coder 6"
							"Coder 7"
							"Coder 8";
#delimit cr
mata : st_matrix("Total", rowsum(st_matrix("x_full")))
matrix colnames Total = "Total"
matrix FULL2_`i' = x_full, Total 
tempfile data_3`i'
save `data_3`i''
local++i
}

	esttab matrix(FULL2_1)
	esttab matrix(FULL2_2)

*-----------------------*
* combine the two files 	
*-----------------------*

use `data_31'
append using `data_32', generate(time)
label define session 0 "pre" 1 "post"
label values time session 


*-----------------------*
* Check Each Participants Rating Scheme 	
*-----------------------*


* Each participant is rated by a new combination in pre an post 
* some videos are rated by the same rater in pre-post video matches  

frame put id_site, into(new_frame)
frame change new_frame
duplicates drop
local my_local
forvalues j = 1/`=_N' {
    local my_local `my_local' `=id_site[`j']'
}
frame change default // OR RETURN TO WHATEVER FRAME YOU WERE IN

foreach id in `my_local' {
	list video* if id_site == "`id'"
}
save ${clean_data}/base.dta, replace 
	
*---------------------------------------------------*
* LONG DATA 
* To Run Random Effects Model / Use G-theory 
*---------------------------------------------------*

use ${clean_data}/base.dta, clear 
rename video_1 video_1_sc 
rename video_2 video_2_sc 
rename video_3 video_3_sc 
rename video_4 video_1_dc 
rename video_5 video_2_dc 
rename video_6 video_3_dc 
reshape long video_1_ video_2_ video_3_ , i(id_site participantid site time) j(double_code) string
reshape long video, i(id_site participantid site double_code time) j(task) string
encode task, gen(task_2)
drop task 
rename task_2 task
label define task_num 1 "Task 1" 2 "Task 2" 3 "Task 3"
label values task task_num 
encode double_code, gen(double_code_2)
drop double_code
rename double_code_2 double_code
label define double_code_num 1 "One" 2 "Two" 
label values double_code double_code_num 
rename video coder
save ${clean_data}/long.dta, replace

/*
set seed 3408
generate score = runiformint(0, 100)
xtmixed score || _all: R.coder || _all: R.double_code || _all: R.id_site if task == 1
*/ 

*---------------------------------------------------*
* WIDE DATA 
* SEM -> rater bias, video bias ect. 
*---------------------------------------------------*

use ${clean_data}/base.dta, clear 
rename video_1 video_1_sc 
rename video_2 video_2_sc 
rename video_3 video_3_sc 
rename video_4 video_1_dc 
rename video_5 video_2_dc 
rename video_6 video_3_dc 
reshape wide video*, i(id_site participantid site) j(time) 
local i = 1
forvalues k = 0/1 {
	forvalues x = 1/3 {
		foreach j in sc dc {
			qui tab video_`x'_`j'`k' , matcell(x_`x'_`j'`k')
			matrix colnames x_`x'_`j'`k' = "video_`x'_`j'`k'"
			if `i' == 1 {
				matrix x_full = x_`x'_`j'`k'
			}
			else {
				matrix x_full = (x_full, x_`x'_`j'`k')
			}
			local++i 
		}
	}
}
#delimit ; 
matrix rownames x_full = 	"Coder 1"
							"Coder 2"
							"Coder 3"
							"Coder 4"
							"Coder 5"
							"Coder 6"
							"Coder 7"
							"Coder 8";
#delimit cr
mata : st_matrix("Total", rowsum(st_matrix("x_full")))
matrix colnames Total = "Total"
matrix FULL = x_full, Total 
esttab matrix(FULL)
corr video*
save ${clean_data}/wide.dta, replace


*---------------------------------------------------*
* Rater specific files 
*---------------------------------------------------*

use  ${clean_data}/long.dta, clear

forvalues x = 1/8 {
	preserve
	keep if coder == `x'	
	drop id_site
	order coder site participantid task double_code time 
	save ${clean_data}/coder_`x'.dta , replace
	restore 
}
use ${clean_data}/coder_2.dta, clear 
       


