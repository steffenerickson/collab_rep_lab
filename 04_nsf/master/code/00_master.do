*------------------------------------------------------------------------------*
/* 
Title:	NSF Master Do File 																   
Author: Steffen Erickson 																		  
Date: 12/5/22
Purpose: This file contains data cleaning, randomizations, and 
		 video rater assignment


Contents: 
	
	(1) Set Directories (line 31)
	(2) Specify Data Files (line 62)
	(3) Run Program Dependencies (line 93)
	(4) Baseline Survey Data Cleaning (line 105)
	(5) Randomization and Appending (line 117)
	(6) Baseline Descriptive Tables (line 148)
	(7) Assign Coders to Participant Videos (line 178)
	(8) Performance Task Cleaning (line 192)
	
Instructions:

	(1) Choose switch in step (1) to run code on your local machine
	(2) Set globals and run code blocks in  step (1), step (2) and step (3) 
		to set directories and bring data files and programs into stata memory 
	(3) Run step (4) and step (5) to create baseline analytic dataset 
	(4) Run step (5) and steo (6) as needed 
	(5) Run step (8) to create performance analytic dataset 
*/																		   
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
 * (1) Set Directories  * 
*------------------------------------------------------------------------------*

* File path switch - type your name (lowercase) within the parentheses
local person = "steffen" 

if "`person'" == "steffen" {
global root_drive "/Users/steffenerickson/Desktop/repos/collab_rep_lab/04_nsf/master"
global clean_data "clean_data"
global raw_data "raw_data"
global programs "code"
global results "results"
}
if "`person" == "poppy" {
global root_drive 
global clean_data 
global raw_data 
global programs 
global results 
}
if "`person'" == "vivian"{
global root_drive 
global clean_data 
global raw_data 
global programs 
global results 
}

cd ${root_drive}

*------------------------------------------------------------------------------*
 * (2) Data Files  * 
*------------------------------------------------------------------------------*
/* 
Data files are required to run master file. Import commands are stored in 
globals used in other do files 

To edit or update, change import command after global name 

	global data_name | import command |

*/ 

#delimit ;

// Background survey data - Used in step (4)  // ; 
global bs_data import excel 
"${raw_data}/F22: SimSE Background & Demographics Survey_October 10, 2022_07.52.xlsx"
, sheet("Sheet0") firstrow case(lower) clear ;

// Numeric background survey data - Used in step (4) // ; 
global num_bs_data import excel 
${raw_data}/numeric_bd_survey.xlsx 
, sheet("Sheet0") firstrow case(lower) clear ; 

// Participant Tracker data - Used in step (5) // ; 
global uva_tracker_data import excel "${raw_data}/UVA Data Tracker.xlsx"
, sheet("UVA Data Tracker") cellrange(A1:E21) firstrow clear ;

global ud_tracker_data import excel "${raw_data}/UD Data Tracker.xlsx"
, sheet("UD Data Tracker") cellrange(A1:G60) firstrow clear ;

global jmu_tracker_data import excel "${raw_data}/JMU Data Tracker.xlsx"
, sheet("JMU Data Tracker") cellrange(A1:I81) firstrow clear;

// Performance task data - Used in step (8) // ; 
global performance_task_data import excel 
"${data}/F22: NSF Performance Task Coding_September 2, 2022_12.10.xlsx"
, sheet("Sheet0") cellrange(A1:AO8) firstrow case(lower) ;

#delimit cr 
*------------------------------------------------------------------------------*
 * (3) Programs * 
*------------------------------------------------------------------------------*
*Randomization Program
do ${programs}/01_randomize_v3.do 

*Balance Check Program 
do ${programs}/02_randomize_balance.do 

*Permutations Program 
do ${programs}/03_permin_2.do

*------------------------------------------------------------------------------*
 * (4) Baseline Survey Data Cleaning 
*------------------------------------------------------------------------------*
/* 
 Cleans the baseline survey data 
 - Requires bs_data and num_bs_data 
 Files Produced: 
 - baseline_clean.dta
*/ 

do ${programs}/04_baseline_demographics_nsf.do

*------------------------------------------------------------------------------*
 * (5) Randomization and Appending 
*------------------------------------------------------------------------------*
/* 
 Randomizes participants into treatment conditions 
 - Requires step (4) 
 - Requires uva_tracker_data, ud_tracker_data, and jmu_tracker_data
 Files Produced: 
 - nsf_full_sample.dta
 - uva_randomize.dta
 - ud_randomize.dta
 - jmu_norandomize.dta
*/ 

do ${programs}/05_nsf_uva_randomization.do
do ${programs}/06_nsf_ud_randomization.do
do ${programs}/07_nsf_jmu.do

*Append 
use ${clean_data}/ud_randomize.dta
append using ${clean_data}/uva_randomize.dta
append using ${clean_data}/jmu_norandomize.dta
replace consent = "yes" if consent == ""
replace section = "Thomas" if section == ""
recode strata (. = 1) if site == "UVA"
encode site, gen(site2) 
drop site
rename site2 site 
save ${clean_data}/nsf_full_sample.dta, replace 


*------------------------------------------------------------------------------*
 * (6) Baseline Descriptive Tables 
*------------------------------------------------------------------------------*
/*
 Produces baseline tables 
 - Requires step (4) and step (5)
 - Instructions: write yes in = " " next to global commands to produce the table
	"yes" will produce table 
	"no"  will not produce table

 Table 1 -> randomize_balance_table 
 - Produces a balance plot and balance table to assess randomization balance 
   for the combines uva/ud sample 
 Table 2 -> across_site_balance 
 - Produces an across site balance table using the baseline survey 
 Table 3 -> jmu_materials
 - Produces a balance table for the JMU participants. How representive of the 
   whole sample are the participants that submitted their materials? 
 Table 4 -> classroom_efficacy
 - Produces classroom and site level averages for each self efficacy question
   from the baseline survey 
*/ 

// RUN 5 LINES TOGETHER - globals  are table swtiches // 
/* Table 1 */ global randomize_balance_table = "no"
/* Table 2 */ global across_site_balance_table = "no"
/* Table 3 */ global jmu_materials_table = "no"
/* Table 4 */ global classroom_efficacy_table = "yes"
do ${programs}/08_baseline_tables.do

*------------------------------------------------------------------------------*
 * (7) Assign Coders
*------------------------------------------------------------------------------*
/* 
 Generates a rater allocation scheme, randomly assigning raters to paricipant 
 videos 
 Files Produced: 
 - wide.dta (template for rater bias and sem work)
 - long.dta (template for g-theory and random effects analysis)
 - coder_`x'.dta (data files to send to content team for rater assignment)
*/ 

do ${programs}/09_assign_coders.do

*------------------------------------------------------------------------------*
 * (8) Performance Task Cleaning 
*------------------------------------------------------------------------------*
/* 
 Cleans the simulator performance tasks 
 Files Produced: 
*/ 

do ${programs}/10_perform_task_clean.do



