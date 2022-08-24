********************************************************************************                
						  ** Table 3  **					
				   *Correspondence Test Tables *							
********************************************************************************	


		**********************************
			  ** Base Study Results **
		**********************************



matrix drop _all 
estimates drop _all	
	

cd ${results}
${data}	
${exclude}

	
	local i = 1
	forvalues x = 1/5 {
	 
	#delimit ;

	regress score_dc_avg_z i.ra_coaching i.block_encoded 
	ccs_gpa moedu_colab 
	gender_female race_white score_dc_avg_bs 
	if ma_study_num== `x'
	, robust ;
	
	#delimit cr
	
	matrix M = r(table)
	
	scalar te = M[1,2]
	scalar se = M[2,2]
	matrix df`i' = e(df_r) 
	
	
	*columnn vector 
	matrix col`i' = (te,se)'
	
	if `i' == 1 { // * if loop 1, create a matrix called T
		matrix T = col`i'
		matrix D = df`i'
	}
	else {  // If loop 2..n,  bind new column vector to T
		matrix T = T,col`i'
		matrix D = D\df`i' 
	}
	
	local++i
	}
	
	*need to define reference somehow

	matrix rownames T = "te" "se" 		
	*matrix colnames T = 
	
	*need to specify reference study 
	




		***************************
			*Correspondence Test *
		***************************
		
	*Inputs for the function 
	* (1) row names 
		
	*Effect Estimates 
	#delimit ;

	
	 global table3rownames matrix rownames effect_stats =  "1"  
														   "2"  
														   "3" 
														   "4"  
														   "5" ;
	 
	 #delimit cr
	 
	 *Difference Test 
	 #delimit ;
	 
	 global table3difftestrownames matrix rownames 
	 difference_stats =  "1_vs_3" 
						 "2_vs_3"
						 "4_vs_3"
						 "5_vs_3" ;
	 #delimit cr
	 
	
	*Equivalence Test
	#delimit ;
	 global table3equivtestrownames matrix rownames 
	 equiv_stats  =  "1_vs_3" 
					 "2_vs_3"
					 "4_vs_3"
	                 "5_vs_3" ;
	#delimit cr	
	
	*Correspodence Test
	 #delimit ;
	 global table3corrtestrownames matrix rownames 
	 correspondence =    "1_vs_3" 
						 "2_vs_3"
						 "4_vs_3"
						 "5_vs_3" ;
	 #delimit cr
	 
	 
	
	* (2) mata inputs 
	mata 
	mata clear 
	refstudy = 3
	alpha = .05
	e_th = 1
	end 

	*Input is Matrix T with Treatment Effects and SE's 
	
	do "${programs}/06_correspondence.do"
	
	
	*output file names 
	
	
	/*uncomment for full results 
	if k == 1 {
	esttab matrix(effect_stats) using effect_stats_base.csv,replace
	esttab matrix(difference_stats) using difference_stats_base.csv,replace
	esttab matrix(equiv_stats) using equiv_stats_base.csv,replace
	esttab matrix(correspondence) using correspondence_stats_base.csv,replace
	
	}
	*/

	
	*Treatment Effects 
	matrix compare = (effect_stats[1..2,1...]\effect_stats[4..5,1...])
	

	foreach i in 1 2 4 5  {
		
	matrix c`i'	= (effect_stats[3,1...]\effect_stats[`i',1...])
		
	#delimit ;
		
		matrix rowname c`i' = "`i'_vs_3" 
					          "`i'_vs_3" ;
	#delimit cr	
	
	if `i' == 1 {
		matrix base_te = c`i'
	} 
	else {
	matrix base_te = base_te\c`i'
	}
		
			
	}
	
	
	
	matrix base_te  = (base_te[1...,1..2],base_te [1...,6])
	
	matrix colnames base_te = "te" "se" "sig"
	
	local rownames: rowfullnames base_te 
	local c : word count `rownames'
	
	
	clear 
	svmat base_te  , names(col)
	
	
	gen studies = ""
	forvalues i = 1/`c' { 
		replace studies = "`:word `i' of `rownames''" in `i'
		
	}
	
	sort studies 
	by studies: gen index = _n
	tempfile base_te
	save `base_te'
	
	
	
	*correspondence Test
	matrix base = (difference_stats,equiv_stats,correspondence)
	matrix base = (base[1...,1],base[1...,3],base[1...,13])
	

	matrix base = (base\base)
	
	matrix colnames base = "difference" "p_value" "correspondence"
	
	local rownames: rowfullnames base 
	local c : word count `rownames'
	
	
	clear 
	svmat base , names(col)
	
	
	gen studies = ""
	forvalues i = 1/`c' { 
		replace studies = "`:word `i' of `rownames''" in `i'
		
	}
	sort studies 
	by studies: gen index = _n
	tempfile base_corr
	save `base_corr'

	use `base_te',clear 
	merge 1:1 studies index using `base_corr'
	
	gen type = "base"
	drop _merge 
	tempfile base_full
	save `base_full'


	


  **********************************
     ** Adjusted Study Results **
  **********************************	
  
  matrix drop _all 
  estimates drop _all	
	
	
	*calculate IVP weights 
  do "${programs}/05_invpw.do"
  
  
   *Model 1 
local ref 3
foreach i in 1 2 4 5 {
	
	#delimit ;
	
	*Need to set the reference as the control for the ;
	*compiled table results to be correct;
	* set to study 3 right now | ib3.ma_study_num |; 
	
	regress score_dc_avg_z i.ra_coaching##ib3.ma_study_num i.id_section 
	[pweight=weight] if ma_study_num == `i' | ma_study_num == `ref' ;
	
	#delimit cr
	
	matrix M = r(table)
	
	scalar te_ref = M[1,2]
	scalar se_ref = M[2,2]
	
	if `i' <= 2 {
		scalar te = M[1,2] + M[1,7] 
		scalar se = M[2,7]
		
	} 
	if `i' >= 4 {
		scalar te = M[1,2] + M[1,8] 
		scalar se = M[2,8]
	}
	
	
	matrix D_`i' = e(df_r) 
	matrix T_`i' = (te_ref, te \ se_ref, se)

	
} 


  		***************************
			*Correspondence Test *
		***************************
  
  	mata 
	mata clear 
	refstudy = 1 //This will always be one 
	alpha = .05
	e_th = 1
	end 
  

 
  *Need to call the function for each pairwise comparison because the 
  *baseline Treatment effect changes
  
	* (2) mata inputs

 
foreach i in 1 2 4 5 {
	
	 *i(1) Switch the row and column names inputs 
	*Effect Estimates 
	global table3rownames matrix rownames effect_stats =  "`i'_vs_3" "`i'_vs_3" 
	 
	*Difference Test 
	global table3difftestrownames matrix rownames difference_stats =  "`i'_vs_3" 
	 
	*Equivalence Test
	global table3equivtestrownames matrix rownames equiv_stats  = "`i'_vs_3"  


	*Correspodence Test
	global table3corrtestrownames matrix rownames correspondence =  "`i'_vs_3" 
	
	
	matrix T = T_`i'
	matrix D = D_`i'
	
	do "${programs}/06_correspondence.do"
	
	
	matrix effect_stats_`i' = effect_stats
	matrix difference_stats_`i' = difference_stats
	matrix equiv_stats_`i' = equiv_stats
	matrix correspondence_`i' = correspondence
	
	
	}
	
	*Append as one long table 
	matrix effect_stats_master = (effect_stats_1\ effect_stats_2\ effect_stats_4\ effect_stats_5)
	matrix difference_stats_master = (difference_stats_1\ difference_stats_2\ difference_stats_4\ difference_stats_5)
	matrix equiv_stats_master = (equiv_stats_1\ equiv_stats_2\ equiv_stats_4\ equiv_stats_5)
	matrix correspondence_master = (correspondence_1\ correspondence_2\ correspondence_4\ correspondence_5)
	
	*uncomment for full results 
	/*
	if k == 1 {
	esttab matrix(effect_stats_master) using effect_stats_adjust.csv,replace
	esttab matrix(difference_stats_master) using difference_stats_adjust.csv,replace
	esttab matrix(equiv_stats_master) using equiv_stats_base_adjust.csv,replace
	esttab matrix(correspondence_master) using correspondence_stats_adjust.csv,replace
	}
	*/
	
	
	*Treatment Effects 
	matrix adj_effect = (effect_stats_master[1...,1..2],effect_stats_master[1...,6])
	
	matrix colnames adj_effect = "te" "se" "sig"
	
	local rownames: rowfullnames adj_effect
	local c : word count `rownames'
	
	
	clear 
	svmat adj_effect , names(col)
	
	
	gen studies = ""
	forvalues i = 1/`c' { 
		replace studies = "`:word `i' of `rownames''" in `i'
		
	}
	
	sort studies 
	by studies: gen index = _n
	tempfile adjust_te
	save `adjust_te'
	
	*correspondence Test 
	matrix adjust = (difference_stats_master,equiv_stats_master,correspondence_master)
	matrix adjust = (adjust[1...,1],adjust[1...,3],adjust[1...,13])
	
	
	matrix adjust = (adjust\adjust)
	
	matrix colnames adjust = "difference" "p_value" "correspondence"
	
	local rownames: rowfullnames adjust 
	local c : word count `rownames'
	
	
	clear 
	svmat adjust , names(col)
	
	
	gen studies = ""
	forvalues i = 1/`c' { 
		replace studies = "`:word `i' of `rownames''" in `i'
		
	}
	sort studies 
	by studies: gen index = _n
	tempfile adjust_corr
	save `adjust_corr'

	use `adjust_te',clear 
	merge 1:1 studies index using `adjust_corr'
	
	gen type = "adjusted"
	drop _merge 
	tempfile adjust_full
	save `adjust_full'



  
  
****************************************
*Putting the Beast together 
****************************************  
  
  
  use `base_full' , clear
  append using `adjust_full'
  
  
 * Final Data cleaning 

cap drop study_num
gen study_num = substr(studies,1,1) if index == 2
replace study_num = substr(studies,6,1) if index == 1
destring study_num, replace

label define corr_test 1 "Trivial Difference " 2 "Difference" 3 "Equivalence " 4 "Indeterminacy"
label values correspondence corr_test 


encode type, gen(type_2)
recode type_2 (2 = 0)
drop type
rename type_2 type 
label define method 0 "Un-adjusted" 1 "Adjusted"
label values type method

encode studies, gen(source_of_variation)

encode studies, gen(study_comparison)
label define pairwise 1 "Study 1 vs Study 3" 2 "Study 2 vs Study 3" 3 "Study 4 vs Study 3" 4 "Study 5 vs Study 3" 
label values study_comparison pairwise

label define study_type 1 "Timing of Study" 2 "Teaching Task" 3 "Participant characteristics and concurrent coursework" 4 "Delivery"
label values source_of_variation study_type


sort studies type index
drop index studies 
rename study_num study 


order type study_comparison source_of_variation study 

list 

if k == 1 {
save table3.dta, replace 
outsheet using ${table3}.csv, replace
}
  
  
  
  
  

  
