************************************ Organisation :  IHfRA								****************************
************************************ Project Tittle: GEPD TCHAD 2023					****************************
************************************ Purpose:         Data merging 						****************************
************************************ Author:         Ambroise Dognon					****************************
************************************ Email:         adognon@hub4research.com			****************************
************************************ Description:	 This do file is designed to merge 	****************************
************************************                 all data from the questionnaire  	****************************
************************************ 				 into a single data set before		****************************
************************************ 				 the data cleaning process			****************************
************************************ Date Craeation: 2023-06-012                		****************************




*initialize stata 
cls
clear all
cap drop all
version 17
set more off
set maxvar 120000

*set varabbrev on, permanently


**Set the work directory
global path "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Raw data\EPDash_5_STATA_All (4)"
cd "${path}"



********** TEACHERS

use TEACHERS.dta, clear // loading the teacher roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the TEACHERS.dta
tempfile TEACHERS_reshape // creating a tempfile name for the data reshaped 
save `TEACHERS_reshape'.dta, replace // saving the TEACHERS_reshape.dta as a tempfile
*label data `TEACHERS_reshape'.dta "TEACHERS reshaped to wide" //labeling the data save in tempfile

****Merged the TEACHERS_reshape.dta to the main data called EPDash.dta
use EPDash.dta, clear // loading the main dataset called EPDah.dta
merge 1:1 interview__id using `TEACHERS_reshape'.dta //merging the main data to the

save merge.dta, replace // saving the merge as a tempfile





********** questionnaire_roster

use questionnaire_roster.dta, clear // loading the questionnaire roster
rename m3sbq8_tmna__10 m3sbq8_tmna___10
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the questionnaire_roster.dta
tempfile questionnaire_roster_reshape // creating a tempfile name for the data reshaped 
save `questionnaire_roster_reshape'.dta, replace // saving the questionnaire_roster_reshape.dta as a tempfile
*label data `questionnaire_roster_reshape'.dta "questionnaire_roster reshaped to wide" //labeling the data save in tempfile

****Merged the questionnaire_roster_reshape.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `questionnaire_roster_reshape'.dta //merging the merge data to the questionnaire_roster_reshape

save merge.dta, replace // saving the merge as a tempfile


********** before_after_closure

use before_after_closure.dta, clear // loading the before_after_closure roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the before_after_closure.dta
tempfile before_after_closure // creating a tempfile name for the data reshaped 
save `before_after_closure'.dta, replace // saving the before_after_closure.dta as a tempfile
*label data `before_after_closure'.dta "before_after_closure reshaped to wide" //labeling the data save in tempfile

****Merged the before_after_closure.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `before_after_closure'.dta //merging the merge data to the before_after_closure

save merge.dta, replace // saving the merge as a tempfile



********** climatebeliefs

use climatebeliefs.dta, clear // loading the climatebeliefs roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the climatebeliefs.dta
tempfile climatebeliefs // creating a tempfile name for the data reshaped 
save `climatebeliefs'.dta, replace // saving the climatebeliefs.dta as a tempfile
*label data `climatebeliefs'.dta "climatebeliefs reshaped to wide" //labeling the data save in tempfile

****Merged the climatebeliefs.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `climatebeliefs'.dta //merging the merge data to the climatebeliefs

save merge.dta, replace // saving the merge as a tempfile


********** teacherimpact

use teacherimpact.dta, clear // loading the teacherimpact roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the teacherimpact.dta
tempfile teacherimpact // creating a tempfile name for the data reshaped 
save `teacherimpact'.dta, replace // saving the teacherimpact.dta as a tempfile
*label data `teacherimpact'.dta "teacherimpact reshaped to wide" //labeling the data save in tempfile

****Merged the teacherimpact.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `teacherimpact'.dta //merging the merge data to the teacherimpact

save merge.dta, replace // saving the merge as a tempfile



********** random_list

use random_list.dta, clear // loading the random_list roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the random_list.dta
tempfile random_list // creating a tempfile name for the data reshaped 
save `random_list'.dta, replace // saving the random_list.dta as a tempfile
*label data `random_list'.dta "random_list reshaped to wide" //labeling the data save in tempfile

****Merged the random_list.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `random_list'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** etri_roster

use etri_roster.dta, clear // loading the etri_roster roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the etri_roster.dta
tempfile etri_roster // creating a tempfile name for the data reshaped 
save `etri_roster'.dta, replace // saving the etri_roster.dta as a tempfile
*label data `etri_roster'.dta "etri_roster reshaped to wide" //labeling the data save in tempfile

****Merged the etri_roster.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `etri_roster'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** direct_instruction_etri

use direct_instruction_etri.dta, clear // loading the direct_instruction_etri roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the direct_instruction_etri.dta
tempfile direct_instruction_etri // creating a tempfile name for the data reshaped 
save `direct_instruction_etri'.dta, replace // saving the direct_instruction_etri.dta as a tempfile
*label data `direct_instruction_etri'.dta "direct_instruction_etri reshaped to wide" //labeling the data save in tempfile

****Merged the direct_instruction_etri.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `direct_instruction_etri'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** planning_lesson_etri

use planning_lesson_etri.dta, clear // loading the planning_lesson_etri roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the planning_lesson_etri.dta
tempfile planning_lesson_etri // creating a tempfile name for the data reshaped 
save `planning_lesson_etri'.dta, replace // saving the planning_lesson_etri.dta as a tempfile
*label data `planning_lesson_etri'.dta "planning_lesson_etri reshaped to wide" //labeling the data save in tempfile

****Merged the direct_instruction_etri.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `planning_lesson_etri'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** ability_to_use_etri

use ability_to_use_etri.dta, clear // loading the planning_lesson_etri roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the ability_to_use_etri.dta
tempfile ability_to_use_etri // creating a tempfile name for the data reshaped 
save `ability_to_use_etri'.dta, replace // saving the ability_to_use_etri.dta as a tempfile
*label data `ability_to_use_etri'.dta "ability_to_use_etri reshaped to wide" //labeling the data save in tempfile

****Merged the direct_instruction_etri.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `ability_to_use_etri'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** digital_use_inschool_etri

use digital_use_inschool_etri.dta, clear // loading the digital_use_inschool_etri roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the digital_use_inschool_etri.dta
tempfile digital_use_inschool_etri // creating a tempfile name for the data reshaped 
save `digital_use_inschool_etri'.dta, replace // saving the digital_use_inschool_etri.dta as a tempfile
*label data `digital_use_inschool_etri'.dta "digital_use_inschool_etri reshaped to wide" //labeling the data save in tempfile

****Merged the direct_instruction_etri.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `digital_use_inschool_etri'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** use_outsideschool_etri

use use_outsideschool_etri.dta, clear // loading the use_outsideschool_etri roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the use_outsideschool_etri.dta
tempfile use_outsideschool_etri // creating a tempfile name for the data reshaped 
save `use_outsideschool_etri'.dta, replace // saving the use_outsideschool_etri.dta as a tempfile
*label data `use_outsideschool_etri'.dta "use_outsideschool_etri reshaped to wide" //labeling the data save in tempfile

****Merged the use_outsideschool_etri.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `use_outsideschool_etri'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** proficiency_ict_etri

use proficiency_ict_etri.dta, clear // loading the proficiency_ict_etri roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the proficiency_ict_etri.dta
tempfile proficiency_ict_etri // creating a tempfile name for the data reshaped 
save `proficiency_ict_etri'.dta, replace // saving the proficiency_ict_etri.dta as a tempfile
*label data `proficiency_ict_etri'.dta "proficiency_ict_etri reshaped to wide" //labeling the data save in tempfile

****Merged the proficiency_ict_etri.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `proficiency_ict_etri'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** teacher_assessment_answers

use teacher_assessment_answers.dta, clear // loading the teacher_assessment_answers roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the teacher_assessment_answers.dta
tempfile teacher_assessment_answers // creating a tempfile name for the data reshaped 
save `teacher_assessment_answers'.dta, replace // saving the teacher_assessment_answers.dta as a tempfile
*label data `teacher_assessment_answers'.dta "teacher_assessment_answers reshaped to wide" //labeling the data save in tempfile

****Merged the teacher_assessment_answers.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `teacher_assessment_answers'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** ecd_assessment

use ecd_assessment.dta, clear // loading the ecd_assessment roster
rename m6s2q16a_conflict_resol_response m6s2q16a_conflict_resol_resp  // Renamed to reduce the tength of the variable (exced 32 characteres)
rename m6s2q16b_conflict_resol_response m6s2q16b_conflict_resol_resp // Renamed to reduce the tength of the variable (exced 32 characteres)
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the ecd_assessment.dta
tempfile ecd_assessment // creating a tempfile name for the data reshaped 
save `ecd_assessment'.dta, replace // saving the ecd_assessment.dta as a tempfile
*label data `ecd_assessment'.dta "ecd_assessment reshaped to wide" //labeling the data save in tempfile

****Merged the ecd_assessment.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `ecd_assessment'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile




********** fourth_grade_assessment

use fourth_grade_assessment.dta, clear // loading the fourth_grade_assessment roster
rename m8saq2_id__99 m8saq2_id___99 
rename m8saq3_id__99 m8saq3_id___99
rename m8sbq1_number_sense__99 m8sbq1_number_sense___99
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the fourth_grade_assessment.dta
tempfile fourth_grade_assessment // creating a tempfile name for the data reshaped 
save `fourth_grade_assessment'.dta, replace // saving the fourth_grade_assessment.dta as a tempfile
*label data `fourth_grade_assessment'.dta "fourth_grade_assessment reshaped to wide" //labeling the data save in tempfile

****Merged the fourth_grade_assessment.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `fourth_grade_assessment'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile



********** schoolcovid_roster

use schoolcovid_roster.dta, clear // loading the schoolcovid_roster roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the schoolcovid_roster.dta
tempfile schoolcovid_roster // creating a tempfile name for the data reshaped 
save `schoolcovid_roster'.dta, replace // saving the schoolcovid_roster.dta as a tempfile
*label data `schoolcovid_roster'.dta "schoolcovid_roster reshaped to wide" //labeling the data save in tempfile

****Merged the schoolcovid_roster.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `schoolcovid_roster'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile



********** ecd_assessment_g2

use ecd_assessment_g2.dta, clear // loading the ecd_assessment_g2 roster
rename m1s2q16a_conflict_resol_response m1s2q16a_conflict_resol_resp  // Renamed to reduce the tength of the variable (exced 32 characteres)
rename m1s2q16b_conflict_resol_response m1s2q16b_conflict_resol_resp  // Renamed to reduce the tength of the variable (exced 32 characteres)
rename pasec_11 pasec__11 // Renamed to avoid this error message"variable pasec_11 already defined"
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)

 
ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the ecd_assessment_g2.dta
tempfile ecd_assessment_g2 // creating a tempfile name for the data reshaped 
save `ecd_assessment_g2'.dta, replace // saving the ecd_assessment_g2.dta as a tempfile
*label data `ecd_assessment_g2'.dta "ecd_assessment_g2 reshaped to wide" //labeling the data save in tempfile

****Merged the ecd_assessment_g2.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `ecd_assessment_g2'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile



********** pasec_6_roster

use pasec_6_roster.dta, clear // loading the pasec_6_roster roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the pasec_6_roster.dta
tempfile pasec_6_roster // creating a tempfile name for the data reshaped 
save `pasec_6_roster'.dta, replace // saving the pasec_6_roster.dta as a tempfile
*label data `pasec_6_roster'.dta "pasec_6_roster reshaped to wide" //labeling the data save in tempfile

****Merged the pasec_6_roster.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `pasec_6_roster'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile


********** pasec_10_roster

use pasec_10_roster.dta, clear // loading the pasec_10_roster roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the pasec_10_roster.dta
tempfile pasec_10_roster // creating a tempfile name for the data reshaped 
save `pasec_10_roster'.dta, replace // saving the pasec_10_roster.dta as a tempfile
*label data `pasec_10_roster'.dta "pasec_10_roster reshaped to wide" //labeling the data save in tempfile

****Merged the pasec_10_roster.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `pasec_10_roster'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile



********** interview__actions

use interview__actions.dta, clear // loading the interview__actions roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the interview__actions.dta
tempfile interview__actions // creating a tempfile name for the data reshaped 
save `interview__actions'.dta, replace // saving the interview__actions.dta as a tempfile
*label data `interview__actions'.dta "interview__actions reshaped to wide" //labeling the data save in tempfile

****Merged the interview__actions.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `interview__actions'.dta //merging the merge data to the random_list

save merge.dta, replace // saving the merge as a tempfile



********** interview__comments

use interview__comments.dta, clear // loading the interview__comments roster
bysort interview__id: gen count_obs = _n - 1
order count_obs, after(interview__id)


ds interview__id count_obs, not // local to named all the variable in the data base excluding those specified
reshape wide `r(varlist)', i(interview__id) j(count_obs) // reshaping the interview__comments.dta
tempfile interview__comments // creating a tempfile name for the data reshaped 
save `interview__comments'.dta, replace // saving the interview__comments.dta as a tempfile
*label data `interview__comments'.dta "interview__comments reshaped to wide" //labeling the data save in tempfile

****Merged the interview__comments.dta to the main data called merge.dta
use merge.dta, clear // loading the main dataset called EPDah.dta
drop _merge
merge 1:1 interview__id using `interview__comments'.dta //merging the merge data to the random_list

**************Save the merged data base**************

save "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Merged data\GEPD_Tchad_Merged_full_data.dta", replace // saving the full merged data
export delimited "D:\IHfRA\Projet GEPD TCHAD\GEPD TCHAD ORIGINAL\DATA QUALITY\HFC\Merged data\GEPD_Tchad_Merged_full_data.csv",  replace // saving the full merged data in csv file


/*	
 ***************************** End of do-file ************************
