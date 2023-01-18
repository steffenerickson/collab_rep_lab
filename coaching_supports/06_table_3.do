//----------------------------------------------------------------------------//
		//		Table 3 Final Results   //
//----------------------------------------------------------------------------//
global data_drive 
global root_drive 
global programs 

do ${programs}/01_correspondence_test.do
do ${programs}/02_table_3_program.do

cd $root_drive
use data_ipw_full_twang.dta, clear 

recode block_encoded (. = 0)

//------------------//
// Model covariates 
//------------------//
global model_covariates ///
i.ra_coaching i.block_encoded ///
ccs_gpa_c moedu_colab female race_wh score_dc_avg_bs_c  ///
ccs_gpa_im female_im race_wh_im score_dc_avg_bs_im 

//----------------------------------------------------------------------------//
// Unadjusted 
//----------------------------------------------------------------------------//
regress score_dc_avg_z $model_covariates if ma_study_num== 1, robust 
mat M = r(table)
scalar te1 = M[1,2]
scalar se1 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 2, robust 
mat M = r(table)
scalar te2 = M[1,2]
scalar se2 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 3, robust 
mat M = r(table)
scalar te3 = M[1,2]
scalar se3 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 4, robust 
mat M = r(table)
scalar te4 = M[1,2]
scalar se4 = M[2,2]

regress score_dc_avg_z $model_covariates if ma_study_num== 5, robust 
mat M = r(table)
scalar te5 = M[1,2]
scalar se5 = M[2,2]

mat teb = (te1, te2, te3, te4 ,te5)
mat seb = (se1, se2, se3, se4, se5)


// Correspondence Function 
correspondence teb seb .05 .2 3

//----------------------------------------------------------------------------//
// Esmeanatt weighted models  
//----------------------------------------------------------------------------//
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

// Correspondence Function 
correspondence te4 se4 .05 .2 3

//----------------------------------------------------------------------------//
// Create Table 3 
//----------------------------------------------------------------------------//

preserve
table3 teb seb te4 se4 .05 .2 
gen index = _n
keep correspondence index 
rename correspondence correspondence_02
tempfile data1
save `data1'
restore

table3 teb seb te4 se4 .05 1 
gen index = _n
rename correspondence correspondence_1

merge 1:1 index using `data1'
drop _merge index
order type study_comparison source_of_variation study te se sig difference p_value correspondence_02 correspondence_1

list 


