//----------------------------------------------------------------------------//
			* Table 2 - Replication Meta Analysis Template  *
//----------------------------------------------------------------------------//
global data_drive 
global root_drive 

cd $root_drive
use data_ipw_full_twang.dta, clear 

//----------------------------------------------------------------------------//
// Data Check  
//----------------------------------------------------------------------------//

// check Ns for connors
levelsof ma_study_num, local(levels)
foreach l of local levels {
	di "Study `l'"
	tab beh_rating_z if ma_study_num == `l' , missing
}

// check Ns for overall performance 
levelsof ma_study_num, local(levels)
foreach l of local levels {
	di "Study `l'"
	tab score_dc_avg_z if ma_study_num == `l' , missing
}

// Check covariates for missing 
local covs ///
ra_coaching block_encoded ///
ccs_gpa_c moedu_colab female race_wh score_dc_avg_bs_c ///
ccs_gpa_im female_im race_wh_im score_dc_avg_bs_im 
foreach c of local covs {
	codebook `c' 
}

// Recode missing block as 0 
levelsof ma_study_num, local(levels)
foreach l of local levels {
	di "Study `l'"
	tab block_encoded if ma_study_num == `l' , missing
}
recode block_encoded (. = 0)

//----------------------------------------------------------------------------//
// Regression Models
//----------------------------------------------------------------------------//

// Fully interacted model with randomization blocks as cluster SEs
regress score_dc_avg_z /// 
i.ra_coaching##ib3.ma_study_num ///
i.block_encoded ccs_gpa_c /// 
ccs_gpa_c moedu_colab female race_wh score_dc_avg_bs_c ///
ccs_gpa_im female_im race_wh_im score_dc_avg_bs_im ///
, vce(cluster block_encoded)

// Fully interacted model with sites as cluster SEs
regress score_dc_avg_z /// 
i.ra_coaching##ib3.ma_study_num ///
i.block_encoded ccs_gpa_c /// 
ccs_gpa_c moedu_colab female race_wh score_dc_avg_bs_c ///
ccs_gpa_im female_im race_wh_im score_dc_avg_bs_im ///
, vce(cluster ma_study_num)


// Individual Models 
global model_covariates ///
i.ra_coaching i.block_encoded ///
ccs_gpa_c moedu_colab female race_wh score_dc_avg_bs_c ///
ccs_gpa_im female_im race_wh_im score_dc_avg_bs_im 

// Study 1
regress score_dc_avg_z $model_covariates if ma_study_num== 1 , robust 
// Study 2
regress score_dc_avg_z $model_covariates if ma_study_num== 2 , robust 
// Study 3
regress score_dc_avg_z $model_covariates if ma_study_num== 3 , robust 
// Study 4
regress score_dc_avg_z $model_covariates if ma_study_num== 4 , robust 
// Study 5
regress score_dc_avg_z $model_covariates if ma_study_num== 5 , robust 



//----------------------------------------------------------------------------//
// Meta-Analytic Tables 
//----------------------------------------------------------------------------//

//----------------------//
// Overall Performance 
//----------------------//

capture program drop table2 
program table2, rclass 

syntax varlist(fv)

preserve

levelsof ma_study_num, local(levels)	 
foreach x of local levels {
	
	regress `varlist' ///
	if ma_study_num == `x' ///
	, robust 

	matrix M = r(table)
	scalar c = colsof(M)
	* To get pooled control group mean and Std
	qui sum `:word 1 of `varlist''  if ra_coaching == 0
	scalar thetacg = r(mean) 
	scalar thetasd = r(sd)
	* define all as column vectors and fill 
	mat M`x' = J(6,1,.)      	 
	* overall quality of pedagogical performance
	mat M`x'[1,1] = round(M[1,2],0.01)
	*standard errors in ()
	mat M`x'[2,1] = round(M[2,2],0.01)
	*control group mean 
	mat M`x'[3,1] = round(M[1,c],0.01)
	*control group standard deviation ()
	mat M`x'[4,1] = round(M[2,c],0.01)
	*blank 
	mat M`x'[5,1] = .
	*number of observations 
	mat M`x'[6,1] = e(N)
	if `x' == 1 {
		mat teM =  M1  //teM is treatment effect matrix [6,5]
	}
	else {
		mat teM = teM,M`x' 
	}
	
}
	 		
*creating dataset for the meta command 
matrix studies = ( 1, 2, 3, 4, 5 )' 
matrix errors = J(5,1,.) 
#delimit ;
global str_name "spring 2018" 
				"Fall 2018" 
				"spring 2019" 
				"fall 2019 tap" 
				"spring 2020" ;
#delimit cr

mata: K = st_matrix("studies")
mata: c = rows(K) 
mata: teM=st_matrix("teM")
mata: E = st_matrix("errors")
mata: teMb = teM[|1,1 \ 2,c|] //mark the top-left and the bottom-right element of the submatrix
mata: teMb = teMb'   // only contains the TE coefs 
mata: P = (K,teMb,E)
mata: st_matrix("output",P)


clear
matrix colnames output  = "study " "te1" "se1" "e"
svmat output , names(col)
gen study_label="Study 1 (Spring 2018)" if study==1
replace study_label="Study 2 (Fall 2018)" if study==2
replace study_label="Study 3 (Spring 2019)" if study==3
replace study_label="Study 4 (Fall 2019 TAP)" if study==4
replace study_label="Study 6 (Spring 2020)" if study==5	

*Run the meta command 
meta set te1 se1, studylabel(study_label) 
meta summarize, fixed 

*MM is meta matrix [6,1]
matr MM = J(6,1,.)
scalar theta = r(theta) 
scalar thetase = r(se) 
scalar q = r(Q)
mat MM[1,1] = round(theta,0.01)
mat MM[2,1] = round(thetase,0.01)
mat MM[3,1] = round(thetacg,0.01)
mat MM[4,1] = round(thetasd,0.01)
mat MM[5,1] = round(q,0.01)
mat MM[6,1] = .
mat final = (MM, teM)

#delimit ;
matrix colnames final =	 "Meta-analytic" 
						 "Study 1" 
						 "Study 2"
						 "Study 3"
						 "Study 4"
						 "Study 5";


matrix rownames final =  "Overall Quality"  
						 "se" 
						 "Constant" 
						 "se" 
						 "Q-statistic" 
						 "Analytic sample N" ;					  
#delimit cr

esttab matrix(final) 
return mat table2 = final

restore 

end 

// Create Table 
local varlist1 score_dc_avg_z i.ra_coaching i.block_encoded ///
ccs_gpa_c moedu_colab female race_wh score_dc_avg_bs_c  ///
ccs_gpa_im female_im race_wh_im score_dc_avg_bs_im 
table2 `varlist1'

//----------------------//
// Connors Outcome 
//----------------------//

capture program drop table2 
program table2_connors, rclass 

syntax varlist(fv)

preserve
drop if ma_study_num == 2
levelsof ma_study_num, local(levels)	 
foreach x of local levels {
	
	regress `varlist' ///
	if ma_study_num == `x' ///
	, robust 

	matrix M = r(table)
	scalar c = colsof(M)
	*To get pooled control group mean and Std
	qui sum `:word 1 of `varlist''  if ra_coaching == 0
	scalar thetacg = r(mean) 
	scalar thetasd = r(sd)
	* define all as column vectors and fill 
	mat M`x' = J(6,1,.)      	 
	* Overall quality of pedagogical performance
	mat M`x'[1,1] = round(M[1,2],0.01)
	*standard errors in ()
	mat M`x'[2,1] = round(M[2,2],0.01)
	*control group mean 
	mat M`x'[3,1] = round(M[1,c],0.01)
	*control group standard deviation ()
	mat M`x'[4,1] = round(M[2,c],0.01)
	*blank 
	mat M`x'[5,1] = .
	* number of observations 
	mat M`x'[6,1] = e(N)
	if `x' == 1 {
		mat teM =  M1  //teM is treatment effect matrix [6,5]
	}
	else {
		mat teM = teM,M`x' 
	}
	
}
	 		
*creating dataset for the meta command 
matrix studies = ( 1, 3, 4, 5 )' 
matrix errors = J(4,1,.) 
#delimit ;
global str_name "spring 2018" 
				"spring 2019" 
				"fall 2019 tap" 
				"spring 2020" ;
#delimit cr

mata: K = st_matrix("studies")
mata: c = rows(K) 
mata: teM=st_matrix("teM")
mata: E = st_matrix("errors")
mata: teMb = teM[|1,1 \ 2,c|] //mark the top-left and the bottom-right element of the submatrix
mata: teMb = teMb'   // only contains the TE coefs 
mata: P = (K,teMb,E)
mata: st_matrix("output",P)


clear
matrix colnames output  = "study " "te1" "se1" "e"
svmat output , names(col)
gen study_label="Study 1 (Spring 2018)" if study==1
replace study_label="Study 3 (Spring 2019)" if study==3
replace study_label="Study 4 (Fall 2019 TAP)" if study==4
replace study_label="Study 6 (Spring 2020)" if study==5	

*run the meta command 
meta set te1 se1, studylabel(study_label) 
meta summarize, fixed 

*MM is meta matrix [6,1]
matr MM = J(6,1,.)
scalar theta = r(theta) 
scalar thetase = r(se) 
scalar q = r(Q) 
mat MM[1,1] = round(theta,0.01)
mat MM[2,1] = round(thetase,0.01)
mat MM[3,1] = round(thetacg,0.01)
mat MM[4,1] = round(thetasd,0.01)
mat MM[5,1] = round(q,0.01)
mat MM[6,1] = .
mat final = (MM, teM)

#delimit ;
matrix colnames final =	 "Meta-analytic" 
						 "Study 1" 
						 "Study 3"
						 "Study 4"
						 "Study 5";


matrix rownames final =  "Overall Quality"  
						 "se" 
						 "Constant" 
						 "se" 
						 "Q-statistic" 
						 "Analytic sample N" ;					  
#delimit cr

esttab matrix(final) 
return mat table2 = final

restore 
end 

// Create Table 
local varlist2 beh_rating_z i.ra_coaching i.block_encoded ///
ccs_gpa_c moedu_colab female race_wh beh_rating_bs_c ///
ccs_gpa_im female_im race_wh_im beh_rating_bs_im 
table2_connors `varlist2'

