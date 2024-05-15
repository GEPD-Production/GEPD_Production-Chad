*read in and clean chad data

clear all

global path "C:\Users\WB469649\WBG\HEDGE Files - HEDGE Documents\GEPD-Confidential\General\Country_Data\GEPD_Production-Chad\01_GEPD_raw_data\School\"

*read data from csv and save as stata format
import delimited "${path}\Gepd_Chad_2023_Data_Folder\Cleaned data\GEPD_CHAD_SCHOOL_2023.csv"

*save as dta file
save "${path}\EPDash_final.dta", replace

frame create school_link
frame change school_link

use "${path}\EPDash_final.dta", replace

keep interview__key m1s0q2_*

* merge the teacher file with Teach scored data
frame create teach_scores
frame change teach_scores

use "${path}\Teach\EPDash.dta", replace


gen school_code=school_emis_preload
replace school_code=m1s0q2_emis if school_info_correct!=1 | school_code=="Information a completer" | school_code=="##N/A##"
destring school_code, replace force

*select g4 observations
frame copy teach_scores teach_scores_g4
frame change teach_scores_g4

drop if missing(m4saq1) & missing(m4saq1_number)
drop if m4saq1=="##N/A##"
drop if m4saq1=="NA"
keep school_code m4saq1 m4saq1_number class_start_sched - s2_c9_3

*g2 observations
frame copy teach_scores teach_scores_g2
frame change teach_scores_g2

drop if missing(m10_teacher_name) & missing(m10_teacher_code)
keep school_code m4saq1 m4saq1_number m10_teacher_name m10_teacher_code m10_class_count m10_instruction_time class_start_sched_g2 - s2_c9_3_g2


* open combined teacher file
frame create teachers 
frame change teachers

use "${path}\TCD_teacher_level.dta", replace

drop s_* s1_* s2_*

*get info from teach for g4
frlink m:1 school_code m4saq1 m4saq1_number, frame(teach_scores_g4)
frget class_start_sched - s2_c9_3, from(teach_scores_g4)

*get info for g2
frlink m:1 school_code m4saq1 m4saq1_number, frame(teach_scores_g2)
frget class_start_sched_g2 - s2_c9_3_g2, from(teach_scores_g2)
