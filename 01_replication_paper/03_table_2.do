********************************************************************************
			* Table 2 - Replication Meta Analysis Template  *
			
			
			
			
			
			
********************************************************************************	
quietly {
matrix drop _all 
estimates drop _all	
	

*commands defined earlier 
${data}	
${exclude}


	* Start of the table
	 
	*set trace on 
	foreach x in $study_numbers {
	 
	  *foreach loop for outcome type needs to be here 
	
	 #delimit ;

	eststo: regress $outcome_variable_z i.ra_coaching i.block_encoded 
	ccs_gpa moedu_colab 
	gender_female race_white score_dc_avg_bs 
	if ma_study_num== `x'
	, robust ;
	
	#delimit cr
	
	matrix M = r(table)
	 
	*To get control group mean an Std
	sum $outcome_variable if ma_study_num == `x' & ra_coaching == 0
	scalar cg = r(mean) 
	scalar sd = r(sd)
	
	*To get pooled control group mean and Std
	sum $outcome_variable if ra_coaching == 0
	scalar thetacg = r(mean) 
	scalar thetasd = r(sd)
	

	 * define all as column vectors and fill 
	 
	 matrix M`x' = J(6,1,.)      	 
	* . creates missing 
	 
	 * Overall Quality of Pedagogical Performance
	 scalar b = M[1,2] //append to column in each loop 
	 matrix M`x'[1,1] = round(M[1,2],0.01)
						
	 *standard errors in ()
	 scalar se = M`x'[2,2]
	 matrix M`x'[2,1] = round(M[2,2],0.01)
	 
	 *control group mean 
	 matrix M`x'[3,1] = round(cg,0.01)
	 
	 *control group standard deviation ()
	 matrix M`x'[4,1] = round(sd,0.01)
	 
	 *blank 
	 scalar blank = .
	 matrix M`x'[5,1] = blank
	 
	 * number of observations 
	 scalar n = e(N)
	 matrix M`x'[6,1] = n 
	 
	 if `x' == 1 {
	 	matrix teM =  M1  //teM is treatment effect Matrix [6,5]
	 }
	 else {
		matrix teM = teM,M`x' //column binding one at a time in each loop 
	 }
	 
	 
	 matrix list teM
	}
	 		
	*creating dataset for the meta command 

	matrix studies = ( 1, 2, 3, 4, 5 )' //these lines will be at the top 
	matrix errors = J(5,1,.) // place holder 
	#delimit ;
	global str_name "spring 2018" 
					"Fall 2018" 
					"spring 2019" 
					"fall 2019 tap" 
					"spring 2020" ;
	#delimit cr

		mata 
			

			K = st_matrix("studies")
			K
			c = rows(K) 
			teM=st_matrix("teM")
			E = st_matrix("errors")
			E
			
			teMb = teM[|1,1 \ 2,c|] //mark the top-left and the bottom-right element of the subm4atrix
			teMb
			teMb = teMb'   // only contains the beta estimates on the TE coefs 
			teMb					// and the std errors's transpose
			P = (K,teMb,E)
			P
			st_matrix("output",P)

 
		end 
		

	matrix colnames output  = "study " "te1" "se1" "e"
	
	cd "${results}"
	esttab matrix(output) using metatable.csv, plain replace
	
	import delimited "${results}/metatable.csv", varnames(2) rowrange(1) colrange(2) clear
	
	gen study_label="Study 1 (Spring 2018)" if study==1
	replace study_label="Study 2 (Fall 2018)" if study==2
	replace study_label="Study 3 (Spring 2019)" if study==3
	replace study_label="Study 4 (Fall 2019 TAP)" if study==4
	replace study_label="Study 6 (Spring 2020)" if study==5	

	*Run the meta command 

	    meta set te1 se1, studylabel(study_label) // what does this do?
	
		meta summarize, fixed // model 	
		*MM is meta matrix [6,1]
		matrix MM = J(6,1,.)

		scalar theta = r(theta) 
		scalar thetase = r(se) 
		*scalar thetacg = . calculated above using full data 
		*scalar thetasd = . calculated above using full data 
		scalar q = r(Q) 

		matrix MM[1,1] = round(theta,0.01)
		matrix MM[2,1] = round(thetase,0.01)
		matrix MM[3,1] = round(thetacg,0.01)
		matrix MM[4,1] = round(thetasd,0.01)
		matrix MM[5,1] = round(q,0.01)
		matrix MM[6,1] = blank

        matrix final = (MM, teM)
	
	*commands defined earlier
	${table2colnames}
	${table2rownames}

	*Export 
}
	if k == 1 {
		esttab matrix(final) 
		esttab matrix(final) using ${table2}.csv,replace
	}
	if k != 1 {
		esttab matrix(final) 
	}
	