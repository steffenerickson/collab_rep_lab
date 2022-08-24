********************************************************************************
/*						*Replicating analysis *
*						 * Master Do File *
		
 Author: Anandita Krishnamachari, Steffen Erickson, Qiu Liu 	
 Contents (1) Table 1 (line 129) creates Table 1: Descriptive statistics 
			  across replication studies. do file -> 02_table_1.do	
		  (2) Table 2 (line 190) creates Table 2: Meta-Analytic Average 		
			  Treatment Effect Size, and Average Treatment Effect Size by 
			  Study. do file -> 03_table_2.do
		  (3) Table 3 (line 234)creates Table 3: Replication success across 
			  series of systematic replication studies. 
			  do file -> 04_table_3.do. Two programs run in this file to 
			  produce the table estimates. 06_correspondence.do runs to 
			  conduct the correspondence test. 05_invpw.do runs to 
			  calculate the inverse probability weights for the adjusted 
			  samples listed in the table. This file also creates 
			  Tables A12.1, Table A12.2, Table A12.3, and Table A12.4 
			  (Standardized Differences between study 3 and #)
		  (4) Balance Table (line 234) creates A7 - A11 (Balance table for full
			  and analytic samples for Study #)
		  (5) Bootstrapping (Line ) creates bootstrapped samples to 
			  recalculate the standard errors for studies 3 and 2 


*/ 

********************************************************************************

							* PROGRAM SET UP  * 
	
********************************************************************************
	clear all 
	set more off 
	
	*****************************************************
					* Set Directories *
	*****************************************************
	* Home *
	global data_drive "/Users/steffenerickson/Box Sync/Project SimTeacher/9. Data (SimTeacher)/Replication Data (All Years)/Final Analytic Files" 
	* Results folder *
	
	global results "/Users/steffenerickson/Desktop/collab_rep_lab/2021-2022/replicating_analysis/01_replication_analysis/03_results"  
	
	*Programs Folder *
	global programs "/Users/steffenerickson/Desktop/collab_rep_lab/2021-2022/replicating_analysis/01_replication_analysis/01_do_files" 
	
	*****************************************************
					* Data Files *
	*****************************************************

	*Analytic data file
	global data use  "${data_drive}/Replication_Final_Analytic.dta", clear
	
	*Data to calculate ivpws
	global data2 use "${data_drive}/HTE_Outcomes_CPP_Final_Jan2021.dta", clear 
	
	*Data to for baseline balance tables 
	* spring 2018 
	global data3 use "${data_drive}/Spring2018_Final_Analytic.dta", clear 
	global data4
	global data5
	global data6
	global data7 
	
   	*****************************************************
					* Switches *
	*****************************************************
   
   *Write out csv files? "yes" for YES and "no" for NO. simple 
   
   ************************
	  global switch1 "yes"
   ************************
   
   * Write out log file?  * "yes" for YES and "no" for NO. simple
   
   ************************
	  global switch2 "no"
   ************************

  
	quietly {
	if "${switch1}" == "yes" {
		scalar k = 1
	}
	if "${switch1}" !=  "yes" {
		scalar k = 0
	}
	
	if "${switch2}" == "yes" {
		scalar t = 1
	}
	if "${switch2}" !=  "yes" {
		scalar t = 0
	}
	}
	
	*****************************************************
					* Log file  *
	*****************************************************	
	
	if t == 1 {
		
	
	log using "${results}/tablelog.smcl", replace	
	
	#delimit ;
	global logtranslate 
			capture log close;
			translate "${results}/tablelog.smcl"
					  "${results}/tablelog.pdf"
					   , replace;				
	#delimit cr 					
	
	}

	*****************************************************
	* Drop studies not needed for analysis 
	*****************************************************
	
	global exclude drop if ma_study=="Fall 2019" | ma_study=="Fall 2017"

********************************************************************************
							
							* TABLE SET UP *
							
********************************************************************************	

	*****************************************************
					* Table 1 set up *
	*****************************************************
	
	*This table is fully adjustable using inputs from this masterfile. 
	*The covariates are compared across study using a regression adjusted mean
	* difference 
	
	*Name of exported table 
	global table1 "table1"
	

	
	
	*covariates to compare across studies 
	global demo ccs_gpa partch_either moedu_colab faedu_colab ///
	gender_female age_21ab race_white hsloc_1 hsloc_2 hsloc_3 ///
	hsses_1 hsses_2 hsses_3 hsrace_1 hsrace_2 hsrace_3 hsach_1 ///
	hsach_2 hsach_3 
	
	
	*size of table _rows are number of covariates and columns are the number 
	*of studies
	matrix balance = J(19,5,.)
	
	#delimit ;
	
	global table1colnames matrix colnames balance = 
										  "Spring 2018" 
										  "Fall 2018" 
										  "Spring 2019" 
										  "Fall 2019 Tap" 
										  "Spring 2020" ;

								
	global table1rownames matrix rownames balance = 
										  "GPA"  
										  "% Either parent a teacher" 
										  "% Mother education"
										  "% Father education"
										  "% Female"
										  "% Over the age of 21"
										  "% White"
										  "% Rural"
										  "% Suburban"
										  "% Urban"
										  "% Low SES"
										  "% Middle SES"
										  "% High SES"
										  "% Primarily students of color"
										  "% Mixed"
										  "% Primarily white students"
										  "% Primarily low achieving"
										  "% Primarily middle"
										  "% Primarily high achieving" ;
	#delimit cr
	
	
	do "${programs}/02_table_1.do"
	
	*****************************************************
				* table 2 set up *
	****************************************************
	
	*Currently you must manually change lines 90-98 and 129-133 in 03_table_3
	* to add/change study names 
	
	*Name of exported table 
	global table2 "score_dc_avg_table2"
	
	*Add the study numbers you are comparing
	global study_numbers 1 2 3 4 5 
	
	*Add the same twice variable if you do not want to show the raw score 
	*control group mean in the table (as opposed to the standardized control group mean)
	global outcome_variable_z score_dc_avg_z
	global outcome_variable score_dc_avg
	
	*size of table rows are fixed, columns are the number of studies + 1 
	matrix final = J(6,6,.)
	#delimit ;
	global table2colnames matrix colnames final = 
										  "Meta-analytic" 
										  "Study 1" 
										  "Study 2"
										  "Study 3"
										  "Study 4"
										  "Study 5";
	
	global table2rownames matrix rownames final = 
										  "Overall Quality"  
										  "se" 
										  "Control Mean" 
										  "sd" 
										  "Q-statistic" 
										  "Analytic sample N" ;					  
	#delimit cr
	
	
	do "${programs}/03_table_2.do"
	
     *****************************************************
				* table 3 set up *
	 *****************************************************
	 
	 *Currently there is no flexibility in this table 
	 
	 
	 *If you would like to change the threshold for the Equivalency test, 
	 * Change 	alpha = .05
	 *           e_th = .5
	 * in lines 119-124 and 290-294
	 *threshold is set to 1 sd right now 
	 
	 
	 *Name of exported table 
	 global table3 "table3_.2sd_threshold"
	 
	 
	 do "${programs}/04_table_3.do"
	 
	 *****************************************************
			* Balance Table Set Up *
	 *****************************************************
	 
	*Produce for each study baseline datafile - change file here
	
	$data3
	
	*covariates to compare across samples 
	global demo2 ccs_gpa partch_either moedu_colab faedu_colab ///
	gender_female age_21ab race_white hsloc_1 hsloc_2 hsloc_3 ///
	hsses_1 hsses_2 hsses_3 hsrace_1 hsrace_2 hsrace_3 hsach_1 ///
	hsach_2 hsach_3 tses_av 

	#delimit ;
	
	global balancecolnames matrix colnames balance_full = 
								   "Full Control Group Mean" 
								   "Full Coaching group difference" 
								   "AS Control Group Mean" 
								   "AS Coaching group difference" ;
	
	

	global balancerownames matrix rownames balance_full = 
										  "GPA"  
										  "se"
										  "% Either parent a teacher" 
										  "se"
										  "% Mother education"
										  "se"
										  "% Father education"
										  "se"
										  "% Female"
										  "se"
										  "% Over the age of 21"
										  "se"
										  "% White"
										  "se"
										  "% Rural"
										  "se"
										  "% Suburban"
										  "se"
										  "% Urban"
										  "se"
										  "% Low SES"
										  "se"
										  "% Middle SES"
										  "se"
										  "% High SES"
										  "se"
										  "% Primarily students of color"
										  "se"
										  "% Mixed"
										  "se"
										  "% Primarily white students"
										  "se"
										  "% Primarily low achieving"
										  "se"
										  "% Primarily middle"
										  "se"
										  "% Primarily high achieving" 
										  "se"
										  "Instructional score at pretest"
										  "se" ;
	
	#delimit cr
			
	do "${programs}/07_balance_table.do"	
		
		
	 *****************************************************
			     * Bootstrapping *
	 *****************************************************
	 
${logtranslate} 	 	 

		 
		 
	 
	 
	 
