*-------------------------------------------
* GEPD - Chad
* Quality checks 
* By: Mohammed ElDesouky - Mar 27th 2024. 
* Last updated: Apr 28th 2024 

*! [Some key parameters below must be checked or modified by the user before run]

*------------------------------------------
clear all

*****************************
*Installing dependencies
****************************
ssc install unique  

*****************************
*!/[User to verify or modify key parameters]:
*______________________________
 * User directory,
 * country name, 
 * Datasets names,
 * ID variables in each dataset.
****************************

*user directory "C:\Users\wb589124\WBG\HEDGE Files - HEDGE Documents\"
*----------------------------
gl main "C:\Users\wb589124\WBG\HEDGE Files - HEDGE Documents\"

*Country name
*----------------------------
gl country "Chad"

*Defining the data files' names
*----------------------------
* In-Raw -- if a dataset doesnt apply to a country [replace dataset name with ("na.")-keep the qoutations ""]
gl school_r		 			"EPDash_final.dta"	 
gl teacher_r	 		 	"TCD_teacher_level.dta"
gl teacher_r_as		 	 	$teacher_r
gl teacher_r_qs 		 	$teacher_r
gl teacher_r_tch 		 	$teacher_r
gl first_r				  	"ecd_assessment.dta" 
gl fourth_r				 	"fourth_grade_assessment.dta"
gl second_r				 	"ecd_assessment_g2"
* In-Processed 
gl school_p		 			"school_Stata.dta"	 
gl teacher_p	 		 	"teachers_Stata.dta"
gl teacher_p_as		 	 	$teacher_p
gl teacher_p_qs 		 	$teacher_p
gl teacher_p_tch 		 	$school_p
gl first_p				  	"first_grade_Stata.dta"
gl fourth_p				 	"fourth_grade_Stata.dta"
gl second_p				 	"second_grade_Stata.dta"

*Defining the ID variables for each dataset -- if a dataset doesnt apply to a country [replace dataset name with (na.)-NO-qoutations !""]
*----------------------------
* In Raw
gl school_IDs_r 		 m1s0q2_emis
gl Tch_rstr_IDs_r 		 school_code	 teachers_id
gl Tch_assment_IDs_r 	 school_code	 m5sb_tnumber
gl Tch_quest_IDs_r 		 school_code	 m3sb_tnumber
gl Tch_teach_IDs_r 		 school_code	 m4saq1_number
gl Fst_assessment_IDs_r  interview__key  ecd_assessment__id 
gl Frth_assessment_IDs_r interview__key  fourth_grade_assessment__id
gl Scnd_assessment_IDs_r interview__key  ecd_assessment_g2__id

* In processed
gl school_IDs_p 		 school_code
gl Tch_rstr_IDs_p 		 school_code 	 teachers_id
gl Tch_assment_IDs_p 	 school_code 	 m5sb_tnumber
gl Tch_quest_IDs_p 		 school_code 	 m3sb_tnumber
gl Tch_teach_IDs_p 		 school_code 	 m4saq1_number
gl Fst_assessment_IDs_p  school_code 	 ecd_assessment__id
gl Frth_assessment_IDs_p school_code 	 fourth_grade_assessment__id
gl Scnd_assessment_IDs_p school_code 	 ecd_assessment_g2__id


*****************************
*! PROFILE [Don't adjust from here onwards]: Required step before running any dcommands in this project (select the "Run file in the same directory below")
*****************************
do "$main\GEPD-Confidential\General\Country_Data\GEPD_Production-$country\profile_GEPD.do"

*****************************
*Define save path
****************************
gl save_dir ${clone}/03_GEPD_processed_data/School/Confidential/Cleaned/

*****************************
*Define data paths
*****************************
gl raw_dir ${clone}/01_GEPD_raw_data/
			// path to raw data
gl clean_dir ${clone}/03_GEPD_processed_data/
			// path to cleaned data

*****************************
*Define data directories and loading datasets
*****************************
// School _raw_ data
cap frame create school_r
frame change school_r
use "${raw_dir}/School/$school_r"

// School _processes_ data
cap frame create school_p
frame change school_p
use "${clean_dir}/School/Confidential/Cleaned/$school_p"

// Teachers _raw_ data (roster/absence,  assessment, questionnaire, Teach)
cap frame create teacher_r
frame change teacher_r
use "${raw_dir}/School/$teacher_r"

// Teachers _processed_ data
cap frame create teacher_p
frame change teacher_p
use "${clean_dir}/School/Confidential/Cleaned/$teacher_p"

// First grade _raw_ data (assessment)
cap frame create first_r
frame change first_r
use "${raw_dir}/School/$first_r"

// First grade _processes_ data (assessment)
cap frame create first_p
frame change first_p
use "${clean_dir}/School/Confidential/Cleaned/$first_p"

// Fourth grade _raw_ data (assessment)
cap frame create fourth_r
frame change fourth_r
use "${raw_dir}/School/$fourth_r"

// Fourth grade _processes_ data (assessment)
cap frame create fourth_p
frame change fourth_p
use "${clean_dir}/School/Confidential/Cleaned/$fourth_p"

// Second grade _raw_ data (assessment)
cap frame create second_r
frame change second_r
cap use "${raw_dir}/School/$second_r"

// Second grade _processes_ data (assessment)
cap frame create second_p
frame change second_p
cap use "${clean_dir}/School/Confidential/Cleaned/$second_p"

*****************************
*Running the checks
*****************************
// defining the results matrices to store results 

matrix datasets_Keys = J(8, 4, .z)
matrix rownames datasets_Keys = "School" "Teachers_roster" "Teachers_assessment" "Teachers_questionnaire" "Teachers_Observation" "First_grade_assessment" "Fourth_grade_assessment" "Second_grade_assessment"
matrix colname datasets_Keys = "Dataset_raw" "ID_varibales_raw" "Dataset_cleaned" "ID_varibales_cleaned"
matlist datasets_Keys

matrix observation_duplicates = J(12, 4, .z)
matrix rownames observation_duplicates = "School" "Teachers_roster" "Teachers_assessment" "Teachers_assessment_g4" "Teachers_assessment_g2" "Teachers_questionnaire" "Teachers_Observation" "Teachers_Observation_g4"  "Teachers_Observation_g2" "First_grade_assessment" "Fourth_grade_assessment" "Second_grade_assessment"
matrix colname observation_duplicates = "Unique  (N) In-raw" "Surplus (N) In-raw" "Unique  (N) In-cleaned" "Surplus (N) In-cleaned" 
matlist observation_duplicates

matrix identifiers = J(8, 4, .z)
matrix rownames identifiers = "School" "Teachers_roster" "Teachers_assessment" "Teachers_questionnaire" "Teachers_Observation" "First_grade_assessment" "Fourth_grade_assessment" "Second_grade_assessment"
matrix colname identifiers = "N. Missing (ID_1) In-raw" "N. Missing (ID_2) In-raw" "N. Missing (ID_1) In-cleaned" "N. Missing (ID_2) In-cleaned"
matlist identifiers

matrix observation = J(8, 2, .z)
matrix rownames observation = "School" "Teachers_roster" "Teachers_assessment" "Teachers_questionnaire" "Teachers_Observation" "First_grade_assessment" "Fourth_grade_assessment" "Second_grade_assessment"
matrix colname observation = "Variables (K) In-raw" "Variables (K) In-cleaned"
matlist observation


// Filling in the meta matrix [Matrix "1"]-----------------------------*

frame create meta
frame change meta

matlist datasets_Keys

matrix datasets_Keys[1, 1] = 1
matrix datasets_Keys[2, 1] = 2
matrix datasets_Keys[3, 1] = 3
matrix datasets_Keys[4, 1] = 4
matrix datasets_Keys[5, 1] = 5
matrix datasets_Keys[6, 1] = 6
matrix datasets_Keys[7, 1] = 7

matrix datasets_Keys[1, 2] = 1
matrix datasets_Keys[2, 2] = 2
matrix datasets_Keys[3, 2] = 3
matrix datasets_Keys[4, 2] = 4
matrix datasets_Keys[5, 2] = 5
matrix datasets_Keys[6, 2] = 6
matrix datasets_Keys[7, 2] = 7

matrix datasets_Keys[1, 3] = 11
matrix datasets_Keys[2, 3] = 12
matrix datasets_Keys[3, 3] = 13
matrix datasets_Keys[4, 3] = 14
matrix datasets_Keys[5, 3] = 15
matrix datasets_Keys[6, 3] = 16
matrix datasets_Keys[7, 3] = 17

matrix datasets_Keys[1, 4] = 11
matrix datasets_Keys[2, 4] = 12
matrix datasets_Keys[3, 4] = 13
matrix datasets_Keys[4, 4] = 14
matrix datasets_Keys[5, 4] = 15
matrix datasets_Keys[6, 4] = 16
matrix datasets_Keys[7, 4] = 17

matlist datasets_Keys

*--Converting matrix to a dataset to add string information 
svmat datasets_Keys, names(col)					

*--Getting the original row names of matrix (and row count), then add them to the dataset
local rownames : rowfullnames datasets_Keys		
local c : word count `rownames'
gen rownames = ""
forvalues i = 1/`c' {
    replace rownames = "`:word `i' of `rownames''" in `i'
}

order rownames

*-- Adding string information (dataset names and key var names)
recode Dataset_raw (1=1 $school_r) (2=2 $teacher_r) (3=3 $teacher_r_as) (4=4 $teacher_r_qs) (5=5 $teacher_r_tch) (6=6 $first_r) (7=7 $fourth_r) (.z=.z $second_r), gen(filename_raw)  
												
recode ID_varibales_raw (1=1 "$school_IDs_r") (2=2 "$Tch_rstr_IDs_r") (3=3 "$Tch_assment_IDs_r") (4=4 "$Tch_quest_IDs_r") (5=5 "$Tch_teach_IDs_r") (6=6 "$Fst_assessment_IDs_r") (7=7 "$Frth_assessment_IDs_r") (.z=.z "$Scnd_assessment_IDs_r"), gen(IDs_raw)  

recode Dataset_cleaned (11=11 $school_p) (12=12 $teacher_p) (13=13 $teacher_p_as) (14=14 $teacher_p_qs) (15=15 $teacher_p_tch) (16=16 "$first_p") (17=17 $fourth_p) (.z=.z $second_p), gen(filename_cleaned)  
												
recode ID_varibales_cleaned (11=11 "$school_IDs_p") (12=12 "$Tch_rstr_IDs_p") (13=13 "$Tch_assment_IDs_p") (14=14 "$Tch_quest_IDs_p") (15=15 "$Tch_teach_IDs_p") (16=16 "$Fst_assessment_IDs_p") (17=17 "$Frth_assessment_IDs_p") (.z=.z "$Scnd_assessment_IDs_p"), gen(IDs_cleaned)  

drop Dataset_raw ID_varibales_raw Dataset_cleaned ID_varibales_cleaned

foreach var of varlist filename_raw IDs_raw filename_cleaned IDs_cleaned {
	decode `var', gen (`var'_s)
}
label var rownames ""
label var filename_raw_s 	 "file name in-raw"
label var filename_cleaned_s "file name in-cleaned" 
label var IDs_raw_s 		 "ID variables in-raw" 
label var IDs_cleaned_s      "ID variables in-raw" 


//Filling in the observation_duplicates matrix [Matrix "2"]--------------------------------*

** School
frame change school_r
capture unique  $school_IDs_r 
matrix observation_duplicates[1, 1] = r(unique)
matrix observation_duplicates[1, 2] = r(N)-r(unique)

frame change school_p
capture unique  $school_IDs_p  
matrix observation_duplicates[1, 3] = r(unique)
matrix observation_duplicates[1, 4] = r(N)-r(unique)

** Teachers
frame change teacher_r
capture unique  $Tch_rstr_IDs_r 
matrix observation_duplicates[2, 1] = r(unique)
matrix observation_duplicates[2, 2] = r(N)-r(unique)

capture unique  $Tch_assment_IDs_r if m5sb_tnumber!=.
matrix observation_duplicates[3, 1] = r(unique)
matrix observation_duplicates[3, 2] = r(N)-r(unique)

capture unique  $Tch_assment_IDs_r if (m5sb_tnumber!=. & m3saq2_4 ==1)
matrix observation_duplicates[4, 1] = r(unique)
matrix observation_duplicates[4, 2] = r(N)-r(unique)
capture unique  $Tch_assment_IDs_r if (m5sb_tnumber!=. & m3saq2_2 ==1)
matrix observation_duplicates[5, 1] = r(unique)
matrix observation_duplicates[5, 2] = r(N)-r(unique)

capture unique  $Tch_quest_IDs_r if m3sb_tnumber!=.
matrix observation_duplicates[6, 1] = r(unique)
matrix observation_duplicates[6, 2] = r(N)-r(unique)

capture unique  $Tch_teach_IDs_r  if m4saq1_number!=.
matrix observation_duplicates[7, 1] = r(unique)
matrix observation_duplicates[7, 2] = r(N)-r(unique)

capture unique  $Tch_teach_IDs_r  if (m4saq1_number!=. & m3saq2_4 ==1)
matrix observation_duplicates[8, 1] = r(unique)
matrix observation_duplicates[8, 2] = r(N)-r(unique)
capture unique  $Tch_teach_IDs_r  if (m4saq1_number!=. & m3saq2_2 ==1)
matrix observation_duplicates[9, 1] = r(unique)
matrix observation_duplicates[9, 2] = r(N)-r(unique)

frame change teacher_p
capture unique  $Tch_rstr_IDs_p
matrix observation_duplicates[2, 3] = r(unique)
matrix observation_duplicates[2, 4] = r(N)-r(unique)

capture unique   $Tch_assment_IDs_p  if m5sb_tnumber!=.
matrix observation_duplicates[3, 3] = r(unique)
matrix observation_duplicates[3, 4] = r(N)-r(unique)

capture unique   $Tch_assment_IDs_p  if (m5sb_tnumber!=. & m3saq2_4 ==1)
matrix observation_duplicates[4, 3] = r(unique)
matrix observation_duplicates[4, 4] = r(N)-r(unique)
capture unique   $Tch_assment_IDs_p  if (m5sb_tnumber!=. & m3saq2_2 ==1)
matrix observation_duplicates[5, 3] = r(unique)
matrix observation_duplicates[5, 4] = r(N)-r(unique)

capture unique  $Tch_quest_IDs_p  if m3sb_tnumber!=.
matrix observation_duplicates[6, 3] = r(unique)
matrix observation_duplicates[6, 4] = r(N)-r(unique) 

capture unique  school_code m4saq1_number  if m4saq1_number!=.
matrix observation_duplicates[7, 3] = r(unique)
matrix observation_duplicates[7, 4] = r(N)-r(unique)

capture unique  school_code m4saq1_number  if (m4saq1_number!=. & m3saq2_4 ==1)
matrix observation_duplicates[8, 3] = r(unique)
matrix observation_duplicates[8, 4] = r(N)-r(unique)
capture unique  school_code m4saq1_number  if (m4saq1_number!=. & m3saq2_2 ==1)
matrix observation_duplicates[9, 3] = r(unique)
matrix observation_duplicates[9, 4] = r(N)-r(unique)

** First grade
frame change first_r
capture unique  $Fst_assessment_IDs_r 
matrix observation_duplicates[10, 1] = r(unique)
matrix observation_duplicates[10, 2] = r(N)-r(unique)

frame change first_p
capture unique  $Fst_assessment_IDs_p
matrix observation_duplicates[10, 3] = r(unique)
matrix observation_duplicates[10, 4] = r(N)-r(unique)

** Fourth grade
frame change fourth_r
capture unique  $Frth_assessment_IDs_r
matrix observation_duplicates[11, 1] = r(unique)
matrix observation_duplicates[11, 2] = r(N)-r(unique)

frame change fourth_p
capture unique  $Frth_assessment_IDs_p
matrix observation_duplicates[11, 3] = r(unique)
matrix observation_duplicates[11, 4] = r(N)-r(unique)

** second grade
frame change second_r
capture unique  $Scnd_assessment_IDs_r
matrix observation_duplicates[12, 1] = r(unique)
matrix observation_duplicates[12, 2] = r(N)-r(unique)

frame change second_p
capture unique  $Scnd_assessment_IDs_p
matrix observation_duplicates[12, 3] = r(unique)
matrix observation_duplicates[12, 4] = r(N)-r(unique)

matlist observation_duplicates


//Filling in the identifiers matrix [Matrix "3"]-------------------------------*

** School
frame change school_r
capture gen byte _m1s0q2_emis = 1 if !missing(m1s0q2_emis)
capture misstable patterns _m1s0q2_emis 
matrix identifiers[1, 1] = r(N_incomplete)

frame change school_p
capture gen byte _school_code = 1 if !missing(school_code)
capture misstable patterns _school_code
matrix identifiers[1, 3] = r(N_incomplete)

** Teachers
frame change teacher_r
capture gen byte _school_code = 1 if !missing(school_code) 
capture misstable patterns _school_code
matrix identifiers[2, 1] = r(N_incomplete)
	drop _school_code
capture gen byte _teachers_id = 1 if !missing(teachers_id)
capture misstable patterns _teachers_id
matrix identifiers[2, 2] = r(N_incomplete)

capture gen byte _school_code = 1 if !missing(school_code) & !missing(in_assessment)
capture misstable patterns _school_code if !missing(in_assessment)
matrix identifiers[3, 1] = r(N_incomplete)
	drop _school_code
capture gen byte _m5sb_tnumber = 1 if !missing(m5sb_tnumber)
capture misstable patterns _m5sb_tnumber if !missing(in_assessment)
matrix identifiers[3, 2] = r(N_incomplete)

capture gen byte _school_code  = 1 if !missing(school_code) & !missing(in_questionnaire)
capture misstable patterns _school_code if !missing(in_questionnaire)
matrix identifiers[4, 1] = r(N_incomplete)
	drop _school_code
capture gen byte _m3sb_tnumber  = 1 if !missing(m3sb_tnumber)
capture misstable patterns _m3sb_tnumber if !missing(in_questionnaire)
matrix identifiers[4, 2] = r(N_incomplete)

capture gen byte _school_code  = 1 if !missing(school_code) & !missing(in_pedagogy)
capture misstable patterns _school_code if !missing(in_pedagogy)
matrix identifiers[5, 1] = r(N_incomplete)
	drop _school_code
capture gen byte _m4saq1_number  = 1 if !missing(m4saq1_number)
capture misstable patterns _m4saq1_number if !missing(in_pedagogy)
matrix identifiers[5, 2] = r(N_incomplete)

frame change teacher_p
capture gen byte _school_code  = 1 if !missing(school_code)
capture misstable patterns _school_code
matrix identifiers[2, 3] = r(N_incomplete)
	drop _school_code
capture gen byte _teachers__id  = 1 if !missing(teachers_id)
capture misstable patterns _teachers__id
matrix identifiers[2, 4] = r(N_incomplete)

capture gen byte _school_code = 1 if !missing(school_code) & !missing(in_assessment)
capture misstable patterns _school_code	if !missing(in_assessment)
matrix identifiers[3, 3] = r(N_incomplete)
	drop _school_code
capture gen byte _m5sb_tnum  = 1 if !missing(m5sb_tnumber)
capture misstable patterns _m5sb_tnum if !missing(in_assessment)
matrix identifiers[3, 4] = r(N_incomplete)

capture gen byte _school_code = 1 if !missing(school_code) & !missing(in_questionnaire)
capture misstable patterns _school_code if !missing(in_questionnaire)  
matrix identifiers[4, 3] = r(N_incomplete)
	drop _school_code
capture gen byte _m3sb_tnumber  = 1 if !missing(m3sb_tnumber)
capture misstable patterns _m3sb_tnumber if !missing(in_questionnaire)
matrix identifiers[4, 4] = r(N_incomplete)

capture gen byte _school_code = 1 if !missing(school_code) & !missing(in_pedagogy)
capture misstable patterns _school_code if !missing(in_pedagogy)
matrix identifiers[5, 3] = r(N_incomplete)
capture gen byte _m4saq1_number  = 1 if !missing(m4saq1_number)
capture misstable patterns _m4saq1_number if !missing(in_pedagogy)
matrix identifiers[5, 4] = r(N_incomplete)

** First grade
frame change first_r
capture gen byte _interview__key  = 1 if !missing(interview__key)
capture misstable patterns _interview__key
matrix identifiers[6, 1] = r(N_incomplete)
capture gen byte _ecd_assessment__id  = 1 if !missing(ecd_assessment__id)
capture misstable patterns _ecd_assessment__id
matrix identifiers[6, 2] = r(N_incomplete)

frame change first_p
capture gen byte _school_code  = 1 if !missing(school_code)
capture misstable patterns _school_code
matrix identifiers[6, 3] = r(N_incomplete)
capture gen byte _ecd_assessment__id  = 1 if !missing(ecd_assessment__id)
capture misstable patterns _ecd_assessment__id
matrix identifiers[6, 4] = r(N_incomplete)

** Fourth grade
frame change fourth_r
capture gen byte _interview__key  = 1 if !missing(interview__key)
capture misstable patterns _interview__key
matrix identifiers[7, 1] = r(N_incomplete)
capture gen byte _fourth_grade_assessment__id  = 1 if !missing(fourth_grade_assessment__id)
capture misstable patterns _fourth_grade_assessment__id
matrix identifiers[7, 2] = r(N_incomplete)

frame change fourth_p
capture gen byte _school_code  = 1 if !missing(school_code)
capture misstable patterns _school_code
matrix identifiers[7, 3] = r(N_incomplete)
capture gen byte _fourth_grade_assessment__id  = 1 if !missing(fourth_grade_assessment__id)
capture misstable patterns _fourth_grade_assessment__id
matrix identifiers[7, 4] = r(N_incomplete)

** second grade
frame change second_r
capture gen byte _interview__key  = 1 if !missing(interview__key)
capture misstable patterns _interview__key
matrix identifiers[8, 1] = r(N_incomplete)
capture gen byte _ecd_assessment_g2__id  = 1 if !missing(ecd_assessment_g2__id)
capture misstable patterns _ecd_assessment_g2__id
matrix identifiers[8, 2] = r(N_incomplete)

frame change second_p
capture gen byte _school_code  = 1 if !missing(school_code)
capture misstable patterns _school_code
matrix identifiers[8, 3] = r(N_incomplete)
capture gen byte _ecd_assessment_g2__id  = 1 if !missing(ecd_assessment_g2__id)
capture misstable patterns _ecd_assessment_g2__id
matrix identifiers[8, 4] = r(N_incomplete)


// Filling in the Report verification checks [Matrix "4"]-----------------------------*

** School
frame change school_r
de 
matrix observation[1, 1] = r(k)

frame change school_p
de 
matrix observation[1, 2] = r(k)

** Teachers
frame change teacher_r
unab vars : m2*
global count `: word count `vars''
matrix observation[2, 1] = $count

unab vars : m5* 
global count `: word count `vars''
matrix observation[3, 1] = $count

unab vars : m3saq* m3sbq* m3bq10* m3scq* m3sdq* m3seq* m3covq* m3_clim*
global count `: word count `vars''
matrix observation[4, 1] = $count

frame change school_r
unab vars : s1_* s2_* 
global count `: word count `vars''
matrix observation[5, 1] = $count

frame change teacher_p
unab vars : m2*
global count `: word count `vars''
matrix observation[2, 2] = $count

unab vars : m5* 
global count `: word count `vars''
matrix observation[3, 2] = $count

unab vars :  m3saq* m3sbq* m3bq10* m3scq* m3sdq* m3seq* m3covq* m3_clim*
global count `: word count `vars''
matrix observation[4, 2] = $count

frame change school_p
unab vars :  s1_* s2_* 
global count `: word count `vars''
matrix observation[5, 2] = $count

** First grade
frame change first_r
de 
matrix observation[6, 1] = r(k)

frame change first_p
de 
matrix observation[6, 2] = r(k)

** Fourth grade
frame change fourth_r
de 
matrix observation[7, 1] = r(k)

frame change fourth_p
de 
matrix observation[7, 2] = r(k)

** second grade
frame change second_r
de 
matrix observation[8, 1] = r(k)

frame change second_p
de 
matrix observation[8, 2] = r(k)


*****************************
*Displaying the matrices and output them in an xlsx file
*****************************
matlist observation_duplicates, border(rows)
matlist identifiers, border(rows)
matlist observation, border(rows)


*Setting up the export xlsx file  
gl font Calibri
gl color_r "055 086 035"
gl color_p "131 060 012"
gl font_size 12

**--- Set workbook for export
        putexcel set "${save_dir}/${country}_QCs.xlsx",  sheet("Document overview") replace
**--- Set the sheet for export
        putexcel sheetset, gridoff hpagebreak(1) header("text", margin(15)) footer("text", margin(15)) 
	
	
**--- Populating the intro sheet (Document overview)
gl title "Report on Quality Checks for the GEPD data for ${country}"
gl date "`c(current_date)'"
gl work_location "${clone}"
gl text1_1 "This report provides a set of tables necessary to conduct some essential quality checks on the collected GEPD data."
gl text1_2 "These checks are conducted by comparing some aspects in the different datasets (e.g. number of unique observations,"
gl text1_3 "number of key variables, duplicates and missing observations on the ID variables)"

gl text2 "1- Sheet (Keys)- Provides information on the datafiles' names and key ID variables used in this report"
gl text3 "2- Sheet (Observation_duplicates)- Provides information on the # of unique observation and # of duplicates on key ID variables"
gl text4 "3- Sheet (Identifiers)- Provides information on the # of missing points on key ID variables"
gl text5_1 "4- Sheet (Variables_K)- Provides information on the # of variables in each dataset -- this sheet is meant to verify that the"
gl text5_2 "   compared datasets (raw vs cleaned) are the same and no mistakes happened while specifiying the datasets"

putexcel B4:O4 = "$title", merge vcenter left bold underline font($font, 16, darkblue) 
putexcel B6:D6 = "Date of the report:", merge vcenter left bold  font($font, $font_size, darkblue) 
putexcel E6:H6 = "$date", merge vcenter left font($font, $font_size) 
putexcel B7:D7 = "Work location:", merge vcenter left bold font($font, $font_size, darkblue) 
putexcel E7:R7 = "$work_location", merge vcenter left font($font, $font_size) 
putexcel B9:N9 = "$text1_1", merge vcenter left font($font, $font_size)
putexcel B10:N10 = "$text1_2", merge vcenter left font($font, $font_size) 
putexcel B11:N11 = "$text1_3", merge vcenter left font($font, $font_size) 
putexcel B14:H14 = "Content:", merge vcenter left bold font($font, $font_size, darkblue) 
putexcel B16:O16 = "$text2", merge vcenter left font($font, $font_size) 
putexcel B18:O18 = "$text3", merge vcenter left font($font, $font_size) 
putexcel B20:O20 = "$text4", merge vcenter left font($font, $font_size) 
putexcel B22:O22 = "$text5_1", merge vcenter left font($font, $font_size) 
putexcel B23:O23 = "$text5_2", merge vcenter left font($font, $font_size) 


**--- Populating the second sheet (Keys)
        putexcel set "${save_dir}/${country}_QCs.xlsx",  sheet(Keys) modify
        putexcel sheetset, gridoff hpagebreak(1) header("text", margin(15)) footer("text", margin(15)) 

gl title_keys "Table (1): Datafiles and key ID variables used in this report"
gl note "Notes on Table:"
gl note_1 "1- [Add note here in the do-file]"
gl note_2 "2- [Add note here in the do-file]"
gl note_3 "3- [Add note here in the do-file]"
gl note_4 "4- [Add note here in the do-file]"
gl note_5 "5- [Add note here in the do-file]"
gl note_6 "6- [Add note here in the do-file]"


putexcel B4:O4 = "$title_keys", merge vcenter left bold underline font($font, 16, darkblue) 


putexcel B6:E6 = "School", merge vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue) 
putexcel B7:E7 = "Teachers_roster", merge vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue) 
putexcel B8:E8 = "Teachers_assessment", merge vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)
putexcel B9:E9 = "Teachers_questionnaire", merge vcenter right bold underline font($font, $font_size, darkblue)border(right, medium, darkblue)
putexcel B10:E10 = "Teachers_Observation", merge vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)
putexcel B11:E11 = "First_grade_assessment", merge vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)
putexcel B12:E12 = "Fourth_grade_assessment", merge vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)
putexcel B13:E13 = "Second_grade_assessment", merge vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)

putexcel F6:F13="",  merge border(top, dashed, darkblue) 	
putexcel F6:F13="",  border(bottom, dashed, darkblue) 	

putexcel J6:J13="",  merge border(top, dashed, darkblue) 	
putexcel J6:J13="",  border(bottom, dashed, darkblue) 	

putexcel P6:P13="",  merge border(top, dashed, darkblue) 	
putexcel P6:P13="",  border(bottom, dashed, darkblue) 	

putexcel T6:T13="",  merge border(top, dashed, darkblue) 	
putexcel T6:T13="",  border(bottom, dashed, darkblue) 	

putexcel G5:I5 = "Filename_raw", top bold font($font, $font_size, darkblue) merge hcenter
putexcel G6:I6 = "$school_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel G7:I7 = "$teacher_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel G8:I8 = "$teacher_r_as", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel G9:I9 = "$teacher_r_qs", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel G10:I10 = "$teacher_r_tch", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel G11:I11 = "$first_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel G12:I12 = "$fourth_r", font($font, $font_size, "$color_r") merge left border(all, dashed, darkblue)
putexcel G13:I13 = "$second_r", font($font, $font_size, "$color_r") merge left border(all, dashed, darkblue) 

putexcel K5:O5 = "IDs_raw", top bold font($font, $font_size, darkblue)  merge hcenter 
putexcel K6:O6 = "$school_IDs_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel K7:O7 = "$Tch_rstr_IDs_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel K8:O8 = "$Tch_assment_IDs_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel K9:O9 = "$Tch_quest_IDs_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel K10:O10 = "$Tch_teach_IDs_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel K11:O11 = "$Fst_assessment_IDs_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)
putexcel K12:O12 = "$Frth_assessment_IDs_r", font($font, $font_size, "$color_r") merge left border(all, dashed, darkblue)
putexcel K13:O13 = "$Scnd_assessment_IDs_r", font($font, $font_size, "$color_r")  merge left border(all, dashed, darkblue)

putexcel Q5:S5 = "Filename_cleaned", top bold font($font, $font_size, darkblue)  merge hcenter
putexcel Q6:S6 = "$school_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel Q7:S7 = "$teacher_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel Q8:S8 = "$teacher_p_as", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel Q9:S9 = "$teacher_p_qs", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel Q10:S10 = "$teacher_p_tch ", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel Q11:S11 = "$first_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel Q12:S12 = "$fourth_p", font($font, $font_size, "$color_p") merge left border(all, dashed, darkblue)
putexcel Q13:S13 = "$second_p", font($font, $font_size, "$color_p") merge left border(all, dashed, darkblue)

putexcel U5:Y5 = "IDs_cleaned", top bold font($font, $font_size, darkblue)  merge hcenter 
putexcel U6:Y6 = "$school_IDs_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel U7:Y7 = "$Tch_rstr_IDs_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel U8:Y8 = "$Tch_assment_IDs_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel U9:Y9 = "$Tch_quest_IDs_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel U10:Y10 = "$Tch_teach_IDs_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel U11:Y11 = "$Fst_assessment_IDs_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)
putexcel U12:Y12 = "$Frth_assessment_IDs_p", font($font, $font_size, "$color_p") merge left border(all, dashed, darkblue)
putexcel U13:Y13 = "$Scnd_assessment_IDs_p", font($font, $font_size, "$color_p")  merge left border(all, dashed, darkblue)


putexcel B16:P16 = "$note", merge top left bold underline font($font, 12, darkblue) 
putexcel B18:P18 = "$note_1", merge top left  font($font, 12) 
putexcel B19:P19 = "$note_2", merge top left  font($font, 12) 
putexcel B20:P20 = "$note_3", merge top left  font($font, 12) 
putexcel B21:P21 = "$note_4", merge top left  font($font, 12) 
putexcel B22:P22 = "$note_5", merge top left  font($font, 12) 
putexcel B23:P23 = "$note_6", merge top left  font($font, 12) 


**--- Populating the third sheet (Observation_duplicates)
        putexcel set "${save_dir}/${country}_QCs.xlsx",  sheet(Observation_duplicates) modify
        putexcel sheetset, gridoff hpagebreak(1) header("text", margin(15)) footer("text", margin(15)) 

gl title_dup "Table (2): Unique(N) and Number of duplicates - Raw vs Processed GEPD data"
gl note "Notes on Table:"
gl note_1 "1- Unique  = # of unique observations"
gl note_2 "2- Surplus = # of duplicates"
gl note_3 "3- A blank cell indicates an issue with the ID variable"


putexcel B4:O4 = "$title_dup", merge vcenter left bold underline font($font, 16, darkblue) 

putexcel B5 = matrix(observation_duplicates), names 

mata
b = xl()
b.load_book("${save_dir}/${country}_QCs.xlsx")
b.set_sheet("Observation_duplicates")
b.set_column_width(2,2,33) //make title column widest
b.set_column_width(3,6,25) //make othe columns less wide

b.close_book()
end

putexcel B6:B17, vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)  overwritefmt
putexcel C5:F5, top bold font($font, $font_size, darkblue) hcenter  overwritefmt
putexcel C6:D17, font($font, $font_size, "$color_r") left border(all, dashed, darkblue)  overwritefmt
putexcel E6:F17, font($font, $font_size, "$color_p") left border(all, dashed, darkblue)

putexcel B19:P19 = "$note", merge top left bold underline font($font, 12, darkblue) 
putexcel B21:P21 = "$note_1", merge top left  font($font, 12) 
putexcel B22:P22 = "$note_2", merge top left  font($font, 12) 
putexcel B23:P23 = "$note_3", merge top left  font($font, 12) 


**--- Populating the fourth sheet (Identifiers)
        putexcel set "${save_dir}/${country}_QCs.xlsx",  sheet(Identifiers) modify
        putexcel sheetset, gridoff hpagebreak(1) header("text", margin(15)) footer("text", margin(15)) 

gl title_id "Table (3): Number of missing points on the Key ID variables - Raw vs Processed GEPD data"
gl note "Notes on Table:"
gl note_1 "1- School data has a single ID variable"
gl note_2 "2- Except for school datasets, a blank cell indicate an error/issue with the ID variable"



putexcel B4:O4 = "$title_id", merge vcenter left bold underline font($font, 16, darkblue) 

putexcel B5 = matrix(identifiers), names 

mata
b = xl()
b.load_book("${save_dir}/${country}_QCs.xlsx")
b.set_sheet("Identifiers")
b.set_column_width(2,2,33) //make title column widest
b.set_column_width(3,6,30) //make othe columns less wide

b.close_book()
end

putexcel B6:B13, vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)  overwritefmt
putexcel C5:F5, top bold font($font, $font_size, darkblue) hcenter  overwritefmt
putexcel C6:D13, font($font, $font_size, "$color_r") left border(all, dashed, darkblue)  overwritefmt
putexcel E6:F13, font($font, $font_size, "$color_p") left border(all, dashed, darkblue)

putexcel B19:P19 = "$note", merge top left bold underline font($font, 12, darkblue) 
putexcel B21:P21 = "$note_1", merge top left  font($font, 12) 
putexcel B22:P22 = "$note_2", merge top left  font($font, 12) 
putexcel B23:P23 = "$note_3", merge top left  font($font, 12) 


**--- Populating the fifth sheet (Variables_K)
        putexcel set "${save_dir}/${country}_QCs.xlsx",  sheet(Variables_K) modify
        putexcel sheetset, gridoff hpagebreak(1) header("text", margin(15)) footer("text", margin(15)) 

gl title_k "Table (4): Number of variables (K) within each dataset - Raw vs Processed GEPD data"
gl note "Notes on Table:"
gl note_1 "1- Raw count of number of variables (K) within each dataset"
gl note_2 "2- A blank cell indicate an error/issue with the ID variable"



putexcel B4:O4 = "$title_k", merge vcenter left bold underline font($font, 16, darkblue) 

putexcel B5 = matrix(observation), names 

mata
b = xl()
b.load_book("${save_dir}/${country}_QCs.xlsx")
b.set_sheet("Variables_K")
b.set_column_width(2,2,33) //make title column widest
b.set_column_width(3,4,25) //make othe columns less wide

b.close_book()
end

putexcel B6:B13, vcenter right bold underline font($font, $font_size, darkblue) border(right, medium, darkblue)  overwritefmt
putexcel C5:D5, top bold font($font, $font_size, darkblue) hcenter  overwritefmt
putexcel C6:C13, font($font, $font_size, "$color_r") left border(all, dashed, darkblue)  overwritefmt
putexcel D6:D13, font($font, $font_size, "$color_p") left border(all, dashed, darkblue)

putexcel B19:P19 = "$note", merge top left bold underline font($font, 12, darkblue) 
putexcel B21:P21 = "$note_1", merge top left  font($font, 12) 
putexcel B22:P22 = "$note_2", merge top left  font($font, 12) 






clear all

*End.




