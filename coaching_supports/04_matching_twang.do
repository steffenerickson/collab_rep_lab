//----------------------------------------------------------------------------//
//			Box Drive globals 									  			  //
//----------------------------------------------------------------------------//
global data_drive 
global root_drive

cd $root_drive
//----------------------------------------------------------------------------//
//	Globals for twang stata package		//
//----------------------------------------------------------------------------//
* location of adofiles
global ado "${root_drive}/twang/ado files"
* location to put output
global objpath "${root_drive}/twang/output"
* location of R executable file on mac
global RScript "/usr/local/bin/Rscript"
/*install ado files*/
adopath + "$ado"

//----------------------------------------------------------------------------//
//    				 		             //
//	Generate Weights with TWANG  		 //
// 										 //
//  Create Dummy Indicators for each Study
//  Fit Seperate GBMs to each study 
//  Use Propensity Scores to compute weights 
// 	Uses twang function in R and RAND-STATA macros to obtain weights
//----------------------------------------------------------------------------//

cd $root_drive
use covariates_imputed_centered.dta, clear 

global covariates ///
female race_wh hsloc_3 hsach_3 hsses_2 tses_total_c tmas_total_c crtse_total_c ///
tses_cm_c ccs_gpa_c score_dc_avg_bs_c female_im race_wh_im hsloc_3_im ///
hsach_3_im hsses_2_im tses_total_im tmas_total_im crtse_total_im tses_cm_im ///
ccs_gpa_im score_dc_avg_bs_im


// Loop creates 4 temporary datafiles with the reference and comparison studies 
// and their ATT weights 

local ref 3
local j = 1
foreach i in 1 2 4 5 {
	preserve
	quietly {
	keep if ma_study_num == `i' | ma_study_num == `ref'
	gen treat = (ma_study_num == 3)
	cd "$objpath" 
	ps treat $covariates, ///
	ntrees(10000) /// -> number of iterations (trees) run. increase if warning
	intdepth(2) /// -> level of interactions (2) allows for all 2-way interact.
	shrinkage(0.01) /// -> smaller value requires a greater # of trees
	permtestiters(2) /// -> 0 = analytic approx. >0 is # of monte carlo trials 
	stopmethod(es.mean) /// -> stopping rules (max or avg) see Mcaffrey et. al 
	estimand(ATT) /// ATE or ATT 
	rcmd("$RScript") ///
	objpath("$objpath") ///
	plotname("replication_twang.pdf")
	*psplot:effect size (figure4)
	psplot, ///
	inputobj("$objpath/ps.RData") ///
	plotname(lalonde_es_`i'_`ref'.pdf) plotformat(pdf) ///
	plots(3) ///
	rcmd("$RScript") ///
	objpath("$objpath")
	}
	
	// Creates balance table conparing weighted and unweighted covariates 
	// mean differences
	
	di "study `i' vs `ref'"
	
	balance, summary unweighted 
	
	mat M = r(coefs)
	mat M`i'`ref' = (M[1..., 1],M[1..., 3])
	mat UW_Diff =  M`i'`ref'[1..., 1] -  M`i'`ref'[1..., 2]

	balance, summary weighted 
	
	mat M = r(coefs)
	mat M`i'`ref' = (M[1..., 1],M[1..., 3])
	mat W_Diff =  M`i'`ref'[1..., 1] -  M`i'`ref'[1..., 2]
	
	mat balance`i'`ref' = (UW_Diff, W_Diff)
	
	mat li  balance`i'`ref'
	
	tempfile data`j'
	save `data`j'',replace
	restore
	local ++ j
	
}

//-------------------------//
// Append Individual Files 	
//-------------------------//		                
preserve 
forvalues x =  2/4 {
	use `data`x'', clear 
	drop if ma_study_num == 3 
	tempfile data_temp_`x'
	save `data_temp_`x''
}
use `data1', clear
append using `data_temp_2' `data_temp_3' `data_temp_4' 
*egen  = rowtotal(weight_*)
*egen ip = rowtotal(ipw_group_*)
cd "/Users/steffenerickson/Desktop/repos/collab_rep_lab/06_replication_paper_updates/output"
save data_ipw_full_twang.dta, replace
restore 

// Display Balance tables 

foreach j in 1 2 4 5 {
	esttab mat(balance`j'3) ///using balance`j'.csv , replace
}


// ---------------------------------------------------------------------------//
// Vefify Balance Tables with Tabstat 
// ---------------------------------------------------------------------------//

use data_ipw_full_twang.dta, clear 
global covariates2 ///
female race_wh hsloc_3 hsach_3 hsses_2 tses_total_c ///
tmas_total_c crtse_total_c tses_cm_c ccs_gpa_c  ///
score_dc_avg_bs_c 

local ref = 3 
foreach j in 1 2 4 5 {

	// Unweighted 
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `j', ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_vec1 = e(mean)'
	mat li mean_vec1
	
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `ref', ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_vec2 = e(mean)'
	mat li mean_vec2
	mat diff1 = mean_vec1 - mean_vec2
	
	
	// weighted 
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `j' [aw=esmeanatt], ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_veca1 = e(mean)'
	mat li mean_veca1
	
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `ref' [aw=esmeanatt], ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_veca2 = e(mean)'
	mat li mean_veca2
	mat diff2 = mean_veca1 - mean_veca2
	
	mat balance`j' = (diff1 , diff2)
	mat colnames balance`j' = "b_weighting" "a_weighting"
	//esttab mat(balance`j') , title("study `j' vs. `ref'")

}

foreach j in 1 2 4 5 {
	esttab mat(balance`j') using balance`j'.csv , replace
}

// Treatment vs. control contrasts 
local ref = 3 
foreach j in 1 2 4 5 {

	// Unweighted 
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `j', ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_vec1 = e(mean)'
	mat li mean_vec1
	
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `ref', ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_vec2 = e(mean)'
	mat li mean_vec2
	mat diff1 = mean_vec1 - mean_vec2
	
	
	// weighted 
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `j' [aw=esmeanatt], ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_veca1 = e(mean)'
	mat li mean_veca1
	
	eststo: qui estpost tabstat $covariates2 if ma_study_num == `ref' [aw=esmeanatt], ///
		stat(mean sd) columns(statistics) 
	esttab, cells("mean sd") nomtitle nonumber
	mat mean_veca2 = e(mean)'
	mat li mean_veca2
	mat diff2 = mean_veca1 - mean_veca2
	
	mat balance`j' = (diff1 , diff2)
	mat colnames balance`j' = "b_weighting" "a_weighting"
	//esttab mat(balance`j') , title("study `j' vs. `ref'")

}




















use data_ipw_full_twang.dta, clear 
global model_covariates ///
i.ra_coaching i.block_encoded ///
ccs_gpa_c moedu_colab female race_wh score_dc_avg_bs_c crtse_total_c ///
ccs_gpa_im female_im race_wh_im score_dc_avg_bs_im crtse_total_im

recode block_encoded (. = 0)



// esmeanatt weighted models  //------------------------------------

regress score_dc_avg_z $model_covariates if ma_study_num== 1 [pweight=esmeanatt ] , robust 
mat M = r(table)
scalar te1 = M[1,2]
scalar se1 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 2 [pweight=esmeanatt ] , robust 
mat M = r(table)
scalar te2 = M[1,2]
scalar se2 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 3 [pweight=esmeanatt ]  , robust 
mat M = r(table)
scalar te3 = M[1,2]
scalar se3 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 4 [pweight=esmeanatt ]  , robust 
mat M = r(table)
scalar te4 = M[1,2]
scalar se4 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 5 [pweight=esmeanatt ] , robust 
mat M = r(table)
scalar te5 = M[1,2]
scalar se5 = M[2,2]

mat te4 = (te1, te2, te3, te4 ,te5)
mat se4 = (se1, se2, se3, se4, se5)

correspondence te4 se4 .05 1 3
table3 teb seb te4 se4 .05 1 
list if type == 1

// ksmeanatt weighted models  //------------------------------------


use data_ipw_full_twang.dta, clear 


regress score_dc_avg_z $model_covariates if ma_study_num== 1 [pweight=ksmeanatt ] , robust 
mat M = r(table)
scalar te1 = M[1,2]
scalar se1 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 2 [pweight=ksmeanatt ] , robust 
mat M = r(table)
scalar te2 = M[1,2]
scalar se2 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 3 [pweight=ksmeanatt ]  , robust 
mat M = r(table)
scalar te3 = M[1,2]
scalar se3 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 4 [pweight=ksmeanatt ]  , robust 
mat M = r(table)
scalar te4 = M[1,2]
scalar se4 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 5 [pweight=ksmeanatt ] , robust 
mat M = r(table)
scalar te5 = M[1,2]
scalar se5 = M[2,2]

mat te5 = (te1, te2, te3, te4 ,te5)
mat se5 = (se1, se2, se3, se4, se5)

correspondence te5 se5 .05 .2 3
table3 teb seb te5 se5 .05 .8 
list if type == 1



/*



//------------------//
// Checking Correspondence for Study 3
//------------------//

//--------------------------------------------------------//
// -- uses standardized mean differences of covariates -- //
//--------------------------------------------------------//

// Unweighted 

regress score_dc_avg_z /// on 
i.ra_coaching##ib3.ma_study_num ///interaction 
i.block_encoded ccs_gpa_c /// 
female race_wh score_dc_avg_bs_c moedu_colab ///
if ma_study_num== 1 | ma_study_num == 3, robust 
mat M = r(table)
scalar te3 = M[1,2]
scalar se3 = M[2,2]
lincom [ (1.ra_coaching) + (1.ra_coaching#1.ma_study_num) ]
scalar te1 = r(estimate)
scalar se1 = r(se)
mat te = (te3, te1)
mat se = (se3, se1)

correspondence te se .05 .5 1


//Weighted - correspondence output - study 3 is the adjusted study 1 , stufy 2 is unadjusted study 1

regress score_dc_avg_z /// on 
i.ra_coaching##ib3.ma_study_num ///interaction 
i.block_encoded ccs_gpa_c /// 
female race_wh score_dc_avg_bs_c moedu_colab ///
[pweight=esmeanatt] ///
if ma_study_num== 1 | ma_study_num == 3, robust 
mat M = r(table)
scalar te3 = M[1,2]
scalar se3 = M[2,2]
lincom [ (1.ra_coaching) + (1.ra_coaching#1.ma_study_num) ]
scalar te1a = r(estimate)
scalar se1a = r(se)
mat te = (te3, te1, te1a)
mat se = (se3, se1, se1a)

correspondence te se .05 .5 1


//--------------------------------------------------------//
// -- ks statisitc - weighted empirical distribution fucntions for each sample (compares entire distribution -- //
//--------------------------------------------------------//

// Unweighted 

regress score_dc_avg_z /// on 
i.ra_coaching##ib3.ma_study_num ///interaction 
i.block_encoded ccs_gpa_c /// 
female race_wh score_dc_avg_bs_c moedu_colab ///
if ma_study_num== 1 | ma_study_num == 3, robust 
mat M = r(table)
scalar te3 = M[1,2]
scalar se3 = M[2,2]
lincom [ (1.ra_coaching) + (1.ra_coaching#1.ma_study_num) ]
scalar te1 = r(estimate)
scalar se1 = r(se)
mat te = (te3, te1)
mat se = (se3, se1)

correspondence te se .05 .5 1


//Weighted - correspondence output - study 3 is the adjusted study 1 , stufy 2 is unadjusted study 1

regress score_dc_avg_z /// on 
i.ra_coaching##ib3.ma_study_num ///interaction 
i.block_encoded ccs_gpa_c /// 
female race_wh score_dc_avg_bs_c moedu_colab ///
[pweight=ksmaxatt] ///
if ma_study_num== 1 | ma_study_num == 3, robust 
mat M = r(table)
scalar te3 = M[1,2]
scalar se3 = M[2,2]
lincom [ (1.ra_coaching) + (1.ra_coaching#1.ma_study_num) ]
scalar te1a = r(estimate)
scalar se1a = r(se)
mat te = (te3, te1, te1a)
mat se = (se3, se1, se1a)

correspondence te se .05 .5 1


//-----------------------------
// No interaction 

regress score_dc_avg_z /// on 
i.ra_coaching ///interaction 
i.block_encoded ccs_gpa_c /// 
female race_wh score_dc_avg_bs_c moedu_colab ///
[pweight=ksmaxatt] ///
if ma_study_num== 1 , robust 

*/
